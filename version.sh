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
BUILD=armv7-devel-r15

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="8bdc69b764013a9b5ebeef7df8f314f1066c5d79"
KERNEL_SHA="1e1a4e8f439113b7820bc7150569f685e1cc2b43"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
