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
BUILD=armv7-devel-r6

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="6c373ca89399c5a3f7ef210ad8f63dc3437da345"
KERNEL_SHA="c841e12add6926d64aa608687893465330b5a03e"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
