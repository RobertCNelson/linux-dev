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
KERNEL_TAG=${KERNEL_REL}-rc3
BUILD=armv7-devel-r38

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="110bc76729d448fdbcb5cdb63b83d9fd65ce5e26"
KERNEL_SHA="c0655fe9b0901a968800f56687be3c62b4cce5d2"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
