#!/bin/sh
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Split out, so build_kernel.sh and build_deb.sh can share..

git="git am"

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		git format-patch -${number} -o ${DIR}/patches/
	fi
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

dma_devel () {
	echo "dir: dma-devel"
	${git} "${DIR}/patches/dma-devel/0001-ARM-EDMA-Fix-clearing-of-unused-list-for-DT-DMA-reso.patch"
	${git} "${DIR}/patches/dma-devel/0002-da8xx-config-Enable-MMC-and-FS-options.patch"
	${git} "${DIR}/patches/dma-devel/0003-ARM-dts-add-AM33XX-EDMA-support.patch"
	${git} "${DIR}/patches/dma-devel/0004-ARM-dts-add-AM33XX-SPI-DMA-support.patch"
	${git} "${DIR}/patches/dma-devel/0005-ARM-dts-add-AM33XX-MMC-support-and-documentation.patch"
	${git} "${DIR}/patches/dma-devel/0006-sound-soc-soc-dmaengine-pcm-Add-support-for-new-DMAE.patch"
}

general_fixes () {
	echo "dir: general-fixes"
	${git} "${DIR}/patches/general-fixes/0001-add-PM-firmware.patch"
	#Nak! use zImage + dtb file...
	#${git} "${DIR}/patches/general-fixes/0002-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/general-fixes/0003-defconfig-add-for-mainline-on-the-beaglebone.patch"
}

dtc_fixes () {
	echo "dir: dtc-fixes"
	${git} "${DIR}/patches/dtc-fixes/0001-Fix-util_is_printable_string.patch"
	${git} "${DIR}/patches/dtc-fixes/0002-fdtdump-properly-handle-multi-string-properties.patch"
}

dtc_overlays () {
	echo "dir: dtc-overlays"
	${git} "${DIR}/patches/dtc-overlays/0001-dtc-Dynamic-symbols-fixup-support.patch"
	${git} "${DIR}/patches/dtc-overlays/0002-dtc-Dynamic-symbols-fixup-support-shipped.patch"
}

of_fixes () {
	echo "dir: of-fixes"
	${git} "${DIR}/patches/of-fixes/0001-of-i2c-Export-single-device-registration-method.patch"
	${git} "${DIR}/patches/of-fixes/0002-OF-Clear-detach-flag-on-attach.patch"
	${git} "${DIR}/patches/of-fixes/0003-OF-Introduce-device-tree-node-flag-helpers.patch"
	${git} "${DIR}/patches/of-fixes/0004-OF-export-of_property_notify.patch"
	${git} "${DIR}/patches/of-fixes/0005-OF-Export-all-DT-proc-update-functions.patch"
	${git} "${DIR}/patches/of-fixes/0006-OF-Introduce-utility-helper-functions.patch"
	${git} "${DIR}/patches/of-fixes/0007-OF-Introduce-Device-Tree-resolve-support.patch"
	${git} "${DIR}/patches/of-fixes/0008-OF-Introduce-DT-overlay-support.patch"
}

pdev_fixes () {
	echo "dir: pdev-fixes"
	${git} "${DIR}/patches/pdev-fixes/0001-pdev-Fix-platform-device-resource-linking.patch"
	${git} "${DIR}/patches/pdev-fixes/0002-of-Link-platform-device-resources-properly.patch"
	${git} "${DIR}/patches/pdev-fixes/0003-omap-Properly-handle-resources-for-omap_devices.patch"
	${git} "${DIR}/patches/pdev-fixes/0004-omap-Avoid-crashes-in-the-case-of-hwmod-misconfigura.patch"
}

mmc_fixes () {
	echo "dir: mmc-fixes"
	${git} "${DIR}/patches/mmc-fixes/0001-omap-hsmmc-Correct-usage-of-of_find_node_by_name.patch"
	${git} "${DIR}/patches/mmc-fixes/0002-omap_hsmmc-Add-reset-gpio.patch"
}

