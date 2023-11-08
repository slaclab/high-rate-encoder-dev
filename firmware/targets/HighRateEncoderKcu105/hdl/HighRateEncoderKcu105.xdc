##############################################################################
## This file is part of 'high-rate-encoder-dev'.
## It is subject to the license terms in the LICENSE.txt file found in the
## top-level directory of this distribution and at:
##    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html.
## No part of 'high-rate-encoder-dev', including this file,
## may be copied, modified, propagated, or distributed except according to
## the terms contained in the LICENSE.txt file.
##############################################################################

##############################################################################
# I/O Constraints
##############################################################################

set_property PACKAGE_PIN U4 [get_ports pgpTxP]; # SFP0 = PGPv4
set_property PACKAGE_PIN U3 [get_ports pgpTxN]; # SFP0 = PGPv4
set_property PACKAGE_PIN T2 [get_ports pgpRxP]; # SFP0 = PGPv4
set_property PACKAGE_PIN T1 [get_ports pgpRxN]; # SFP0 = PGPv4

set_property PACKAGE_PIN P6 [get_ports pgpClkP]
set_property PACKAGE_PIN P5 [get_ports pgpClkN]

set_property -dict { PACKAGE_PIN V12 IOSTANDARD ANALOG } [get_ports { vPIn }]
set_property -dict { PACKAGE_PIN W11 IOSTANDARD ANALOG } [get_ports { vNIn }]

set_property -dict { PACKAGE_PIN AN8 IOSTANDARD LVCMOS18 } [get_ports { extRst }]

set_property -dict { PACKAGE_PIN AL8  IOSTANDARD LVCMOS18 } [get_ports { sfpTxDisL }]
set_property -dict { PACKAGE_PIN AP10 IOSTANDARD LVCMOS18 } [get_ports { i2cRstL }]
set_property -dict { PACKAGE_PIN J24  IOSTANDARD LVCMOS18 } [get_ports { i2cScl }]
set_property -dict { PACKAGE_PIN J25  IOSTANDARD LVCMOS18 } [get_ports { i2cSda }]

set_property -dict { PACKAGE_PIN AP8 IOSTANDARD LVCMOS18 } [get_ports { led[0] }]
set_property -dict { PACKAGE_PIN H23 IOSTANDARD LVCMOS18 } [get_ports { led[1] }]
set_property -dict { PACKAGE_PIN P20 IOSTANDARD LVCMOS18 } [get_ports { led[2] }]
set_property -dict { PACKAGE_PIN P21 IOSTANDARD LVCMOS18 } [get_ports { led[3] }]
set_property -dict { PACKAGE_PIN N22 IOSTANDARD LVCMOS18 } [get_ports { led[4] }]
set_property -dict { PACKAGE_PIN M22 IOSTANDARD LVCMOS18 } [get_ports { led[5] }]
set_property -dict { PACKAGE_PIN R23 IOSTANDARD LVCMOS18 } [get_ports { led[6] }]
set_property -dict { PACKAGE_PIN P23 IOSTANDARD LVCMOS18 } [get_ports { led[7] }]

set_property -dict { PACKAGE_PIN G26 IOSTANDARD LVCMOS18 } [get_ports { flashCsL }]  ; # QSPI1_CS_B
set_property -dict { PACKAGE_PIN M20 IOSTANDARD LVCMOS18 } [get_ports { flashMosi }] ; # QSPI1_IO[0]
set_property -dict { PACKAGE_PIN L20 IOSTANDARD LVCMOS18 } [get_ports { flashMiso }] ; # QSPI1_IO[1]
set_property -dict { PACKAGE_PIN R21 IOSTANDARD LVCMOS18 } [get_ports { flashWp }]   ; # QSPI1_IO[2]
set_property -dict { PACKAGE_PIN R22 IOSTANDARD LVCMOS18 } [get_ports { flashHoldL }]; # QSPI1_IO[3]

set_property -dict { PACKAGE_PIN K20 IOSTANDARD LVCMOS18 } [get_ports { emcClk }]

##############################################################################
# Timing Constraints
##############################################################################

