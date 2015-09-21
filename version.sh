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
KERNEL_TAG=${KERNEL_REL}-rc2
BUILD=armv7-devel-r26
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="72714841b705a5b9bccf37ee85a62352bee3a3ef"
#KERNEL_SHA="00ade1f553e3b947cd26228392ee47d6f0f550e1"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
