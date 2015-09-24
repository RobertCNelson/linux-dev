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
BUILD=armv7-devel-r28
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="ac2fc4b9d5b7d8e4878c6f04f947d42707f782ef"
KERNEL_SHA="d5fc4f555d7d29f9c868e7505e08bcd7676bc943"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
