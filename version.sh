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
KERNEL_REL=4.3
KERNEL_TAG=${KERNEL_REL}-rc3
BUILD=armv7-devel-r33
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="e3be4266d3488cbbaddf7fcc661f4473db341e46"
KERNEL_SHA="ccf70ddcbe9984cee406be2bacfedd5e4776919d"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
