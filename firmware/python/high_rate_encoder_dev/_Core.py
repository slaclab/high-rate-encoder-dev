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

import surf.axi                  as axi
import surf.devices.micron       as micron
import surf.devices.transceivers as xceiver
import surf.protocols.pgp        as pgp
import surf.xilinx               as xil

class Core(pr.Device):
    def __init__( self,
            promProg = False,
        **kwargs):
        super().__init__(**kwargs)

        self.add(axi.AxiVersion(
            offset = 0x0000_0000,
            expand = True,
        ))

        for i in range(2):
            self.add(micron.AxiMicronN25Q(
                name         = f'AxiMicronN25Q[{i}]',
                offset       = 0x0002_0000 + (i * 0x0001_0000),
                hidden       = True,
            ))

        if not promProg:
            self.add(xil.AxiSysMonUltraScale(
                offset  = 0x0001_0000,
            ))

            self.add(pgp.Pgp4AxiL(
                offset  = 0x0010_0000,
                numVc   = 4,
                writeEn = False,
            ))

            self.add(axi.AxiStreamMonAxiL(
                name        = 'AxisMon',
                offset      = 0x0011_0000,
                numberLanes = 8,
                chName      = [
                    'TxVc[0]','TxVc[1]','TxVc[2]','TxVc[3]',
                    'RxVc[0]','RxVc[1]','RxVc[2]','RxVc[3]',
                ],
                expand      = True,
            ))

            # Close the streams that you don't want to monitor
            for i in range(4):
                self.AxisMon.RxVc[i]._expand = False
                if (i == 1):
                    self.AxisMon.TxVc[i]._expand = True
                else:
                    self.AxisMon.TxVc[i]._expand = False

            for i in range(2):
                self.add(xceiver.Sfp(
                    name   = f'Sfp[{i}]',
                    offset = (0x0020_2000+i*0x1000),
                    enabled = False,
                ))
