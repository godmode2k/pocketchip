#!/bin/bash


#
# based: https://github.com/NextThingCo/CHIP-tools/blob/chip/stable/chip-update-firmware.sh
# based: https://github.com/NextThingCo/CHIP-tools/blob/chip/stable/common.sh
#
# - hjkim, 2018.03.22
#



SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $SCRIPTDIR/common.sh

#UBOOT_IMAGE_PATH="/test/tmp/pocketchip_uboot/CHIP-u-boot-nextthing-2016.01-next-mlc"
UBOOT_IMAGE_PATH="/test/tmp/pocketchip_uboot/CHIP-u-boot-production-mlc"

#DL_DIR=".dl"
#IMAGESDIR=".new/firmware/images"
IMAGESDIR=".images"

#DL_URL="http://opensource.nextthing.co/chip/images"
#WGET="wget"

FLAVOR=server
BRANCH=stable


UBI_PREFIX="chip"
UBI_SUFFIX="ubi.sparse"
UBI_TYPE="400000-4000-680"

echo "== Pocketchip selected =="
FLAVOR="pocketchip"


function require_directory {
  if [[ ! -d "${1}" ]]; then
      mkdir -p "${1}"
  fi
}

function dl_probe {
  # Hynix_8G_MLC
  #echo hello
  #export nand_erasesize=400000
  #export nand_oobsize=680
  #export nand_writesize=4000

  # Toshiba_4G_MLC
  export nand_erasesize=400000
  export nand_oobsize=500
  export nand_writesize=4000

  # Toshiba_512M_SLC
  #echo correct
  #export nand_erasesize=40000
  #export nand_oobsize=100
  #export nand_writesize=1000


  UBI_TYPE="$nand_erasesize-$nand_writesize-$nand_oobsize"
  echo $UBI_TYPE > ${IMAGESDIR}/ubi_type


  echo "Copy firmware files..."
  # sunxi-spl.bin
  cp $UBOOT_IMAGE_PATH/spl/sunxi-spl.bin $IMAGESDIR

  # uboot-400000.bin
  cp ./output/uboot-400000.bin $IMAGESDIR
  #cp ./uboot-400000.bin $IMAGESDIR
  #cp $UBOOT_IMAGE_PATH/uboot-400000.bin $IMAGESDIR
  #cp /test/tmp/pocketchip_buildroot/CHIP-buildroot-chip-stable/output/images/uboot-env.bin $IMAGESDIR/uboot-400000.bin

  # spl-400000-4000-500.bin
  cp ./output/spl-400000-4000-500.bin $IMAGESDIR
  #cp $UBOOT_IMAGE_PATH/spl/sunxi-spl-with-ecc.bin $IMAGESDIR/spl-400000-4000-500.bin

  # uboot script image
  # SEE common.sh: flash_images()

  # for Toshiba_4G_MLC
  # chip-400000-4000-500.ubi.sparse (UBI sparse)
  # - http://opensource.nextthing.co/chip/images/stable/pocketchip/126/chip-400000-4000-500.ubi.sparse
  cp ./chip-400000-4000-500.ubi.sparse $IMAGESDIR


  if [[ ! -f "$IMAGESDIR/sunxi-spl.bin" ]]; then
    echo "Could not locate sunxi-spl.bin"
    exit 1
  else
    echo "== Cached UBI sunxi-spl.bin =="
  fi

  if [[ ! -f "$IMAGESDIR/uboot-400000.bin" ]]; then
    echo "Could not locate uboot-400000.bin"
    exit 1
  else
    echo "== Cached UBI uboot-400000.bin =="
  fi

  if [[ ! -f "$IMAGESDIR/spl-400000-4000-500.bin" ]]; then
    echo "Could not locate spl-400000-4000-500.bin"
    exit 1
  else
    echo "== Cached UBI spl-400000-4000-500.bin =="
  fi

  if [[ ! -f "$IMAGESDIR/chip-400000-4000-500.ubi.sparse" ]]; then
    echo "Could not locate chip-400000-4000-500.ubi.sparse"
    exit 1
  else
    echo "== Cached UBI chip-400000-4000-500.ubi.sparse =="
  fi

#  if [[ ! -f "$IMAGESDIR/$UBI_PREFIX-$UBI_TYPE.$UBI_SUFFIX" ]]; then
#    echo "Could not locate UBI files"
#    exit 1
#  else
#    echo "== Cached UBI located =="
#  fi
}

echo == preparing images ==
require_directory "$IMAGESDIR"
#rm -rf ${IMAGESDIR}
#require_directory "$DL_DIR"

##pass
dl_probe || (
  ##fail
  echo -e "\n FLASH VERIFICATION FAILED.\n\n"
  echo -e "\tTROUBLESHOOTING:\n"
  echo -e "\tIs the FEL pin connected to GND?"
  echo -e "\tHave you tried turning it off and turning it on again?"
  echo -e "\tDid you run the setup script in CHIP-SDK?"
  echo -e "\tDownload could be corrupt, it can be re-downloaded by adding the '-f' flag."
  echo -e "\n\n"
  exit 1
)

##pass
flash_images && ready_to_roll || (
  ##fail
  echo -e "\n FLASH VERIFICATION FAILED.\n\n"
  echo -e "\tTROUBLESHOOTING:\n"
  echo -e "\tIs the FEL pin connected to GND?"
  echo -e "\tHave you tried turning it off and turning it on again?"
  echo -e "\tDid you run the setup script in CHIP-SDK?"
  echo -e "\tDownload could be corrupt, it can be re-downloaded by adding the '-f' flag."
  echo -e "\n\n"
)
