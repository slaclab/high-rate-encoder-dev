# Load RUCKUS environment and library
source -quiet $::env(RUCKUS_DIR)/vivado_proc.tcl

# Load shared and sub-module ruckus.tcl files
loadRuckusTcl $::env(TOP_DIR)/submodules/surf
loadRuckusTcl $::env(TOP_DIR)/submodules/lcls-timing-core
loadRuckusTcl $::env(TOP_DIR)/submodules/lcls2-pgp-fw-lib/shared
loadRuckusTcl $::env(TOP_DIR)/shared

# Load the l2si-core source code
loadSource -lib l2si_core -dir "$::env(TOP_DIR)/submodules/l2si-core/xpm/rtl"
loadSource -lib l2si_core -dir "$::env(TOP_DIR)/submodules/l2si-core/base/rtl"

# Load local source Code and constraints
loadSource      -dir "$::DIR_PATH/hdl"
loadConstraints -dir "$::DIR_PATH/hdl"
