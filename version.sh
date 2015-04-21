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
BUILD=armv7-devel-r10

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="09d51602cf84a1264946711dd4ea0dddbac599a1"
KERNEL_SHA="646da63172f660ba84f195c1165360a9b73583ee"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
