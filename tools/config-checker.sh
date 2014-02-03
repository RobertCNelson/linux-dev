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

config="CONFIG_EXPERT"
check_config_builtin
config="CONFIG_EMBEDDED"
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
config="CONFIG_SECCOMP_FILTER"
check_config_builtin
config="CONFIG_CC_STACKPROTECTOR"
check_config_builtin
config="CONFIG_CC_STACKPROTECTOR_REGULAR"
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

config="CONFIG_PARTITION_ADVANCED"
check_config_builtin
config="CONFIG_KARMA_PARTITION"
check_config_builtin

#
# CPU Core family selection
#

config="CONFIG_ARCH_MVEBU"
check_config_disabled
config="CONFIG_ARCH_BCM"
check_config_disabled
config="CONFIG_ARCH_BERLIN"
check_config_disabled

config="CONFIG_ARCH_HIGHBANK"
check_config_disabled
config="CONFIG_ARCH_HI3xxx"
check_config_disabled
config="CONFIG_ARCH_KEYSTONE"
check_config_disabled

#
# Device tree only
#

config="CONFIG_WAND_RFKILL"
check_config_builtin

#
# OMAP Legacy Platform Data Board Type
#

config="CONFIG_ARCH_ROCKCHIP"
check_config_disabled
config="CONFIG_ARCH_SOCFPGA"
check_config_disabled
config="CONFIG_PLAT_SPEAR"
check_config_disabled
config="CONFIG_ARCH_STI"
check_config_disabled

config="CONFIG_ARCH_SUNXI"
check_config_disabled
config="CONFIG_ARCH_SIRF"
check_config_disabled
config="CONFIG_ARCH_TEGRA"
check_config_disabled
config="CONFIG_ARCH_U8500"
check_config_disabled
config="CONFIG_ARCH_VEXPRESS"
check_config_disabled
config="CONFIG_ARCH_VIRT"
check_config_disabled
config="CONFIG_ARCH_WM8850"
check_config_disabled
config="CONFIG_ARCH_ZYNQ"
check_config_disabled

#
# Processor Features
#

config="CONFIG_ARM_ERRATA_430973"
check_config_builtin

#
# Bus support
#

config="CONFIG_PCI_MSI"
check_config_disabled

#
# PCI host controller drivers
#

config="CONFIG_PCI_IMX6"
check_config_builtin

#
# Kernel Features
#

config="CONFIG_THUMB2_KERNEL"
check_config_disabled
config="CONFIG_ZSMALLOC"
check_config_builtin
config="CONFIG_SECCOMP"
check_config_builtin

#
# CPU Frequency scaling
#

config="CONFIG_CPU_FREQ_STAT_DETAILS"
check_config_disabled
config="CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE"
check_config_builtin

config="CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND"
check_config_disabled

config="CONFIG_CPU_FREQ_GOV_POWERSAVE"
check_config_builtin
config="CONFIG_CPU_FREQ_GOV_USERSPACE"
check_config_builtin

config="CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
check_config_builtin
config="CONFIG_GENERIC_CPUFREQ_CPU0"
check_config_builtin

#
# ARM CPU frequency scaling drivers
#

config="CONFIG_ARM_IMX6Q_CPUFREQ"
check_config_builtin
config="CONFIG_ARM_OMAP2PLUS_CPUFREQ"
check_config_disabled

#
# At least one emulation must be selected
#

config="CONFIG_KERNEL_MODE_NEON"
check_config_builtin

#
# Device Tree and Open Firmware support
#

config="CONFIG_ZRAM"
check_config_module

#
# Controllers with non-SFF native interface
#

config="CONFIG_AHCI_IMX"
check_config_builtin

#
# SPI Protocol Masters
#

config="CONFIG_SPI_SPIDEV"
check_config_builtin

#
# Pin controllers
#

config="CONFIG_DEBUG_GPIO"
check_config_builtin

#
# Native drivers
#

config="CONFIG_CPU_THERMAL"
check_config_builtin
config="CONFIG_IMX_THERMAL"
check_config_builtin

#
# Texas Instruments thermal drivers
#
config="CONFIG_TI_SOC_THERMAL"
check_config_builtin
config="CONFIG_TI_THERMAL"
check_config_builtin
config="CONFIG_OMAP4_THERMAL"
check_config_builtin
config="CONFIG_OMAP5_THERMAL"
check_config_builtin

#
# Watchdog Device Drivers
#

config="CONFIG_WATCHDOG"
check_config_builtin
config="CONFIG_WATCHDOG_CORE"
check_config_builtin
config="CONFIG_OMAP_WATCHDOG"
check_config_builtin
config="CONFIG_TWL4030_WATCHDOG"
check_config_builtin
config="CONFIG_IMX2_WDT"
check_config_builtin

