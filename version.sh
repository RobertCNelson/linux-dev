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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r38
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
#prev_KERNEL_SHA="049e6dde7e57f0054fdc49102e7ef4830c698b46"
#KERNEL_SHA="c6fa8e6de3dc420cba092bf155b2ed25bcd537f7"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
