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

#Basic:
config="CONFIG_LOCALVERSION_AUTO"
check_config_disabled

#Modules
config="CONFIG_MODULES"
check_config_builtin
config="CONFIG_MODULE_FORCE_LOAD"
check_config_builtin
config="CONFIG_MODULE_UNLOAD"
check_config_builtin
config="CONFIG_MODULE_FORCE_UNLOAD"
check_config_builtin
config="CONFIG_MODVERSIONS"
check_config_builtin

###CONFIG_ARCH_MULTIPLATFORM
if_config="CONFIG_ARCH_MULTIPLATFORM"

config="CONFIG_ARCH_MULTI_V6"
check_if_set_then_disable

#drop non omap3/imx
config="CONFIG_ARCH_BERLIN"
check_if_set_then_disable
config="CONFIG_ARCH_BCM"
check_if_set_then_disable
config="CONFIG_ARCH_HI3xxx"
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

#omap3/4/5
if_config="CONFIG_ARCH_OMAP3"
config="CONFIG_PINCTRL_SINGLE"
check_if_set_then_set
config="CONFIG_WATCHDOG"
check_if_set_then_set
config="CONFIG_OMAP_WATCHDOG"
check_if_set_then_set
config="CONFIG_TWL4030_WATCHDOG"
check_if_set_then_set
config="CONFIG_USB_MUSB_OMAP2PLUS"
check_if_set_then_set_module
config="CONFIG_TWL4030_USB"
check_if_set_then_set_module
config="CONFIG_TWL6030_USB"
check_if_set_then_set_module
config="CONFIG_MFD_PALMAS"
check_if_set_then_set
config="CONFIG_MFD_TPS65217"
check_if_set_then_set
config="CONFIG_MFD_TPS65910"
check_if_set_then_set
config="CONFIG_TWL6040_CORE"
check_if_set_then_set
config="CONFIG_REGULATOR_FIXED_VOLTAGE"
check_if_set_then_set
config="CONFIG_REGULATOR_PALMAS"
check_if_set_then_set
config="CONFIG_PINCTRL_PALMAS"
check_if_set_then_set
config="CONFIG_GPIO_PALMAS"
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
config="CONFIG_CPU_FREQ"
check_if_set_then_set
config="CONFIG_CPU_FREQ_GOV_PERFORMANCE"
check_if_set_then_set
config="CONFIG_CPU_FREQ_GOV_POWERSAVE"
check_if_set_then_set
config="CONFIG_CPU_FREQ_GOV_USERSPACE"
check_if_set_then_set
config="CONFIG_CPU_FREQ_GOV_ONDEMAND"
check_if_set_then_set
config="CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
check_if_set_then_set
config="CONFIG_GENERIC_CPUFREQ_CPU0"
check_if_set_then_set
config="CONFIG_DRM"
check_if_set_then_set
config="CONFIG_OMAP2_DSS"
check_if_set_then_set
config="CONFIG_DRM_OMAP"
check_if_set_then_set
config="CONFIG_DISPLAY_ENCODER_TFP410"
check_if_set_then_set
config="CONFIG_DISPLAY_ENCODER_TPD12S015"
check_if_set_then_set
config="CONFIG_DISPLAY_CONNECTOR_DVI"
check_if_set_then_set
config="CONFIG_DISPLAY_CONNECTOR_HDMI"
check_if_set_then_set
config="CONFIG_DISPLAY_CONNECTOR_ANALOG_TV"
check_if_set_then_set
config="CONFIG_DISPLAY_PANEL_DPI"
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
config="CONFIG_OMAP4_THERMAL"
check_if_set_then_set
config="CONFIG_OMAP5_THERMAL"
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

if_config="CONFIG_ARCH_MULTI_V7"
config="CONFIG_SMP"
check_if_set_then_set
config="CONFIG_SMP_ON_UP"
check_if_set_then_set
config="CONFIG_SWP_EMULATE"
check_if_set_then_set
#config="CONFIG_THUMB2_KERNEL"
#check_if_set_then_set

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
config="CONFIG_STAGING"
check_config_builtin
config="CONFIG_ZSMALLOC"
check_config_builtin
config="CONFIG_ZRAM"
check_config_module

#Hints from Debian loading..
config="CONFIG_PACKET"
check_config_builtin
config="CONFIG_VFAT_FS"
check_config_builtin

#CONFIG_CC_STACKPROTECTOR
config="CONFIG_CC_STACKPROTECTOR"
check_config_builtin
config="CONFIG_CC_STACKPROTECTOR_NONE"
check_config_disabled
config="CONFIG_CC_STACKPROTECTOR_REGULAR"
check_config_builtin

#Android
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

#useful
config="CONFIG_I2C_CHARDEV"
check_config_builtin
config="CONFIG_DEBUG_GPIO"
check_config_builtin
config="CONFIG_GPIO_SYSFS"
check_config_builtin
config="CONFIG_SPI_SPIDEV"
check_config_builtin

#
