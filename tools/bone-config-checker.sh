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

config_module_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=m"
		sed -i -e 's:# '$config' is not set:'$config'=m:g' .config
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
# Distributed Switch Architecture drivers
#
config="CONFIG_NET_DSA_MV88E6XXX" ; config_disable
config="CONFIG_NET_VENDOR_ALACRITECH" ; config_disable
config="CONFIG_NET_VENDOR_AMAZON" ; config_disable
config="CONFIG_NET_VENDOR_AQUANTIA" ; config_disable
config="CONFIG_NET_CADENCE" ; config_disable
config="CONFIG_NET_VENDOR_BROADCOM" ; config_disable
config="CONFIG_NET_VENDOR_CIRRUS" ; config_disable
config="CONFIG_NET_VENDOR_EZCHIP" ; config_disable
config="CONFIG_NET_VENDOR_FARADAY" ; config_disable
config="CONFIG_NET_VENDOR_HISILICON" ; config_disable
config="CONFIG_NET_VENDOR_INTEL" ; config_disable
config="CONFIG_NET_VENDOR_I825XX" ; config_disable
config="CONFIG_NET_VENDOR_MARVELL" ; config_disable
config="CONFIG_NET_VENDOR_QUALCOMM" ; config_disable
config="CONFIG_NET_VENDOR_NETRONOME" ; config_disable
config="CONFIG_NET_VENDOR_8390" ; config_disable
config="CONFIG_NET_VENDOR_RENESAS" ; config_disable
config="CONFIG_NET_VENDOR_ROCKER" ; config_disable
config="CONFIG_NET_VENDOR_SAMSUNG" ; config_disable
config="CONFIG_STMMAC_ETH" ; config_disable
config="CONFIG_NET_VENDOR_VIA" ; config_disable

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
config="CONFIG_USB_DWC3" ; config_disable
config="CONFIG_USB_DWC2" ; config_disable
config="CONFIG_USB_DWC3_DUAL_ROLE" ; config_disable

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
config="CONFIG_USB_CHIPIDEA" ; config_disable

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

#
# Display Interface Bridges
#
config="CONFIG_DRM_DUMB_VGA_DAC" ; config_disable
config="CONFIG_DRM_MXS" ; config_disable
config="CONFIG_DRM_MXSFB" ; config_disable

#
# USB Peripheral Controller
#
config="CONFIG_USB_ZERO" ; config_module
config="CONFIG_USB_AUDIO" ; config_module
config="CONFIG_GADGET_UAC1" ; config_disable
config="CONFIG_USB_ETH" ; config_module
config="CONFIG_USB_ETH_RNDIS" ; config_enable
config="CONFIG_USB_ETH_EEM" ; config_disable
config="CONFIG_USB_G_NCM" ; config_module
config="CONFIG_USB_MASS_STORAGE" ; config_module
config="CONFIG_USB_MIDI_GADGET" ; config_module
config="CONFIG_USB_G_PRINTER" ; config_module
config="CONFIG_USB_CDC_COMPOSITE" ; config_module
config="CONFIG_USB_G_ACM_MS" ; config_module
config="CONFIG_USB_G_MULTI" ; config_module
config="CONFIG_USB_G_MULTI_RNDIS" ; config_enable
config="CONFIG_USB_G_MULTI_CDC" ; config_disable
config="CONFIG_USB_G_HID" ; config_module
config="CONFIG_USB_G_DBGP" ; config_module
config="CONFIG_USB_G_DBGP_PRINTK" ; config_disable
config="CONFIG_USB_G_DBGP_SERIAL" ; config_enable

#capes:
config="CONFIG_CAPE_BONE_ARGUS" ; config_enable
config="CONFIG_BEAGLEBONE_PINMUX_HELPER" ; config_enable

#Reset Controller:
config="CONFIG_STMMAC_ETH" ; config_disable
config="CONFIG_RESET_CONTROLLER" ; config_disable

#
# DMA Devices
#
config="CONFIG_FSL_EDMA" ; config_disable

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
