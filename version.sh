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
KERNEL_REL=3.19
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r0

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="bfa76d49576599a4b9f9b7a71f23d73d6dcff735"
KERNEL_SHA="ce01e871a1d44cc97cdd7e5ba6cb0c3613c15552"

#git branch
#BRANCH="v3.20.x"

DISTRO=cross
DEBARCH=armhf
#
