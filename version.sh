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
KERNEL_TAG=${KERNEL_REL}-rc6
BUILD=armv7-devel-r56
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="73796d8bf27372e26c2b79881947304c14c2d353"
#KERNEL_SHA="9f7e43278605a0daf4edf7025c52c25e9ace6875"

#git branch
#BRANCH="v4.4.x"

DISTRO=cross
DEBARCH=armhf
#
