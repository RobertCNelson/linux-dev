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
KERNEL_TAG=${KERNEL_REL}-rc1
BUILD=armv7-devel-r22

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754"
KERNEL_SHA="1c4c7159ed2468f3ac4ce5a7f08d79663d381a93"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