dts_fixes () {
	echo "dir: dts-fixes"
	${git} "${DIR}/patches/dts-fixes/0001-dts-beaglebone-Add-I2C-definitions-for-EEPROMs-capes.patch"
	${git} "${DIR}/patches/dts-fixes/0002-arm-beaglebone-dts-Add-capemanager-to-the-DTS.patch"
	${git} "${DIR}/patches/dts-fixes/0003-OF-Compile-Device-Tree-sources-with-resolve-option.patch"
	${git} "${DIR}/patches/dts-fixes/0004-arm-bone-dts-add-CD-for-mmc1.patch"
	${git} "${DIR}/patches/dts-fixes/0005-am335x-boneblack-add-eMMC-DT-entry.patch"
	${git} "${DIR}/patches/dts-fixes/0006-am335x-bone-fix-MMC-regulators-on-boneblack.patch"
	${git} "${DIR}/patches/dts-fixes/0007-am335x-bone-enable-HDMI-on-black.patch"
	${git} "${DIR}/patches/dts-fixes/0008-ARM-am335x-bone-common-switch-mmc1-to-4-bit-mode.patch"
	${git} "${DIR}/patches/dts-fixes/0009-ARM-dts-am335x-bone-common-add-cpu0-and-mmc1-trigger.patch"
}

i2c_fixes () {
	echo "dir: i2c-fixes"
	${git} "${DIR}/patches/i2c-fixes/0001-i2c-EEPROM-In-kernel-memory-accessor-interface.patch"
	${git} "${DIR}/patches/i2c-fixes/0002-grove-i2c-Add-rudimentary-grove-i2c-motor-control-dr.patch"
}

pinctrl_fixes () {
	echo "dir: pinctrl-fixes"
	${git} "${DIR}/patches/pinctrl-fixes/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
}

capemgr () {
	echo "dir: capemgr"
	${git} "${DIR}/patches/capemgr/0001-capemgr-Capemgr-makefiles-and-Kconfig-fragments.patch"
	${git} "${DIR}/patches/capemgr/0002-capemgr-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/capemgr/0003-capemgr-Remove-__devinit-__devexit.patch"
	${git} "${DIR}/patches/capemgr/0004-bone-capemgr-Make-sure-cape-removal-works.patch"
	${git} "${DIR}/patches/capemgr/0005-bone-capemgr-Fix-crash-when-trying-to-remove-non-exi.patch"
	${git} "${DIR}/patches/capemgr/0006-bone-capemgr-Force-a-slot-to-load-unconditionally.patch"
	${git} "${DIR}/patches/capemgr/0007-capemgr-Added-module-param-descriptions.patch"
	${git} "${DIR}/patches/capemgr/0008-capemgr-Implement-disable-overrides-on-the-cmd-line.patch"
	${git} "${DIR}/patches/capemgr/0009-capemgr-Implement-cape-priorities.patch"
	${git} "${DIR}/patches/capemgr/0010-bone-capemgr-Introduce-simple-resource-tracking.patch"
	${git} "${DIR}/patches/capemgr/0011-capemgr-Add-enable_partno-parameter.patch"
}

reset () {
	echo "dir: reset"
	${git} "${DIR}/patches/reset/0001-reset-Add-driver-for-gpio-controlled-reset-pins.patch"
}

capes () {
	echo "dir: capes"
	${git} "${DIR}/patches/capes/0001-capemgr-firmware-makefiles-for-DT-objects.patch"
}

lcdc_fixes () {
	echo "dir: lcdc-fixes"
	${git} "${DIR}/patches/lcdc-fixes/0001-gpu-drm-tilcdc-get-preferred_bpp-value-from-DT.patch"
	${git} "${DIR}/patches/lcdc-fixes/0002-drm-tilcdc-fixing-i2c-slave-initialization-race.patch"
	${git} "${DIR}/patches/lcdc-fixes/0003-drm-tilcdc-Fix-scheduling-while-atomic-from-irq-hand.patch"
	${git} "${DIR}/patches/lcdc-fixes/0004-tilcdc-Slave-panel-settings-read-from-DT-now.patch"
}

net () {
	echo "dir: net"
	${git} "${DIR}/patches/net/0001-am33xx-cpsw-default-to-ethernet-hwaddr-from-efuse-if.patch"
}

deassert_hard_reset () {
	echo "dir: deassert-hard-reset"
	${git} "${DIR}/patches/deassert-hard-reset/0001-ARM-omap-add-DT-support-for-deasserting-hardware-res.patch"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
}

###
arm
dma_devel
general_fixes
dtc_fixes
dtc_overlays
of_fixes
pdev_fixes
mmc_fixes
dts_fixes
i2c_fixes
pinctrl_fixes
capemgr
reset
capes
lcdc_fixes
net
deassert_hard_reset
saucy

echo "patch.sh ran successful"
