-------------------------------------------------------------------------------
-- Company    : SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------
-- Description: Application Top-Level Firmware Module
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

library surf;
use surf.StdRtlPkg.all;
use surf.AxiStreamPkg.all;
use surf.AxiLitePkg.all;
use surf.Pgp4Pkg.all;

library lcls2_pgp_fw_lib;

library l2si_core;
use l2si_core.L2SiPkg.all;

entity App is
   generic (
      TPD_G        : time    := 1 ns;
      SIMULATION_G : boolean := false);
   port (
      -- Clocks and Resets
      axilClk         : in    sl;
      axilRst         : in    sl;
      userClk156      : in    sl;
      userClk25       : in    sl;
      userRst25       : in    sl;
      fmcClk          : in    sl;
      fmcRst          : in    sl;
      -- AXI-Stream Interface
      ibPgpMaster     : out   AxiStreamMasterType;
      ibPgpSlave      : in    AxiStreamSlaveType;
      obPgpMaster     : in    AxiStreamMasterType;
      obPgpSlave      : out   AxiStreamSlaveType;
      -- AXI-Lite Interface
      axilReadMaster  : in    AxiLiteReadMasterType;
      axilReadSlave   : out   AxiLiteReadSlaveType;
      axilWriteMaster : in    AxiLiteWriteMasterType;
      axilWriteSlave  : out   AxiLiteWriteSlaveType;
      -- FMC Ports
      fmcHpcLaP       : inout slv(33 downto 0);
      fmcHpcLaN       : inout slv(33 downto 0);
      -- Timing Ports
      timingRxP       : in    slv(1 downto 0);
      timingRxN       : in    slv(1 downto 0);
      timingTxP       : out   slv(1 downto 0);
      timingTxN       : out   slv(1 downto 0));
end App;

architecture mapping of App is

   constant FMC_INDEX_C         : natural  := 0;
   constant TIMING_INDEX_C      : natural  := 1;
   constant EVENT_BUILD_INDEX_C : natural  := 2;
   constant NUM_AXIL_MASTERS_C  : positive := 3;

   constant XBAR_CONFIG_C : AxiLiteCrossbarMasterConfigArray(NUM_AXIL_MASTERS_C-1 downto 0) := genAxiLiteConfig(NUM_AXIL_MASTERS_C, x"8000_0000", 24, 20);

   signal axilWriteMasters : AxiLiteWriteMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilWriteSlaves  : AxiLiteWriteSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0) := (others => AXI_LITE_WRITE_SLAVE_EMPTY_SLVERR_C);
   signal axilReadMasters  : AxiLiteReadMasterArray(NUM_AXIL_MASTERS_C-1 downto 0);
   signal axilReadSlaves   : AxiLiteReadSlaveArray(NUM_AXIL_MASTERS_C-1 downto 0)  := (others => AXI_LITE_READ_SLAVE_EMPTY_SLVERR_C);

   signal fmcWriteMaster : AxiLiteWriteMasterType;
   signal fmcWriteSlave  : AxiLiteWriteSlaveType := AXI_LITE_WRITE_SLAVE_EMPTY_SLVERR_C;
   signal fmcReadMaster  : AxiLiteReadMasterType;
   signal fmcReadSlave   : AxiLiteReadSlaveType  := AXI_LITE_READ_SLAVE_EMPTY_SLVERR_C;

   signal eventTimingMsgMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal eventTimingMsgSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;
   signal eventTrigMsgMaster   : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal eventTrigMsgSlave    : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;
   signal eventTrigMsgCtrl     : AxiStreamCtrlType   := AXI_STREAM_CTRL_UNUSED_C;

   signal trigMsgMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal trigMsgSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;
   signal triggerData   : TriggerEventDataType;

   signal dataMsgMaster : AxiStreamMasterType := AXI_STREAM_MASTER_INIT_C;
   signal dataMsgSlave  : AxiStreamSlaveType  := AXI_STREAM_SLAVE_FORCE_C;

