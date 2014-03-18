#!/bin/sh
#
ARCH=$(uname -m)

if [ $(which nproc) ] ; then
	CORES=$(nproc)
else
	CORES=1
fi

#Debian 7 (Wheezy): git version 1.7.10.4 and later needs "--no-edit"
unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" >/dev/null 2>&1 && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS="${GIT_OPTS} --no-edit"
fi

config="multi_v7_defconfig"

#toolchain="arm9_gcc_4_7"
#toolchain="gcc_arm_embedded_4_8"
#toolchain="cortex_gcc_4_6"
#toolchain="cortex_gcc_4_7"
#toolchain="cortex_gcc_4_8"
toolchain="gcc_linaro_gnueabihf_4_8"

#Kernel/Build
KERNEL_REL=3.14
KERNEL_TAG=${KERNEL_REL}-rc7
BUILD=armv7-devel-r78

#v3.X-rcX + upto SHA
KERNEL_SHA="9a15c944f76cffa5581959cefe709c7c4ea26994"

#git branch
#BRANCH="v3.14.x"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armhf
