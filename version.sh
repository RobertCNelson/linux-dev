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
prev_KERNEL_SHA="e0dd880a545c36bd56489a97bb1d337cb873a9d5"
KERNEL_SHA="4a10a91756ef381bced7b88cfb9232f660b92d93"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