create_clock -name pgpClkP -period  6.400 [get_ports {pgpClkP}]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_axilClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks -of_objects [get_pins {U_Core/U_Pgp/U_Pgp/REAL_PGP.GEN_LANE[0].U_Pgp/U_Pgp3GthUsIpWrapper_1/GEN_6G.U_Pgp3GthUsIp/inst/gen_gtwizard_gthe3_top.Pgp3GthUsIp6G_gtwizard_gthe3_inst/gen_gtwizard_gthe3.gen_tx_user_clocking_internal.gen_single_instance.gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_axilClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks -of_objects [get_pins {U_Core/U_Pgp/U_Pgp/REAL_PGP.GEN_LANE[0].U_Pgp/U_Pgp3GthUsIpWrapper_1/GEN_6G.U_Pgp3GthUsIp/inst/gen_gtwizard_gthe3_top.Pgp3GthUsIp6G_gtwizard_gthe3_inst/gen_gtwizard_gthe3.gen_rx_user_clocking_internal.gen_single_instance.gtwiz_userclk_rx_inst/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins {U_Core/U_Pgp/U_Pgp/REAL_PGP.GEN_LANE[0].U_Pgp/U_Pgp3GthUsIpWrapper_1/GEN_6G.U_Pgp3GthUsIp/inst/gen_gtwizard_gthe3_top.Pgp3GthUsIp6G_gtwizard_gthe3_inst/gen_gtwizard_gthe3.gen_tx_user_clocking_internal.gen_single_instance.gtwiz_userclk_tx_inst/gen_gtwiz_userclk_tx_main.bufg_gt_usrclk2_inst/O}]] -group [get_clocks -of_objects [get_pins {U_Core/U_Pgp/U_Pgp/REAL_PGP.GEN_LANE[0].U_Pgp/U_Pgp3GthUsIpWrapper_1/GEN_6G.U_Pgp3GthUsIp/inst/gen_gtwizard_gthe3_top.Pgp3GthUsIp6G_gtwizard_gthe3_inst/gen_gtwizard_gthe3.gen_rx_user_clocking_internal.gen_single_instance.gtwiz_userclk_rx_inst/gen_gtwiz_userclk_rx_main.bufg_gt_usrclk2_inst/O}]]

##############################################################################
# BITSTREAM: .bit file Configuration
##############################################################################

set_property CONFIG_VOLTAGE 1.8                      [current_design]
set_property CFGBVS GND                              [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE         [current_design]
set_property CONFIG_MODE SPIx8                       [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8         [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES      [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup       [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes     [current_design]
set_property BITSTREAM.STARTUP.LCK_CYCLE NoWait      [current_design]
set_property BITSTREAM.STARTUP.MATCH_CYCLE NoWait    [current_design]

##############################################################################

set_property PACKAGE_PIN R4 [get_ports { timingTxP[0] }]; # SMA = LCLS-I (dummy)
set_property PACKAGE_PIN R3 [get_ports { timingTxN[0] }]; # SMA = LCLS-I (dummy)
set_property PACKAGE_PIN P2 [get_ports { timingRxP[0] }]; # SMA = LCLS-I (dummy)
set_property PACKAGE_PIN P1 [get_ports { timingRxN[0] }]; # SMA = LCLS-I (dummy)

set_property PACKAGE_PIN W4 [get_ports { timingTxP[1] }]; # SFP1 = LCLS-II
set_property PACKAGE_PIN W3 [get_ports { timingTxN[1] }]; # SFP1 = LCLS-II
set_property PACKAGE_PIN V2 [get_ports { timingRxP[1] }]; # SFP1 = LCLS-II
set_property PACKAGE_PIN V1 [get_ports { timingRxN[1] }]; # SFP1 = LCLS-II

##############################################################################

set_property PACKAGE_PIN H11 [get_ports { fmcHpcLaP[0] }]
set_property PACKAGE_PIN G11 [get_ports { fmcHpcLaN[0] }]
set_property PACKAGE_PIN G9  [get_ports { fmcHpcLaP[1] }]
set_property PACKAGE_PIN F9  [get_ports { fmcHpcLaN[1] }]
set_property PACKAGE_PIN K10 [get_ports { fmcHpcLaP[2] }]
set_property PACKAGE_PIN J10 [get_ports { fmcHpcLaN[2] }]
set_property PACKAGE_PIN A13 [get_ports { fmcHpcLaP[3] }]
set_property PACKAGE_PIN A12 [get_ports { fmcHpcLaN[3] }]
set_property PACKAGE_PIN L12 [get_ports { fmcHpcLaP[4] }]
set_property PACKAGE_PIN K12 [get_ports { fmcHpcLaN[4] }]
set_property PACKAGE_PIN L13 [get_ports { fmcHpcLaP[5] }]
set_property PACKAGE_PIN K13 [get_ports { fmcHpcLaN[5] }]
set_property PACKAGE_PIN D13 [get_ports { fmcHpcLaP[6] }]
set_property PACKAGE_PIN C13 [get_ports { fmcHpcLaN[6] }]
set_property PACKAGE_PIN F8  [get_ports { fmcHpcLaP[7] }]
set_property PACKAGE_PIN E8  [get_ports { fmcHpcLaN[7] }]
set_property PACKAGE_PIN J8  [get_ports { fmcHpcLaP[8] }]
set_property PACKAGE_PIN H8  [get_ports { fmcHpcLaN[8] }]
set_property PACKAGE_PIN J9  [get_ports { fmcHpcLaP[9] }]
set_property PACKAGE_PIN H9  [get_ports { fmcHpcLaN[9] }]
set_property PACKAGE_PIN L8  [get_ports { fmcHpcLaP[10] }]
set_property PACKAGE_PIN K8  [get_ports { fmcHpcLaN[10] }]
set_property PACKAGE_PIN K11 [get_ports { fmcHpcLaP[11] }]
set_property PACKAGE_PIN J11 [get_ports { fmcHpcLaN[11] }]
set_property PACKAGE_PIN E10 [get_ports { fmcHpcLaP[12] }]
set_property PACKAGE_PIN D10 [get_ports { fmcHpcLaN[12] }]
set_property PACKAGE_PIN D9  [get_ports { fmcHpcLaP[13] }]
set_property PACKAGE_PIN C9  [get_ports { fmcHpcLaN[13] }]
set_property PACKAGE_PIN B10 [get_ports { fmcHpcLaP[14] }]
set_property PACKAGE_PIN A10 [get_ports { fmcHpcLaN[14] }]
set_property PACKAGE_PIN D8  [get_ports { fmcHpcLaP[15] }]
set_property PACKAGE_PIN C8  [get_ports { fmcHpcLaN[15] }]
set_property PACKAGE_PIN B9  [get_ports { fmcHpcLaP[16] }]
set_property PACKAGE_PIN A9  [get_ports { fmcHpcLaN[16] }]
set_property PACKAGE_PIN D24 [get_ports { fmcHpcLaP[17] }]
set_property PACKAGE_PIN C24 [get_ports { fmcHpcLaN[17] }]
set_property PACKAGE_PIN E22 [get_ports { fmcHpcLaP[18] }]
set_property PACKAGE_PIN E23 [get_ports { fmcHpcLaN[18] }]
set_property PACKAGE_PIN C21 [get_ports { fmcHpcLaP[19] }]
set_property PACKAGE_PIN C22 [get_ports { fmcHpcLaN[19] }]
set_property PACKAGE_PIN B24 [get_ports { fmcHpcLaP[20] }]
set_property PACKAGE_PIN A24 [get_ports { fmcHpcLaN[20] }]
set_property PACKAGE_PIN F23 [get_ports { fmcHpcLaP[21] }]
set_property PACKAGE_PIN F24 [get_ports { fmcHpcLaN[21] }]
set_property PACKAGE_PIN G24 [get_ports { fmcHpcLaP[22] }]
set_property PACKAGE_PIN F25 [get_ports { fmcHpcLaN[22] }]
set_property PACKAGE_PIN G22 [get_ports { fmcHpcLaP[23] }]
set_property PACKAGE_PIN F22 [get_ports { fmcHpcLaN[23] }]
set_property PACKAGE_PIN E20 [get_ports { fmcHpcLaP[24] }]
set_property PACKAGE_PIN E21 [get_ports { fmcHpcLaN[24] }]
set_property PACKAGE_PIN D20 [get_ports { fmcHpcLaP[25] }]
set_property PACKAGE_PIN D21 [get_ports { fmcHpcLaN[25] }]
set_property PACKAGE_PIN G20 [get_ports { fmcHpcLaP[26] }]
set_property PACKAGE_PIN F20 [get_ports { fmcHpcLaN[26] }]
set_property PACKAGE_PIN H21 [get_ports { fmcHpcLaP[27] }]
set_property PACKAGE_PIN G21 [get_ports { fmcHpcLaN[27] }]
set_property PACKAGE_PIN B21 [get_ports { fmcHpcLaP[28] }]
set_property PACKAGE_PIN B22 [get_ports { fmcHpcLaN[28] }]
set_property PACKAGE_PIN B20 [get_ports { fmcHpcLaP[29] }]
set_property PACKAGE_PIN A20 [get_ports { fmcHpcLaN[29] }]
set_property PACKAGE_PIN C26 [get_ports { fmcHpcLaP[30] }]
set_property PACKAGE_PIN B26 [get_ports { fmcHpcLaN[30] }]
set_property PACKAGE_PIN B25 [get_ports { fmcHpcLaP[31] }]
set_property PACKAGE_PIN A25 [get_ports { fmcHpcLaN[31] }]
set_property PACKAGE_PIN E26 [get_ports { fmcHpcLaP[32] }]
set_property PACKAGE_PIN D26 [get_ports { fmcHpcLaN[32] }]
set_property PACKAGE_PIN A27 [get_ports { fmcHpcLaP[33] }]
set_property PACKAGE_PIN A28 [get_ports { fmcHpcLaN[33] }]

set_property -dict { IOSTANDARD LVCMOS18 } [get_ports { fmcHpcLaP[*] }]
set_property -dict { IOSTANDARD LVCMOS18 } [get_ports { fmcHpcLaN[*] }]

##############################################################################

set_property PACKAGE_PIN W23  [get_ports { fmcLpcLaP[0] }]
set_property PACKAGE_PIN W24  [get_ports { fmcLpcLaN[0] }]
set_property PACKAGE_PIN W25  [get_ports { fmcLpcLaP[1] }]
set_property PACKAGE_PIN Y25  [get_ports { fmcLpcLaN[1] }]
set_property PACKAGE_PIN AA22 [get_ports { fmcLpcLaP[2] }]
set_property PACKAGE_PIN AB22 [get_ports { fmcLpcLaN[2] }]
set_property PACKAGE_PIN W28  [get_ports { fmcLpcLaP[3] }]
set_property PACKAGE_PIN Y28  [get_ports { fmcLpcLaN[3] }]
set_property PACKAGE_PIN U26  [get_ports { fmcLpcLaP[4] }]
set_property PACKAGE_PIN U27  [get_ports { fmcLpcLaN[4] }]
set_property PACKAGE_PIN V27  [get_ports { fmcLpcLaP[5] }]
set_property PACKAGE_PIN V28  [get_ports { fmcLpcLaN[5] }]
set_property PACKAGE_PIN V29  [get_ports { fmcLpcLaP[6] }]
set_property PACKAGE_PIN W29  [get_ports { fmcLpcLaN[6] }]
set_property PACKAGE_PIN V22  [get_ports { fmcLpcLaP[7] }]
set_property PACKAGE_PIN V23  [get_ports { fmcLpcLaN[7] }]
set_property PACKAGE_PIN U24  [get_ports { fmcLpcLaP[8] }]
set_property PACKAGE_PIN U25  [get_ports { fmcLpcLaN[8] }]
set_property PACKAGE_PIN V26  [get_ports { fmcLpcLaP[9] }]
set_property PACKAGE_PIN W26  [get_ports { fmcLpcLaN[9] }]
set_property PACKAGE_PIN T22  [get_ports { fmcLpcLaP[10] }]
set_property PACKAGE_PIN T23  [get_ports { fmcLpcLaN[10] }]
set_property PACKAGE_PIN V21  [get_ports { fmcLpcLaP[11] }]
set_property PACKAGE_PIN W21  [get_ports { fmcLpcLaN[11] }]
set_property PACKAGE_PIN AC22 [get_ports { fmcLpcLaP[12] }]
set_property PACKAGE_PIN AC23 [get_ports { fmcLpcLaN[12] }]
set_property PACKAGE_PIN AA20 [get_ports { fmcLpcLaP[13] }]
set_property PACKAGE_PIN AB20 [get_ports { fmcLpcLaN[13] }]
set_property PACKAGE_PIN U21  [get_ports { fmcLpcLaP[14] }]
set_property PACKAGE_PIN U22  [get_ports { fmcLpcLaN[14] }]
set_property PACKAGE_PIN AB25 [get_ports { fmcLpcLaP[15] }]
set_property PACKAGE_PIN AB26 [get_ports { fmcLpcLaN[15] }]
set_property PACKAGE_PIN AB21 [get_ports { fmcLpcLaP[16] }]
set_property PACKAGE_PIN AC21 [get_ports { fmcLpcLaN[16] }]
set_property PACKAGE_PIN AA32 [get_ports { fmcLpcLaP[17] }]
set_property PACKAGE_PIN AB32 [get_ports { fmcLpcLaN[17] }]
set_property PACKAGE_PIN AB30 [get_ports { fmcLpcLaP[18] }]
set_property PACKAGE_PIN AB31 [get_ports { fmcLpcLaN[18] }]
set_property PACKAGE_PIN AA29 [get_ports { fmcLpcLaP[19] }]
set_property PACKAGE_PIN AB29 [get_ports { fmcLpcLaN[19] }]
set_property PACKAGE_PIN AA34 [get_ports { fmcLpcLaP[20] }]
set_property PACKAGE_PIN AB34 [get_ports { fmcLpcLaN[20] }]
set_property PACKAGE_PIN AC33 [get_ports { fmcLpcLaP[21] }]
set_property PACKAGE_PIN AD33 [get_ports { fmcLpcLaN[21] }]
set_property PACKAGE_PIN AC34 [get_ports { fmcLpcLaP[22] }]
set_property PACKAGE_PIN AD34 [get_ports { fmcLpcLaN[22] }]
set_property PACKAGE_PIN AD30 [get_ports { fmcLpcLaP[23] }]
set_property PACKAGE_PIN AD31 [get_ports { fmcLpcLaN[23] }]
set_property PACKAGE_PIN AE32 [get_ports { fmcLpcLaP[24] }]
set_property PACKAGE_PIN AF32 [get_ports { fmcLpcLaN[24] }]
set_property PACKAGE_PIN AE33 [get_ports { fmcLpcLaP[25] }]
set_property PACKAGE_PIN AF34 [get_ports { fmcLpcLaN[25] }]
set_property PACKAGE_PIN AF33 [get_ports { fmcLpcLaP[26] }]
set_property PACKAGE_PIN AG34 [get_ports { fmcLpcLaN[26] }]
set_property PACKAGE_PIN AG31 [get_ports { fmcLpcLaP[27] }]
set_property PACKAGE_PIN AG32 [get_ports { fmcLpcLaN[27] }]
set_property PACKAGE_PIN V31  [get_ports { fmcLpcLaP[28] }]
set_property PACKAGE_PIN W31  [get_ports { fmcLpcLaN[28] }]
set_property PACKAGE_PIN U34  [get_ports { fmcLpcLaP[29] }]
set_property PACKAGE_PIN V34  [get_ports { fmcLpcLaN[29] }]
set_property PACKAGE_PIN Y31  [get_ports { fmcLpcLaP[30] }]
set_property PACKAGE_PIN Y32  [get_ports { fmcLpcLaN[30] }]
set_property PACKAGE_PIN V33  [get_ports { fmcLpcLaP[31] }]
set_property PACKAGE_PIN W34  [get_ports { fmcLpcLaN[31] }]
set_property PACKAGE_PIN W30  [get_ports { fmcLpcLaP[32] }]
set_property PACKAGE_PIN Y30  [get_ports { fmcLpcLaN[32] }]
set_property PACKAGE_PIN W33  [get_ports { fmcLpcLaP[33] }]
set_property PACKAGE_PIN Y33  [get_ports { fmcLpcLaN[33] }]

set_property -dict { IOSTANDARD LVCMOS18 } [get_ports { fmcLpcLaP[*] }]
set_property -dict { IOSTANDARD LVCMOS18 } [get_ports { fmcLpcLaN[*] }]

##############################################################################

set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[6] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[10] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[14] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[18] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[27] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[1] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcHpcLaP[5] }]

set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[6] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[10] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[14] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[18] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[27] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[1] }]
set_property -dict { IOSTANDARD LVDS DIFF_TERM_ADV TERM_100 } [get_ports { fmcLpcLaP[5] }]

##############################################################################

#### Base Clocks
create_generated_clock -name clk156 [get_pins {U_Core/U_Pgp/U_axilClk/PllGen.U_Pll/CLKOUT0}]
create_generated_clock -name clk25  [get_pins {U_Core/U_Pgp/U_axilClk/PllGen.U_Pll/CLKOUT1}]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets U_Core/U_Pgp/U_axilClk/clkOut[1]]

create_generated_clock -name clk238 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_MMCM.U_238MHz/MmcmGen.U_Mmcm/CLKOUT0}]
create_generated_clock -name clk371 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_MMCM.U_371MHz/MmcmGen.U_Mmcm/CLKOUT0}]

