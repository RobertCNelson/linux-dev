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
config="CONFIG_USELIB"
check_config_builtin

#
# RCU Subsystem
#
config="CONFIG_IKCONFIG"
check_config_builtin
config="CONFIG_IKCONFIG_PROC"
check_config_builtin
config="CONFIG_LOG_BUF_SHIFT"
value="18"
check_config_value
config="CONFIG_SYSFS_SYSCALL"
check_config_builtin
config="CONFIG_SYSCTL_SYSCALL"
check_config_builtin
config="CONFIG_KALLSYMS_ALL"
check_config_builtin
config="CONFIG_EMBEDDED"
check_config_builtin

#
# Kernel Performance Events And Counters
#
config="CONFIG_OPROFILE"
check_config_builtin
config="CONFIG_SECCOMP_FILTER"
check_config_builtin

#
# CPU Core family selection
#
config="CONFIG_ARCH_VIRT"
check_config_disable
config="CONFIG_ARCH_MVEBU"
check_config_disable
config="CONFIG_ARCH_HIGHBANK"
check_config_disable

#
# Device tree only
#
config="CONFIG_SOC_IMX50"
check_config_builtin
config="CONFIG_SOC_IMX6SL"
check_config_builtin
config="CONFIG_SOC_IMX6SX"
check_config_builtin
config="CONFIG_SOC_VF610"
check_config_builtin
config="CONFIG_WAND_RFKILL"
check_config_builtin

#
# OMAP Feature Selections
#
config="CONFIG_POWER_AVS_OMAP"
check_config_builtin
config="CONFIG_POWER_AVS_OMAP_CLASS3"
check_config_builtin
config="CONFIG_OMAP_MUX_DEBUG"
check_config_builtin
config="CONFIG_SOC_AM43XX"
check_config_builtin
config="CONFIG_SOC_DRA7XX"
check_config_builtin

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_MACH_OMAP3_BEAGLE"
check_config_disable
config="CONFIG_MACH_DEVKIT8000"
check_config_disable
config="CONFIG_MACH_OMAP_LDP"
check_config_disable
config="CONFIG_MACH_OMAP3530_LV_SOM"
check_config_disable
config="CONFIG_MACH_OMAP3_TORPEDO"
check_config_disable
config="CONFIG_MACH_OVERO"
check_config_disable
config="CONFIG_MACH_OMAP3517EVM"
check_config_disable
config="CONFIG_MACH_OMAP3_PANDORA"
check_config_disable
config="CONFIG_MACH_TOUCHBOOK"
check_config_disable
config="CONFIG_MACH_OMAP_3430SDP"
check_config_disable
config="CONFIG_MACH_NOKIA_RX51"
check_config_disable
config="CONFIG_MACH_CM_T35"
check_config_disable
config="CONFIG_MACH_CM_T3517"
check_config_disable
config="CONFIG_MACH_SBC3530"
check_config_disable
config="CONFIG_MACH_TI8168EVM"
check_config_disable
config="CONFIG_MACH_TI8148EVM"
check_config_disable
config="CONFIG_ARCH_SOCFPGA"
check_config_disable
config="CONFIG_ARCH_EXYNOS"
check_config_disable
config="CONFIG_ARCH_TEGRA"
check_config_builtin
config="CONFIG_ARCH_TEGRA_124_SOC"
check_config_builtin
config="CONFIG_TEGRA_AHB"
check_config_builtin
config="CONFIG_ARCH_VEXPRESS"
check_config_disable
config="CONFIG_ARCH_WM8850"
check_config_disable

#
# Processor Features
#
config="CONFIG_ARM_ERRATA_430973"
check_config_builtin
config="CONFIG_PL310_ERRATA_753970"
check_config_disable

#
# Bus support
#
config="CONFIG_PCI"
check_config_disable
config="CONFIG_PCI_SYSCALL"
check_config_disable

#first check..
#exit

#
# Kernel Features
#
config="CONFIG_HZ_100"
check_config_builtin
config="CONFIG_HZ_250"
check_config_disable
config="CONFIG_HIGHPTE"
check_config_builtin
config="CONFIG_MEMORY_ISOLATION"
check_config_builtin
config="CONFIG_CMA"
check_config_builtin
config="CONFIG_CMA_DEBUG"
check_config_disable
config="CONFIG_SECCOMP"
check_config_builtin
config="CONFIG_XEN"
check_config_disable

#
# Boot options
#
config="CONFIG_ARM_APPENDED_DTB"
check_config_disable

#
# CPU Frequency scaling
#
config="CONFIG_CPU_FREQ_STAT"
check_config_builtin
config="CONFIG_CPU_FREQ_STAT_DETAILS"
check_config_builtin
config="CONFIG_CPU_FREQ_GOV_POWERSAVE"
check_config_builtin
config="CONFIG_CPU_FREQ_GOV_USERSPACE"
check_config_builtin
config="CONFIG_CPU_FREQ_GOV_ONDEMAND"
check_config_builtin
config="CONFIG_CPU_FREQ_GOV_CONSERVATIVE"
check_config_builtin
config="CONFIG_CPUFREQ_DT"
check_config_builtin

#
# ARM CPU frequency scaling drivers
#
config="CONFIG_ARM_IMX6Q_CPUFREQ"
check_config_builtin
config="CONFIG_ARM_OMAP2PLUS_CPUFREQ"
check_config_disable

#
# CPU Idle
#
config="CONFIG_CPU_IDLE"
check_config_builtin
config="CONFIG_CPU_IDLE_GOV_LADDER"
check_config_builtin
config="CONFIG_CPU_IDLE_GOV_MENU"
check_config_builtin

#
# At least one emulation must be selected
#
config="CONFIG_KERNEL_MODE_NEON"
check_config_builtin

#
# Power management options
#
config="CONFIG_PM_AUTOSLEEP"
check_config_builtin
config="CONFIG_PM_WAKELOCKS"
check_config_builtin
config="CONFIG_PM_WAKELOCKS_GC"
check_config_builtin

#
# Networking options
#
config="CONFIG_IP_PNP"
check_config_builtin
config="CONFIG_IP_PNP_DHCP"
check_config_builtin
config="CONFIG_IP_PNP_BOOTP"
check_config_builtin
config="CONFIG_IP_PNP_RARP"
check_config_builtin
config="CONFIG_NET_FOU"
check_config_module
config="CONFIG_GENEVE"
check_config_module
config="CONFIG_TCP_CONG_DCTCP"
check_config_module
config="CONFIG_NETLABEL"
check_config_builtin

#
# Core Netfilter Configuration
#
config="CONFIG_NFT_MASQ"
check_config_module

#
# Xtables targets
#
config="CONFIG_NETFILTER_XT_NAT"
check_config_module

#
# Xtables matches
#
config="CONFIG_IP_SET_HASH_MAC"
check_config_module

#
# IPVS scheduler
#
config="CONFIG_IP_VS_FO"
check_config_module

#
# IP: Netfilter Configuration
#
config="CONFIG_NF_LOG_ARP"
check_config_module
config="CONFIG_NF_NAT_MASQUERADE_IPV4"
check_config_module
config="CONFIG_NFT_MASQ_IPV4"
check_config_module
config="CONFIG_IP_NF_NAT"
check_config_module
config="CONFIG_IP_NF_TARGET_MASQUERADE"
check_config_module
config="CONFIG_IP_NF_TARGET_NETMAP"
check_config_module
config="CONFIG_IP_NF_TARGET_REDIRECT"
check_config_module

#
# IPv6: Netfilter Configuration
#
config="CONFIG_NF_NAT_MASQUERADE_IPV6"
check_config_module
config="CONFIG_NFT_MASQ_IPV6"
check_config_module
config="CONFIG_IP6_NF_NAT"
check_config_module
config="CONFIG_IP6_NF_TARGET_MASQUERADE"
check_config_module
config="CONFIG_IP6_NF_TARGET_NPT"
check_config_module
config="CONFIG_NFT_BRIDGE_REJECT"
check_config_module
config="CONFIG_NF_LOG_BRIDGE"
check_config_module

#
# DCCP Kernel Hacking
#
config="CONFIG_6LOWPAN"
check_config_module
config="CONFIG_IEEE802154_6LOWPAN"
check_config_module
config="CONFIG_MAC802154"
check_config_module

