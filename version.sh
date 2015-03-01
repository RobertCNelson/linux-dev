#!/bin/sh
#
ARCH=$(uname -m)
CORES=$(getconf _NPROCESSORS_ONLN)

#Debian 7 (Wheezy): git version 1.7.10.4 and later needs "--no-edit"
unset git_opts
git_no_edit=$(LC_ALL=C git help pull | grep -m 1 -e "--no-edit" || true)
if [ ! "x${git_no_edit}" = "x" ] ; then
	git_opts="--no-edit"
fi

config="multi_v7_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
toolchain="gcc_linaro_gnueabihf_4_9"

#Kernel/Build
KERNEL_REL=4.0
KERNEL_TAG=${KERNEL_REL}-rc1
BUILD=armv7-devel-r11

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="4f671fe2f9523a1ea206f63fe60a7c7b3a56d5c7"
KERNEL_SHA="a38ecbbd0be025a6ecbbfd22d2575a5b46317117"

#git branch
#BRANCH="v4.0.x"

DISTRO=cross
DEBARCH=armhf
#
