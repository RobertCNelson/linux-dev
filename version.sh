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
BUILD=armv7-devel-r8
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="60b7eca1dc2ec066916b3b7ac6ad89bea13cb9af"
KERNEL_SHA="67990608c8b95d2b8ccc29932376ae73d5818727"

#git branch
#BRANCH="v4.5.x"

DISTRO=cross
DEBARCH=armhf
#