create_generated_clock -name clk119 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_refClkDiv2/O}]
create_generated_clock -name clk186 [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_refClkDiv2/O}]

#### GT Out Clocks
create_clock -name timingGtRxOutClk0  -period 8.403 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTH/*/RXOUTCLK}]

create_generated_clock -name timingGtTxOutClk0 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTH/*/TXOUTCLK}]

create_generated_clock -name timingTxOutClk0 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].REAL_PCIE.U_GTH/LOCREF_G.TIMING_TXCLK_BUFG_GT/O}]

create_clock -name timingGtRxOutClk1  -period 5.384 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].REAL_PCIE.U_GTH/*/RXOUTCLK}]

create_generated_clock -name timingGtTxOutClk1 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].REAL_PCIE.U_GTH/*/TXOUTCLK}]

create_generated_clock -name timingTxOutClk1 \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].REAL_PCIE.U_GTH/LOCREF_G.TIMING_TXCLK_BUFG_GT/O}]


#### Cascaded clock muxing - GEN_VEC[0] RX mux
create_generated_clock -name muxRxClk119 \
    -divide_by 1 -add -master_clock clk119 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/O}]

create_generated_clock -name muxTimingGtRxOutClk0 \
    -divide_by 1 -add -master_clock timingGtRxOutClk0 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingGtRxOutClk0 -group muxRxClk119
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_RXCLK/CE*}]

