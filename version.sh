#!/bin/sh
#
ARCH=$(uname -m)

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
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r2

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="cb0fc55dea8b498c286976bc4833481f6078c061"
KERNEL_SHA="d700b0567132e894971325fbb452a8db9e781c13"

#git branch
#BRANCH="v4.1.x"

DISTRO=cross
DEBARCH=armhf
#
