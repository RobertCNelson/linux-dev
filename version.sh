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
KERNEL_TAG=${KERNEL_REL}-rc7
BUILD=armv7-devel-r45

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="ed596cde9425509ec6ce88e19f03e9b13b6f518b"
#KERNEL_SHA="5b3e2e14eaa2a98232a4f292341fb88438685734"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