#
# Classification
#
config="CONFIG_DNS_RESOLVER"
check_config_builtin
config="CONFIG_HSR"
check_config_module

#
# CAN USB interfaces
#
config="CONFIG_BT_6LOWPAN"
check_config_module

#
# Bluetooth device drivers
#
config="CONFIG_BT_HCIUART"
check_config_module
config="CONFIG_BT_HCIUART_H4"
check_config_builtin
config="CONFIG_BT_HCIUART_BCSP"
check_config_builtin
config="CONFIG_BT_HCIUART_ATH3K"
check_config_builtin
config="CONFIG_BT_HCIUART_LL"
check_config_builtin
config="CONFIG_BT_HCIUART_3WIRE"
check_config_builtin
config="CONFIG_NFC_NCI"
check_config_module
config="CONFIG_NFC_NCI_SPI"
check_config_builtin
config="CONFIG_NFC_HCI"
check_config_module
config="CONFIG_NFC_SHDLC"
check_config_builtin

#
# Near Field Communication (NFC) devices
#
config="CONFIG_NFC_WILINK"
check_config_module
config="CONFIG_NFC_PN544"
check_config_module
config="CONFIG_NFC_PN544_I2C"
check_config_module
config="CONFIG_NFC_MICROREAD"
check_config_module
config="CONFIG_NFC_MICROREAD_I2C"
check_config_module

#
# Generic Driver Options
#
config="CONFIG_DEVTMPFS_MOUNT"
check_config_builtin

#
# Generic Driver Options
#
config="CONFIG_DMA_CMA"
check_config_builtin

#
# Bus devices
#
config="CONFIG_OMAP_OCP2SCP"
check_config_builtin
config="CONFIG_VEXPRESS_CONFIG"
check_config_disable

#
# LPDDR & LPDDR2 PCM memory drivers
#
config="CONFIG_MTD_LPDDR2_NVM"
check_config_module
config="CONFIG_MTD_SPI_NOR_USE_4K_SECTORS"
check_config_builtin
config="CONFIG_SPI_FSL_QUADSPI"
check_config_module

#
# Device Tree and Open Firmware support
#
config="CONFIG_PARPORT"
check_config_disable
config="CONFIG_ZRAM_LZ4_COMPRESS"
check_config_builtin

#
# EEPROM support
#
config="CONFIG_EEPROM_AT24"
check_config_builtin
config="CONFIG_EEPROM_93XX46"
check_config_module
config="CONFIG_EEPROM_SUNXI_SID"
check_config_builtin

#
# Texas Instruments shared transport line discipline
#
config="CONFIG_SENSORS_LIS3_SPI"
check_config_module

#
# Argus cape driver for beaglebone black
#
config="CONFIG_CAPE_BONE_ARGUS"
check_config_builtin
config="CONFIG_BEAGLEBONE_PINMUX_HELPER"
check_config_builtin
#
# SCSI device support
#
config="CONFIG_SCSI_MOD"
check_config_builtin
config="CONFIG_SCSI"
check_config_builtin
config="CONFIG_SCSI_PROC_FS"
check_config_builtin

#
# SCSI support type (disk, tape, CD-ROM)
#
config="CONFIG_BLK_DEV_SD"
check_config_builtin

#
# SCSI Transports
#
config="CONFIG_ATA"
check_config_builtin

#
# Controllers with non-SFF native interface
#
config="CONFIG_SATA_AHCI_PLATFORM"
check_config_builtin
config="CONFIG_AHCI_IMX"
check_config_builtin
config="CONFIG_AHCI_SUNXI"
check_config_builtin
config="CONFIG_AHCI_TEGRA"
check_config_builtin

#
# PATA SFF controllers with BMDMA
#
config="CONFIG_PATA_IMX"
check_config_builtin

#
# PIO-only SFF controllers
#
config="CONFIG_PATA_PLATFORM"
check_config_builtin
config="CONFIG_PATA_OF_PLATFORM"
check_config_builtin

#
# Generic fallback / legacy drivers
#
config="CONFIG_MII"
check_config_builtin

#
# Distributed Switch Architecture drivers
#
config="CONFIG_SUN4I_EMAC"
check_config_builtin
config="CONFIG_MVMDIO"
check_config_disable
config="CONFIG_KS8851"
check_config_module
config="CONFIG_NET_VENDOR_QUALCOMM"
check_config_disable
config="CONFIG_NET_VENDOR_SEEQ"
check_config_builtin
config="CONFIG_SMC91X"
check_config_disable
config="CONFIG_SMC911X"
check_config_disable
config="CONFIG_SMSC911X"
check_config_builtin
config="CONFIG_STMMAC_ETH"
check_config_builtin
config="CONFIG_TI_DAVINCI_EMAC"
check_config_builtin
config="CONFIG_TI_DAVINCI_MDIO"
check_config_builtin
config="CONFIG_TI_DAVINCI_CPDMA"
check_config_builtin
config="CONFIG_TI_CPSW"
check_config_builtin
config="CONFIG_VIA_VELOCITY"
check_config_disable

#
# MII PHY device drivers
#
config="CONFIG_SMSC_PHY"
check_config_builtin

#
# USB Network Adapters
#
config="CONFIG_USB_ZD1201"
check_config_module
config="CONFIG_ATH9K_CHANNEL_CONTEXT"
check_config_builtin
config="CONFIG_WCN36XX"
check_config_module
config="CONFIG_WCN36XX_DEBUGFS"
check_config_disable
config="CONFIG_BRCMDBG"
check_config_builtin
config="CONFIG_LIBERTAS_SPI"
check_config_module
config="CONFIG_MWIFIEX"
check_config_module
config="CONFIG_MWIFIEX_SDIO"
check_config_module
config="CONFIG_MWIFIEX_USB"
check_config_module

#
# WiMAX Wireless Broadband devices
#
config="CONFIG_IEEE802154_FAKELB"
check_config_module
config="CONFIG_IEEE802154_AT86RF230"
check_config_module
config="CONFIG_IEEE802154_MRF24J40"
check_config_module
config="CONFIG_IEEE802154_CC2520"
check_config_module

#
# Input Device Drivers
#
config="CONFIG_KEYBOARD_ADP5589"
check_config_module
config="CONFIG_KEYBOARD_ATKBD"
check_config_module
config="CONFIG_KEYBOARD_QT1070"
check_config_module
config="CONFIG_KEYBOARD_LKKBD"
check_config_module
config="CONFIG_KEYBOARD_GPIO"
check_config_module
config="CONFIG_KEYBOARD_GPIO_POLLED"
check_config_module
config="CONFIG_KEYBOARD_TCA6416"
check_config_module
config="CONFIG_KEYBOARD_TCA8418"
check_config_module
config="CONFIG_KEYBOARD_MATRIX"
check_config_module
config="CONFIG_KEYBOARD_LM8333"
check_config_module
config="CONFIG_KEYBOARD_MCS"
check_config_module
config="CONFIG_KEYBOARD_MPR121"
check_config_module
config="CONFIG_KEYBOARD_NEWTON"
check_config_module
config="CONFIG_KEYBOARD_TEGRA"
check_config_module
config="CONFIG_KEYBOARD_SAMSUNG"
check_config_module
config="CONFIG_KEYBOARD_SUNKBD"
check_config_module
config="CONFIG_KEYBOARD_XTKBD"
check_config_module
config="CONFIG_KEYBOARD_CAP1106"
check_config_module

#exit

config="CONFIG_MOUSE_PS2_TOUCHKIT"
check_config_builtin
config="CONFIG_MOUSE_SERIAL"
check_config_module
config="CONFIG_MOUSE_BCM5974"
check_config_module
config="CONFIG_MOUSE_CYAPA"
check_config_module
config="CONFIG_MOUSE_VSXXXAA"
check_config_module
config="CONFIG_MOUSE_GPIO"
check_config_module

#exit

