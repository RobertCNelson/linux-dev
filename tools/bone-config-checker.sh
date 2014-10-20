#!/bin/sh -e

DIR=$PWD

check_config_value () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "echo ${config}=${value} >> ./KERNEL/.config"
	else
		if [ ! "x${test_config}" = "x${config}=${value}" ] ; then
			echo "sed -i -e 's:${test_config}:${config}=${value}:g' ./KERNEL/.config"
		fi
	fi
}

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

check_config_disable () {
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
		check_config_disable
	fi
}

#
# General setup
#
config="CONFIG_KERNEL_XZ"
check_config_disable
config="CONFIG_KERNEL_LZO"
check_config_builtin

#
# CPU Core family selection
#
config="CONFIG_ARCH_MXC"
check_config_disable

#
# OMAP Feature Selections
#
config="CONFIG_ARCH_OMAP4"
check_config_disable
config="CONFIG_SOC_OMAP5"
check_config_disable
config="CONFIG_SOC_AM43XX"
check_config_disable
config="CONFIG_SOC_DRA7XX"
check_config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_ARCH_SUNXI"
check_config_disable
config="CONFIG_ARCH_TEGRA"
check_config_disable

#
# Processor Features
#
config="CONFIG_PL310_ERRATA_769419"
check_config_disable

#
# Kernel Features
#
config="CONFIG_SMP"
check_config_disable
config="CONFIG_THUMB2_KERNEL"
check_config_builtin

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_FSL_LPUART"
check_config_disable

#
# Input Device Drivers
#
config="CONFIG_TOUCHSCREEN_EDT_FT5X06"
check_config_builtin

#
# Native drivers
#
config="CONFIG_IMX_THERMAL"
check_config_disable

#
# Watchdog Device Drivers
#
config="CONFIG_DA9052_WATCHDOG"
check_config_disable

#
# USB Imaging devices
#
config="CONFIG_USB_MUSB_TUSB6010"
check_config_disable
config="CONFIG_USB_MUSB_OMAP2PLUS"
check_config_disable
config="CONFIG_USB_MUSB_AM35X"
check_config_disable
config="CONFIG_USB_MUSB_DSPS"
check_config_builtin
config="CONFIG_USB_MUSB_UX500"
check_config_disable
config="CONFIG_USB_MUSB_AM335X_CHILD"
check_config_builtin
config="CONFIG_USB_TI_CPPI41_DMA"
check_config_disable
config="CONFIG_MUSB_PIO_ONLY"
check_config_builtin

#
# USB Physical Layer drivers
#
config="CONFIG_AM335X_CONTROL_USB"
check_config_builtin
config="CONFIG_AM335X_PHY_USB"
check_config_builtin

#
# USB Peripheral Controller
#
config="CONFIG_USB_LIBCOMPOSITE"
check_config_module
config="CONFIG_USB_F_ACM"
check_config_module
config="CONFIG_USB_F_SS_LB"
check_config_module
config="CONFIG_USB_U_SERIAL"
check_config_module
config="CONFIG_USB_U_ETHER"
check_config_module
config="CONFIG_USB_F_SERIAL"
check_config_module
config="CONFIG_USB_F_OBEX"
check_config_module
config="CONFIG_USB_F_NCM"
check_config_module
config="CONFIG_USB_F_ECM"
check_config_module
config="CONFIG_USB_F_PHONET"
check_config_module
config="CONFIG_USB_F_EEM"
check_config_module
config="CONFIG_USB_F_SUBSET"
check_config_module
config="CONFIG_USB_F_RNDIS"
check_config_module
config="CONFIG_USB_F_MASS_STORAGE"
check_config_module
config="CONFIG_USB_F_FS"
check_config_module
config="CONFIG_USB_CONFIGFS"
check_config_module
config="CONFIG_USB_CONFIGFS_SERIAL"
check_config_builtin
config="CONFIG_USB_CONFIGFS_ACM"
check_config_builtin
config="CONFIG_USB_CONFIGFS_OBEX"
check_config_builtin
config="CONFIG_USB_CONFIGFS_NCM"
check_config_builtin
config="CONFIG_USB_CONFIGFS_ECM"
check_config_builtin
config="CONFIG_USB_CONFIGFS_ECM_SUBSET"
check_config_builtin
config="CONFIG_USB_CONFIGFS_RNDIS"
check_config_builtin
config="CONFIG_USB_CONFIGFS_EEM"
check_config_builtin
config="CONFIG_USB_CONFIGFS_PHONET"
check_config_disable
config="CONFIG_USB_CONFIGFS_MASS_STORAGE"
check_config_disable
config="CONFIG_USB_CONFIGFS_F_LB_SS"
check_config_disable
config="CONFIG_USB_CONFIGFS_F_FS"
check_config_disable
config="CONFIG_USB_ZERO"
check_config_module
config="CONFIG_USB_ZERO_HNPTEST"
check_config_builtin
config="CONFIG_USB_AUDIO"
check_config_module
config="CONFIG_GADGET_UAC1"
check_config_disable
config="CONFIG_USB_ETH"
check_config_module
config="CONFIG_USB_ETH_RNDIS"
check_config_builtin
config="CONFIG_USB_ETH_EEM"
check_config_builtin
config="CONFIG_USB_G_NCM"
check_config_module
config="CONFIG_USB_GADGETFS"
check_config_module
config="CONFIG_USB_FUNCTIONFS"
check_config_module
config="CONFIG_USB_FUNCTIONFS_ETH"
check_config_builtin
config="CONFIG_USB_FUNCTIONFS_RNDIS"
check_config_builtin
config="CONFIG_USB_FUNCTIONFS_GENERIC"
check_config_builtin
config="CONFIG_USB_MASS_STORAGE"
check_config_module
config="CONFIG_USB_GADGET_TARGET"
check_config_disable
config="CONFIG_USB_G_SERIAL"
check_config_module
config="CONFIG_USB_MIDI_GADGET"
check_config_module
config="CONFIG_USB_G_PRINTER"
check_config_module
config="CONFIG_USB_CDC_COMPOSITE"
check_config_module
config="CONFIG_USB_G_NOKIA"
check_config_module
config="CONFIG_USB_G_ACM_MS"
check_config_module
config="CONFIG_USB_G_MULTI"
check_config_module
config="CONFIG_USB_G_MULTI_RNDIS"
check_config_builtin
config="CONFIG_USB_G_MULTI_CDC"
check_config_builtin
config="CONFIG_USB_G_HID"
check_config_module
config="CONFIG_USB_G_DBGP"
check_config_module
config="CONFIG_USB_G_DBGP_PRINTK"
check_config_disable
config="CONFIG_USB_G_DBGP_SERIAL"
check_config_builtin
config="CONFIG_USB_G_WEBCAM"
check_config_disable

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_OMAP"
check_config_builtin

#
# Graphics support
#
config="CONFIG_GPU_VIVANTE_V4"
check_config_disable

#
# I2C encoder or helper chips
#
config="CONFIG_DRM_OMAP"
check_config_disable

#
# Android
#
config="CONFIG_DRM_IMX"
check_config_disable

#capes:
config="CONFIG_CAPE_BONE_ARGUS"
check_config_builtin

#lcd4:
config="CONFIG_BACKLIGHT_GPIO"
check_config_builtin

#Reset Controller:
config="CONFIG_STMMAC_ETH"
check_config_disable
config="CONFIG_RESET_CONTROLLER"
check_config_disable

#
