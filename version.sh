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
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r16

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="5e6c94a999f67f120c6bbba71bbee840dfee6338"
KERNEL_SHA="b9bb6fb73b3e112d241a5edd146740be9a0c3cc0"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
