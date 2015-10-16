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
BUILD=armv7-devel-r39
kernel_rt=".X-rtY"

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="25cb62b76430a91cc6195f902e61c2cb84ade622"
KERNEL_SHA="045ce743498881b39e672da948c210c769209515"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
