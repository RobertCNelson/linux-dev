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
BUILD=armv7-devel-r19

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="7adf12b87f45a77d364464018fb8e9e1ac875152"
KERNEL_SHA="44b061f77f70e21031444e3611dfddbb80b4defc"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
