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
KERNEL_TAG=${KERNEL_REL}-rc1
BUILD=armv7-devel-r24

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="b787f68c36d49bb1d9236f403813641efa74a031"
KERNEL_SHA="2decb2682f80759f631c8332f9a2a34a02150a03"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
