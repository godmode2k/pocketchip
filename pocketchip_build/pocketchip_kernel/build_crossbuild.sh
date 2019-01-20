#!/bin/sh

#
# PocketChip Kernel build script
# hjkim, 2018.03.08
#
#
# Source: https://github.com/NextThingCo/CHIP-linux/tree/debian/4.4.13-ntc-mlc
#         (branch: debian/4.4.13-ntc-mlc)
#
#
#
# NOTE:
#  - COPY the config file to source path as named '.config'
#  - file: config-4.4.13-ntc-mlc -> .config
#

make clean && \
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-
