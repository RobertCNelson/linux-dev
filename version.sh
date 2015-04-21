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
BUILD=armv7-devel-r11

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="646da63172f660ba84f195c1165360a9b73583ee"
KERNEL_SHA="1fc149933fd49a5b0e7738dc0853dbfbac4ae0e1"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
