#!/bin/sh
#
ARCH=$(uname -m)

config="multi_v7_defconfig"

#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
toolchain="gcc_linaro_gnueabihf_4_9"

#Kernel/Build
KERNEL_REL=4.2
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r7

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="26f8b7edc9eab56638274f5db90848a6df602081"
KERNEL_SHA="f36fc04e4cdda9e4c72ee504e7dc638f9a168863"

#git branch
#BRANCH="v4.3.x"

DISTRO=cross
DEBARCH=armhf
#
