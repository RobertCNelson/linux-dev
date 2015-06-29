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
BUILD=armv7-devel-r14

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="4a10a91756ef381bced7b88cfb9232f660b92d93"
KERNEL_SHA="c63f887bdae80858c7cebf914f45f69bbaa88e8d"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