begin

   -------------------------------
   -- Terminating unused RX stream
   -------------------------------
   obPgpSlave <= AXI_STREAM_SLAVE_FORCE_C;

   ---------------------------
   -- AXI-Lite Crossbar Module
   ---------------------------
   U_XBAR : entity surf.AxiLiteCrossbar
      generic map (
         TPD_G              => TPD_G,
         NUM_SLAVE_SLOTS_G  => 1,
         NUM_MASTER_SLOTS_G => NUM_AXIL_MASTERS_C,
         MASTERS_CONFIG_G   => XBAR_CONFIG_C)
      port map (
         sAxiWriteMasters(0) => axilWriteMaster,
         sAxiWriteSlaves(0)  => axilWriteSlave,
         sAxiReadMasters(0)  => axilReadMaster,
         sAxiReadSlaves(0)   => axilReadSlave,
         mAxiWriteMasters    => axilWriteMasters,
         mAxiWriteSlaves     => axilWriteSlaves,
         mAxiReadMasters     => axilReadMasters,
         mAxiReadSlaves      => axilReadSlaves,
         axiClk              => axilClk,
         axiClkRst           => axilRst);

   U_AxiLiteAsync : entity surf.AxiLiteAsync
      generic map (
         TPD_G           => TPD_G,
         COMMON_CLK_G    => false,
         NUM_ADDR_BITS_G => 24)
      port map (
         -- Slave Interface
         sAxiClk         => axilClk,
         sAxiClkRst      => axilRst,
         sAxiReadMaster  => axilReadMasters(FMC_INDEX_C),
         sAxiReadSlave   => axilReadSlaves(FMC_INDEX_C),
         sAxiWriteMaster => axilWriteMasters(FMC_INDEX_C),
         sAxiWriteSlave  => axilWriteSlaves(FMC_INDEX_C),
         -- Master Interface
         mAxiClk         => fmcClk,
         mAxiClkRst      => fmcRst,
         mAxiReadMaster  => fmcReadMaster,
         mAxiReadSlave   => fmcReadSlave,
         mAxiWriteMaster => fmcWriteMaster,
         mAxiWriteSlave  => fmcWriteSlave);

   --------------------------------
   -- Application TX Streaming Module
   --------------------------------
   U_Fmc : entity work.Fmc
      generic map (
         TPD_G        => TPD_G,
         SIMULATION_G => SIMULATION_G)
      port map (
         -- FMC Ports
         fmcLaP          => fmcHpcLaP,
         fmcLaN          => fmcHpcLaN,
         -- Trigger Interface (fmcClk domain)
         triggerData     => triggerData,
         -- AXI-Stream Interface (dataMsgClk domain)
         dataMsgClk      => axilClk,
         dataMsgRst      => axilRst,
         dataMsgMaster   => dataMsgMaster,
         dataMsgSlave    => dataMsgSlave,
         -- AXI-Lite Interface (fmcClk domain)
         fmcClk          => fmcClk,
         fmcRst          => fmcRst,
         axilReadMaster  => fmcReadMaster,
         axilReadSlave   => fmcReadSlave,
         axilWriteMaster => fmcWriteMaster,
         axilWriteSlave  => fmcWriteSlave);

   ------------------
   -- Timing Receiver
   ------------------
   U_TimingRx : entity lcls2_pgp_fw_lib.TimingRx
      generic map (
         TPD_G               => TPD_G,
         USE_GT_REFCLK_G     => false,  -- FALSE: userClk25/userRst25
         SIMULATION_G        => SIMULATION_G,
         DMA_AXIS_CONFIG_G   => PGP4_AXIS_CONFIG_C,
         AXIL_CLK_FREQ_G     => 156.25E+6,
         AXI_BASE_ADDR_G     => XBAR_CONFIG_C(TIMING_INDEX_C).baseAddr,
         NUM_DETECTORS_G     => 1,
         EN_LCLS_I_TIMING_G  => true,
         EN_LCLS_II_TIMING_G => true)
      port map (
         -- Reference Clock and Reset
         userClk156               => userClk156,
         userClk25                => userClk25,
         userRst25                => userRst25,
         -- Trigger interface
         triggerClk               => fmcClk,
         triggerRst               => fmcRst,
         triggerData(0)           => triggerData,
         -- L1 trigger feedback (optional)
         l1Clk                    => axilClk,
         l1Rst                    => axilRst,
         -- Event interface
         eventClk                 => axilClk,
         eventRst                 => axilRst,
         eventTrigMsgMasters(0)   => eventTrigMsgMaster,
         eventTrigMsgSlaves(0)    => eventTrigMsgSlave,
         eventTrigMsgCtrl(0)      => eventTrigMsgCtrl,
         eventTimingMsgMasters(0) => eventTimingMsgMaster,
         eventTimingMsgSlaves(0)  => eventTimingMsgSlave,
         -- AXI-Lite Interface (axilClk domain)
         axilClk                  => axilClk,
         axilRst                  => axilRst,
         axilReadMaster           => axilReadMasters(TIMING_INDEX_C),
         axilReadSlave            => axilReadSlaves(TIMING_INDEX_C),
         axilWriteMaster          => axilWriteMasters(TIMING_INDEX_C),
         axilWriteSlave           => axilWriteSlaves(TIMING_INDEX_C),
         -- GT Serial Ports
         timingRxP                => timingRxP,
         timingRxN                => timingRxN,
         timingTxP                => timingTxP,
         timingTxN                => timingTxN);

   -----------------------------
   -- Event Trigger Pause Buffer
   -----------------------------
   U_EventTrigPause : entity surf.AxiStreamFifoV2
      generic map (
         -- General Configurations
         TPD_G               => TPD_G,
         SLAVE_READY_EN_G    => true,
         -- FIFO configurations
         GEN_SYNC_FIFO_G     => true,
         FIFO_ADDR_WIDTH_G   => 10,
         FIFO_PAUSE_THRESH_G => 128,
         MEMORY_TYPE_G       => "block",
         -- AXI Stream Port Configurations
         SLAVE_AXI_CONFIG_G  => PGP4_AXIS_CONFIG_C,
         MASTER_AXI_CONFIG_G => PGP4_AXIS_CONFIG_C)
      port map (
         -- Slave Port
         sAxisClk    => axilClk,
         sAxisRst    => axilRst,
         sAxisMaster => eventTrigMsgMaster,
         sAxisSlave  => eventTrigMsgSlave,
         sAxisCtrl   => eventTrigMsgCtrl,
         -- Master Port
         mAxisClk    => axilClk,
         mAxisRst    => axilRst,
         mAxisMaster => trigMsgMaster,
         mAxisSlave  => trigMsgSlave);

   ----------------
   -- Event Builder
   ----------------
   U_EventBuilder : entity surf.AxiStreamBatcherEventBuilder
      generic map (
         TPD_G          => TPD_G,
         NUM_SLAVES_G   => 3,
         MODE_G         => "ROUTED",
         TDEST_ROUTES_G => (
            0           => "0000000-",   -- Map Trig on 0x0, Event on 0x1
            1           => "00000010",   -- Map DATA to TDEST 0x2
            2           => "00000011"),  -- Map Timing to TDEST 0x3
         TRANS_TDEST_G  => X"01",
         AXIS_CONFIG_G  => PGP4_AXIS_CONFIG_C)
      port map (
         -- Clock and Reset
         axisClk         => axilClk,
         axisRst         => axilRst,
         -- AXI-Lite Interface (axisClk domain)
         axilReadMaster  => axilReadMasters(EVENT_BUILD_INDEX_C),
         axilReadSlave   => axilReadSlaves(EVENT_BUILD_INDEX_C),
         axilWriteMaster => axilWriteMasters(EVENT_BUILD_INDEX_C),
         axilWriteSlave  => axilWriteSlaves(EVENT_BUILD_INDEX_C),
         -- AXIS Interfaces
         sAxisMasters(0) => trigMsgMaster,
         sAxisMasters(1) => dataMsgMaster,
         sAxisMasters(2) => eventTimingMsgMaster,
         sAxisSlaves(0)  => trigMsgSlave,
         sAxisSlaves(1)  => dataMsgSlave,
         sAxisSlaves(2)  => eventTimingMsgSlave,
         mAxisMaster     => ibPgpMaster,
         mAxisSlave      => ibPgpSlave);

end mapping;
