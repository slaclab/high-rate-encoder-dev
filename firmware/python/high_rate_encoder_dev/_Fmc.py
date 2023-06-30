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

class Fmc(pr.Device):
    def __init__( self,**kwargs):
        super().__init__(**kwargs)

        self.add(pr.RemoteVariable(
            name         = 'Position',
            description  = 'Encoder position',
            offset       = 0x00,
            bitSize      = 64,
            mode         = 'RO',
            pollInterval = 1,
        ))

        self.add(pr.RemoteVariable(
            name         = 'MissedTrigCnt',
            description  = 'Number of missed triggers due to back pressure',
            offset       = 0x08,
            bitSize      = 16,
            bitOffset    = 0,
            mode         = 'RO',
            pollInterval = 1,
        ))

        self.add(pr.RemoteVariable(
            name         = 'EncErrCnt',
            description  = 'Number of malformed encoder transitions detected',
            offset       = 0x08,
            bitSize      = 16,
            bitOffset    = 16,
            mode         = 'RO',
            pollInterval = 1,
        ))

        encSign = ['X','E','P','Q','A','B','Z']
        for i in range(len(encSign)):
            self.add(pr.RemoteVariable(
                name         = f'{encSign[i]}',
                description  = f'Encoder {encSign[i]} signal',
                offset       = 0x0C,
                bitSize      = 1,
                bitOffset    = i,
                mode         = 'RO',
                pollInterval = 1,
                base         = pr.Bool,
            ))

        self.add(pr.RemoteCommand(
            name         = 'PositionReset',
            description  = 'Zero out the position',
            offset       = 0x10,
            bitSize      = 1,
            function     = lambda cmd: cmd.post(1),
        ))

        self.add(pr.RemoteCommand(
            name         = 'CntRst',
            description  = 'Reset all the status counters',
            offset       = 0x14,
            bitSize      = 1,
            function     = lambda cmd: cmd.post(1),
        ))

    def hardReset(self):
        self.CntRst()

    def initialize(self):
        self.CntRst()

    def countReset(self):
        self.CntRst()
