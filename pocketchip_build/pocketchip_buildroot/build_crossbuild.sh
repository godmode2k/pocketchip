#!/bin/sh

#
# PocketChip buildroot build script
# hjkim, 2018.03.08
#
#
# Source: https://github.com/NextThingCo/CHIP-buildroot/tree/chip/stable
#         (branch: chip/stable)
#
# NOTE:
#  - DO NOT RUN AS root
#
#  - pocketchip_buildroot/output/build/rtl8723bs_bt-master/Makefile
#    (edit the install path)
#
#


export LD_LIBRARY_PATH=""


make clean && \

# CHIP
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- chip_defconfig && \

# PocketCHIP (DO NOT USE THIS!)
#make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- pocketchip_defconfig && \

# Kernel configuration (DO NOT USE THIS for DEFAULT)
#make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- nconfig && \

make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
