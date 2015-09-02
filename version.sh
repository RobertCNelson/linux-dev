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
KERNEL_REL=4.2
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r13

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="8d01b66b4f23a9fcf5c6787b27f0be5f8cbae98c"
KERNEL_SHA="ae982073095a44f004d7ffb9f271077abef9dbcf"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
