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
KERNEL_TAG=${KERNEL_REL}-rc2
BUILD=armv7-devel-r29

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="5ebe6afaf0057ac3eaeb98defd5456894b446d22"
KERNEL_SHA="0e1dc4274828f64fcb56fc7b950acdc5ff7a395f"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
