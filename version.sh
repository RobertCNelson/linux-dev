#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

#arm
KERNEL_ARCH=arm
#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
toolchain="gcc_linaro_gnueabihf_5"
#arm64
#KERNEL_ARCH=arm64
#toolchain="gcc_linaro_aarch64_gnu_5"

#Kernel/Build
KERNEL_REL=4.4
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r6
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="4f31d774dd5239e563f22ffe1403292414e6f779"
KERNEL_SHA="33caf82acf4dc420bf0f0136b886f7b27ecf90c5"

#git branch
#BRANCH="v4.5.x"

DISTRO=cross
DEBARCH=armhf
#
