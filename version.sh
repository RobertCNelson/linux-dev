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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r43

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="ba155e2d21f6bf05de86a78dbe5bfd8757604a65"
KERNEL_SHA="1b887bf31dd6e2f8cef80d205d6e9949a7dd98cc"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
