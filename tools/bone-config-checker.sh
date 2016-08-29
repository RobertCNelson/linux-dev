#!/bin/sh -e

DIR=$PWD

config_enable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xy" ] ; then
		echo "Setting: ${config}=y"
		./scripts/config --enable ${config}
	fi
}

config_disable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xn" ] ; then
		echo "Setting: ${config}=n"
		./scripts/config --disable ${config}
	fi
}

config_module () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xm" ] ; then
		echo "Setting: ${config}=m"
		./scripts/config --module ${config}
	fi
}

config_string () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=\"${option}\""
		./scripts/config --set-str ${config} "${option}"
	fi
}

config_value () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=${option}"
		./scripts/config --set-val ${config} ${option}
	fi
}

cd ${DIR}/KERNEL/

#
# General setup
#
config="CONFIG_KERNEL_XZ" ; config_disable
config="CONFIG_KERNEL_LZO" ; config_enable

#
# Bus support
#
config="CONFIG_PCI" ; config_disable
config="CONFIG_PCI_SYSCALL" ; config_disable

#
# CPU Core family selection
#
config="CONFIG_ARCH_MXC" ; config_disable

#
# OMAP Feature Selections
#
config="CONFIG_ARCH_OMAP3" ; config_disable
config="CONFIG_ARCH_OMAP4" ; config_disable
config="CONFIG_SOC_OMAP5" ; config_disable
config="CONFIG_SOC_AM43XX" ; config_disable
config="CONFIG_SOC_DRA7XX" ; config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_ARCH_EXYNOS" ; config_disable
config="CONFIG_ARCH_ROCKCHIP" ; config_disable
config="CONFIG_ARCH_SOCFPGA" ; config_disable
config="CONFIG_ARCH_SUNXI" ; config_disable
config="CONFIG_ARCH_TEGRA" ; config_disable
config="CONFIG_ARCH_ZYNQ" ; config_disable

#
# Processor Features
#
config="CONFIG_PL310_ERRATA_769419" ; config_disable

#
# Kernel Features
#
config="CONFIG_SMP" ; config_disable
config="CONFIG_THUMB2_KERNEL" ; config_enable

#
# CPU frequency scaling drivers
#
config="CONFIG_QORIQ_CPUFREQ" ; config_disable
config="CONFIG_CLK_QORIQ" ; config_disable

#
# Serial drivers
#
config="CONFIG_SERIAL_8250_DMA" ; config_disable
config="CONFIG_SERIAL_8250_OMAP" ; config_enable
config="CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP" ; config_enable

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_OMAP" ; config_disable
config="CONFIG_SERIAL_FSL_LPUART" ; config_disable
config="CONFIG_SERIAL_XILINX_PS_UART" ; config_disable

#
# Input Device Drivers
#
config="CONFIG_TOUCHSCREEN_EDT_FT5X06" ; config_enable

#
# Native drivers
#
config="CONFIG_IMX_THERMAL" ; config_disable

#
# Watchdog Device Drivers
#
config="CONFIG_DA9052_WATCHDOG" ; config_disable

#
# Miscellaneous USB options
#
#http://bugs.elinux.org/issues/127
config="CONFIG_USB_OTG" ; config_disable

#
# USB Imaging devices
#
config="CONFIG_USB_MUSB_TUSB6010" ; config_disable
config="CONFIG_USB_MUSB_OMAP2PLUS" ; config_disable
config="CONFIG_USB_MUSB_AM35X" ; config_disable
config="CONFIG_USB_MUSB_DSPS" ; config_enable
config="CONFIG_USB_MUSB_UX500" ; config_disable
config="CONFIG_USB_TI_CPPI41_DMA" ; config_disable

#
# MUSB DMA mode
#
config="CONFIG_MUSB_PIO_ONLY" ; config_enable

