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
BUILD=armv7-devel-r27

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="3d99e3fe13d473ac4578c37f477a59b829530764"
KERNEL_SHA="9dbbe3cfc3c208643cf0e81c8f660f43e1b4b2e8"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
