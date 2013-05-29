#!/bin/sh
#copy as "system.sh" and tweak for your system

ARCH=$(uname -m)

#ARM Native gcc compiler (running gcc on arm target)
if [ "x${ARCH}" = "xarmv7l" ] ; then
	#Native arm gcc compiler
	CC=
fi

###REQUIRED:

#ARM GCC CROSS Compiler:
#if CC is not set, a known working linaro compiler (ubuntu, or the one you installed via apt-get) will be used.
#CC=<enter full path>/bin/arm-none-eabi-
#CC=<enter full path>/bin/arm-linux-gnueabi-
#CC=<enter full path>/bin/arm-linux-gnueabihf-

###OPTIONAL:

###OPTIONAL: LINUX_GIT: specify location of locally cloned git tree.
#
#LINUX_GIT=/home/user/linux-stable/

###OPTIONAL: GIT_OVER_HTTP: clone over http vs git: git clone http://
#
#GIT_OVER_HTTP=1

###OPTIONAL: ZRELADDR: used by mkimage when copying files to target
# with: ./tools/install_kernel.sh...
#
##For TI: OMAP3/4/AM35xx
#ZRELADDR=0x80008000
#
##For Freescale: i.mx51:
#ZRELADDR=0x90008000
#
##For Freescale: i.mx53:
#ZRELADDR=0x70008000
#
##For Freescale: i.mx6:
#ZRELADDR=0x10008000

###OPTIONAL: MMC: (REQUIRED FOR RUNNING: tools/install_kernel.sh)
#Note: This operates on raw disks, NOT PARTITIONS..
#
#WRONG: MMC=/dev/mmcblk0p1
#CORRECT: MMC=/dev/mmcblk0
#
#WRONG: MMC=/dev/sde1
#CORRECT: MMC=/dev/sde
#
#MMC=/dev/sde

###ADVANCED:

###ADVANCED: DEBUG_SECTION: enable DEBUG_SECTION_MISMATCH
#http://cateee.net/lkddb/web-lkddb/DEBUG_SECTION_MISMATCH.html
#
#DEBUG_SECTION=1

###ADVANCED: RUN_BISECT: used with ./scripts/bisect.sh
#
#RUN_BISECT=1

###ADVANCED: LOCAL_PATCH_DIR: Secret Sauce Patches:
#Have some secret sauce, you dont want to share with the community??
#
#It'll look specifically for *.patch files... Doesn't care about order/etc..
#And I don't care about enhancing it.. ;)
#
#LOCAL_PATCH_DIR=/full/path/to/dir/

###ADVANCED: AUTO_BUILD: Easier integration with Jenkins/Buildbot/etc..
#
#AUTO_BUILD=1
