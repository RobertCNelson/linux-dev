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
BUILD=armv7-devel-r9
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="67990608c8b95d2b8ccc29932376ae73d5818727"
KERNEL_SHA="4c257ec37bc365614933c7f0a7fe9b0688dfd1e7"

#git branch
#BRANCH="v4.5.x"

DISTRO=cross
DEBARCH=armhf
#