#
# USB Peripheral Controller
#
config="CONFIG_USB_LIBCOMPOSITE" ; config_module
config="CONFIG_USB_F_ACM" ; config_module
config="CONFIG_USB_F_SS_LB" ; config_module
config="CONFIG_USB_U_SERIAL" ; config_module
config="CONFIG_USB_U_ETHER" ; config_module
config="CONFIG_USB_F_SERIAL" ; config_module
config="CONFIG_USB_F_OBEX" ; config_module
config="CONFIG_USB_F_NCM" ; config_module
config="CONFIG_USB_F_ECM" ; config_module
config="CONFIG_USB_F_PHONET" ; config_module
config="CONFIG_USB_F_SUBSET" ; config_module
config="CONFIG_USB_F_RNDIS" ; config_module
config="CONFIG_USB_F_MASS_STORAGE" ; config_module
config="CONFIG_USB_F_FS" ; config_module
config="CONFIG_USB_CONFIGFS" ; config_module
config="CONFIG_USB_CONFIGFS_SERIAL" ; config_enable
config="CONFIG_USB_CONFIGFS_ACM" ; config_enable
config="CONFIG_USB_CONFIGFS_OBEX" ; config_enable
config="CONFIG_USB_CONFIGFS_NCM" ; config_enable
config="CONFIG_USB_CONFIGFS_ECM" ; config_enable
config="CONFIG_USB_CONFIGFS_ECM_SUBSET" ; config_enable
config="CONFIG_USB_CONFIGFS_RNDIS" ; config_enable
config="CONFIG_USB_CONFIGFS_PHONET" ; config_disable
config="CONFIG_USB_CONFIGFS_MASS_STORAGE" ; config_disable
config="CONFIG_USB_CONFIGFS_F_LB_SS" ; config_disable
config="CONFIG_USB_CONFIGFS_F_FS" ; config_disable
config="CONFIG_USB_ZERO" ; config_module
config="CONFIG_USB_AUDIO" ; config_module
config="CONFIG_GADGET_UAC1" ; config_disable
config="CONFIG_USB_ETH" ; config_module
config="CONFIG_USB_ETH_RNDIS" ; config_enable
config="CONFIG_USB_ETH_EEM" ; config_disable
config="CONFIG_USB_G_NCM" ; config_module
config="CONFIG_USB_GADGETFS" ; config_module
config="CONFIG_USB_FUNCTIONFS" ; config_module
config="CONFIG_USB_FUNCTIONFS_ETH" ; config_enable
config="CONFIG_USB_FUNCTIONFS_RNDIS" ; config_enable
config="CONFIG_USB_FUNCTIONFS_GENERIC" ; config_enable
config="CONFIG_USB_MASS_STORAGE" ; config_module
config="CONFIG_USB_GADGET_TARGET" ; config_disable
config="CONFIG_USB_G_SERIAL" ; config_module
config="CONFIG_USB_MIDI_GADGET" ; config_module
config="CONFIG_USB_G_PRINTER" ; config_module
config="CONFIG_USB_CDC_COMPOSITE" ; config_module
config="CONFIG_USB_G_NOKIA" ; config_module
config="CONFIG_USB_G_ACM_MS" ; config_module
config="CONFIG_USB_G_MULTI" ; config_module
config="CONFIG_USB_G_MULTI_RNDIS" ; config_enable
config="CONFIG_USB_G_MULTI_CDC" ; config_disable
config="CONFIG_USB_G_HID" ; config_module
config="CONFIG_USB_G_DBGP" ; config_module
config="CONFIG_USB_G_DBGP_PRINTK" ; config_disable
config="CONFIG_USB_G_DBGP_SERIAL" ; config_enable
config="CONFIG_USB_G_WEBCAM" ; config_disable

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_OMAP" ; config_enable

#
# Graphics support
#
config="CONFIG_DRM_EXYNOS" ; config_disable
config="CONFIG_DRM_OMAP" ; config_disable
config="CONFIG_DRM_IMX" ; config_disable
config="CONFIG_DRM_ETNAVIV" ; config_disable

#breaks tilcd + tfp410...
config="CONFIG_OMAP2_DSS" ; config_disable

#capes:
config="CONFIG_CAPE_BONE_ARGUS" ; config_enable
config="CONFIG_BEAGLEBONE_PINMUX_HELPER" ; config_enable

#Reset Controller:
config="CONFIG_STMMAC_ETH" ; config_disable
config="CONFIG_RESET_CONTROLLER" ; config_disable

#
# FPGA Configuration Support
#
config="CONFIG_FPGA" ; config_disable
config="CONFIG_FPGA_MGR_SOCFPGA" ; config_disable

#overlay bugs...

#These have to be modules, to work...
config="CONFIG_DRM_I2C_NXP_TDA998X" ; config_module
config="CONFIG_DRM_TILCDC" ; config_module
config="CONFIG_DRM_UDL" ; config_module
config="CONFIG_BACKLIGHT_PWM" ; config_module
config="CONFIG_BACKLIGHT_GPIO" ; config_module
config="CONFIG_LEDS_GPIO" ; config_module

#
# Pin controllers
#
config="CONFIG_GPIO_OF_HELPER" ; config_enable

#
