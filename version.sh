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
BUILD=armv7-devel-r19

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="a62d016cece2fce1d5e4eedf36b17f03a7a5c78e"
KERNEL_SHA="27cf3a16b2535a490f8cf1d29a6634f1c70f7831"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
