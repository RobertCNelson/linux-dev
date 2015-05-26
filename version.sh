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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r42

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA="e26081808edadfd257c6c9d81014e3b25e9a6118"
#KERNEL_SHA="1113cdfe7d2c1fe08b64caa3affe19260e66dd95"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
