#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
toolchain="gcc_linaro_gnueabihf_4_9"

#Kernel/Build
KERNEL_REL=4.1
KERNEL_TAG=${KERNEL_REL}-rc3
BUILD=armv7-devel-r32

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA="0e1dc4274828f64fcb56fc7b950acdc5ff7a395f"
#KERNEL_SHA="68c2f356c9ec65e1eb50c31690b095673dbd8010"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
