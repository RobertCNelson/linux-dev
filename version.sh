#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
#toolchain="gcc_linaro_gnueabihf_4_9"
toolchain="gcc_linaro_gnueabihf_5"

#Kernel/Build
KERNEL_REL=4.3
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r2
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="e86328c489d7ecdca99410a06a3f448caf7857bf"
KERNEL_SHA="5062ecdb662bf3aed6dc975019c53ffcd3b01d1c"

#git branch
#BRANCH="v4.4.x"

DISTRO=cross
DEBARCH=armhf
#
