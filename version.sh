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
KERNEL_REL=4.2
KERNEL_TAG=${KERNEL_REL}-rc2
BUILD=armv7-devel-r27

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="bc0195aad0daa2ad5b0d76cce22b167bc3435590"
KERNEL_SHA="f760b87f8f12eb262f14603e65042996fe03720e"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
