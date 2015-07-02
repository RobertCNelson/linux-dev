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
BUILD=armv7-devel-r20

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="44b061f77f70e21031444e3611dfddbb80b4defc"
KERNEL_SHA="93899e39e86bfc021a190a9c26e8e516561f2756"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
