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
BUILD=armv7-devel-r31

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="3aa20508a6fe386c2a893027ef4c4ef78ee4eac2"
#KERNEL_SHA="eb254374a30cc53f976f2302f2198813a3b687ea"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
