

PocketC.H.I.P. source tree

 - hjkim, 2018.03.08




u-boot:
 - https://github.com/NextThingCo/CHIP-u-boot/tree/production-mlc
   (branch: production-mlc)



kernel:
 - https://github.com/NextThingCo/CHIP-linux/tree/debian/4.4.13-ntc-mlc
   (branch: debian/4.4.13-ntc-mlc)



tools:
 - https://github.com/NextThingCo/CHIP-tools

 - https://github.com/NextThingCo/chip-nand-scripts
   (DO NOT USE THIS)

 - https://github.com/nextthingco/chip-mtd-utils
 - dependencies
   (sudo apt-get install libacl1-dev zlib1g-dev liblzo2-dev libuuid uuid-dev)
   ( Ubuntu 16.04 LTS x64:
     Download: https://packages.ubuntu.com/xenial/uuid-dev
               https://packages.ubuntu.com/xenial/libuuid1
   )

 - https://github.com/linux-sunxi/sunxi-tools
   ( $ make && make misc )

 - https://github.com/NextThingCo/CHIP-buildroot/tree/chip/stable
   (branch: chip/stable)
   (CHIP-buildroot/CHIP-buildroot-chip-stable/output/images/rootfs.tar)





__EOF__
