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
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
#toolchain="gcc_linaro_gnueabihf_5"
toolchain="gcc_linaro_gnueabihf_6"
#arm64
#KERNEL_ARCH=arm64
#toolchain="gcc_linaro_aarch64_gnu_5"
#toolchain="gcc_linaro_aarch64_gnu_6"

#Kernel/Build
KERNEL_REL=4.8
KERNEL_TAG=${KERNEL_REL}
BUILD=${build_prefix}13
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="5691f0e9a3e7855832d5fd094801bf600347c2d0"
KERNEL_SHA="a6930aaee06755d1bdcfd943fbf614e4d92bb0c7"

#git branch
#BRANCH="${branch_prefix}${KERNEL_REL}${branch_postfix}"

DISTRO=cross
DEBARCH=armhf
#
