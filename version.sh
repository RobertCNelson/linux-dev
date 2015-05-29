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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r45

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="de182468d1bb726198abaab315820542425270b7"
KERNEL_SHA="2a6451718627eb60e85691053cb9820ae7ed3913"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
