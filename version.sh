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
BUILD=armv7-devel-r11

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="c5fc249862af862df027030188cc083e072ecd19"
KERNEL_SHA="102178108e2246cb4b329d3fb7872cd3d7120205"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
