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
BUILD=armv7-devel-r15

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="db4fd9c5d072a20ea6b7e40276a9822e04732610"
KERNEL_SHA="5e6c94a999f67f120c6bbba71bbee840dfee6338"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
