#!/bin/sh -e

DIR=$PWD

check_config_builtin () {
	unset test_config
	test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "------------------------------------"
		echo "Config: [${config}=y] not enabled"
		echo "echo ${config}=y >> ./KERNEL/.config"
	fi
}

check_config_module () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "------------------------------------"
		echo "Config: [${config}] not enabled"
		echo "echo ${config}=m >> ./KERNEL/.config"
	fi
}

check_config () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "------------------------------------"
		echo "Config: [${config}] not enabled"
		echo "echo ${config}=y >> ./KERNEL/.config"
		echo "echo ${config}=m >> ./KERNEL/.config"
	fi
}

check_config_disabled () {
	unset test_config
	test_config=$(grep "${config} is not set" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "------------------------------------"
		echo "Disable config: [${config}]"
		unset test_config
		test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
		if [ "x${test_config}" = "x${config}=y" ] ; then
			echo "sed -i -e 's:${config}=y:# ${config} is not set:g' ./KERNEL/.config"
		else
			echo "sed -i -e 's:${config}=m:# ${config} is not set:g' ./KERNEL/.config"
		fi
	fi
}

check_if_set_then_set () {
	unset test_config
	test_config=$(grep "${if_config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x${if_config}=y" ] ; then
		check_config_builtin
	fi
}

check_if_set_then_disable () {
	unset test_config
	test_config=$(grep "${if_config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x${if_config}=y" ] ; then
		check_config_disabled
	fi
}

###CONFIG_ARCH_MULTIPLATFORM
if_config="CONFIG_ARCH_MULTIPLATFORM"

config="CONFIG_ARCH_MULTI_V6"
check_if_set_then_disable

#drop non omap3/imx
config="CONFIG_ARCH_BERLIN"
check_if_set_then_disable
config="CONFIG_ARCH_BCM"
check_if_set_then_disable
config="CONFIG_ARCH_KEYSTONE"
check_if_set_then_disable
config="CONFIG_ARCH_HIGHBANK"
check_if_set_then_disable
config="CONFIG_ARCH_MVEBU"
check_if_set_then_disable
config="CONFIG_ARCH_ROCKCHIP"
check_if_set_then_disable
config="CONFIG_ARCH_SOCFPGA"
check_if_set_then_disable
config="CONFIG_ARCH_STI"
check_if_set_then_disable
config="CONFIG_ARCH_SUNXI"
check_if_set_then_disable
config="CONFIG_ARCH_SIRF"
check_if_set_then_disable
config="CONFIG_ARCH_TEGRA"
check_if_set_then_disable
config="CONFIG_ARCH_VIRT"
check_if_set_then_disable
config="CONFIG_ARCH_WM8850"
check_if_set_then_disable
config="CONFIG_ARCH_ZYNQ"
check_if_set_then_disable
config="CONFIG_ARCH_VEXPRESS"
check_if_set_then_disable

#not disabling easily...
config="CONFIG_PLAT_SPEAR"
check_if_set_then_disable
config="CONFIG_ARCH_U8500"
check_if_set_then_disable

#omap3 beagles need this... (thumb2 bugs)
if_config="CONFIG_ARCH_OMAP3"
config="CONFIG_ARM_ERRATA_430973"
check_if_set_then_set
config="CONFIG_PINCTRL_SINGLE"
check_if_set_then_set

if_config="CONFIG_ARCH_MULTI_V7"
config="CONFIG_SMP"
check_if_set_then_set
config="CONFIG_SMP_ON_UP"
check_if_set_then_set
config="CONFIG_SWP_EMULATE"
check_if_set_then_set

if_config="CONFIG_ARCH_MULTI_V7"
config="CONFIG_KERNEL_MODE_NEON"
check_if_set_then_set

if_config="CONFIG_ARCH_MULTI_V7"
config="CONFIG_XFS_FS"
check_if_set_then_set
config="CONFIG_BTRFS_FS"
check_if_set_then_set

config="CONFIG_MSDOS_FS"
check_config_builtin

#debian netinstall
config="CONFIG_NLS_CODEPAGE_437"
check_config_builtin
config="CONFIG_NLS_ISO8859_1"
check_config_builtin

#systemd : http://cgit.freedesktop.org/systemd/systemd/tree/README#n36
config="CONFIG_DEVTMPFS"
check_config_builtin
config="CONFIG_CGROUPS"
check_config_builtin
config="CONFIG_INOTIFY_USER"
check_config_builtin
config="CONFIG_SIGNALFD"
check_config_builtin
config="CONFIG_TIMERFD"
check_config_builtin
config="CONFIG_EPOLL"
check_config_builtin
config="CONFIG_NET"
check_config_builtin
config="CONFIG_SYSFS"
check_config_builtin
config="CONFIG_PROC_FS"
check_config_builtin
config="CONFIG_SYSFS_DEPRECATED"
check_config_disabled
#CONFIG_UEVENT_HELPER_PATH=""
config="CONFIG_FW_LOADER_USER_HELPER"
check_config_disabled
#CONFIG_DMIID
config="CONFIG_FHANDLE"
check_config_builtin
config="CONFIG_BLK_DEV_BSG"
check_config_builtin
config="CONFIG_IPV6"
check_config_builtin
config="CONFIG_AUTOFS4_FS"
check_config_builtin
config="CONFIG_TMPFS_POSIX_ACL"
check_config_builtin
config="CONFIG_TMPFS_XATTR"
check_config_builtin
config="CONFIG_SECCOMP"
check_config_builtin
config="CONFIG_SCHEDSTATS"
check_config_builtin
config="CONFIG_SCHED_DEBUG"
check_config_builtin
#config="CONFIG_AUDIT"
#check_config_disabled

#zram
config="CONFIG_ZSMALLOC"
check_config_builtin
config="CONFIG_ZRAM"
check_config_module

#ancient...
config="CONFIG_OABI_COMPAT"
check_config_disabled
#
