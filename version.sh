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
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r0

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="b953c0d234bc72e8489d3bf51a276c5c4ec85345"
KERNEL_SHA="cb8a4deaf9b2778653c4391d8ccb24c5ab159f9d"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
