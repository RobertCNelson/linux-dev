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
KERNEL_TAG=${KERNEL_REL}-rc6
BUILD=armv7-devel-r43

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="30065bfda900a844d9c88bc4d5d298025a4fef5e"
KERNEL_SHA="ed596cde9425509ec6ce88e19f03e9b13b6f518b"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
