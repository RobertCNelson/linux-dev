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
KERNEL_REL=4.1
KERNEL_TAG=${KERNEL_REL}
BUILD=armv7-devel-r11

#v4.X-rcX + upto SHA
prev_KERNEL_SHA="22165fa79814e71e7a5974b3c37a5028ed16c8f9"
KERNEL_SHA="099bfbfc7fbbe22356c02f0caf709ac32e1126ea"

#git branch
#BRANCH="v4.2.x"

DISTRO=cross
DEBARCH=armhf
#