#### Cascaded clock muxing - GEN_VEC[0] TX mux
create_generated_clock -name muxTxClk119 \
    -divide_by 1 -add -master_clock clk119 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/O}]

create_generated_clock -name muxTimingTxOutClk0 \
    -divide_by 1 -add -master_clock timingTxOutClk0 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingTxOutClk0 -group muxTxClk119
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[0].U_TXCLK/CE*}]


##### Cascaded clock muxing - GEN_VEC[1] RX mux
create_generated_clock -name muxRxClk186 \
    -divide_by 1 -add -master_clock clk186 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/O}]

create_generated_clock -name muxTimingGtRxOutClk1 \
    -divide_by 1 -add -master_clock timingGtRxOutClk1 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingGtRxOutClk1 -group muxRxClk186
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_RXCLK/CE*}]

##### Cascaded clock muxing - GEN_VEC[1] TX mux
create_generated_clock -name muxTxClk186 \
    -divide_by 1 -add -master_clock clk186 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/I1}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/O}]

create_generated_clock -name muxTimingTxOutClk1 \
    -divide_by 1 -add -master_clock timingTxOutClk1 \
    -source [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/I0}] \
    [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/O}]

set_clock_groups -physically_exclusive -group muxTimingTxOutClk1 -group muxTxClk186
set_false_path -to [get_pins -hier -filter {name =~ */U_TimingRx/GEN_VEC[1].U_TXCLK/CE*}]