config="CONFIG_INPUT_JOYSTICK"
check_config_builtin
config="CONFIG_JOYSTICK_ANALOG"
check_config_module
config="CONFIG_JOYSTICK_A3D"
check_config_module
config="CONFIG_JOYSTICK_ADI"
check_config_module
config="CONFIG_JOYSTICK_COBRA"
check_config_module
config="CONFIG_JOYSTICK_GF2K"
check_config_module
config="CONFIG_JOYSTICK_GRIP"
check_config_module
config="CONFIG_JOYSTICK_GRIP_MP"
check_config_module
config="CONFIG_JOYSTICK_GUILLEMOT"
check_config_module
config="CONFIG_JOYSTICK_INTERACT"
check_config_module
config="CONFIG_JOYSTICK_SIDEWINDER"
check_config_module
config="CONFIG_JOYSTICK_TMDC"
check_config_module
config="CONFIG_JOYSTICK_IFORCE"
check_config_module
config="CONFIG_JOYSTICK_IFORCE_USB"
check_config_builtin
config="CONFIG_JOYSTICK_IFORCE_232"
check_config_builtin
config="CONFIG_JOYSTICK_WARRIOR"
check_config_module
config="CONFIG_JOYSTICK_MAGELLAN"
check_config_module
config="CONFIG_JOYSTICK_SPACEORB"
check_config_module
config="CONFIG_JOYSTICK_SPACEBALL"
check_config_module
config="CONFIG_JOYSTICK_STINGER"
check_config_module
config="CONFIG_JOYSTICK_TWIDJOY"
check_config_module
config="CONFIG_JOYSTICK_ZHENHUA"
check_config_module
config="CONFIG_JOYSTICK_AS5011"
check_config_module
config="CONFIG_JOYSTICK_JOYDUMP"
check_config_module
config="CONFIG_JOYSTICK_XPAD"
check_config_module
config="CONFIG_JOYSTICK_XPAD_FF"
check_config_builtin
config="CONFIG_JOYSTICK_XPAD_LEDS"
check_config_builtin
config="CONFIG_TABLET_SERIAL_WACOM4"
check_config_module

#exit

config="CONFIG_TOUCHSCREEN_AD7879_SPI"
check_config_module
config="CONFIG_TOUCHSCREEN_AR1021_I2C"
check_config_module
config="CONFIG_TOUCHSCREEN_AUO_PIXCIR"
check_config_module
config="CONFIG_TOUCHSCREEN_BU21013"
check_config_module
config="CONFIG_TOUCHSCREEN_CY8CTMG110"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_CORE"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_I2C"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP_SPI"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_CORE"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_I2C"
check_config_module
config="CONFIG_TOUCHSCREEN_CYTTSP4_SPI"
check_config_module
config="CONFIG_TOUCHSCREEN_DA9052"
check_config_module
config="CONFIG_TOUCHSCREEN_EETI"
check_config_module
config="CONFIG_TOUCHSCREEN_EGALAX"
check_config_module
config="CONFIG_TOUCHSCREEN_ILI210X"
check_config_module
config="CONFIG_TOUCHSCREEN_WACOM_I2C"
check_config_module
config="CONFIG_TOUCHSCREEN_MAX11801"
check_config_module
config="CONFIG_TOUCHSCREEN_MMS114"
check_config_module
config="CONFIG_TOUCHSCREEN_EDT_FT5X06"
check_config_module
config="CONFIG_TOUCHSCREEN_PIXCIR"
check_config_module
config="CONFIG_TOUCHSCREEN_TSC_SERIO"
check_config_module
config="CONFIG_TOUCHSCREEN_ST1232"
check_config_module
config="CONFIG_TOUCHSCREEN_ZFORCE"
check_config_module

#exit

config="CONFIG_INPUT_AD714X"
check_config_module
config="CONFIG_INPUT_AD714X_I2C"
check_config_module
config="CONFIG_INPUT_AD714X_SPI"
check_config_module
config="CONFIG_INPUT_BMA150"
check_config_module
config="CONFIG_INPUT_MC13783_PWRBUTTON"
check_config_module
config="CONFIG_INPUT_MPU3050"
check_config_module
config="CONFIG_INPUT_GP2A"
check_config_module
config="CONFIG_INPUT_GPIO_TILT_POLLED"
check_config_module
config="CONFIG_INPUT_KXTJ9"
check_config_module
config="CONFIG_INPUT_KXTJ9_POLLED_MODE"
check_config_builtin
config="CONFIG_INPUT_TWL4030_PWRBUTTON"
check_config_builtin
config="CONFIG_INPUT_TWL4030_VIBRA"
check_config_builtin
config="CONFIG_INPUT_TWL6040_VIBRA"
check_config_builtin
config="CONFIG_INPUT_UINPUT"
check_config_builtin
config="CONFIG_INPUT_PALMAS_PWRBUTTON"
check_config_builtin
config="CONFIG_INPUT_PCF8574"
check_config_module
config="CONFIG_INPUT_GPIO_ROTARY_ENCODER"
check_config_module
config="CONFIG_INPUT_DA9052_ONKEY"
check_config_module
config="CONFIG_INPUT_DA9055_ONKEY"
check_config_module
config="CONFIG_INPUT_ADXL34X"
check_config_module
config="CONFIG_INPUT_ADXL34X_I2C"
check_config_module
config="CONFIG_INPUT_ADXL34X_SPI"
check_config_module
config="CONFIG_INPUT_IMS_PCU"
check_config_module
config="CONFIG_INPUT_CMA3000"
check_config_module
config="CONFIG_INPUT_CMA3000_I2C"
check_config_module

config="CONFIG_INPUT_DRV260X_HAPTICS"
check_config_module
config="CONFIG_INPUT_DRV2667_HAPTICS"
check_config_module

#
# Character devices
#
config="CONFIG_DEVKMEM"
check_config_builtin

#
# Non-8250 serial port support
#
config="CONFIG_SERIAL_TEGRA"
check_config_builtin
config="CONFIG_SERIAL_ARC"
check_config_disable
config="CONFIG_SERIAL_FSL_LPUART"
check_config_builtin
config="CONFIG_SERIAL_FSL_LPUART_CONSOLE"
check_config_builtin
config="CONFIG_HW_RANDOM"
check_config_builtin
config="CONFIG_HW_RANDOM_OMAP"
check_config_builtin
config="CONFIG_HW_RANDOM_OMAP3_ROM"
check_config_builtin
config="CONFIG_HW_RANDOM_TPM"
check_config_module
config="CONFIG_TCG_TPM"
check_config_module
config="CONFIG_TCG_TIS_I2C_ATMEL"
check_config_module

#
# I2C support
#
config="CONFIG_I2C_CHARDEV"
check_config_builtin

#
# Multiplexer I2C Chip support
#
config="CONFIG_I2C_MUX_PCA954x"
check_config_builtin

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
config="CONFIG_I2C_IMX"
check_config_builtin
config="CONFIG_I2C_MV64XXX"
check_config_builtin
config="CONFIG_I2C_SUN6I_P2WI"
check_config_builtin
config="CONFIG_I2C_TEGRA"
check_config_builtin

#
# SPI Master Controller Drivers
#
config="CONFIG_SPI_IMX"
check_config_builtin
config="CONFIG_SPI_OMAP24XX"
check_config_builtin
config="CONFIG_SPI_SUN4I"
check_config_builtin
config="CONFIG_SPI_SUN6I"
check_config_builtin
config="CONFIG_SPI_TEGRA114"
check_config_builtin
config="CONFIG_SPI_TEGRA20_SFLASH"
check_config_module
config="CONFIG_SPI_TEGRA20_SLINK"
check_config_module

#
# Pin controllers
#
config="CONFIG_PINCTRL_PALMAS"
check_config_builtin
config="CONFIG_GPIO_DA9052"
check_config_builtin
config="CONFIG_GPIO_DA9055"
check_config_module
config="CONFIG_GPIO_MAX730X"
check_config_module

#
# I2C GPIO expanders:
#
config="CONFIG_GPIO_MAX7300"
check_config_module
config="CONFIG_GPIO_MAX732X"
check_config_module
config="CONFIG_GPIO_PCA953X"
check_config_module
config="CONFIG_GPIO_PCF857X"
check_config_module
config="CONFIG_GPIO_SX150X"
check_config_builtin
config="CONFIG_GPIO_ADP5588"
check_config_module
config="CONFIG_GPIO_ADNP"
check_config_module

#
# SPI GPIO expanders:
#
config="CONFIG_GPIO_MAX7301"
check_config_module
config="CONFIG_GPIO_MCP23S08"
check_config_module
config="CONFIG_GPIO_MC33880"
check_config_module
config="CONFIG_GPIO_74X164"
check_config_module

#
# MODULbus GPIO expanders:
#
config="CONFIG_GPIO_PALMAS"
check_config_builtin
config="CONFIG_GPIO_TPS65910"
check_config_builtin

