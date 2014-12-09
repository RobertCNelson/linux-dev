#!/bin/sh
#
ARCH=$(uname -m)

if [ $(which nproc) ] ; then
	CORES=$(nproc)
else
	CORES=1
fi

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
KERNEL_REL=3.18
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r0

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="b2776bf7149bddd1f4161f14f79520f17fc1d71d"
KERNEL_SHA="f3f62a38ceda4e4d34a1dc3ebbc0f8d426c9e8d9"

#git branch
#BRANCH="v3.18.x"

DISTRO=cross
DEBARCH=armhf
#