###### Cascaded clock muxing - Final RX mux
create_generated_clock -name casMuxRxClk119 \
    -divide_by 1 -add -master_clock muxRxClk119 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxTimingGtRxOutClk0 \
    -divide_by 1 -add -master_clock muxTimingGtRxOutClk0 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxRxClk186 \
    -divide_by 1 -add -master_clock muxRxClk186 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

create_generated_clock -name casMuxTimingGtRxOutClk1 \
    -divide_by 1 -add -master_clock muxTimingGtRxOutClk1 \
    -source [get_pins {*/U_TimingRx/U_RXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_RXCLK/O}]

set_clock_groups -physically_exclusive \
    -group casMuxRxClk119 \
    -group casMuxTimingGtRxOutClk0 \
    -group casMuxRxClk186 \
    -group casMuxTimingGtRxOutClk1

set_false_path -to [get_pins {*/U_TimingRx/U_RXCLK/CE*}]

###### Cascaded clock muxing - Final TX mux
create_generated_clock -name casMuxTxClk119 \
    -divide_by 1 -add -master_clock muxTxClk119 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTimingTxOutClk0 \
    -divide_by 1 -add -master_clock muxTimingTxOutClk0 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I0}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTxClk186 \
    -divide_by 1 -add -master_clock muxTxClk186 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