#
# 1-wire Bus Masters
#
config="CONFIG_W1_MASTER_MXC"
check_config_module
config="CONFIG_W1_MASTER_DS1WM"
check_config_module
config="CONFIG_W1_MASTER_GPIO"
check_config_module
config="CONFIG_HDQ_MASTER_OMAP"
check_config_module

#
# 1-wire Slaves
#
config="CONFIG_W1_SLAVE_DS2408"
check_config_module
config="CONFIG_W1_SLAVE_DS2408_READBACK"
check_config_builtin
config="CONFIG_W1_SLAVE_DS2413"
check_config_module
config="CONFIG_W1_SLAVE_DS2406"
check_config_module
config="CONFIG_W1_SLAVE_DS2423"
check_config_module
config="CONFIG_W1_SLAVE_DS2433_CRC"
check_config_builtin
config="CONFIG_W1_SLAVE_DS2760"
check_config_module
config="CONFIG_W1_SLAVE_DS2780"
check_config_module
config="CONFIG_W1_SLAVE_DS2781"
check_config_module
config="CONFIG_W1_SLAVE_DS28E04"
check_config_module
config="CONFIG_GENERIC_ADC_BATTERY"
check_config_module
config="CONFIG_BATTERY_DA9052"
check_config_module
config="CONFIG_CHARGER_GPIO"
check_config_module
config="CONFIG_POWER_RESET_GPIO_RESTART"
check_config_builtin
config="CONFIG_POWER_RESET_SUN6I"
check_config_builtin
config="CONFIG_POWER_RESET_SYSCON"
check_config_builtin
config="CONFIG_POWER_AVS"
check_config_builtin

#
# Native drivers
#
config="CONFIG_SENSORS_AD7314"
check_config_module
config="CONFIG_SENSORS_ADM1021"
check_config_module
config="CONFIG_SENSORS_ADM1025"
check_config_module
config="CONFIG_SENSORS_ADM1026"
check_config_module
config="CONFIG_SENSORS_ADM1031"
check_config_module
config="CONFIG_SENSORS_ADT7X10"
check_config_module
config="CONFIG_SENSORS_ADT7310"
check_config_module
config="CONFIG_SENSORS_ADT7410"
check_config_module
config="CONFIG_SENSORS_DS1621"
check_config_module
config="CONFIG_SENSORS_DA9052_ADC"
check_config_module
config="CONFIG_SENSORS_DA9055"
check_config_module
config="CONFIG_SENSORS_F71805F"
check_config_module
config="CONFIG_SENSORS_GL518SM"
check_config_module
config="CONFIG_SENSORS_GL520SM"
check_config_module
config="CONFIG_SENSORS_G762"
check_config_module
config="CONFIG_SENSORS_GPIO_FAN"
check_config_module
config="CONFIG_SENSORS_HIH6130"
check_config_module
config="CONFIG_SENSORS_IIO_HWMON"
check_config_module
config="CONFIG_SENSORS_IT87"
check_config_module
config="CONFIG_SENSORS_POWR1220"
check_config_module
config="CONFIG_SENSORS_LTC2945"
check_config_module
config="CONFIG_SENSORS_LTC4222"
check_config_module
config="CONFIG_SENSORS_LTC4260"
check_config_module
config="CONFIG_SENSORS_MAX1619"
check_config_module
config="CONFIG_SENSORS_MAX197"
check_config_module
config="CONFIG_SENSORS_MAX6697"
check_config_module
config="CONFIG_SENSORS_HTU21"
check_config_module
config="CONFIG_SENSORS_MCP3021"
check_config_module
config="CONFIG_SENSORS_LM63"
check_config_module
config="CONFIG_SENSORS_LM75"
check_config_module
config="CONFIG_SENSORS_LM77"
check_config_module
config="CONFIG_SENSORS_LM78"
check_config_module
config="CONFIG_SENSORS_LM80"
check_config_module
config="CONFIG_SENSORS_LM83"
check_config_module
config="CONFIG_SENSORS_LM85"
check_config_module
config="CONFIG_SENSORS_LM87"
check_config_module
config="CONFIG_SENSORS_LM90"
check_config_module
config="CONFIG_SENSORS_LM92"
check_config_module
config="CONFIG_SENSORS_LM95234"
check_config_module
config="CONFIG_SENSORS_PC87360"
check_config_module
config="CONFIG_SENSORS_NCT6683"
check_config_module
config="CONFIG_SENSORS_PCF8591"
check_config_module

#exit

config="CONFIG_PMBUS"
check_config_module
config="CONFIG_SENSORS_PMBUS"
check_config_module
config="CONFIG_SENSORS_ADM1275"
check_config_module
config="CONFIG_SENSORS_LM25066"
check_config_module
config="CONFIG_SENSORS_LTC2978"
check_config_module
config="CONFIG_SENSORS_MAX16064"
check_config_module
config="CONFIG_SENSORS_MAX34440"
check_config_module
config="CONFIG_SENSORS_MAX8688"
check_config_module
config="CONFIG_SENSORS_TPS40422"
check_config_module
config="CONFIG_SENSORS_UCD9000"
check_config_module
config="CONFIG_SENSORS_UCD9200"
check_config_module
config="CONFIG_SENSORS_ZL6100"
check_config_module
config="CONFIG_SENSORS_PWM_FAN"
check_config_module
config="CONFIG_SENSORS_SHT15"
check_config_module
config="CONFIG_SENSORS_SHTC1"
check_config_module
config="CONFIG_SENSORS_SMSC47M1"
check_config_module
config="CONFIG_SENSORS_SMSC47B397"
check_config_module
config="CONFIG_SENSORS_SCH5636"
check_config_module
config="CONFIG_SENSORS_ADC128D818"
check_config_module
config="CONFIG_SENSORS_INA209"
check_config_module
config="CONFIG_SENSORS_INA2XX"
check_config_module
config="CONFIG_SENSORS_TMP103"
check_config_module
config="CONFIG_SENSORS_TWL4030_MADC"
check_config_module
config="CONFIG_SENSORS_W83781D"
check_config_module
config="CONFIG_SENSORS_W83L785TS"
check_config_module
config="CONFIG_SENSORS_W83627HF"
check_config_module
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
config="CONFIG_DRA752_THERMAL"
check_config_builtin
config="CONFIG_WATCHDOG_NOWAYOUT"
check_config_builtin

#
# Watchdog Device Drivers
#
config="CONFIG_SOFT_WATCHDOG"
check_config_disable
config="CONFIG_DA9052_WATCHDOG"
check_config_builtin
config="CONFIG_OMAP_WATCHDOG"
check_config_builtin
config="CONFIG_SUNXI_WATCHDOG"
check_config_builtin
config="CONFIG_TWL4030_WATCHDOG"
check_config_builtin
config="CONFIG_IMX2_WDT"
check_config_builtin
config="CONFIG_TEGRA_WATCHDOG"
check_config_builtin

#
# Multifunction device drivers
#
config="CONFIG_MFD_AXP20X"
check_config_builtin
config="CONFIG_MFD_DA9055"
check_config_builtin
config="CONFIG_MFD_DA9063"
check_config_builtin
config="CONFIG_MFD_MC13XXX"
check_config_builtin
config="CONFIG_MFD_MC13XXX_SPI"
check_config_builtin
config="CONFIG_MFD_MC13XXX_I2C"
check_config_builtin
config="CONFIG_MFD_TI_AM335X_TSCADC"
check_config_builtin
config="CONFIG_MFD_PALMAS"
check_config_builtin
config="CONFIG_MFD_TPS65217"
check_config_builtin
config="CONFIG_MFD_TPS65218"
check_config_builtin
config="CONFIG_MFD_TPS65910"
check_config_builtin
config="CONFIG_MFD_WL1273_CORE"
check_config_module
config="CONFIG_REGULATOR_USERSPACE_CONSUMER"
check_config_builtin
config="CONFIG_REGULATOR_ANATOP"
check_config_builtin
config="CONFIG_REGULATOR_AXP20X"
check_config_builtin
config="CONFIG_REGULATOR_DA9052"
check_config_builtin
config="CONFIG_REGULATOR_DA9055"
check_config_disable
config="CONFIG_REGULATOR_DA9063"
check_config_disable
config="CONFIG_REGULATOR_GPIO"
check_config_builtin
config="CONFIG_REGULATOR_MC13XXX_CORE"
check_config_builtin
config="CONFIG_REGULATOR_MC13783"
check_config_builtin
config="CONFIG_REGULATOR_MC13892"
check_config_builtin
config="CONFIG_REGULATOR_PALMAS"
check_config_builtin
config="CONFIG_REGULATOR_PBIAS"
check_config_builtin
config="CONFIG_REGULATOR_PFUZE100"
check_config_builtin
config="CONFIG_REGULATOR_PWM"
check_config_builtin
config="CONFIG_REGULATOR_TI_ABB"
check_config_builtin
config="CONFIG_REGULATOR_TPS65023"
check_config_builtin
config="CONFIG_REGULATOR_TPS6507X"
check_config_builtin
config="CONFIG_REGULATOR_TPS65217"
check_config_builtin
config="CONFIG_REGULATOR_TPS65218"
check_config_builtin
config="CONFIG_REGULATOR_TPS65910"
check_config_builtin

