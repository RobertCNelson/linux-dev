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
BUILD=armv7-devel-r23

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA="d19d133e432248c9b3efa9c10dda5f050cbbcd72"
#KERNEL_SHA="c8b3fd0ce313443731e8fd6d5a541085eb465f99"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
