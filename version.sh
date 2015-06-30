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
BUILD=armv7-devel-r15

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="c63f887bdae80858c7cebf914f45f69bbaa88e8d"
KERNEL_SHA="6aaf0da8728c55ff627619f933ed161cc89057c6"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