#
# Multimedia core support
#
config="CONFIG_MEDIA_SDR_SUPPORT"
check_config_builtin
config="CONFIG_VIDEO_V4L2_SUBDEV_API"
check_config_builtin
config="CONFIG_V4L2_MEM2MEM_DEV"
check_config_builtin
config="CONFIG_VIDEOBUF2_CORE"
check_config_builtin
config="CONFIG_VIDEOBUF2_MEMOPS"
check_config_builtin
config="CONFIG_VIDEOBUF2_DMA_CONTIG"
check_config_builtin

#
# Media drivers
#
config="CONFIG_IR_HIX5HD2"
check_config_module
config="CONFIG_IR_SUNXI"
check_config_module

#
# Analog TV USB devices
#
config="CONFIG_VIDEO_GO7007"
check_config_module
config="CONFIG_VIDEO_GO7007_USB"
check_config_module
config="CONFIG_VIDEO_GO7007_LOADER"
check_config_module
config="CONFIG_VIDEO_GO7007_USB_S2250_BOARD"
check_config_module

#
# Analog/digital TV USB devices
#
config="CONFIG_VIDEO_AU0828_RC"
check_config_builtin
config="CONFIG_VIDEO_TM6000"
check_config_module
config="CONFIG_VIDEO_TM6000_ALSA"
check_config_module
config="CONFIG_VIDEO_TM6000_DVB"
check_config_module

#
# Digital TV USB devices
#
config="CONFIG_DVB_USB_DVBSKY"
check_config_module
config="CONFIG_DVB_AS102"
check_config_module

#
# Software defined radio USB devices
#
config="CONFIG_USB_AIRSPY"
check_config_module
config="CONFIG_USB_HACKRF"
check_config_module
config="CONFIG_USB_MSI2500"
check_config_module

config="CONFIG_VIDEO_OMAP3"
check_config_module
config="CONFIG_VIDEO_OMAP3_DEBUG"
check_config_disable
config="CONFIG_SOC_CAMERA"
check_config_module
config="CONFIG_SOC_CAMERA_PLATFORM"
check_config_module
config="CONFIG_VIDEO_CODA"
check_config_builtin
config="CONFIG_VIDEO_MEM2MEM_DEINTERLACE"
check_config_module

#
# Supported MMC/SDIO adapters
#
config="CONFIG_I2C_SI470X"
check_config_module
config="CONFIG_USB_SI4713"
check_config_module
config="CONFIG_USB_DSBR"
check_config_module
config="CONFIG_RADIO_TEA5764"
check_config_module
config="CONFIG_RADIO_SAA7706H"
check_config_module
config="CONFIG_RADIO_TEF6862"
check_config_module
config="CONFIG_RADIO_WL1273"
check_config_module

#
# soc_camera sensor drivers
#
config="CONFIG_SOC_CAMERA_IMX074"
check_config_module
config="CONFIG_SOC_CAMERA_MT9M001"
check_config_module
config="CONFIG_SOC_CAMERA_MT9M111"
check_config_module
config="CONFIG_SOC_CAMERA_MT9T031"
check_config_module
config="CONFIG_SOC_CAMERA_MT9T112"
check_config_module
config="CONFIG_SOC_CAMERA_MT9V022"
check_config_module
config="CONFIG_SOC_CAMERA_OV2640"
check_config_module
config="CONFIG_SOC_CAMERA_OV5642"
check_config_module
config="CONFIG_SOC_CAMERA_OV6650"
check_config_module
config="CONFIG_SOC_CAMERA_OV772X"
check_config_module
config="CONFIG_SOC_CAMERA_OV9640"
check_config_module
config="CONFIG_SOC_CAMERA_OV9740"
check_config_module
config="CONFIG_SOC_CAMERA_RJ54N1"
check_config_module
config="CONFIG_SOC_CAMERA_TW9910"
check_config_module

#
# Graphics support
#
# CONFIG_TEGRA_HOST1X is not set
config="CONFIG_GPU_VIVANTE_V4"
check_config_builtin
config="CONFIG_GPU_VIVANTE_PROFILER"
check_config_builtin
config="CONFIG_IMX_IPUV3_CORE"
check_config_builtin

#
# Graphics support
#
config="CONFIG_DRM"
check_config_builtin

#...Drivers... (these will enable other defaults..)
config="CONFIG_DRM_UDL"
check_config_builtin
config="CONFIG_DRM_OMAP"
check_config_builtin
config="CONFIG_DRM_TILCDC"
check_config_builtin

#exit

#
# I2C encoder or helper chips
#
config="CONFIG_DRM_I2C_NXP_TDA998X"
check_config_builtin
config="CONFIG_DRM_OMAP"
check_config_builtin

#
# Frame buffer Devices
#
config="CONFIG_FIRMWARE_EDID"
check_config_disable

#
# Frame buffer hardware drivers
#
config="CONFIG_FB_MX3"
check_config_disable
config="CONFIG_OMAP2_DSS"
check_config_builtin
config="CONFIG_OMAP5_DSS_HDMI"
check_config_builtin
config="CONFIG_OMAP2_DSS_SDI"
check_config_disable

#
# OMAP Display Device Drivers (new device model)
#
config="CONFIG_DISPLAY_ENCODER_TFP410"
check_config_builtin
config="CONFIG_DISPLAY_ENCODER_TPD12S015"
check_config_builtin
config="CONFIG_DISPLAY_CONNECTOR_DVI"
check_config_builtin
config="CONFIG_DISPLAY_CONNECTOR_HDMI"
check_config_builtin
config="CONFIG_DISPLAY_PANEL_DPI"
check_config_builtin

config="CONFIG_FB_SSD1307"
check_config_builtin
config="CONFIG_BACKLIGHT_GPIO"
check_config_builtin

#
# Console display driver support
#
config="CONFIG_FRAMEBUFFER_CONSOLE_ROTATION"
check_config_disable
config="CONFIG_LOGO"
check_config_builtin
config="CONFIG_LOGO_LINUX_MONO"
check_config_builtin
config="CONFIG_LOGO_LINUX_VGA16"
check_config_builtin
config="CONFIG_LOGO_LINUX_CLUT224"
check_config_builtin

#
# HD-Audio
#
config="CONFIG_SND_HDA"
check_config_module
config="CONFIG_SND_HDA_TEGRA"
check_config_module
config="CONFIG_SND_HDA_CODEC_HDMI"
check_config_module
config="CONFIG_SND_HDA_GENERIC"
check_config_module
config="CONFIG_SND_USB_HIFACE"
check_config_module
config="CONFIG_SND_BCD2000"
check_config_module
config="CONFIG_SND_EDMA_SOC"
check_config_module
config="CONFIG_SND_DAVINCI_SOC_MCASP"
check_config_module
config="CONFIG_SND_DAVINCI_SOC_GENERIC_EVM"
check_config_module
config="CONFIG_SND_AM33XX_SOC_EVM"
check_config_module
config="CONFIG_SND_AM335X_SOC_NXPTDA_EVM"
check_config_module

#
# Common SoC Audio options for Freescale CPUs:
#
config="CONFIG_SND_SOC_FSL_ASRC"
check_config_module
config="CONFIG_SND_SOC_FSL_SAI"
check_config_module
config="CONFIG_SND_SOC_FSL_ESAI"
check_config_module

