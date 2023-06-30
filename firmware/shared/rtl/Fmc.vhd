-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Application Encoder Firmware Module
-------------------------------------------------------------------------------
-- This file is part of 'high-rate-encoder-dev'.
-- It is subject to the license terms in the LICENSE.txt file found in the
-- top-level directory of this distribution and at:
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
-- No part of 'high-rate-encoder-dev', including this file,
-- may be copied, modified, propagated, or distributed except according to
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

library surf;
use surf.StdRtlPkg.all;
use surf.AxiStreamPkg.all;
use surf.AxiLitePkg.all;
use surf.SsiPkg.all;
use surf.Pgp4Pkg.all;

library l2si_core;
use l2si_core.L2SiPkg.all;

entity Fmc is
   generic (
      TPD_G        : time    := 1 ns;
      SIMULATION_G : boolean := false);
   port (
      -- Clock and Reset
      axilClk         : in    sl;
      axilRst         : in    sl;
      -- FMC Ports
      fmcLaP          : inout slv(33 downto 0);
      fmcLaN          : inout slv(33 downto 0);
      -- Trigger Interface
      triggerData     : in    TriggerEventDataType;
      -- AXI-Stream Interface
      dataMsgMaster   : out   AxiStreamMasterType;
      dataMsgSlave    : in    AxiStreamSlaveType;
      -- AXI-Lite Interface
      axilReadMaster  : in    AxiLiteReadMasterType;
      axilReadSlave   : out   AxiLiteReadSlaveType;
      axilWriteMaster : in    AxiLiteWriteMasterType;
      axilWriteSlave  : out   AxiLiteWriteSlaveType);
end Fmc;

architecture rtl of Fmc is

   type StateType is (
      PHASE1_S,
      PHASE2_S,
      PHASE3_S,
      PHASE4_S);

   type RegType is record
      posRst         : sl;
      cntRst         : sl;
      position       : slv(63 downto 0);
      xSig           : sl;
      eSig           : sl;
      pSig           : sl;
      qSig           : sl;
      aSig           : sl;
      bSig           : sl;
      zSig           : sl;
      encErrCnt      : slv(15 downto 0);
      missedTrigCnt  : slv(15 downto 0);
      txMaster       : AxiStreamMasterType;
      axilReadSlave  : AxiLiteReadSlaveType;
      axilWriteSlave : AxiLiteWriteSlaveType;
      stateCnt       : slv(1 downto 0);
      state          : StateType;
   end record RegType;
   constant REG_INIT_C : RegType := (
      posRst         => '0',
      cntRst         => '0',
      position       => (others => '0'),
      xSig           => '0',
      eSig           => '0',
      pSig           => '0',
      qSig           => '0',
      aSig           => '0',
      bSig           => '0',
      zSig           => '0',
      encErrCnt      => (others => '0'),
      missedTrigCnt  => (others => '0'),
      txMaster       => axiStreamMasterInit(PGP4_AXIS_CONFIG_C),
      axilReadSlave  => AXI_LITE_READ_SLAVE_INIT_C,
      axilWriteSlave => AXI_LITE_WRITE_SLAVE_INIT_C,
      stateCnt       => (others => '0'),
      state          => PHASE1_S);

   signal r   : RegType := REG_INIT_C;
   signal rin : RegType;

   signal xSig : sl;
   signal eSig : sl;
   signal pSig : sl;
   signal qSig : sl;
   signal aSig : sl;
   signal bSig : sl;
   signal zSig : sl;

   signal txSlave : AxiStreamSlaveType;