create_generated_clock -name casMuxTimingTxOutClk1 \
    -divide_by 1 -add -master_clock muxTimingTxOutClk1 \
    -source [get_pins {*/U_TimingRx/U_TXCLK/I1}] \
    [get_pins {*/U_TimingRx/U_TXCLK/O}]

set_clock_groups -physically_exclusive \
    -group casMuxTxClk119 \
    -group casMuxTimingTxOutClk0
    -group casMuxTxClk186 \
    -group casMuxTimingTxOutClk1

set_false_path -to [get_pins {*/U_TimingRx/U_TXCLK/CE*}]



# set_case_analysis 1 [get_pins {*/U_TimingRx/GEN_VEC[0].U_RXCLK/S}]
# set_case_analysis 1 [get_pins {*/U_TimingRx/GEN_VEC[1].U_RXCLK/S}]
# set_case_analysis 1 [get_pins {*/U_TimingRx/U_RXCLK/S}]
# set_case_analysis 1 [get_pins {*/U_TimingRx/U_TXCLK/S}]

set_clock_groups -asynchronous \
    -group [get_clocks -include_generated_clocks {clk156}] \
    -group [get_clocks -include_generated_clocks {timingGtRxOutClk0}] \
    -group [get_clocks -include_generated_clocks {timingGtRxOutClk1}] \
    -group [get_clocks -include_generated_clocks {timingGtTxOutClk0}] \
    -group [get_clocks -include_generated_clocks {timingGtTxOutClk1}] \
    -group [get_clocks -include_generated_clocks {clk238}]  \
    -group [get_clocks -include_generated_clocks {clk371}]

# set_clock_groups -asynchronous \
#     -group [get_clocks {clk156}] \
#     -group [get_clocks {timingGtRxOutClk1}]  \
#     -group [get_clocks {timingTxOutClk1}] \
#     -group [get_clocks {timingRxClk}] \
#     -group [get_clocks {timingTxClk}]

# set_clock_groups -asynchronous \
#     -group [get_clocks {clk156}]  \
#     -group [get_clocks {clk238}]  \
#     -group [get_clocks {clk371}] \
#     -group [get_clocks {dmaClk}]

set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_fmcClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks casMuxRxClk186]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_fmcClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks casMuxTimingGtRxOutClk0]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_fmcClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks casMuxTimingGtRxOutClk1]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_fmcClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_axilClk/PllGen.U_Pll/CLKOUT0]]
set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins U_Core/U_Pgp/U_fmcClk/PllGen.U_Pll/CLKOUT0]] -group [get_clocks casMuxRxClk119]