#
# Multifunction device drivers
#

config="CONFIG_MFD_TPS65217"
check_config_builtin
config="CONFIG_TWL6040_CORE"
check_config_builtin
config="CONFIG_REGULATOR_ANATOP"
check_config_builtin
config="CONFIG_REGULATOR_PFUZE100"
check_config_builtin
config="CONFIG_REGULATOR_TI_ABB"
check_config_builtin
config="CONFIG_REGULATOR_TPS65023"
check_config_builtin
config="CONFIG_REGULATOR_TPS6507X"
check_config_builtin
config="CONFIG_REGULATOR_TPS65217"
check_config_builtin

#
# Multimedia core support
#

config="CONFIG_MEDIA_CONTROLLER"
check_config_builtin
config="CONFIG_VIDEO_V4L2_SUBDEV_API"
check_config_builtin


#
# Graphics support
#

config="CONFIG_DRM_I2C_NXP_TDA998X"
check_config_builtin
config="CONFIG_DRM_OMAP"
check_config_builtin
config="CONFIG_DRM_TILCDC"
check_config_builtin

#
# Frame buffer hardware drivers
#

config="CONFIG_OMAP2_DSS"
check_config_builtin
config="CONFIG_OMAP2_DSS_DPI"
check_config_builtin
config="CONFIG_OMAP2_DSS_VENC"
check_config_builtin
config="CONFIG_OMAP4_DSS_HDMI"
check_config_builtin
config="CONFIG_DISPLAY_ENCODER_TFP410"
check_config_builtin
config="CONFIG_DISPLAY_ENCODER_TPD12S015"
check_config_builtin
config="CONFIG_DISPLAY_CONNECTOR_DVI"
check_config_builtin
config="CONFIG_DISPLAY_CONNECTOR_HDMI"
check_config_builtin
config="CONFIG_DISPLAY_CONNECTOR_ANALOG_TV"
check_config_builtin
config="CONFIG_DISPLAY_PANEL_DPI"
check_config_builtin

#
# Miscellaneous USB options
#

config="CONFIG_USB_OTG"
check_config_builtin

#
# USB Imaging devices
#

config="CONFIG_USB_MUSB_HDRC"
check_config_builtin
config="CONFIG_USB_MUSB_DUAL_ROLE"
check_config_builtin
config="CONFIG_USB_MUSB_TUSB6010"
check_config_module
config="CONFIG_USB_MUSB_OMAP2PLUS"
check_config_module
config="CONFIG_USB_MUSB_DSPS"
check_config_module
config="CONFIG_USB_MUSB_AM335X_CHILD"
check_config_module
config="CONFIG_MUSB_PIO_ONLY"
check_config_builtin

#
# USB Physical Layer drivers
#

config="CONFIG_AM335X_CONTROL_USB"
check_config_builtin
config="CONFIG_AM335X_PHY_USB"
check_config_builtin
config="CONFIG_TWL6030_USB"
check_config_module
config="CONFIG_USB_GADGET"
check_config_builtin
config="CONFIG_USB_LIBCOMPOSITE"
check_config_module
config="CONFIG_USB_U_ETHER"
check_config_module
config="CONFIG_USB_F_ECM"
check_config_module
config="CONFIG_USB_F_SUBSET"
check_config_module
config="CONFIG_USB_F_RNDIS"
check_config_module
config="CONFIG_USB_ETH"
check_config_module
config="CONFIG_USB_ETH_RNDIS"
check_config_builtin
config="CONFIG_MMC_UNSAFE_RESUME"
check_config_builtin

#
# LED drivers
#

config="CONFIG_NEW_LEDS"
check_config_builtin
config="CONFIG_LEDS_CLASS"
check_config_builtin
config="CONFIG_LEDS_GPIO"
check_config_builtin
config="CONFIG_LEDS_TRIGGERS"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_TIMER"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_ONESHOT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_HEARTBEAT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_BACKLIGHT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_CPU"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_GPIO"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_DEFAULT_ON"
check_config_builtin

#
# on-CPU RTC drivers
#

config="CONFIG_RTC_DRV_OMAP"
check_config_builtin
config="CONFIG_RTC_DRV_SNVS"
check_config_builtin

#
# DMA Devices
#

config="CONFIG_TI_CPPI41"
check_config_builtin

#
# Speakup console speech
#

config="CONFIG_STAGING_MEDIA"
check_config_builtin
config="CONFIG_VIDEO_OMAP4"
check_config_builtin

#
# Android
#

