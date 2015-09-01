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
BUILD=armv7-devel-r5

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="cf9d615f7f5842ca1ef0f28ed9f67a97d20cf6fc"
KERNEL_SHA="e5aeced6bcec5a110e6dfcb78acc203dbe895b59"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
