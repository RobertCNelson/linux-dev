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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r37

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="cbfe8fa6cd672011c755c3cd85c9ffd4e2d10a6f"
#KERNEL_SHA="86ea07ca846a7c352f39dd0b7d81f15f403c7db8"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
