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
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-devel-r21

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA="b314acaccd7e0d55314d96be4a33b5f50d0b3344"
#KERNEL_SHA="bc465aa9d045feb0e13b4a8f32cc33c1943f62d6"

#git branch
#BRANCH="v4.0.x"

DISTRO=cross
DEBARCH=armhf
#
