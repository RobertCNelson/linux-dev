#!/bin/sh -e

DIR=$PWD

check_config_builtin () {
	unset test_config
	test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "Config: [${config}=y] not enabled"
		echo "echo ${config}=y >> ./KERNEL/.config"
		exit
	fi
}

check_config_disabled () {
	unset test_config
	test_config=$(grep "${config} is not set" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "Disable config: [${config}]"
		exit
	fi
}

check_config () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "Config: [${config}] not enabled"
		echo "echo ${config}=y >> ./KERNEL/.config"
		echo "echo ${config}=m >> ./KERNEL/.config"
		exit
	fi
}

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
check_config
config="CONFIG_ZRAM"
check_config

#
