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
KERNEL_TAG=${KERNEL_REL}-rc3
BUILD=armv7-devel-r34

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="45b4b782e8489bcf45a4331ee32f0f3037c5c3aa"
KERNEL_SHA="afdf0b91bdf04bc66ee64e1ac44f0979c55749b1"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
