#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

build_prefix="-armv7-devel-r"
branch_prefix="v"
branch_postfix=".x"

#arm
KERNEL_ARCH=arm
#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_eabi_6"
#toolchain="gcc_linaro_eabi_7"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
#toolchain="gcc_linaro_gnueabihf_5"
#toolchain="gcc_linaro_gnueabihf_6"
toolchain="gcc_linaro_gnueabihf_7"
#arm64
#KERNEL_ARCH=arm64
#toolchain="gcc_linaro_aarch64_gnu_5"
#toolchain="gcc_linaro_aarch64_gnu_6"
#toolchain="gcc_linaro_aarch64_gnu_7"

#Kernel
KERNEL_REL=4.18
KERNEL_TAG=${KERNEL_REL}-rc6
kernel_rt=".X-rtY"
#Kernel Build
BUILD=${build_prefix}31

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="6f0d349d922ba44e4348a17a78ea51b7135965b1"
#KERNEL_SHA="883c9ab9eb595f8542d01e55d29a346c8d96862e"

#git branch
#BRANCH="${branch_prefix}${KERNEL_REL}${branch_postfix}"

DISTRO=cross
DEBARCH=armhf
#