config="CONFIG_ANDROID"
check_config_builtin
config="CONFIG_ANDROID_BINDER_IPC"
check_config_builtin
config="CONFIG_ASHMEM"
check_config_builtin
config="CONFIG_ANDROID_LOGGER"
check_config_module
config="CONFIG_ANDROID_TIMED_OUTPUT"
check_config_builtin
config="CONFIG_ANDROID_TIMED_GPIO"
check_config_module
config="CONFIG_ANDROID_LOW_MEMORY_KILLER"
check_config_disabled
config="CONFIG_ANDROID_INTF_ALARM_DEV"
check_config_builtin
config="CONFIG_SYNC"
check_config_builtin
config="CONFIG_ION"
check_config_builtin

config="CONFIG_DRM_IMX"
check_config_builtin
config="CONFIG_DRM_IMX_FB_HELPER"
check_config_builtin
config="CONFIG_DRM_IMX_PARALLEL_DISPLAY"
check_config_builtin
config="CONFIG_DRM_IMX_TVE"
check_config_builtin
config="CONFIG_DRM_IMX_LDB"
check_config_builtin
config="CONFIG_DRM_IMX_IPUV3_CORE"
check_config_builtin
config="CONFIG_DRM_IMX_IPUV3"
check_config_builtin
config="CONFIG_DRM_IMX_HDMI"
check_config_builtin

#
# PHY Subsystem
#

config="CONFIG_TWL4030_USB"
check_config_module

#
# File systems
#

config="CONFIG_XFS_FS"
check_config_builtin
config="CONFIG_BTRFS_FS"
check_config_builtin
config="CONFIG_AUTOFS4_FS"
check_config_builtin

#
# DOS/FAT/NT Filesystems
#

config="CONFIG_MSDOS_FS"
check_config_builtin

#
# Pseudo filesystems
#

config="CONFIG_TMPFS_POSIX_ACL"
check_config_builtin
config="CONFIG_TMPFS_XATTR"
check_config_builtin
config="CONFIG_CONFIGFS_FS"
check_config_builtin

config="CONFIG_NLS_CODEPAGE_437"
check_config_builtin
config="CONFIG_NLS_ISO8859_1"
check_config_builtin

#FIXME: cleanup below...

#debian:
config="CONFIG_SYSVIPC"
check_config_builtin
config="CONFIG_SYSVIPC_SYSCTL"
check_config_builtin


#imx6 stuff.
if_config="CONFIG_SOC_IMX6Q"
config="CONFIG_CFG80211"
check_if_set_then_set
config="CONFIG_BRCMFMAC"
check_if_set_then_set
config="CONFIG_BRCMFMAC_SDIO"
check_if_set_then_set
config="CONFIG_AT803X_PHY"
check_if_set_then_set

#All enabled by CONFIG_PCI CONFIG_SOC_IMX6Q
if_config="CONFIG_SOC_IMX6Q"
config="CONFIG_NET_VENDOR_3COM"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_ADAPTEC"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_ALTEON"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_AMD"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_ATHEROS"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_BROCADE"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_CHELSIO"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_CISCO"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_DEC"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_DLINK"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_EMULEX"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_EXAR"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_HP"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_MELLANOX"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_MYRI"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_NVIDIA"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_OKI"
check_if_set_then_disable
config="CONFIG_NET_PACKET_ENGINE"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_QLOGIC"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_REALTEK"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_RDC"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_SILAN"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_SIS"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_SUN"
check_if_set_then_disable
config="CONFIG_NET_VENDOR_TEHUTI"
check_if_set_then_disable

#omap3:
if_config="CONFIG_ARCH_OMAP3"
config="CONFIG_PINCTRL_SINGLE"
check_if_set_then_set
config="CONFIG_MFD_PALMAS"
check_if_set_then_set
config="CONFIG_MFD_TPS65217"
check_if_set_then_set
config="CONFIG_MFD_TPS65910"
check_if_set_then_set
config="CONFIG_REGULATOR_FIXED_VOLTAGE"
check_if_set_then_set
config="CONFIG_GPIO_TPS65910"
check_if_set_then_set
config="CONFIG_REGULATOR_TPS65023"
check_if_set_then_set
config="CONFIG_REGULATOR_TPS6507X"
check_if_set_then_set
config="CONFIG_REGULATOR_TPS65217"
check_if_set_then_set
config="CONFIG_REGULATOR_TPS65910"
check_if_set_then_set
config="CONFIG_REGULATOR_TWL4030"
check_if_set_then_set
config="CONFIG_REGULATOR_TI_ABB"
check_if_set_then_set
config="CONFIG_USB_USBNET"
check_if_set_then_set
config="CONFIG_USB_NET_SMSC95XX"
check_if_set_then_set
config="CONFIG_LOGO"
check_if_set_then_set
config="CONFIG_LOGO_LINUX_MONO"
check_if_set_then_set
config="CONFIG_LOGO_LINUX_VGA16"
check_if_set_then_set
config="CONFIG_LOGO_LINUX_CLUT224"
check_if_set_then_set
config="CONFIG_MMC_UNSAFE_RESUME"
check_if_set_then_set
config="CONFIG_NEW_LEDS"
check_if_set_then_set
config="CONFIG_LEDS_CLASS"
check_if_set_then_set
config="CONFIG_LEDS_GPIO"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGERS"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_TIMER"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_ONESHOT"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_HEARTBEAT"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_BACKLIGHT"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_CPU"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_GPIO"
check_if_set_then_set
config="CONFIG_LEDS_TRIGGER_DEFAULT_ON"
check_if_set_then_set
config="CONFIG_THERMAL"
check_if_set_then_set
config="CONFIG_THERMAL_GOV_FAIR_SHARE"
check_if_set_then_set
config="CONFIG_THERMAL_GOV_USER_SPACE"
check_if_set_then_set
config="CONFIG_TI_SOC_THERMAL"
check_if_set_then_set
config="CONFIG_TI_THERMAL"
check_if_set_then_set
config="CONFIG_ARM_OMAP2PLUS_CPUFREQ"
check_if_set_then_disable

