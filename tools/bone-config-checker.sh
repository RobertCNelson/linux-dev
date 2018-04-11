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

config_enable_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:# '$config' is not set:'$config'=y:g' .config
	fi
	if [ "x${test_module}" = "x${config}=m" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:'$config'=m:'$config'=y:g' .config
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
# CPU Core family selection
#
config="CONFIG_ARCH_MXC" ; config_disable

#
# TI OMAP/AM/DM/DRA Family
#
config="CONFIG_ARCH_OMAP3" ; config_disable
config="CONFIG_ARCH_OMAP4" ; config_disable
config="CONFIG_SOC_OMAP5" ; config_disable
config="CONFIG_SOC_AM43XX" ; config_disable
config="CONFIG_SOC_DRA7XX" ; config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_ARCH_ROCKCHIP" ; config_disable
config="CONFIG_ARCH_EXYNOS" ; config_disable
config="CONFIG_ARCH_SOCFPGA" ; config_disable
config="CONFIG_ARCH_SUNXI" ; config_disable
config="CONFIG_ARCH_TEGRA" ; config_disable

#
# Processor Features
#
config="CONFIG_PL310_ERRATA_769419" ; config_disable

#these errata are not needed on am335x
config="CONFIG_ARM_ERRATA_430973" ; config_disable
config="CONFIG_ARM_ERRATA_720789" ; config_disable
config="CONFIG_ARM_ERRATA_754322" ; config_disable
config="CONFIG_ARM_ERRATA_775420" ; config_disable

#
# Kernel Features
#
config="CONFIG_SMP" ; config_disable

#broken in gcc/as...sid/stretch...
#config="CONFIG_THUMB2_KERNEL" ; config_enable

#
# VOP Driver
#
config="CONFIG_BEAGLEBONE_PINMUX_HELPER" ; config_enable

#
# Distributed Switch Architecture drivers
#
config="CONFIG_B53" ; config_disable
config="CONFIG_NET_DSA_BCM_SF2" ; config_disable
config="CONFIG_NET_DSA_MV88E6060" ; config_disable
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
config="CONFIG_NET_VENDOR_HUAWEI" ; config_disable
config="CONFIG_NET_VENDOR_INTEL" ; config_disable
config="CONFIG_NET_VENDOR_MARVELL" ; config_disable
config="CONFIG_NET_VENDOR_MELLANOX" ; config_disable
config="CONFIG_NET_VENDOR_NETRONOME" ; config_disable
config="CONFIG_NET_VENDOR_NATSEMI" ; config_disable
config="CONFIG_NET_VENDOR_8390" ; config_disable
config="CONFIG_NET_VENDOR_QUALCOMM" ; config_disable
config="CONFIG_NET_VENDOR_RENESAS" ; config_disable
config="CONFIG_NET_VENDOR_ROCKER" ; config_disable
config="CONFIG_NET_VENDOR_SAMSUNG" ; config_disable
config="CONFIG_NET_VENDOR_SEEQ" ; config_disable
config="CONFIG_NET_VENDOR_SOLARFLARE" ; config_disable
config="CONFIG_NET_VENDOR_STMICRO" ; config_disable
config="CONFIG_NET_VENDOR_VIA" ; config_disable
config="CONFIG_NET_VENDOR_SYNOPSYS" ; config_disable
config="CONFIG_MDIO_BCM_UNIMAC" ; config_disable

#
# MII PHY device drivers
#
config="CONFIG_AMD_PHY" ; config_disable
config="CONFIG_AQUANTIA_PHY" ; config_disable
config="CONFIG_AT803X_PHY" ; config_disable
config="CONFIG_BCM7XXX_PHY" ; config_disable
config="CONFIG_BCM87XX_PHY" ; config_disable
config="CONFIG_BROADCOM_PHY" ; config_disable
config="CONFIG_CICADA_PHY" ; config_disable
config="CONFIG_DAVICOM_PHY" ; config_disable
config="CONFIG_ICPLUS_PHY" ; config_disable
config="CONFIG_LSI_ET1011C_PHY" ; config_disable
config="CONFIG_LXT_PHY" ; config_disable
config="CONFIG_MARVELL_PHY" ; config_disable
config="CONFIG_NATIONAL_PHY" ; config_disable
config="CONFIG_QSEMI_PHY" ; config_disable
config="CONFIG_REALTEK_PHY" ; config_disable
config="CONFIG_STE10XP" ; config_disable
config="CONFIG_TERANETICS_PHY" ; config_disable

#
# Input Device Drivers
#
config="CONFIG_TOUCHSCREEN_EDT_FT5X06" ; config_enable
config="CONFIG_TOUCHSCREEN_TI_AM335X_TSC" ; config_enable
config="CONFIG_TOUCHSCREEN_AR1021_I2C" ; config_enable

#
# Hardware I/O ports
#
config="CONFIG_SERIO_LIBPS2" ; config_disable

#
# Serial drivers
#
config="CONFIG_SERIAL_8250_DEPRECATED_OPTIONS" ; config_disable
config="CONFIG_SERIAL_8250_FSL" ; config_disable
config="CONFIG_SERIAL_8250_DW" ; config_disable
config="CONFIG_SERIAL_8250_DMA" ; config_disable
config="CONFIG_SERIAL_8250_OMAP" ; config_enable
config="CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP" ; config_enable

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_FSL_LPUART" ; config_disable

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
config="CONFIG_I2C_RK3X" ; config_disable

#
# AX.25 network device drivers
#
config="CONFIG_CAN" ; config_enable

#
# CAN Device Drivers
#
config="CONFIG_CAN_DEV" ; config_enable
config="CONFIG_CAN_C_CAN" ; config_enable
config="CONFIG_CAN_C_CAN_PLATFORM" ; config_enable

#
# SPI Master Controller Drivers
#
config="CONFIG_SPI_DLN2" ; config_disable
config="CONFIG_SPI_TI_QSPI" ; config_disable
config="CONFIG_SPI_ROCKCHIP" ; config_disable

#
# Pin controllers
#
config="CONFIG_PINCTRL_AS3722" ; config_disable
config="CONFIG_PINCTRL_SX150X" ; config_disable
config="CONFIG_PINCTRL_PALMAS" ; config_disable
config="CONFIG_GPIO_OF_HELPER" ; config_enable

#
# Memory mapped GPIO drivers
#
config="CONFIG_GPIO_AXP209" ; config_disable

#
# I2C GPIO expanders
#
config="CONFIG_GPIO_SX150X" ; config_disable

#
# 1-wire Slaves
#
config="CONFIG_POWER_RESET_AS3722" ; config_disable
config="CONFIG_BATTERY_SBS" ; config_disable
config="CONFIG_BATTERY_BQ27XXX" ; config_disable
config="CONFIG_BATTERY_DA9052" ; config_disable
config="CONFIG_AXP20X_POWER" ; config_disable
config="CONFIG_AXP288_FUEL_GAUGE" ; config_disable
config="CONFIG_BATTERY_TWL4030_MADC" ; config_disable
config="CONFIG_BATTERY_RX51" ; config_disable
config="CONFIG_CHARGER_ISP1704" ; config_disable
config="CONFIG_CHARGER_TWL4030" ; config_disable
config="CONFIG_CHARGER_BQ2415X" ; config_disable

#broken...
config="CONFIG_CHARGER_TPS65217" ; config_disable

#
# Watchdog Device Drivers
#
config="CONFIG_SOFT_WATCHDOG" ; config_enable
config="CONFIG_OMAP_WATCHDOG" ; config_enable
config="CONFIG_DA9052_WATCHDOG" ; config_disable
config="CONFIG_DW_WATCHDOG" ; config_disable
config="CONFIG_TWL4030_WATCHDOG" ; config_disable

#
# Multifunction device drivers
#
config="CONFIG_MFD_AS3722" ; config_disable
config="CONFIG_MFD_AXP20X_I2C" ; config_disable
config="CONFIG_MFD_DA9052_SPI" ; config_disable
config="CONFIG_MFD_DA9052_I2C" ; config_disable
config="CONFIG_MFD_DA9055" ; config_disable
config="CONFIG_MFD_DA9063" ; config_disable
config="CONFIG_MFD_DLN2" ; config_disable
config="CONFIG_MFD_MC13XXX_SPI" ; config_disable
config="CONFIG_MFD_MC13XXX_I2C" ; config_disable
config="CONFIG_MFD_MAX77686" ; config_disable
config="CONFIG_MFD_RK808" ; config_disable
config="CONFIG_MFD_SEC_CORE" ; config_disable
config="CONFIG_MFD_STMPE" ; config_disable
config="CONFIG_MFD_TI_AM335X_TSCADC" ; config_enable
config="CONFIG_MFD_PALMAS" ; config_disable
config="CONFIG_MFD_TPS65218" ; config_disable
config="CONFIG_MFD_TPS65910" ; config_disable
config="CONFIG_TWL4030_CORE" ; config_disable
config="CONFIG_TWL6040_CORE" ; config_disable

#REGULATOR
config="CONFIG_REGULATOR_ACT8865" ; config_disable
config="CONFIG_REGULATOR_AD5398" ; config_disable
config="CONFIG_REGULATOR_ANATOP" ; config_disable
config="CONFIG_REGULATOR_DA9210" ; config_disable
config="CONFIG_REGULATOR_DA9211" ; config_disable
config="CONFIG_REGULATOR_FAN53555" ; config_disable
config="CONFIG_REGULATOR_MT6311" ; config_disable
config="CONFIG_REGULATOR_PFUZE100" ; config_disable
config="CONFIG_REGULATOR_TPS51632" ; config_disable
config="CONFIG_REGULATOR_TPS62360" ; config_disable
config="CONFIG_REGULATOR_TPS65023" ; config_disable
config="CONFIG_REGULATOR_TPS6507X" ; config_disable
config="CONFIG_REGULATOR_TPS65218" ; config_disable
config="CONFIG_REGULATOR_TPS6524X" ; config_disable

#
# Misc devices
#
config="CONFIG_ENCLOSURE_SERVICES" ; config_disable
config="CONFIG_TIEQEP" ; config_enable

#
# Generic fallback / legacy drivers
#
config="CONFIG_MD_RAID456" ; config_disable
config="CONFIG_DM_RAID" ; config_disable

#
# Graphics support
#
config="CONFIG_DRM_EXYNOS" ; config_disable
config="CONFIG_DRM_OMAP" ; config_disable
config="CONFIG_DRM_IMX" ; config_disable
config="CONFIG_IMX_IPUV3_CORE" ; config_disable
config="CONFIG_DRM_DUMB_VGA_DAC" ; config_disable
config="CONFIG_DRM_ETNAVIV" ; config_disable
config="CONFIG_DRM_MXS" ; config_disable
config="CONFIG_DRM_MXSFB" ; config_disable
config="CONFIG_DRM_VIRTIO_GPU" ; config_disable

#breaks tilcd + tfp410...
config="CONFIG_OMAP2_DSS" ; config_disable
config="CONFIG_DRM_PANEL_SIMPLE" ; config_enable

#
# I2C encoder or helper chips
#
config="CONFIG_DRM_I2C_ADIHDMI" ; config_enable
config="CONFIG_DRM_I2C_NXP_TDA998X" ; config_enable

#
# Console display driver support
#
config="CONFIG_SOUND" ; config_enable
config="CONFIG_SND" ; config_enable
config="CONFIG_SND_TIMER" ; config_enable
config="CONFIG_SND_PCM" ; config_enable
config="CONFIG_SND_DMAENGINE_PCM" ; config_enable

#
# HD-Audio
#
config="CONFIG_SND_SOC" ; config_enable
config="CONFIG_SND_EDMA_SOC" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_I2S" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_MCASP" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_GENERIC_EVM" ; config_enable
config="CONFIG_SND_AM33XX_SOC_EVM" ; config_enable

#
# Common SoC Audio options for Freescale CPUs:
#
config="CONFIG_SND_SOC_FSL_SSI" ; config_disable
config="CONFIG_SND_SOC_FSL_SPDIF" ; config_disable
config="CONFIG_SND_SOC_IMX_AUDMUX" ; config_disable

config="CONFIG_SND_OMAP_SOC" ; config_enable
config="CONFIG_SND_OMAP_SOC_HDMI_AUDIO" ; config_disable
config="CONFIG_SND_OMAP_SOC_RX51" ; config_disable

#
# CODEC drivers
#
config="CONFIG_SND_SIMPLE_CARD_UTILS" ; config_enable
config="CONFIG_SND_SIMPLE_CARD" ; config_enable

#
# Miscellaneous USB options
#
#http://bugs.elinux.org/issues/127
#2017.10.20 re-enable...
config="CONFIG_USB_OTG" ; config_enable

#
# USB Host Controller Drivers
#
config="CONFIG_USB_XHCI_HCD" ; config_disable
config="CONFIG_USB_U132_HCD" ; config_disable

#
# Platform Glue Layer
#
config="CONFIG_USB_MUSB_TUSB6010" ; config_disable
config="CONFIG_USB_MUSB_OMAP2PLUS" ; config_disable
config="CONFIG_USB_MUSB_AM35X" ; config_disable
config="CONFIG_USB_MUSB_DSPS" ; config_enable
config="CONFIG_USB_MUSB_UX500" ; config_disable

#
# MUSB DMA mode
#
config="CONFIG_MUSB_PIO_ONLY" ; config_disable
config="CONFIG_USB_TI_CPPI41_DMA" ; config_enable
config="CONFIG_USB_DWC3" ; config_disable
config="CONFIG_USB_DWC3_OMAP" ; config_disable
config="CONFIG_USB_DWC3_OF_SIMPLE" ; config_disable
config="CONFIG_USB_DWC2" ; config_disable

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
config="CONFIG_USB_CHIPIDEA" ; config_disable

#
# USB Peripheral Controller
#
config="CONFIG_USB_ZERO" ; config_module
config="CONFIG_USB_AUDIO" ; config_module
config="CONFIG_GADGET_UAC1" ; config_disable
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

#
# MMC/SD/SDIO Host Controller Drivers
#
config="CONFIG_MMC_SDHCI" ; config_disable
config="CONFIG_MMC_SDHCI_PLTFM" ; config_disable
config="CONFIG_MMC_SDHCI_OF_ARASAN" ; config_disable
config="CONFIG_MMC_DW" ; config_disable
config="CONFIG_MMC_CQHCI" ; config_disable
config="CONFIG_MEMSTICK" ; config_disable

#
# MemoryStick drivers
#
config="CONFIG_MSPRO_BLOCK" ; config_disable

#
# LED drivers
#
config="CONFIG_LEDS_GPIO" ; config_enable

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_SNVS" ; config_disable
config="CONFIG_RTC_DRV_R7301" ; config_disable

#
# DMA Devices
#
config="CONFIG_FSL_EDMA" ; config_disable
config="CONFIG_DW_DMAC_CORE" ; config_disable
config="CONFIG_DW_DMAC" ; config_disable

#
# Qualcomm SoC drivers
#
config="CONFIG_SUNXI_SRAM" ; config_disable

#
# Analog to digital converters
#
config="CONFIG_TI_AM335X_ADC" ; config_enable
config="CONFIG_VF610_ADC" ; config_disable

#
# Temperature sensors
#
config="CONFIG_PWM_OMAP_DMTIMER" ; config_enable
config="CONFIG_PWM_TIECAP" ; config_enable
config="CONFIG_PWM_TIEHRPWM" ; config_enable
config="CONFIG_RESET_IMX7" ; config_disable
config="CONFIG_RESET_SUNXI" ; config_disable

config="CONFIG_EXOFS_FS" ; config_disable

#
# Common Clock Framework
#
config="CONFIG_COMMON_CLK_SI5351" ; config_disable

exit

CONFIG_MSPRO_BLOCK:
CONFIG_LEDS_BCM6328:

exit
exit


#
# Native drivers
#
config="CONFIG_IMX_THERMAL" ; config_disable



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

#U-boot Overlays
config="CONFIG_BACKLIGHT_PWM" ; config_enable
config="CONFIG_BACKLIGHT_PANDORA" ; config_disable
config="CONFIG_BACKLIGHT_GPIO" ; config_enable

#
# Pin controllers
#
config="CONFIG_GPIO_OF_HELPER" ; config_enable

#u-boot overlays
config="CONFIG_MFD_TI_AM335X_TSCADC" ; config_enable
config="CONFIG_TOUCHSCREEN_TI_AM335X_TSC" ; config_enable
config="CONFIG_PWM_TIECAP" ; config_enable
config="CONFIG_PWM_TIEHRPWM" ; config_enable

#dont have...
config="CONFIG_AXP20X_ADC" ; config_disable
config="CONFIG_AXP288_ADC" ; config_disable
config="CONFIG_TWL4030_MADC" ; config_disable
config="CONFIG_TWL6030_GPADC" ; config_disable

config="CONFIG_VIPERBOARD_ADC" ; config_disable
config="CONFIG_AXP20X_POWER" ; config_disable

#
