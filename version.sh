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
BUILD=armv7-devel-r17

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="51e771c0d25b43d0f12b2c7c01939942becbbe28"
KERNEL_SHA="7d9071a095023cd1db8fa18fa0d648dc1a5210e0"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
