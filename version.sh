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
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r7

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="c841e12add6926d64aa608687893465330b5a03e"
KERNEL_SHA="34c9a0ffc75ad25b6a60f61e27c4a4b1189b8085"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
