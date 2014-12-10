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
BUILD=armv7-devel-r4

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="3a647c1d7ab08145cee4b650f5e797d168846c51"
KERNEL_SHA="a0e4467726cd26bacb16f13d207ffcfa82ffc07d"

#git branch
#BRANCH="v3.18.x"

DISTRO=cross
DEBARCH=armhf
#
