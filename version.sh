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
BUILD=armv7-devel-r17

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="b9bb6fb73b3e112d241a5edd146740be9a0c3cc0"
KERNEL_SHA="a62d016cece2fce1d5e4eedf36b17f03a7a5c78e"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
