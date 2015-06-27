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
BUILD=armv7-devel-r9

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="3d9f96d850e4bbfae24dc9aee03033dd77c81596"
KERNEL_SHA="e8a0b37d28ace440776c0a4fe3c65f5832a9a7ee"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