#omap4:
if_config="CONFIG_ARCH_OMAP4"
config="CONFIG_TWL6030_USB"
check_if_set_then_set_module
config="CONFIG_TWL6040_CORE"
check_if_set_then_set
config="CONFIG_OMAP4_THERMAL"
check_if_set_then_set
config="CONFIG_MEDIA_SUPPORT"
check_if_set_then_set
config="CONFIG_MEDIA_CAMERA_SUPPORT"
check_if_set_then_set
config="CONFIG_MEDIA_CONTROLLER"
check_if_set_then_set
config="CONFIG_VIDEO_V4L2_SUBDEV_API"
check_if_set_then_set
config="CONFIG_STAGING_MEDIA"
check_if_set_then_set
config="CONFIG_VIDEO_OMAP4"
check_if_set_then_set

#omap5:
if_config="CONFIG_SOC_OMAP5"
config="CONFIG_REGULATOR_PALMAS"
check_if_set_then_set
config="CONFIG_PINCTRL_PALMAS"
check_if_set_then_set
config="CONFIG_GPIO_PALMAS"
check_if_set_then_set
config="CONFIG_OMAP5_THERMAL"
check_if_set_then_set
config="CONFIG_RTC_DRV_PALMAS"
check_if_set_then_set

#BeagleBoneBlack:
if_config="CONFIG_SOC_AM33XX"
config="CONFIG_DRM_TILCDC"
check_if_set_then_set
config="CONFIG_DRM_I2C_NXP_TDA998X"
check_if_set_then_set
config="CONFIG_AM335X_PHY_USB"
check_if_set_then_set
config="CONFIG_TI_CPPI41"
check_if_set_then_set
config="CONFIG_USB_OTG"
check_if_set_then_set
config="CONFIG_USB_OTG_WHITELIST"
check_config_disabled
config="CONFIG_USB_MUSB_HDRC"
check_if_set_then_set
config="CONFIG_USB_MUSB_DSPS"
check_if_set_then_set_module
config="CONFIG_USB_GADGET"
check_if_set_then_set
config="CONFIG_USB_ETH"
check_if_set_then_set_module
config="CONFIG_RTC_DRV_OMAP"
check_if_set_then_set
config="CONFIG_SOUND"
check_if_set_then_set_module
config="CONFIG_SND"
check_if_set_then_set_module
config="CONFIG_SND_SOC"
check_if_set_then_set_module
config="CONFIG_SND_DAVINCI_SOC"
check_if_set_then_set_module
config="CONFIG_SND_AM33XX_SOC_EVM"
check_if_set_then_set_module

if_config="CONFIG_ARCH_MULTI_V7"
config="CONFIG_SMP"
check_if_set_then_set
config="CONFIG_SMP_ON_UP"
check_if_set_then_set
config="CONFIG_SWP_EMULATE"
check_if_set_then_set


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

#Hints from Debian loading..
config="CONFIG_PACKET"
check_config_builtin
config="CONFIG_VFAT_FS"
check_config_builtin

#Useful
config="CONFIG_I2C_CHARDEV"
check_config_builtin
config="CONFIG_I2C_MUX"
check_config_builtin
config="CONFIG_DEBUG_GPIO"
check_config_builtin
config="CONFIG_GPIO_SYSFS"
check_config_builtin
config="CONFIG_SPI_SPIDEV"
check_config_builtin

#broken:
#config="CONFIG_DRM_TEGRA"
#check_config_disabled
#
