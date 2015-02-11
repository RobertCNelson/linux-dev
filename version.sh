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
BUILD=armv7-devel-r59

#v3.X-rcX + upto SHA
#prev_KERNEL_SHA="00845eb968ead28007338b2bb852b8beef816583"
#KERNEL_SHA="fba7e99458b606dc9a84332d38cd40e9d367633f"

#git branch
#BRANCH="v3.19.x"

DISTRO=cross
DEBARCH=armhf
#
