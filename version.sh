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
BUILD=armv7-devel-r21

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="4da3064d1775810f10f7ddc1c34c3f1ff502a654"
#KERNEL_SHA="d770e558e21961ad6cfdf0ff7df0eb5d7d4f0754"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