#
# SoC Audio support for Freescale i.MX boards:
#
config="CONFIG_SND_SOC_IMX_WM8962"
check_config_module
config="CONFIG_SND_SOC_IMX_ES8328"
check_config_module
config="CONFIG_SND_SOC_FSL_ASOC_CARD"
check_config_module
config="CONFIG_SND_SOC_TEGRA"
check_config_module

#
# CODEC drivers
#
config="CONFIG_SND_SOC_TLV320AIC31XX"
check_config_module

#
# HID support
#
config="CONFIG_HID_BATTERY_STRENGTH"
check_config_builtin
config="CONFIG_UHID"
check_config_builtin
config="CONFIG_HID_GENERIC"
check_config_builtin

#
# Special HID drivers
#
config="CONFIG_HID_APPLEIR"
check_config_module
config="CONFIG_HID_CP2112"
check_config_module
config="CONFIG_HID_GT683R"
check_config_module
config="CONFIG_HID_LENOVO"
check_config_module
config="CONFIG_HID_PENMOUNT"
check_config_module

#
# Miscellaneous USB options
#
config="CONFIG_USB_OTG"
check_config_builtin

#
# USB Host Controller Drivers
#
config="CONFIG_USB_XHCI_HCD"
check_config_builtin
config="CONFIG_USB_EHCI_HCD"
check_config_builtin
config="CONFIG_USB_EHCI_MXC"
check_config_disable
config="CONFIG_USB_EHCI_HCD_OMAP"
check_config_builtin
config="CONFIG_USB_EHCI_TEGRA"
check_config_builtin
config="CONFIG_USB_EHCI_HCD_PLATFORM"
check_config_builtin
config="CONFIG_USB_OHCI_HCD"
check_config_disable
config="CONFIG_USB_U132_HCD"
check_config_disable

#
# also be needed; see USB_STORAGE Help for more info
#
config="CONFIG_USB_STORAGE"
check_config_builtin

#
# USB Imaging devices
#
config="CONFIG_USBIP_CORE"
check_config_module
config="CONFIG_USBIP_VHCI_HCD"
check_config_module
config="CONFIG_USBIP_HOST"
check_config_module
config="CONFIG_USBIP_DEBUG"
check_config_disable

config="CONFIG_USB_MUSB_TUSB6010"
check_config_disable
config="CONFIG_USB_MUSB_OMAP2PLUS"
check_config_builtin
config="CONFIG_USB_MUSB_AM35X"
check_config_disable
config="CONFIG_USB_MUSB_DSPS"
check_config_disable
config="CONFIG_USB_CHIPIDEA"
check_config_builtin
config="CONFIG_USB_CHIPIDEA_DEBUG"
check_config_disable

#
# USB Physical Layer drivers
#
config="CONFIG_TWL6030_USB"
check_config_builtin
config="CONFIG_USB_GPIO_VBUS"
check_config_builtin
config="CONFIG_USB_MXS_PHY"
check_config_builtin
config="CONFIG_USB_GADGET_VBUS_DRAW"
value="500"
check_config_value

#
# USB Peripheral Controller
#
config="CONFIG_USB_LIBCOMPOSITE"
check_config_builtin
config="CONFIG_USB_U_ETHER"
check_config_builtin
config="CONFIG_USB_F_ECM"
check_config_builtin
config="CONFIG_USB_F_EEM"
check_config_builtin
config="CONFIG_USB_F_SUBSET"
check_config_builtin
config="CONFIG_USB_F_RNDIS"
check_config_builtin
config="CONFIG_USB_ETH"
check_config_builtin
config="CONFIG_USB_ETH_EEM"
check_config_builtin
config="CONFIG_USB_GADGETFS"
check_config_disable
config="CONFIG_USB_G_NOKIA"
check_config_disable

config="CONFIG_USB_LED_TRIG"
check_config_builtin

#
# MMC/SD/SDIO Host Controller Drivers
#
config="CONFIG_MMC_SDHCI"
check_config_builtin
config="CONFIG_MMC_SDHCI_PLTFM"
check_config_builtin
config="CONFIG_MMC_SDHCI_ESDHC_IMX"
check_config_builtin
config="CONFIG_MMC_SDHCI_TEGRA"
check_config_builtin
config="CONFIG_MMC_OMAP"
check_config_builtin
config="CONFIG_MMC_OMAP_HS"
check_config_builtin
config="CONFIG_MMC_VUB300"
check_config_disable
config="CONFIG_MMC_USHC"
check_config_disable
config="CONFIG_MMC_SUNXI"
check_config_builtin
config="CONFIG_MEMSTICK"
check_config_disable

#
# LED drivers
#
config="CONFIG_LEDS_LM3530"
check_config_module
config="CONFIG_LEDS_LM3642"
check_config_module
config="CONFIG_LEDS_PCA9532_GPIO"
check_config_builtin
config="CONFIG_LEDS_GPIO"
check_config_builtin
config="CONFIG_LEDS_LP5521"
check_config_module
config="CONFIG_LEDS_LP5562"
check_config_module
config="CONFIG_LEDS_LP8501"
check_config_module
config="CONFIG_LEDS_PCA963X"
check_config_module
config="CONFIG_LEDS_PWM"
check_config_module
config="CONFIG_LEDS_TCA6507"
check_config_module
config="CONFIG_LEDS_LM355x"
check_config_module

#
# LED Triggers
#
config="CONFIG_LEDS_TRIGGER_TIMER"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_ONESHOT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_HEARTBEAT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_BACKLIGHT"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_GPIO"
check_config_builtin
config="CONFIG_LEDS_TRIGGER_DEFAULT_ON"
check_config_builtin

#
# I2C RTC drivers
#
config="CONFIG_RTC_DRV_DS1307"
check_config_module
config="CONFIG_RTC_DRV_DS1374"
check_config_module
config="CONFIG_RTC_DRV_DS1672"
check_config_module
config="CONFIG_RTC_DRV_DS3232"
check_config_module
config="CONFIG_RTC_DRV_HYM8563"
check_config_module
config="CONFIG_RTC_DRV_MAX6900"
check_config_module
config="CONFIG_RTC_DRV_RS5C372"
check_config_module
config="CONFIG_RTC_DRV_ISL1208"
check_config_module
config="CONFIG_RTC_DRV_ISL12022"
check_config_module
config="CONFIG_RTC_DRV_ISL12057"
check_config_module
config="CONFIG_RTC_DRV_X1205"
check_config_module
config="CONFIG_RTC_DRV_PALMAS"
check_config_module
config="CONFIG_RTC_DRV_PCF2127"
check_config_module
config="CONFIG_RTC_DRV_PCF8523"
check_config_module
config="CONFIG_RTC_DRV_PCF8563"
check_config_module
config="CONFIG_RTC_DRV_PCF85063"
check_config_module
config="CONFIG_RTC_DRV_PCF8583"
check_config_module
config="CONFIG_RTC_DRV_M41T80"
check_config_module
config="CONFIG_RTC_DRV_M41T80_WDT"
check_config_builtin
config="CONFIG_RTC_DRV_BQ32K"
check_config_module
config="CONFIG_RTC_DRV_TWL4030"
check_config_module
config="CONFIG_RTC_DRV_TPS65910"
check_config_module
config="CONFIG_RTC_DRV_S35390A"
check_config_module
config="CONFIG_RTC_DRV_FM3130"
check_config_module
config="CONFIG_RTC_DRV_RX8581"
check_config_module
config="CONFIG_RTC_DRV_RX8025"
check_config_module
config="CONFIG_RTC_DRV_EM3027"
check_config_module
config="CONFIG_RTC_DRV_RV3029C2"
check_config_module
config="CONFIG_RTC_DRV_S5M"
check_config_module

#
# SPI RTC drivers
#
config="CONFIG_RTC_DRV_M41T93"
check_config_module
config="CONFIG_RTC_DRV_M41T94"
check_config_module
config="CONFIG_RTC_DRV_DS1305"
check_config_module
config="CONFIG_RTC_DRV_DS1343"
check_config_module
config="CONFIG_RTC_DRV_DS1347"
check_config_module
config="CONFIG_RTC_DRV_DS1390"
check_config_module
config="CONFIG_RTC_DRV_MAX6902"
check_config_module
config="CONFIG_RTC_DRV_R9701"
check_config_module
config="CONFIG_RTC_DRV_RS5C348"
check_config_module
config="CONFIG_RTC_DRV_DS3234"
check_config_module
config="CONFIG_RTC_DRV_PCF2123"
check_config_module
config="CONFIG_RTC_DRV_RX4581"
check_config_module
config="CONFIG_RTC_DRV_MCP795"
check_config_module

