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
BUILD=armv7-devel-r3

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="2f37d65a6a5c360ba0c386a6aa0d2afcbda7060d"
KERNEL_SHA="4ff12049d6b6cc79ad8ee092ae226434687062ec"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
