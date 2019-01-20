#!/bin/sh

#
# PocketChip U-boot flashing script
# hjkim, 2018.03.08
#

# Reference:
# https://github.com/NextThingCo/CHIP-tools
# https://github.com/NextThingCo/CHIP-tools/blob/chip/stable/common.sh
# https://github.com/NextThingCo/CHIP-tools/blob/chip/stable/chip-fel-upload.sh
#
# mkimage
# sudo apt-get install u-boot-tools
# img2simg
# sudo apt-get install android-tools-fsutils


export PATH=/test/tmp/pocketchip_tools/sunxi-tools-master:$PATH
# check: fastboot path
# check: img2simg path

SUNXI_FEL=sunxi-fel
FASTBOOT=fastboot
UBOOT_PATH="/test/tmp/pocketchip_uboot/CHIP-u-boot-nextthing-2016.01-next-mlc"
UBOOT_SCRIPT="./CHIP-u-boot-script"
BUILDROOT_OUTPUT_PATH="/test/tmp/pocketchip_buildroot/CHIP-buildroot-chip-stable/output/images"
UBI="$BUILDROOT_OUTPUT_PATH/rootfs.ubi"

echo "[REMOVE $UBOOT_SCRIPT]"
rm -f "$UBOOT_SCRIPT"


PAGE_SIZE=16384
OOB_SIZE=1664
PADDED_SPL_SIZE=`stat --printf="%s" $UBOOT_PATH/spl/sunxi-spl-with-ecc.bin`
echo "PADDED SPL SIZE = $PADDED_SPL_SIZE"
PADDED_SPL_SIZE=$(($PADDED_SPL_SIZE / ($PAGE_SIZE + $OOB_SIZE)))
PADDED_SPL_SIZE=$(echo $PADDED_SPL_SIZE | xargs printf "0x%08x")
echo "PADDED SPL SIZE = $PADDED_SPL_SIZE"
#
#
PADDED_UBOOT="uboot-padded_uboot"
echo '[padded u-boot]: it needs to be padded to 4MB ...'
dd if=u-boot-dtb.bin of="$PADDED_UBOOT" bs=4M conv=sync
echo
echo '[padded u-boot]'
PADDED_UBOOT_SIZE=0x400000
UBOOT_SIZE=`stat --printf="%s" "$PADDED_UBOOT" | xargs printf "0x%08x"`
echo "UBOOT_SIZE=${UBOOT_SIZE}"
echo "PADDED_UBOOT_SIZE=${PADDED_UBOOT_SIZE}"
dd if=/dev/urandom of="$PADDED_UBOOT" seek=$((UBOOT_SIZE / 0x4000)) bs=16k count=$(((PADDED_UBOOT_SIZE - UBOOT_SIZE) / 0x4000))
echo
#
#
#DTB_NAME="ntc-gr8-crumb.dtb"
DTB_NAME="sun5i-r8-chip.dtb"
echo "#echo \"Erase NAND memory\"" >> $UBOOT_SCRIPT
echo "#nand erase 0x0 0x200000000" >> $UBOOT_SCRIPT
echo "echo \"Write primary SPL\"" >> $UBOOT_SCRIPT
echo "nand write.raw.noverify 0x43000000 0x0 $PADDED_SPL_SIZE" >> $UBOOT_SCRIPT
echo "echo \"Write backup SPL\"" >> $UBOOT_SCRIPT
echo "nand write.raw.noverify 0x43000000 0x400000 $PADDED_SPL_SIZE" >> $UBOOT_SCRIPT
echo "echo \"Write Uboot\"" >> $UBOOT_SCRIPT
echo "nand write 0x4a000000 0x800000 $PADDED_UBOOT_SIZE" >> $UBOOT_SCRIPT
echo "echo \"Setup boot env\"" >> $UBOOT_SCRIPT
echo "setenv bootargs root=ubi0:rootfs rootfstype=ubifs rw earlyprintk ubi.mtd=4" >> $UBOOT_SCRIPT
echo "setenv bootcmd 'gpio set PB2; if test -n \${fel_booted} && test -n \${scriptaddr}; then echo '(FEL boot)'; source \${scriptaddr}; fi; mtdparts; ubi part UBI; ubifsmount ubi0:rootfs; ubifsload \$fdt_addr_r /boot/$DTB_NAME; ubifsload \$kernel_addr_r /boot/zImage; bootz \$kernel_addr_r - \$fdt_addr_r'" >> $UBOOT_SCRIPT
echo "setenv fel_booted 0" >> $UBOOT_SCRIPT
echo "#" >> $UBOOT_SCRIPT
echo "echo \"Enabling Splash\"" >> $UBOOT_SCRIPT
echo "setenv stdout serial" >> $UBOOT_SCRIPT
echo "setenv stderr serial" >> $UBOOT_SCRIPT
echo "setenv splashpos m,m" >> $UBOOT_SCRIPT
echo "#" >> $UBOOT_SCRIPT
echo "echo \"echo Configuring Video Mode\"" >> $UBOOT_SCRIPT
echo "setenv clear_fastboot 'i2c mw 0x34 0x4 0x00 4;'" >> $UBOOT_SCRIPT
echo "setenv write_fastboot 'i2c mw 0x34 0x4 66 1; i2c mw 0x34 0x5 62 1; i2c mw 0x34 0x6 30 1; i2c mw 0x34 0x7 00 1'" >> $UBOOT_SCRIPT
echo "setenv test_fastboot 'i2c read 0x34 0x4 4 0x80200000; if itest.s *0x80200000 -eq fb0; then echo (Fastboot); i2c mw 0x34 0x4 0x00 4; fastboot 0; fi'" >> $UBOOT_SCRIPT