#
# Platform RTC drivers
#
config="CONFIG_RTC_DRV_DS1286"
check_config_module
config="CONFIG_RTC_DRV_DS1511"
check_config_module
config="CONFIG_RTC_DRV_DS1553"
check_config_module
config="CONFIG_RTC_DRV_DS1742"
check_config_module
config="CONFIG_RTC_DRV_DA9055"
check_config_module
config="CONFIG_RTC_DRV_DA9063"
check_config_module
config="CONFIG_RTC_DRV_STK17TA8"
check_config_module
config="CONFIG_RTC_DRV_M48T86"
check_config_module
config="CONFIG_RTC_DRV_M48T35"
check_config_module
config="CONFIG_RTC_DRV_M48T59"
check_config_module
config="CONFIG_RTC_DRV_MSM6242"
check_config_module
config="CONFIG_RTC_DRV_BQ4802"
check_config_module
config="CONFIG_RTC_DRV_RP5C01"
check_config_module
config="CONFIG_RTC_DRV_V3020"
check_config_module
config="CONFIG_RTC_DRV_DS2404"
check_config_module

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_SUN6I"
check_config_module
config="CONFIG_RTC_DRV_TEGRA"
check_config_module
config="CONFIG_RTC_DRV_SNVS"
check_config_module

#
# HID Sensor RTC drivers
#
config="CONFIG_RTC_DRV_HID_SENSOR_TIME"
check_config_module

#
# DMA Devices
#
config="CONFIG_DW_DMAC_CORE"
check_config_builtin
config="CONFIG_DW_DMAC"
check_config_builtin
config="CONFIG_TEGRA20_APB_DMA"
check_config_builtin
config="CONFIG_TI_CPPI41"
check_config_builtin
config="CONFIG_FSL_EDMA"
check_config_builtin
config="CONFIG_DMA_SUN6I"
check_config_builtin

#STAGING

#
# Microsoft Hyper-V guest support
#
config="CONFIG_RTLLIB"
check_config_module
config="CONFIG_RTLLIB_CRYPTO_CCMP"
check_config_module
config="CONFIG_RTLLIB_CRYPTO_TKIP"
check_config_module
config="CONFIG_RTLLIB_CRYPTO_WEP"
check_config_module

#
# Accelerometers
#
config="CONFIG_ADIS16201"
check_config_module
config="CONFIG_ADIS16203"
check_config_module
config="CONFIG_ADIS16204"
check_config_module
config="CONFIG_ADIS16209"
check_config_module
config="CONFIG_ADIS16220"
check_config_module
config="CONFIG_ADIS16240"
check_config_module
config="CONFIG_SCA3000"
check_config_module

#
# Analog to digital converters
#
config="CONFIG_AD7606"
check_config_module
config="CONFIG_AD7606_IFACE_SPI"
check_config_module
config="CONFIG_AD7780"
check_config_module
config="CONFIG_AD7816"
check_config_module
config="CONFIG_AD7192"
check_config_module
config="CONFIG_AD7280"
check_config_module

#
# Analog digital bi-direction converters
#
config="CONFIG_ADT7316"
check_config_module
config="CONFIG_ADT7316_SPI"
check_config_module
config="CONFIG_ADT7316_I2C"
check_config_module

#
# Capacitance to digital converters
#
config="CONFIG_AD7150"
check_config_module
config="CONFIG_AD7152"
check_config_module
config="CONFIG_AD7746"
check_config_module

#
# Direct Digital Synthesis
#
config="CONFIG_AD9832"
check_config_module
config="CONFIG_AD9834"
check_config_module

#
# Digital gyroscope sensors
#
config="CONFIG_ADIS16060"
check_config_module

#
# Network Analyzer, Impedance Converters
#
config="CONFIG_AD5933"
check_config_module

#
# Light sensors
#
config="CONFIG_SENSORS_ISL29018"
check_config_module
config="CONFIG_SENSORS_ISL29028"
check_config_module
config="CONFIG_TSL2583"
check_config_module
config="CONFIG_TSL2x7x"
check_config_module

#
# Magnetometer sensors
#
config="CONFIG_SENSORS_HMC5843"
check_config_module
config="CONFIG_SENSORS_HMC5843_I2C"
check_config_module
config="CONFIG_SENSORS_HMC5843_SPI"
check_config_module

#
# Active energy metering IC
#
config="CONFIG_ADE7753"
check_config_module
config="CONFIG_ADE7754"
check_config_module
config="CONFIG_ADE7758"
check_config_module
config="CONFIG_ADE7759"
check_config_module
config="CONFIG_ADE7854"
check_config_module
config="CONFIG_ADE7854_I2C"
check_config_module
config="CONFIG_ADE7854_SPI"
check_config_module

#
# Resolver to digital converters
#
config="CONFIG_AD2S90"
check_config_module
config="CONFIG_AD2S1200"
check_config_module
config="CONFIG_AD2S1210"
check_config_module

#
# Android
#
config="CONFIG_ANDROID"
check_config_builtin
config="CONFIG_ANDROID_BINDER_IPC"
check_config_builtin
config="CONFIG_ANDROID_BINDER_IPC_32BIT"
check_config_builtin
config="CONFIG_ASHMEM"
check_config_builtin
config="CONFIG_ANDROID_LOGGER"
check_config_module
config="CONFIG_ANDROID_TIMED_GPIO"
check_config_module
config="CONFIG_ANDROID_INTF_ALARM_DEV"
check_config_builtin
config="CONFIG_SYNC"
check_config_builtin
config="CONFIG_SW_SYNC"
check_config_disable

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
config="CONFIG_DRM_IMX_IPUV3"
check_config_builtin
config="CONFIG_DRM_IMX_HDMI"
check_config_builtin

#
# SOC (System On Chip) specific Drivers
#
config="CONFIG_SOC_TI"
check_config_builtin

#
# Common Clock Framework
#
config="CONFIG_CLK_TWL6040"
check_config_builtin
config="CONFIG_COMMON_CLK_PALMAS"
check_config_builtin
config="CONFIG_HWSPINLOCK"
check_config_builtin

#
# Hardware Spinlock drivers
#
config="CONFIG_HWSPINLOCK_OMAP"
check_config_builtin

#
# Clock Source drivers
#
config="CONFIG_TEGRA_IOMMU_SMMU"
check_config_builtin

#
# Remoteproc drivers
#
config="CONFIG_REMOTEPROC"
check_config_builtin
config="CONFIG_OMAP_REMOTEPROC"
check_config_builtin

#
# DEVFREQ Governors
#
config="CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND"
check_config_builtin
config="CONFIG_DEVFREQ_GOV_PERFORMANCE"
check_config_builtin
config="CONFIG_DEVFREQ_GOV_POWERSAVE"
check_config_builtin
config="CONFIG_DEVFREQ_GOV_USERSPACE"
check_config_builtin

#
# DEVFREQ Drivers
#
config="CONFIG_MEMORY"
check_config_builtin
config="CONFIG_TI_EMIF"
check_config_builtin

#
# Accelerometers
#
config="CONFIG_BMA180"
check_config_module
config="CONFIG_BMC150_ACCEL"
check_config_module
config="CONFIG_IIO_ST_ACCEL_3AXIS"
check_config_module
config="CONFIG_IIO_ST_ACCEL_I2C_3AXIS"
check_config_module
config="CONFIG_IIO_ST_ACCEL_SPI_3AXIS"
check_config_module
config="CONFIG_KXSD9"
check_config_module
config="CONFIG_MMA8452"
check_config_module
config="CONFIG_KXCJK1013"
check_config_module

