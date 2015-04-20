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
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r9

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="54e514b91b95d6441c12a7955addfb9f9d2afc65"
KERNEL_SHA="09d51602cf84a1264946711dd4ea0dddbac599a1"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