begin

   U_xSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(6),
         IB => fmcLaN(6),
         C  => axilClk,
         Q1 => xSig,
         Q2 => open);

   U_eSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(10),
         IB => fmcLaN(10),
         C  => axilClk,
         Q1 => eSig,
         Q2 => open);

   U_pSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(14),
         IB => fmcLaN(14),
         C  => axilClk,
         Q1 => pSig,
         Q2 => open);

   U_qSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(18),
         IB => fmcLaN(18),
         C  => axilClk,
         Q1 => qSig,
         Q2 => open);

   U_aSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(27),
         IB => fmcLaN(27),
         C  => axilClk,
         Q1 => aSig,
         Q2 => open);

   U_bSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(1),
         IB => fmcLaN(1),
         C  => axilClk,
         Q1 => bSig,
         Q2 => open);

   U_zSig : entity surf.InputBufferReg
      generic map (
         TPD_G       => TPD_G,
         DIFF_PAIR_G => true)
      port map (
         I  => fmcLaP(5),
         IB => fmcLaN(5),
         C  => axilClk,
         Q1 => zSig,
         Q2 => open);

   comb : process (axilReadMaster, axilRst, axilWriteMaster, r, triggerData,
                   txSlave) is
      variable v        : RegType;
      variable trigger  : sl;
      variable trigCode : slv(7 downto 0);
      variable axilEp   : AxiLiteEndPointType;
   begin
      -- Latch the current value
      v := r;

      ----------------------------------------------------------------------
      --                Encoder Logic
      ----------------------------------------------------------------------

      -- Register the encoder values
      v.xSig := r.xSig;
      v.eSig := r.eSig;
      v.pSig := r.pSig;
      v.qSig := r.qSig;
      v.aSig := r.aSig;
      v.bSig := r.bSig;
      v.zSig := r.zSig;

      -- Check for phase 1
      if (r.aSig = '0') and (r.bSig = '0') then
         v.state := PHASE1_S;

      -- Check for phase 2
      elsif (r.aSig = '0') and (r.bSig = '1') then
         v.state := PHASE2_S;

      -- Check for phase 3
      elsif (r.aSig = '1') and (r.bSig = '1') then
         v.state := PHASE3_S;

      -- Check for phase 4
      elsif (r.aSig = '1') and (r.bSig = '0') then
         v.state := PHASE4_S;

      end if;

      case r.state is
         ----------------------------------------------------------------------
         when PHASE1_S =>
            v.stateCnt := "00";
            -- Check for decrement
            if (v.state = PHASE4_S) then
               v.position := r.position - 1;

            -- Check for Increment
            elsif (v.state = PHASE2_S) then
               v.position := r.position + 1;

            -- Check for encoding error
            elsif (v.state /= PHASE1_S) then
               v.encErrCnt := r.encErrCnt + 1;
            end if;
         ----------------------------------------------------------------------
         when PHASE2_S =>
            v.stateCnt := "01";
            -- Check for decrement
            if (v.state = PHASE1_S) then
               v.position := r.position - 1;

            -- Check for Increment
            elsif (v.state = PHASE3_S) then
               v.position := r.position + 1;

            -- Check for encoding error
            elsif (v.state /= PHASE2_S) then
               v.encErrCnt := r.encErrCnt + 1;
            end if;
         ----------------------------------------------------------------------
         when PHASE3_S =>
            v.stateCnt := "10";
            -- Check for decrement
            if (v.state = PHASE2_S) then
               v.position := r.position - 1;

            -- Check for Increment
            elsif (v.state = PHASE4_S) then
               v.position := r.position + 1;

            -- Check for encoding error
            elsif (v.state /= PHASE3_S) then
               v.encErrCnt := r.encErrCnt + 1;
            end if;
         ----------------------------------------------------------------------
         when PHASE4_S =>
            v.stateCnt := "11";
            -- Check for decrement
            if (v.state = PHASE3_S) then
               v.position := r.position - 1;

            -- Check for Increment
            elsif (v.state = PHASE1_S) then
               v.position := r.position + 1;

            -- Check for encoding error
            elsif (v.state /= PHASE4_S) then
               v.encErrCnt := r.encErrCnt + 1;
            end if;
      ----------------------------------------------------------------------
      end case;

      ----------------------------------------------------------------------
      --                AXI Stream TX Logic
      ----------------------------------------------------------------------

      -- Update the trigger variables
      trigger  := triggerData.valid and triggerData.l0Accept;
      trigCode := "000" & triggerData.l0Tag;

      -- AXI Stream Flow Control
      if (txSlave.tReady = '1') then
         v.txMaster := axiStreamMasterInit(PGP4_AXIS_CONFIG_C);
      end if;

      -- Check for trigger
      if (trigger = '1') then

         -- Check if ready to move data
         if (v.txMaster.tValid = '0') then

            -- Generate a AXI-stream frame
            v.txMaster.tValid := '1';
            v.txMaster.tLast  := '1';

            -- Trigger Code
            v.txMaster.tData(63 downto 0) := r.position;

         else
            -- Increment error counter
            v.missedTrigCnt := r.missedTrigCnt + 1;
         end if;

      end if;

      ----------------------------------------------------------------------
      --                AXI-Lite Register Logic
      ----------------------------------------------------------------------

      -- Reset strobes
      v.posRst := '0';
      v.cntRst := '0';

      -- Determine the transaction type
      axiSlaveWaitTxn(axilEp, axilWriteMaster, axilReadMaster, v.axilWriteSlave, v.axilReadSlave);

      -- Map the read registers
      axiSlaveRegisterR(axilEp, x"00", 0, r.position);

      axiSlaveRegisterR(axilEp, x"08", 0, r.missedTrigCnt);
      axiSlaveRegisterR(axilEp, x"08", 16, r.encErrCnt);

      axiSlaveRegisterR(axilEp, x"0C", 0, r.xSig);
      axiSlaveRegisterR(axilEp, x"0C", 1, r.eSig);
      axiSlaveRegisterR(axilEp, x"0C", 2, r.pSig);
      axiSlaveRegisterR(axilEp, x"0C", 3, r.qSig);
      axiSlaveRegisterR(axilEp, x"0C", 4, r.aSig);
      axiSlaveRegisterR(axilEp, x"0C", 5, r.bSig);
      axiSlaveRegisterR(axilEp, x"0C", 6, r.zSig);
      axiSlaveRegisterR(axilEp, x"0C", 8, r.stateCnt);

      axiSlaveRegister (axilEp, x"10", 0, v.posRst);
      axiSlaveRegister (axilEp, x"14", 0, v.cntRst);

      -- Closeout the transaction
      axiSlaveDefault(axilEp, v.axilWriteSlave, v.axilReadSlave, AXI_RESP_DECERR_C);

      -- Counter resets
      if (r.posRst = '1') then
         v.position := (others => '0');
      end if;
      if (r.cntRst = '1') then
         v.missedTrigCnt := (others => '0');
         v.encErrCnt     := (others => '0');
      end if;

      -- Outputs
      axilWriteSlave <= r.axilWriteSlave;
      axilReadSlave  <= r.axilReadSlave;

      -- Reset
      if (axilRst = '1') then
         v := REG_INIT_C;
      end if;

      -- Register the variable for next clock cycle
      rin <= v;

   end process comb;

   seq : process (axilClk) is
   begin
      if rising_edge(axilClk) then
         r <= rin after TPD_G;
      end if;
   end process seq;

   U_Fifo : entity surf.AxiStreamFifoV2
      generic map (
         -- General Configurations
         TPD_G               => TPD_G,
         SLAVE_READY_EN_G    => true,
         -- FIFO configurations
         GEN_SYNC_FIFO_G     => true,
         FIFO_ADDR_WIDTH_G   => 10,
         MEMORY_TYPE_G       => "block",
         -- AXI Stream Port Configurations
         SLAVE_AXI_CONFIG_G  => PGP4_AXIS_CONFIG_C,
         MASTER_AXI_CONFIG_G => PGP4_AXIS_CONFIG_C)
      port map (
         -- Slave Port
         sAxisClk    => axilClk,
         sAxisRst    => axilRst,
         sAxisMaster => r.txMaster,
         sAxisSlave  => txSlave,
         -- Master Port
         mAxisClk    => axilClk,
         mAxisRst    => axilRst,
         mAxisMaster => dataMsgMaster,
         mAxisSlave  => dataMsgSlave);

end rtl;
