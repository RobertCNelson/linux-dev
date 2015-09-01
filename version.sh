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
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r0

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="64291f7db5bd8150a74ad2036f1037e6a0428df2"
KERNEL_SHA="8e42ac814c63dd5c5e39bbbfbc9c6578e19c765f"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
