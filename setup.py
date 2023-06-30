from setuptools import setup

# use softlinks to make the various "board-support-package" submodules
# look like subpackages.  Then __init__.py will modify
# sys.path so that the correct "local" versions of surf etc. are
# picked up.  A better approach would be using relative imports
# in the submodules, but that's more work.  -cpo

setup(
    name = 'high_rate_encoder_dev',
    description = 'High Rate econder  package',
    packages = [
        'high_rate_encoder_dev',
        'high_rate_encoder_dev.axipcie',
        'high_rate_encoder_dev.l2si_core',
        'high_rate_encoder_dev.daq_stream_cache',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib.hardware.XilinxKcu1500',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib.hardware.SlacPgpCardG4',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib.hardware',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib.hardware.shared',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib',
        'high_rate_encoder_dev.surf.misc',
        'high_rate_encoder_dev.surf.xilinx',
        'high_rate_encoder_dev.surf.axi',
        'high_rate_encoder_dev.surf',
        'high_rate_encoder_dev.surf.ethernet.xaui',
        'high_rate_encoder_dev.surf.ethernet.udp',
        'high_rate_encoder_dev.surf.ethernet.ten_gig',
        'high_rate_encoder_dev.surf.ethernet',
        'high_rate_encoder_dev.surf.ethernet.mac',
        'high_rate_encoder_dev.surf.ethernet.gige',
        'high_rate_encoder_dev.surf.dsp',
        'high_rate_encoder_dev.surf.dsp.fixed',
        'high_rate_encoder_dev.surf.protocols.clink',
        'high_rate_encoder_dev.surf.protocols.ssp',
        'high_rate_encoder_dev.surf.protocols.jesd204b',
        'high_rate_encoder_dev.surf.protocols.i2c',
        'high_rate_encoder_dev.surf.protocols',
        'high_rate_encoder_dev.surf.protocols.ssi',
        'high_rate_encoder_dev.surf.protocols.batcher',
        'high_rate_encoder_dev.surf.protocols.rssi',
        'high_rate_encoder_dev.surf.protocols.pgp',
        'high_rate_encoder_dev.surf.devices.intel',
        'high_rate_encoder_dev.surf.devices.nxp',
        'high_rate_encoder_dev.surf.devices.cypress',
        'high_rate_encoder_dev.surf.devices.linear',
        'high_rate_encoder_dev.surf.devices.micron',
        'high_rate_encoder_dev.surf.devices',
        'high_rate_encoder_dev.surf.devices.analog_devices',
        'high_rate_encoder_dev.surf.devices.microchip',
        'high_rate_encoder_dev.surf.devices.transceivers',
        'high_rate_encoder_dev.surf.devices.silabs',
        'high_rate_encoder_dev.surf.devices.ti',
        'high_rate_encoder_dev.LclsTimingCore',
    ],
    package_dir = {
        'high_rate_encoder_dev': 'firmware/python/high_rate_encoder_dev',
        'high_rate_encoder_dev.surf': 'firmware/submodules/surf/python/surf',
        'high_rate_encoder_dev.surf': 'firmware/submodules/surf/python/surf',
        'high_rate_encoder_dev.axipcie': 'firmware/submodules/axi-pcie-core/python/axipcie',
        'high_rate_encoder_dev.LclsTimingCore': 'firmware/submodules/lcls-timing-core/python/LclsTimingCore',
        'high_rate_encoder_dev.lcls2_pgp_fw_lib': 'firmware/submodules/lcls2-pgp-fw-lib/python/lcls2_pgp_fw_lib',
        'high_rate_encoder_dev.l2si_core': 'firmware/submodules/l2si-core/python/l2si_core'
    }
)
