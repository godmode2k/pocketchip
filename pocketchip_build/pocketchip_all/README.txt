
# Source:
https://bbs.nextthing.co/t/yocto-meta-chip-results-in-non-booting-chip-stuck-in-fel-mode/18770/4
https://github.com/myfreescalewebpage/meta-chip
https://github.com/myfreescalewebpage/chip-tools/blob/master/chip-flash-chip.sh
https://bbs.nextthing.co/t/pocket-c-h-i-p-factory-image/9778



files:
 rootfs.ubi
 sunxi-spl.bin
 sunxi-spl-with-ecc.bin
 u-boot-dtb.bin

http://opensource.nextthing.co/pocketchip/rootfs.ubi
http://opensource.nextthing.co/pocketchip/sun5i-r8-chip.dtb
http://opensource.nextthing.co/pocketchip/sunxi-spl.bin
http://opensource.nextthing.co/pocketchip/sunxi-spl-with-ecc.bin
http://opensource.nextthing.co/pocketchip/uboot-env.bin
http://opensource.nextthing.co/pocketchip/zImage
http://opensource.nextthing.co/pocketchip/u-boot-dtb.bin





sudo ./chip-flash-chip.sh "img path"

------------------------

https://github.com/NextThingCo/CHIP-tools/blob/chip/stable/chip-update-firmware.sh

DL_DIR=".dl"
IMAGESDIR=".new/firmware/images"
DL_URL="http://opensource.nextthing.co/chip/images"
WGET="wget"

FLAVOR=pocketchip
BRANCH=stable

UBI_PREFIX="chip"
UBI_SUFFIX="ubi.sparse"
UBI_TYPE="400000-4000-500"
 
/*
UBI_TYPE="$nand_erasesize-$nand_writesize-$nand_oobsize"

// Hynix_8G_MLC
nand_erasesize=400000
nand_oobsize=680
nand_writesize=4000

// Toshiba_4G_MLC
nand_erasesize=400000
nand_oobsize=500
nand_writesize=4000

// Toshiba_512M_SLC
nand_erasesize=40000
nand_oobsize=100
nand_writesize=1000
*/


CACHENUM=$(curl -s $DL_URL/$BRANCH/$FLAVOR/latest)
$WGET $DL_URL/$BRANCH/$FLAVOR/${CACHENUM}/$UBI_PREFIX-$UBI_TYPE.$UBI_SUFFIX

------------------------

# UBI
wget http://opensource.nextthing.co/chip/images/stable/pocketchip/126/chip-400000-4000-680.ubi.sparse
wget http://opensource.nextthing.co/chip/images/stable/pocketchip/126/chip-400000-4000-500.ubi.sparse
wget http://opensource.nextthing.co/pocketchip/rootfs.ubi

# cache number
http://opensource.nextthing.co/chip/images/stable/pocketchip/latest
response: 126

------------------------


