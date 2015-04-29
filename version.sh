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
BUILD=armv7-devel-r26

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="14bc84ce0b41787acc08aefabe718479c5dde60e"
KERNEL_SHA="3d99e3fe13d473ac4578c37f477a59b829530764"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
