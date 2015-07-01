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
BUILD=armv7-devel-r17

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="6aaf0da8728c55ff627619f933ed161cc89057c6"
KERNEL_SHA="05a8256c586ab75bcd6b793737b2022a1a98cb1e"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
