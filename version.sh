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
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r1

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="cb8a4deaf9b2778653c4391d8ccb24c5ab159f9d"
KERNEL_SHA="6eae81a5e2d6646a61146501fd3032a340863c1d"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
