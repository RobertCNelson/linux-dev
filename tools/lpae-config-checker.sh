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

config="CONFIG_ARM_DMA_IOMMU_ALIGNMENT"
value="8"
check_config_value
config="CONFIG_VIRTUALIZATION"
check_config_builtin
config="CONFIG_KVM"
check_config_builtin
config="CONFIG_ARM_LPAE"
check_config_builtin
config="CONFIG_ARM_SMMU"
check_config_builtin

###############

#
# CPU Core family selection
#
config="CONFIG_ARCH_MXC"
check_config_disable

#
# OMAP Feature Selections
#
config="CONFIG_ARCH_OMAP3"
check_config_disable
config="CONFIG_ARCH_OMAP4"
check_config_disable
config="CONFIG_SOC_AM33XX"
check_config_disable
config="CONFIG_SOC_AM43XX"
check_config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_MACH_SUN4I"
check_config_disable
config="CONFIG_MACH_SUN5I"
check_config_disable

#
# Processor Features
#
config="CONFIG_ARM_ERRATA_430973"
check_config_disable

#
# Argus cape driver for beaglebone black
#
config="CONFIG_CAPE_BONE_ARGUS"
check_config_disable
config="CONFIG_BEAGLEBONE_PINMUX_HELPER"
check_config_disable

#
# Graphics support
#
config="CONFIG_GPU_VIVANTE_V4"
check_config_disable
config="CONFIG_IMX_IPUV3_CORE"
check_config_disable

config="CONFIG_DRM_TILCDC"
check_config_disable
config="CONFIG_DRM_IMX"
check_config_disable


#
