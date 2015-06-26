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
KERNEL_REL=4.1
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r5

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="64e22b86854227b4d13a57fa02f26472bc426812"
KERNEL_SHA="c13c81006314ad76c2b31824960a900385601b8b"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
