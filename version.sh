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
BUILD=armv7-devel-r19

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="4e4adb2f462889b9eac736dd06d60658beb091b6"
KERNEL_SHA="26d2177e977c912863ac04f6c1a967e793ca3a56"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