echo "setenv bootargs root=ubi0:rootfs rootfstype=ubifs rw ubi.mtd=4 quiet lpj=501248 loglevel=3 splash plymouth.ignore-serial-consoles" >> $UBOOT_SCRIPT
echo "setenv bootpaths 'initrd noinitrd'" >> $UBOOT_SCRIPT
echo "setenv bootcmd '${NO_LIMIT}run test_fastboot; if test -n \${fel_booted} && test -n \${scriptaddr}; then echo (FEL boot); source \${scriptaddr}; fi; for path in \${bootpaths}; do run boot_\$path; done'" >> $UBOOT_SCRIPT
echo "setenv boot_initrd 'mtdparts; ubi part UBI; ubifsmount ubi0:rootfs; ubifsload \$fdt_addr_r /boot/$DTB_NAME; ubifsload 0x44000000 /boot/initrd.uimage; ubifsload \$kernel_addr_r /boot/zImage; bootz \$kernel_addr_r 0x44000000 \$fdt_addr_r'" >> $UBOOT_SCRIPT
echo "setenv boot_noinitrd 'mtdparts; ubi part UBI; ubifsmount ubi0:rootfs; ubifsload \$fdt_addr_r /boot/$DTB_NAME; ubifsload \$kernel_addr_r /boot/zImage; bootz \$kernel_addr_r - \$fdt_addr_r'" >> $UBOOT_SCRIPT
echo "setenv video-mode" >> $UBOOT_SCRIPT
echo "setenv dip_addr_r 0x43400000" >> $UBOOT_SCRIPT
echo "setenv dip_overlay_dir /lib/firmware/nextthingco/chip/early" >> $UBOOT_SCRIPT
echo "setenv dip_overlay_cmd 'if test -n \"\${dip_overlay_name}\"; then ubifsload \$dip_addr_r \$dip_overlay_dir/\$dip_overlay_name; fi'" >> $UBOOT_SCRIPT
echo "setenv fel_booted 0" >> $UBOOT_SCRIPT
echo "setenv bootdelay 1" >> $UBOOT_SCRIPT
echo "#" >> $UBOOT_SCRIPT
echo "saveenv" >> $UBOOT_SCRIPT
echo "#echo \"Go to fastboot mode\"" >> $UBOOT_SCRIPT
echo "#fastboot 0" >> $UBOOT_SCRIPT







echo '[mkimage]: U-boot script ...'
mkimage -A arm -T script -C none -n "flash CHIP" -d $UBOOT_SCRIPT uboot-script.img
echo


echo '[flashing] ...'

# SPL
$SUNXI_FEL -v -p spl $UBOOT_PATH/spl/sunxi-spl.bin

# PADDED-SPL
$SUNXI_FEL -v -p write 0x43000000 $UBOOT_PATH/spl/sunxi-spl-with-ecc.bin

# PADDED-UBOOT
#$SUNXI_FEL -v -p write 0x4a000000 $UBOOT_PATH/u-boot-sunxi-padded.bin
$SUNXI_FEL -v -p write 0x4a000000 $UBOOT_PATH/uboot-padded_uboot

# UBOOT SCRIPT
$SUNXI_FEL -v -p write 0x43100000 $UBOOT_PATH/uboot-script.img

# UBI
#$SUNXI_FEL -v -p write $UBI_MEM_ADDR "${UBI}"

# EXECUTE THE MAIN U-BOOT BINARY
$SUNXI_FEL -v -p exe 0x4a000000





#wait_for_fastboot() {
#  if [[ -v DONT_WAIT_FOR_STATE ]]; then return 0; fi
#
#  echo -n "waiting for fastboot...";
#  export FLASH_WAITING_FOR_DEVICE=1
#  for ((i=$TIMEOUT; i>0; i--)) {
#    if [[ ! -z "$(${FASTBOOT} -i 0x1f3a $@ devices)" ]]; then
#      echo "OK";
#      unset FLASH_WAITING_FOR_DEVICE
#      return 0;
#    fi
#    echo -n ".";
#    sleep 1
#  }
#
#  echo "TIMEOUT";
#  unset FLASH_WAITING_FOR_DEVICE
#  return 1
#}

#export FLASH_VID_PID=1f3a1010
#  if wait_for_fastboot; then
#    $FASTBOOT -i 0x1f3a -u flash UBI ubi.sparse
#    $FASTBOOT -i 0x1f3a continue > /dev/null
#  else
#    echo "failed to flash the UBI image"
#fi


echo 'done...'
