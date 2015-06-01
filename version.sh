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
KERNEL_TAG=${KERNEL_REL}-rc6
BUILD=armv7-devel-r47

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="8ba64dc33830fbcd57d59fddc2ca1c24a6a394c4"
KERNEL_SHA="c65b99f046843d2455aa231747b5a07a999a9f3d"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
