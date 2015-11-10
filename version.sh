#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
toolchain="gcc_linaro_gnueabihf_5"

#Kernel/Build
KERNEL_REL=4.3
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r17
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="ce5c2d2c256a4c8b523036537cd6be2d6af8f69d"
KERNEL_SHA="e6604ecb70d4b1dbc0372c6518b51c25c4b135a1"

#git branch
#BRANCH="v4.4.x"

DISTRO=cross
DEBARCH=armhf
#
