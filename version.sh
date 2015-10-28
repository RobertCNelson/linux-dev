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
KERNEL_TAG=${KERNEL_REL}-rc7
BUILD=armv7-devel-r45
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="32b88194f71d6ae7768a29f87fbba454728273ee"
KERNEL_SHA="8a28d67457b613258aa0578ccece206d166f2b9f"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
