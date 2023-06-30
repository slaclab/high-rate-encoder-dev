#-----------------------------------------------------------------------------
# This file is part of the 'Simple-PGPv4-KCU105-Example'. It is subject to
# the license terms in the LICENSE.txt file found in the top-level directory
# of this distribution and at:
#    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
# No part of the 'Simple-PGPv4-KCU105-Example', including this file, may be
# copied, modified, propagated, or distributed except according to the terms
# contained in the LICENSE.txt file.
#-----------------------------------------------------------------------------

import pyrogue as pr

import high_rate_encoder_dev   as devBoard
import lcls2_pgp_fw_lib.shared as shared
import surf.protocols.batcher  as batcher

class App(pr.Device):
    def __init__( self,**kwargs):
        super().__init__(**kwargs)

        self.add(devBoard.Fmc(
            offset  = 0*0x0010_0000,
            expand  = True,
            enabled = False, # Do not configure until after timing link is up
        ))

        self.add(shared.TimingRx(
            name         = 'TimingRx',
            offset       = 1*0x0010_0000,
            enLclsI      = False,
            enLclsII     = True,
            numDetectors = 1,
        ))

        #######################################
        # SLAVE[INDEX=0][TDEST=0] = XPM Trigger
        # SLAVE[INDEX=0][TDEST=1] = XPM Event Transition
        # SLAVE[INDEX=1][TDEST=2] = Encoder Data
        # SLAVE[INDEX=2][TDEST=3] = XPM Timing
        #######################################
        self.add(batcher.AxiStreamBatcherEventBuilder(
            name         = 'EventBuilder',
            offset       = 2*0x0010_0000,
            numberSlaves = 3, # Total number of slave indexes (not necessarily same as TDEST)
            tickUnit     = '156.25MHz',
            expand       = True,
        ))
