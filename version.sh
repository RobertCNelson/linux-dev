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
BUILD=armv7-devel-r37

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="6c9d370c16aad97cfc6de68666634eaabac2b048"
KERNEL_SHA="110bc76729d448fdbcb5cdb63b83d9fd65ce5e26"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
