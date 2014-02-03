#!/bin/sh -e

DIR=$PWD

check_config_builtin () {
	unset test_config
	test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "echo ${config}=y >> ./KERNEL/.config"
	fi
}

check_config_module () {
	unset test_config
	test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x${config}=y" ] ; then
		echo "sed -i -e 's:${config}=y:${config}=m:g' ./KERNEL/.config"
	else
		unset test_config
		test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
		if [ "x${test_config}" = "x" ] ; then
			echo "echo ${config}=m >> ./KERNEL/.config"
		fi
	fi
}

check_config () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "echo ${config}=y >> ./KERNEL/.config"
		echo "echo ${config}=m >> ./KERNEL/.config"
	fi
}

check_config_disabled () {
	unset test_config
	test_config=$(grep "${config} is not set" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		unset test_config
		test_config=$(grep "${config}=y" ${DIR}/patches/defconfig || true)
		if [ "x${test_config}" = "x${config}=y" ] ; then
			echo "sed -i -e 's:${config}=y:# ${config} is not set:g' ./KERNEL/.config"
		else
			echo "sed -i -e 's:${config}=m:# ${config} is not set:g' ./KERNEL/.config"
		fi
	fi
}

check_if_set_then_set_module () {
	unset test_config
	test_config=$(grep "${if_config}=y" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x${if_config}=y" ] ; then
		check_config_module
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

#meld patches/defconfig patches/debian-armmp

#
# General setup
#
config="CONFIG_LOCALVERSION_AUTO"
check_config_disabled
config="CONFIG_KERNEL_GZIP"
check_config_disabled
config="CONFIG_KERNEL_XZ"
check_config_builtin

config="CONFIG_POSIX_MQUEUE"
check_config_builtin
config="CONFIG_POSIX_MQUEUE_SYSCTL"
check_config_builtin
config="CONFIG_FHANDLE"
check_config_builtin
config="CONFIG_AUDIT"
check_config_builtin

#
# CPU/Task time and stats accounting
#
config="CONFIG_BSD_PROCESS_ACCT"
check_config_builtin
config="CONFIG_BSD_PROCESS_ACCT_V3"
check_config_builtin
config="CONFIG_TASKSTATS"
check_config_builtin
config="CONFIG_TASK_DELAY_ACCT"
check_config_builtin
config="CONFIG_TASK_XACCT"
check_config_builtin
config="CONFIG_TASK_IO_ACCOUNTING"
check_config_builtin

#
# RCU Subsystem
#

config="CONFIG_CGROUPS"
check_config_builtin
config="CONFIG_CGROUP_FREEZER"
check_config_builtin
config="CONFIG_CGROUP_DEVICE"
check_config_builtin
config="CONFIG_CPUSETS"
check_config_builtin
config="CONFIG_PROC_PID_CPUSET"
check_config_builtin
config="CONFIG_CGROUP_CPUACCT"
check_config_builtin
config="CONFIG_RESOURCE_COUNTERS"
check_config_builtin
config="CONFIG_MEMCG"
check_config_builtin
config="CONFIG_MEMCG_DISABLED"
check_config_builtin
config="CONFIG_MEMCG_SWAP"
check_config_builtin
config="CONFIG_MEMCG_SWAP_ENABLED"
check_config_disabled
config="CONFIG_CGROUP_PERF"
check_config_builtin
config="CONFIG_CGROUP_SCHED"
check_config_builtin
config="CONFIG_FAIR_GROUP_SCHED"
check_config_builtin
config="CONFIG_BLK_CGROUP"
check_config_builtin
config="CONFIG_CHECKPOINT_RESTORE"
check_config_builtin
config="CONFIG_NAMESPACES"
check_config_builtin
config="CONFIG_UTS_NS"
check_config_builtin
config="CONFIG_IPC_NS"
check_config_builtin
config="CONFIG_USER_NS"
check_config_builtin
config="CONFIG_PID_NS"
check_config_builtin
config="CONFIG_NET_NS"
check_config_builtin
config="CONFIG_UIDGID_STRICT_TYPE_CHECKS"
check_config_builtin
config="CONFIG_SCHED_AUTOGROUP"
check_config_builtin
config="CONFIG_MM_OWNER"
check_config_builtin
config="CONFIG_RELAY"
check_config_builtin
config="CONFIG_RD_BZIP2"
check_config_builtin
config="CONFIG_RD_LZMA"
check_config_builtin
config="CONFIG_RD_XZ"
check_config_builtin
config="CONFIG_RD_LZO"
check_config_builtin
config="CONFIG_RD_LZ4"
check_config_builtin

#
# Kernel Performance Events And Counters
#

config="CONFIG_PERF_EVENTS"
check_config_builtin
config="CONFIG_VM_EVENT_COUNTERS"
check_config_builtin
config="CONFIG_COMPAT_BRK"
check_config_disabled
config="CONFIG_SLAB"
check_config_builtin
config="CONFIG_SLUB"
check_config_disabled
config="CONFIG_SLOB"
check_config_disabled
config="CONFIG_PROFILING"
check_config_builtin
config="CONFIG_TRACEPOINTS"
check_config_builtin
config="CONFIG_HAVE_OPROFILE"
check_config_builtin
config="CONFIG_KPROBES"
check_config_builtin
config="CONFIG_JUMP_LABEL"
check_config_builtin

#
# GCOV-based kernel profiling
#

config="CONFIG_MODULE_FORCE_LOAD"
check_config_builtin
config="CONFIG_MODULE_FORCE_UNLOAD"
check_config_builtin
config="CONFIG_MODVERSIONS"
check_config_builtin

config="CONFIG_BLK_DEV_BSGLIB"
check_config_builtin
config="CONFIG_BLK_DEV_INTEGRITY"
check_config_builtin
config="CONFIG_BLK_DEV_THROTTLING"
check_config_builtin

#
# Partition Types
#

config="CONFIG_KARMA_PARTITION"
check_config_builtin

#
# IO Schedulers
#

config="CONFIG_CFQ_GROUP_IOSCHED"
check_config_builtin

#
# Networking options
#

config="CONFIG_PACKET_DIAG"
check_config_module
config="CONFIG_UNIX_DIAG"
check_config_module

config="CONFIG_XFRM_USER"
check_config_module
config="CONFIG_XFRM_SUB_POLICY"
check_config_builtin
config="CONFIG_XFRM_MIGRATE"
check_config_builtin

config="CONFIG_NET_KEY"
check_config_module
config="CONFIG_NET_KEY_MIGRATE"
check_config_builtin

config="CONFIG_IP_MULTICAST"
check_config_builtin
config="CONFIG_IP_ADVANCED_ROUTER"
check_config_builtin
config="CONFIG_IP_FIB_TRIE_STATS"
check_config_builtin
config="CONFIG_IP_MULTIPLE_TABLES"
check_config_builtin
config="CONFIG_IP_ROUTE_MULTIPATH"
check_config_builtin
config="CONFIG_IP_ROUTE_VERBOSE"
check_config_builtin
config="CONFIG_IP_ROUTE_CLASSID"
check_config_builtin
# CONFIG_IP_PNP is not set
config="CONFIG_NET_IPIP"
check_config_module
config="CONFIG_NET_IPGRE_DEMUX"
check_config_module

config="CONFIG_NET_IPGRE"
check_config_module
config="CONFIG_NET_IPGRE_BROADCAST"
check_config_builtin
config="CONFIG_IP_MROUTE"
check_config_builtin
config="CONFIG_IP_MROUTE_MULTIPLE_TABLES"
check_config_builtin
config="CONFIG_IP_PIMSM_V1"
check_config_builtin
config="CONFIG_IP_PIMSM_V2"
check_config_builtin
config="CONFIG_SYN_COOKIES"
check_config_builtin
config="CONFIG_NET_IPVTI"
check_config_module
config="CONFIG_INET_AH"
check_config_module
config="CONFIG_INET_ESP"
check_config_module
config="CONFIG_INET_IPCOMP"
check_config_module
config="CONFIG_INET_XFRM_TUNNEL"
check_config_module

config="CONFIG_INET_XFRM_MODE_TRANSPORT"
check_config_module
config="CONFIG_INET_XFRM_MODE_TUNNEL"
check_config_module
config="CONFIG_INET_XFRM_MODE_BEET"
check_config_module
config="CONFIG_INET_LRO"
check_config_module
config="CONFIG_INET_DIAG"
check_config_module
config="CONFIG_INET_TCP_DIAG"
check_config_module
config="CONFIG_INET_UDP_DIAG"
check_config_module
config="CONFIG_TCP_CONG_ADVANCED"
check_config_builtin
config="CONFIG_TCP_CONG_BIC"
check_config_module

config="CONFIG_TCP_CONG_WESTWOOD"
check_config_module
config="CONFIG_TCP_CONG_HTCP"
check_config_module
config="CONFIG_TCP_CONG_HSTCP"
check_config_module
config="CONFIG_TCP_CONG_HYBLA"
check_config_module
config="CONFIG_TCP_CONG_VEGAS"
check_config_module
config="CONFIG_TCP_CONG_SCALABLE"
check_config_module
config="CONFIG_TCP_CONG_LP"
check_config_module
config="CONFIG_TCP_CONG_VENO"
check_config_module
config="CONFIG_TCP_CONG_YEAH"
check_config_module
config="CONFIG_TCP_CONG_ILLINOIS"
check_config_module
config="CONFIG_DEFAULT_CUBIC"
check_config_builtin

config="CONFIG_TCP_MD5SIG"
check_config_builtin
config="CONFIG_IPV6"
check_config_builtin
config="CONFIG_IPV6_PRIVACY"
check_config_builtin
config="CONFIG_IPV6_ROUTE_INFO"
check_config_builtin

config="CONFIG_IPV6_MIP6"
check_config_builtin

config="CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION"
check_config_module

config="CONFIG_IPV6_SIT_6RD"
check_config_builtin

config="CONFIG_IPV6_GRE"
check_config_module

config="CONFIG_IPV6_SUBTREES"
check_config_builtin
config="CONFIG_IPV6_MROUTE"
check_config_builtin
config="CONFIG_IPV6_MROUTE_MULTIPLE_TABLES"
check_config_builtin
config="CONFIG_IPV6_PIMSM_V2"
check_config_builtin
# CONFIG_NETLABEL is not set
config="CONFIG_NETWORK_SECMARK"
check_config_builtin

config="CONFIG_NETFILTER"
check_config_builtin
# CONFIG_NETFILTER_DEBUG is not set
config="CONFIG_NETFILTER_ADVANCED"
check_config_builtin
config="CONFIG_BRIDGE_NETFILTER"
check_config_builtin

#
