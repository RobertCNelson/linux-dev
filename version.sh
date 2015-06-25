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
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r3

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="e3d8238d7f5c3f539a29f5ac596cd342d847e099"
KERNEL_SHA="aefbef10e3ae6e2c6e3c54f906f10b34c73a2c66"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
