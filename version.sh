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
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r12

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="1fc149933fd49a5b0e7738dc0853dbfbac4ae0e1"
KERNEL_SHA="b8ce8d7222b52200e61ea29523993e20751baaaa"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
