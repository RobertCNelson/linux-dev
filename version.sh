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
KERNEL_REL=4.3
KERNEL_TAG=${KERNEL_REL}-rc2
BUILD=armv7-devel-r30
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="03e8f644868f147e021e8660346890e731c2e435"
KERNEL_SHA="518a7cb6980cd640c7f979d29021ad870f60d7d7"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
