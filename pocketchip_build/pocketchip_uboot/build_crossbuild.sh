#!/bin/sh

#
# PocketChip U-boot build script
# hjkim, 2018.03.08
#
#
# Source: https://github.com/NextThingCo/CHIP-u-boot/tree/production-mlc
#         (branch: production-mlc)
#
#
# bypass EEPROM check
# 1. ignore EEPROM check
#   configs/CHIP_defconfig
#   - comment-out: 
#       #CONFIG_EEPROM=y
#       #CONFIG_EEPROM_DS2431=y
#
# 2. bypass EEPROM check and fixed target board as 'PocketC.H.I.P.' (as-if PocketC.H.I.P. board)
#   board/sunxi/dip.c
#
# static void dip_detect(void) {
#    ...
# 
#    for (device_find_first_child(bus, &dev); dev; device_find_next_child(&dev)) {
#        ...
#    }
#
# [ADD THIS]
#
#//! for custom board
#// 2018.03.08
#// - hjkim
#// bypass EEPROM check [
#	//if ( display == DISPLAY_COMPOSITE ) {
#	//	if ( strlen(dip_name) <= 0 ) {
#			printf( "DIP: reset for custom board\n" );
#			// 0x9d011a / 0x1
#			vid = DIP_VID_NTC;
#			pid = DIP_PID_NTC_POCKET;
#
#			memset( dip_name, 0x00, sizeof(dip_name) );
#			snprintf(dip_name, 64, "dip-%x-%x.dtbo", vid, pid);
#			display = DISPLAY_RGB_POCKET;
#	//	}
#	//}
#// ]
#
#	dip_setup_pocket_display(display);
# }
#
#


# https://github.com/NextThingCo/dtc
export PATH=/test/tmp/dtc/dtc-master:$PATH

make clean && \
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf- CHIP_defconfig && \
make ARCH=arm CROSS_COMPILE=/usr/bin/arm-linux-gnueabihf-

#dd if=u-boot-dtb.bin of=uboot-400000.bin bs=4M conv=sync
