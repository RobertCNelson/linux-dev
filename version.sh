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
BUILD=armv7-devel-r27
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="1f93e4a96c9109378204c147b3eec0d0e8100fde"
KERNEL_SHA="ac2fc4b9d5b7d8e4878c6f04f947d42707f782ef"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
