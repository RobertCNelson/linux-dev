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
KERNEL_TAG=${KERNEL_REL}-rc1
BUILD=armv7-devel-r24
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="9c488de24f7264f08d341024bffdd637b4d04c96"
KERNEL_SHA="72714841b705a5b9bccf37ee85a62352bee3a3ef"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
