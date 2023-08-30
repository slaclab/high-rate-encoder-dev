# high-rate-encoder-dev

<!--- ######################################################## -->

# Before you clone the GIT repository

https://confluence.slac.stanford.edu/x/vJmDFg

# Clone the GIT repository

```
$ git clone --recursive git@github.com:slaclab/high-rate-encoder-dev
```


<!--- ######################################################## -->

# KCU105 Setup for QSPI Boot

For booting up the KCU105 via the QSPI PROM, you will need to setup the SW15 switch with position#1 in the arrow direction:

![KCU105 Setup for QSPI Boot](https://github.com/slaclab/Simple-10GbE-RUDP-KCU105-Example/blob/main/docs/images/SW15.png)

<!--- ######################################################## -->

# KCU105 SFP[1:0] Fiber mapping

```
SFP[0]= PGPv4[6Gb/s].VC[3:0]
SFP[1] = LCLS-II Timing Receiver
```

<!--- ######################################################## -->

# PGPv4[6Gb/s] Virtual Channel mapping on SFP[0]

```
VC[0] = SRPv3
VC[1] = Event Builder Batcher (super-frame)
VC[1].DEST[0] = XPM Trigger Message (sub-frame)
VC[1].DEST[1] = XPM Transition Message (sub-frame)
VC[1].DEST[2] = Encoder 64-bit Message (sub-frame)
VC[1].DEST[3] = XPM Timing Message (sub-frame)
VC[2] = Xilinx Virtual Cable (XVC)
VC[3] = Unused
```

<!--- ######################################################## -->

# Encoder 64-bit Message

```
BIT[31:00] = Encoder position
BIT[39:32] = Encoder Error Counter
BIT[47:40] = Missed Trigger Counter
BIT[48]    = "E" latch
BIT[49]    = "P" latch
BIT[50]    = "Q" latch
BIT[63:51] = Reserved (zeros)
```

<!--- ######################################################## -->

# How to build the KCU105 firmware

1) Setup Xilinx licensing
```
$ source high-rate-encoder-dev/firmware/setup_env_slac.sh
```

2) Go to the target directory and make the firmware:
```
$ cd high-rate-encoder-dev/firmware/targets/HighRateEncoderKcu105
$ make
```

3) Optional: Review the results in GUI mode
```
$ make gui
```

<!--- ######################################################## -->

# How to install the Rogue With Anaconda

> https://slaclab.github.io/rogue/installing/anaconda.html

<!--- ######################################################## -->

# XPM Triggering Documentation

https://docs.google.com/document/d/1B_sIkk9Fxsw2EjOBpGVFpfCCWoIiOJoVGTrkTshZfew/edit?usp=sharing

<!--- ######################################################## -->

# How to reprogram the KCU105 firmware via Rogue software

1) Setup the rogue environment
```
$ cd high-rate-encoder-dev/software
$ source setup_env_slac.sh
```

2) Run the KCU105 firmware update script:
```
$ python scripts/updateBootProm.py --path <PATH_TO_IMAGE_DIR>
```
where <PATH_TO_IMAGE_DIR> is path to image directory (example: ../firmware/targets/HighRateEncoderKcu105/images/)

<!--- ######################################################## -->

# Example of starting up GUI in stand alone mode (locally generated timing)

1) Setup the rogue environment
```
$ cd high-rate-encoder-dev/software
$ source setup_env_slac.sh
```

2) Run the python GUI in stand alone mode
```
$ python scripts/devGui.py --standAloneMode 1
Then execute the StartRun() command to start the triggering
```

<!--- ######################################################## -->
