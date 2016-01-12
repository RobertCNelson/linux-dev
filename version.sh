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
BUILD=armv7-devel-r5
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="01e9d22638f387b5413163d1030169b6478c09c5"
KERNEL_SHA="4f31d774dd5239e563f22ffe1403292414e6f779"

#git branch
#BRANCH="v4.5.x"

DISTRO=cross
DEBARCH=armhf
#
