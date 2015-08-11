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
KERNEL_TAG=${KERNEL_REL}-rc6
BUILD=armv7-devel-r41

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="f7644cbfcdf03528f0f450f3940c4985b2291f49"
KERNEL_SHA="7a834ba5e26e9e4afabf3cce9ca8cd1c6c3dce50"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
