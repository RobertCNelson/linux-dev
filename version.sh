#!/bin/sh
#
ARCH=$(uname -m)

#Dual/Quad Core arms are now more prevalent, so just don't limit it x86:
check_cpuinfo=$(cat /proc/cpuinfo | grep "^processor" | awk '{print $1}' | head -n 1)
if [ "x${check_cpuinfo}" = "xprocessor" ] ; then
	CORES=$(cat /proc/cpuinfo | grep "^processor" | wc -l)
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

config="omap2plus_defconfig"

#linaro_toolchain="arm9_gcc_4_7"
#linaro_toolchain="cortex_gcc_4_6"
linaro_toolchain="cortex_gcc_4_7"
#linaro_toolchain="cortex_gcc_4_8"

#Kernel/Build
KERNEL_REL=3.8
KERNEL_TAG=${KERNEL_REL}.13
BUILD=bone26.1

#v3.X-rcX + upto SHA
#KERNEL_SHA=""

#git branch
BRANCH="am33x-v3.8"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armhf
