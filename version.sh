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
BUILD=armv7-devel-r17

#v3.X-rcX + upto SHA
prev_KERNEL_SHA="2dbfca5a181973558277b28b1f4c36362291f5e0"
KERNEL_SHA="603ba7e41bf5d405aba22294af5d075d8898176d"

#git branch
#BRANCH="v3.19.x"

DISTRO=cross
DEBARCH=armhf
#
