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
BUILD=armv7-devel-r20

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="27cf3a16b2535a490f8cf1d29a6634f1c70f7831"
KERNEL_SHA="d56a669ca59c37ed0a7282a251b2f2f22533343a"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
