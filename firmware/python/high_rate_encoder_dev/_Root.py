#-----------------------------------------------------------------------------
# This file is part of the 'Development Board Examples'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Development Board Examples', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import pyrogue  as pr
import pyrogue.protocols
import pyrogue.utilities.fileio

import rogue
import rogue.hardware.axi
import rogue.interfaces.stream
import rogue.utilities.fileio

import high_rate_encoder_dev  as devBoard
import l2si_core              as l2si
import surf.protocols.batcher as batcher

rogue.Version.exactVersion('5.18.4')

class Root(pr.Root):
    def __init__(   self,
            dev      = '/dev/datadev_0',
            lane     = 0,
            dataVcEn = False,
            #####################################################################################
            defaultFile    = "config/defaults.yml",
            standAloneMode = False, # False = using fiber timing, True = locally generated timing
            #####################################################################################
            pollEn   = True,  # Enable automatic polling registers
            initRead = True,  # Read all registers at start of the system
            promProg = False, # Flag to disable all devices not related to PROM programming
            zmqSrvEn = True,  # Flag to include the ZMQ server
            #####################################################################################
            **kwargs):
        super().__init__(**kwargs)

        #################################################################

        # zmqServer in rogue v6.0.0 (or later)
        # if zmqSrvEn:
            # self.zmqServer = pyrogue.interfaces.ZmqServer(root=self, addr='*', port=0)
            # self.addInterface(self.zmqServer)

        # Start up flags
        self._pollEn   = pollEn
        self._initRead = initRead

        # Save the path for start()
        self.defaultFile = defaultFile
        self.standAloneMode = standAloneMode

        #################################################################

        # Map the DMA streams
        self.dmaStream = [None for x in range(4)]
        for vc in range(4):
            if (vc != 1) or (dataVcEn):
                self.dmaStream[vc] = rogue.hardware.axi.AxiStreamDma(dev,(0x100*lane)+vc,1)

        #################################################################

        # Create (Xilinx Virtual Cable) XVC on localhost
        self.xvc = rogue.protocols.xilinx.Xvc( 2542 )
        self.addProtocol( self.xvc )

        # Connect dmaStream[VC = 2] to XVC
        self.dmaStream[2] == self.xvc

        #################################################################

        # Create SRPv3
        self.srp = rogue.protocols.srp.SrpV3()

        # Connect SRPv3 to dmaStream[VC=0]
        self.srp == self.dmaStream[0]

        #################################################################

        # Add Devices
        self.add(devBoard.Core(
            offset   = 0x0000_0000,
            memBase  = self.srp,
            promProg = promProg,
            expand   = True,
        ))

        self.add(devBoard.App(
            offset   = 0x8000_0000,
            memBase  = self.srp,
            enabled  = not promProg,
            expand   = True,
        ))

        #################################################################

        self.add(pr.LocalVariable(
            name        = 'RunState',
            description = 'Run state status, which is controlled by the StopRun() and StartRun() commands',
            mode        = 'RO',
            value       = False,
        ))

        @self.command(description  = 'Stops the triggers and blows off data in the pipeline')
        def StopRun():
            print ('ClinkDev.StopRun() executed')

            # Get devices
            eventBuilder = self.find(typ=batcher.AxiStreamBatcherEventBuilder)
            trigger      = self.find(typ=l2si.TriggerEventBuffer)

            # Turn off the triggering
            for devPtr in trigger:
                devPtr.MasterEnable.set(False)

            # Flush the downstream data/trigger pipelines
            for devPtr in eventBuilder:
                devPtr.Blowoff.set(True)

            # Update the run state status variable
            self.RunState.set(False)

        @self.command(description  = 'starts the triggers and allow steams to flow to DMA engine')
        def StartRun():
            print ('ClinkDev.StartRun() executed')

            # Get devices
            eventBuilder = self.find(typ=batcher.AxiStreamBatcherEventBuilder)
            trigger      = self.find(typ=l2si.TriggerEventBuffer)

            # Reset all counters
            self.CountReset()

            # Arm for data/trigger stream
            for devPtr in eventBuilder:
                devPtr.Blowoff.set(False)
                devPtr.SoftRst()

            # Turn on the triggering
            for devPtr in trigger:
                devPtr.MasterEnable.set(True)

            # Update the run state status variable
            self.RunState.set(True)

    def start(self, **kwargs):
        super().start(**kwargs)

        # Startup in LCLS-II mode
        if self.standAloneMode:
            self.App.TimingRx.ConfigureXpmMini()
        else:
            self.App.TimingRx.ConfigLclsTimingV2()

        # Load the YAML configurations
        print(f'Loading {self.defaultFile} Configuration File...')
        self.ReadAll()
        self.LoadConfig(self.defaultFile)

        # Enable the FMC core after timing link is up
        self.App.Fmc.enable.set(True)
        self.App.Fmc.writeAndVerifyBlocks(force=True, recurse=True)
        self.ReadAll()
        self.CountReset()

    # Function calls after loading YAML configuration
    def initialize(self):
        super().initialize()
        self.StopRun()
        self.CountReset()

