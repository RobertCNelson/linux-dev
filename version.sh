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
BUILD=armv7-devel-r9

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="361f7d175734a8e21bcd0585eca9be195c12c5c5"
KERNEL_SHA="00e3fcc221f6fe6a890bf3e0e71c6b9944e58233"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
