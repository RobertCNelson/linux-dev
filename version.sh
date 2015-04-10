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
KERNEL_TAG=${KERNEL_REL}-rc7
BUILD=armv7-devel-r31

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="20624d17963c737bbd9f242402bf3136cb664d10"
KERNEL_SHA="e5e02de0665ef2477e7a018193051387c6fe0fbc"

#git branch
#BRANCH="v4.0.x"

DISTRO=cross
DEBARCH=armhf
#
