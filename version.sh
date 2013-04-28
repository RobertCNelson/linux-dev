#!/bin/sh
#
ARCH=$(uname -m)
#DISABLE_MASTER_BRANCH=1

#Dual/Quad Core arms are now more prevalent, so don't just limit to x86:
CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" >/dev/null 2>&1 && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS="${GIT_OPTS} --no-edit"
fi

config="omap2plus_defconfig"

#Kernel/Build
KERNEL_REL=3.9
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=armv7-d5

#v3.X-rcX + upto SHA
#KERNEL_SHA="9217cbb8df31c10efc96362227b2ebdbb9fe996c"

#git branch
#BRANCH="v3.9.x"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armhf