#
# Analog to digital converters
#
config="CONFIG_AD7266"
check_config_module
config="CONFIG_AD7291"
check_config_module
config="CONFIG_AD7298"
check_config_module
config="CONFIG_AD7476"
check_config_module
config="CONFIG_AD7791"
check_config_module
config="CONFIG_AD7793"
check_config_module
config="CONFIG_AD7887"
check_config_module
config="CONFIG_AD7923"
check_config_module
config="CONFIG_AD799X"
check_config_module
config="CONFIG_MAX1027"
check_config_module
config="CONFIG_MAX1363"
check_config_module
config="CONFIG_MCP320X"
check_config_module
config="CONFIG_MCP3422"
check_config_module
config="CONFIG_NAU7802"
check_config_module
config="CONFIG_TI_ADC081C"
check_config_module
config="CONFIG_TI_ADC128S052"
check_config_module
config="CONFIG_TWL4030_MADC"
check_config_module
config="CONFIG_TWL6030_GPADC"
check_config_module
config="CONFIG_VF610_ADC"
check_config_module

#
# Amplifiers
#
config="CONFIG_AD8366"
check_config_module

#
# Digital to analog converters
#
config="CONFIG_AD5064"
check_config_module
config="CONFIG_AD5360"
check_config_module
config="CONFIG_AD5380"
check_config_module
config="CONFIG_AD5421"
check_config_module
config="CONFIG_AD5446"
check_config_module
config="CONFIG_AD5449"
check_config_module
config="CONFIG_AD5504"
check_config_module
config="CONFIG_AD5624R_SPI"
check_config_module
config="CONFIG_AD5686"
check_config_module
config="CONFIG_AD5755"
check_config_module
config="CONFIG_AD5764"
check_config_module
config="CONFIG_AD5791"
check_config_module
config="CONFIG_AD7303"
check_config_module
config="CONFIG_MAX517"
check_config_module
config="CONFIG_MAX5821"
check_config_module
config="CONFIG_MCP4725"
check_config_module
config="CONFIG_MCP4922"
check_config_module

#
# Clock Generator/Distribution
#
config="CONFIG_AD9523"
check_config_module

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
config="CONFIG_ADF4350"
check_config_module

#
# Digital gyroscope sensors
#
config="CONFIG_ADIS16080"
check_config_module
config="CONFIG_ADIS16130"
check_config_module
config="CONFIG_ADIS16136"
check_config_module
config="CONFIG_ADIS16260"
check_config_module
config="CONFIG_ADXRS450"
check_config_module
config="CONFIG_BMG160"
check_config_module
config="CONFIG_IIO_ST_GYRO_3AXIS"
check_config_module
config="CONFIG_IIO_ST_GYRO_I2C_3AXIS"
check_config_module
config="CONFIG_IIO_ST_GYRO_SPI_3AXIS"
check_config_module
config="CONFIG_ITG3200"
check_config_module

#
# Humidity sensors
#
config="CONFIG_DHT11"
check_config_module
config="CONFIG_SI7005"
check_config_module

#
# Inertial measurement units
#
config="CONFIG_ADIS16400"
check_config_module
config="CONFIG_ADIS16480"
check_config_module
config="CONFIG_INV_MPU6050_IIO"
check_config_module

#
# Light sensors
#
config="CONFIG_ADJD_S311"
check_config_module
config="CONFIG_AL3320A"
check_config_module
config="CONFIG_APDS9300"
check_config_module
config="CONFIG_CM32181"
check_config_module
config="CONFIG_CM36651"
check_config_module
config="CONFIG_GP2AP020A00F"
check_config_module
config="CONFIG_ISL29125"
check_config_module
config="CONFIG_LTR501"
check_config_module
config="CONFIG_TCS3414"
check_config_module
config="CONFIG_TCS3472"
check_config_module
config="CONFIG_TSL4531"
check_config_module
config="CONFIG_VCNL4000"
check_config_module

#
# Magnetometer sensors
#
config="CONFIG_AK8975"
check_config_module
config="CONFIG_AK09911"
check_config_module
config="CONFIG_MAG3110"
check_config_module
config="CONFIG_IIO_ST_MAGN_3AXIS"
check_config_module
config="CONFIG_IIO_ST_MAGN_I2C_3AXIS"
check_config_module
config="CONFIG_IIO_ST_MAGN_SPI_3AXIS"
check_config_module

#
# Inclinometer sensors
#
config="CONFIG_HID_SENSOR_DEVICE_ROTATION"
check_config_module

#
# Triggers - standalone
#
config="CONFIG_IIO_INTERRUPT_TRIGGER"
check_config_module
config="CONFIG_IIO_SYSFS_TRIGGER"
check_config_module

#
# Pressure sensors
#
config="CONFIG_MPL115"
check_config_module
config="CONFIG_MPL3115"
check_config_module
config="CONFIG_IIO_ST_PRESS"
check_config_module
config="CONFIG_IIO_ST_PRESS_I2C"
check_config_module
config="CONFIG_IIO_ST_PRESS_SPI"
check_config_module
config="CONFIG_T5403"
check_config_module

#
# Lightning sensors
#
config="CONFIG_AS3935"
check_config_module

#
# Temperature sensors
#
config="CONFIG_MLX90614"
check_config_module
config="CONFIG_TMP006"
check_config_module
config="CONFIG_PWM_IMX"
check_config_builtin
config="CONFIG_PWM_PCA9685"
check_config_builtin
config="CONFIG_PWM_TEGRA"
check_config_builtin
config="CONFIG_PWM_TIECAP"
check_config_builtin
config="CONFIG_PWM_TIEHRPWM"
check_config_builtin
config="CONFIG_PWM_TWL"
check_config_builtin
config="CONFIG_PWM_TWL_LED"
check_config_builtin

#
# PHY Subsystem
#
config="CONFIG_OMAP_CONTROL_PHY"
check_config_builtin
config="CONFIG_OMAP_USB2"
check_config_builtin
config="CONFIG_TI_PIPE3"
check_config_builtin
config="CONFIG_TWL4030_USB"
check_config_builtin
config="CONFIG_PHY_SUN4I_USB"
check_config_builtin

#
# File systems
#
config="CONFIG_EXT4_FS"
check_config_builtin
config="CONFIG_JBD2"
check_config_builtin
config="CONFIG_FS_MBCACHE"
check_config_builtin
config="CONFIG_XFS_FS"
check_config_builtin
config="CONFIG_BTRFS_FS"
check_config_builtin
config="CONFIG_FANOTIFY_ACCESS_PERMISSIONS"
check_config_builtin
config="CONFIG_AUTOFS4_FS"
check_config_builtin
config="CONFIG_FUSE_FS"
check_config_builtin

#
# DOS/FAT/NT Filesystems
#
config="CONFIG_FAT_FS"
check_config_builtin
config="CONFIG_MSDOS_FS"
check_config_builtin
config="CONFIG_VFAT_FS"
check_config_builtin
config="CONFIG_FAT_DEFAULT_IOCHARSET"
value=\"iso8859-1\"
check_config_value

#
# Pseudo filesystems
#
config="CONFIG_F2FS_FS"
check_config_builtin
config="CONFIG_NFS_FS"
check_config_builtin
config="CONFIG_NFS_V2"
check_config_builtin
config="CONFIG_NFS_V3"
check_config_builtin
config="CONFIG_NFS_V4"
check_config_builtin
config="CONFIG_ROOT_NFS"
check_config_builtin
config="CONFIG_NLS_DEFAULT"
value=\"iso8859-1\"
check_config_value
config="CONFIG_NLS_CODEPAGE_437"
check_config_builtin
config="CONFIG_NLS_ISO8859_1"
check_config_builtin

#
# printk and dmesg options
#
config="CONFIG_BOOT_PRINTK_DELAY"
check_config_disable

#
# Debug Lockups and Hangs
#
config="CONFIG_SCHEDSTATS"
check_config_builtin
config="CONFIG_SCHED_STACK_END_CHECK"
check_config_builtin

#
# Runtime Testing
#
config="CONFIG_KGDB"
check_config_builtin
config="CONFIG_KGDB_SERIAL_CONSOLE"
check_config_builtin
config="CONFIG_KGDB_TESTS"
check_config_disable
config="CONFIG_KGDB_KDB"
check_config_builtin
config="CONFIG_KDB_KEYBOARD"
check_config_builtin
config="CONFIG_STRICT_DEVMEM"
check_config_builtin

#
# Digest
#
config="CONFIG_CRYPTO_SHA1_ARM_NEON"
check_config_module
config="CONFIG_CRYPTO_SHA512_ARM_NEON"
check_config_module

echo "#Bugs:"
config="CONFIG_CRYPTO_MANAGER_DISABLE_TESTS"
check_config_builtin

#
