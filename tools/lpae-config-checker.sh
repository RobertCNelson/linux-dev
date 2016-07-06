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

#http://anonscm.debian.org/viewvc/kernel/dists/trunk/linux/debian/config/armhf/config.lpae?view=markup

##
## file: arch/arm/Kconfig
##
CONFIG_ARM_DMA_IOMMU_ALIGNMENT=8

##
## file: arch/arm/kvm/Kconfig
##
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y

##
## file: arch/arm/mm/Kconfig
##
CONFIG_ARM_LPAE=y

##
## file: drivers/iommu/Kconfig
##
CONFIG_ARM_SMMU=y

config="CONFIG_ARM_DMA_IOMMU_ALIGNMENT" ; option="8" ; config_value
config="CONFIG_VIRTUALIZATION" ; config_enable
config="CONFIG_KVM" ; config_enable
config="CONFIG_ARM_LPAE" ; config_enable
config="CONFIG_ARM_SMMU" ; config_enable

###############

#
# CPU Core family selection
#
config="CONFIG_ARCH_MXC" ; config_disable

#
# OMAP Feature Selections
#
config="CONFIG_ARCH_OMAP3" ; config_disable
config="CONFIG_ARCH_OMAP4" ; config_disable
config="CONFIG_SOC_AM33XX" ; config_disable
config="CONFIG_SOC_AM43XX" ; config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_ARCH_SOCFPGA" ; config_disable
config="CONFIG_ARCH_EXYNOS" ; config_enable
config="CONFIG_ARCH_EXYNOS3" ; config_enable
config="CONFIG_ARCH_EXYNOS4" ; config_disable
config="CONFIG_ARCH_EXYNOS5" ; config_enable
config="CONFIG_MACH_SUN4I" ; config_disable
config="CONFIG_MACH_SUN5I" ; config_disable
config="CONFIG_ARCH_ZYNQ" ; config_disable

#
# Processor Features
#
config="CONFIG_ARM_ERRATA_430973" ; config_disable

#
# Kernel Features
#
config="CONFIG_THUMB2_KERNEL" ; config_enable

#
# ARM CPU Idle Drivers
#
config="CONFIG_ARM_EXYNOS_CPUIDLE" ; config_enable
config="CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED" ; config_enable

#
# Generic Driver Options
#
config="CONFIG_FIRMWARE_IN_KERNEL" ; config_disable
config="CONFIG_EXTRA_FIRMWARE" ; option="" ; config_string
config="CONFIG_CMA_SIZE_MBYTES" ; option=64 ; config_value

#
# Distributed Switch Architecture drivers
#
config="CONFIG_R8169" ; config_enable

#
# Serial drivers
#
config="CONFIG_SERIAL_8250_OMAP" ; config_enable
config="CONFIG_SERIAL_8250_OMAP_TTYO_FIXUP" ; config_enable

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_SAMSUNG" ; config_enable
config="CONFIG_SERIAL_SAMSUNG_CONSOLE" ; config_enable
config="CONFIG_SERIAL_OMAP" ; config_disable
config="CONFIG_SERIAL_XILINX_PS_UART" ; config_disable

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
config="CONFIG_I2C_S3C2410" ; config_enable

#
# SPI Master Controller Drivers
#
config="CONFIG_SPI_S3C64XX" ; config_module

#
# Argus cape driver for beaglebone black
#
config="CONFIG_CAPE_BONE_ARGUS" ; config_disable

#
# Graphics support
#
config="CONFIG_IMX_IPUV3_CORE" ; config_disable

config="CONFIG_DRM_TILCDC" ; config_disable
config="CONFIG_DRM_IMX" ; config_disable
config="CONFIG_DRM_ETNAVIV" ; config_disable
config="CONFIG_DRM_NOUVEAU" ; config_module

#
# USB Host Controller Drivers
#
config="CONFIG_USB_EHCI_EXYNOS" ; config_enable

#
# MMC/SD/SDIO Host Controller Drivers
#
config="CONFIG_MMC_DW_EXYNOS" ; config_enable

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_S3C" ; config_enable

#
# Generic IOMMU Pagetable Support
#
config="CONFIG_EXYNOS_IOMMU" ; config_enable

#
# Analog to digital converters
#
config="CONFIG_EXYNOS_ADC" ; config_module

#
# Temperature sensors
#
config="CONFIG_PWM_SAMSUNG" ; config_module

#
# PHY Subsystem
#
config="CONFIG_TI_PIPE3" ; config_enable

#
# Random Number Generation
#
config="CONFIG_CRYPTO_DEV_S5P" ; config_module

#
# FPGA Configuration Support
#
config="CONFIG_FPGA" ; config_disable
config="CONFIG_FPGA_MGR_SOCFPGA" ; config_disable

#
# DEVFREQ Drivers
#
config="CONFIG_ARM_EXYNOS_BUS_DEVFREQ" ; config_enable
config="CONFIG_PM_DEVFREQ_EVENT" ; config_enable
config="CONFIG_DEVFREQ_EVENT_EXYNOS_NOCP" ; config_enable
#
