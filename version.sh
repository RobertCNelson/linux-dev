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
BUILD=armv7-devel-r5

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="bb0fd7ab0986105765d11baa82e619c618a235aa"
KERNEL_SHA="6c373ca89399c5a3f7ef210ad8f63dc3437da345"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
