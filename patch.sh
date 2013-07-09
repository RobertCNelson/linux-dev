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
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

mainline_fixes () {
	echo "dir: mainline-fixes"
	${git} "${DIR}/patches/mainline-fixes/0001-add-PM-firmware.patch"
	${git} "${DIR}/patches/mainline-fixes/0002-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/mainline-fixes/0003-Thumb-2-Add-local-symbols-to-work-around-gas-behavio.patch"
}

mainline_dtc_fixes () {
	echo "dir: mainline-dtc-fixes"
	${git} "${DIR}/patches/mainline-dtc-fixes/0001-Fix-util_is_printable_string.patch"
	${git} "${DIR}/patches/mainline-dtc-fixes/0002-fdtdump-properly-handle-multi-string-properties.patch"
}

mainline_dtc_overlays () {
	echo "dir: mainline-dtc-overlays"
	${git} "${DIR}/patches/mainline-dtc-overlays/0001-dtc-Dynamic-symbols-fixup-support.patch"
	${git} "${DIR}/patches/mainline-dtc-overlays/0002-dtc-Dynamic-symbols-fixup-support-shipped.patch"
}

mainline_of_fixes () {
	echo "dir: mainline-of-fixes"
	${git} "${DIR}/patches/mainline-of-fixes/0001-of-i2c-Export-single-device-registration-method.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0002-OF-Clear-detach-flag-on-attach.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0003-OF-Introduce-device-tree-node-flag-helpers.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0004-OF-export-of_property_notify.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0005-OF-Export-all-DT-proc-update-functions.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0006-OF-Introduce-utility-helper-functions.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0007-OF-Introduce-Device-Tree-resolve-support.patch"
	${git} "${DIR}/patches/mainline-of-fixes/0008-OF-Introduce-DT-overlay-support.patch"
}

mainline_pdev_fixes () {
	echo "dir: mainline-pdev-fixes"
	${git} "${DIR}/patches/mainline-pdev-fixes/0001-pdev-Fix-platform-device-resource-linking.patch"
	${git} "${DIR}/patches/mainline-pdev-fixes/0002-of-Link-platform-device-resources-properly.patch"
	${git} "${DIR}/patches/mainline-pdev-fixes/0003-omap-Properly-handle-resources-for-omap_devices.patch"
	${git} "${DIR}/patches/mainline-pdev-fixes/0004-omap-Avoid-crashes-in-the-case-of-hwmod-misconfigura.patch"
}

mainline_dma_devel () {
	echo "dir: mainline-dma-devel"
	${git} "${DIR}/patches/mainline-dma-devel/0001-ARM-davinci-move-private-EDMA-API-to-arm-common.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0002-ARM-edma-remove-unused-transfer-controller-handlers.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0003-ARM-edma-Convert-to-devm_-api.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0004-ARM-davinci-uart-move-to-devid-based-clk_get.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0005-dmaengine-edma-Add-TI-EDMA-device-tree-binding.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0006-ARM-edma-Add-DT-and-runtime-PM-support-to-the-privat.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0007-ARM-edma-Add-EDMA-crossbar-event-mux-support.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0008-dma-edma-add-device_slave_sg_limits-support.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0009-dmaengine-add-dma_get_slave_sg_limits.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0010-mmc-omap_hsmmc-set-max_segs-based-on-dma-engine-limi.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0011-dmaengine-edma-enable-build-for-AM33XX.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0012-da8xx-config-Enable-MMC-and-FS-options.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0013-spi-omap2-mcspi-add-generic-DMA-request-support-to-t.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0014-spi-omap2-mcspi-convert-to-dma_request_slave_channel.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0015-ARM-dts-add-AM33XX-EDMA-support.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0016-ARM-dts-add-AM33XX-SPI-DMA-support.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0017-ARM-dts-add-AM33XX-MMC-support.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0018-ARM-configs-Enable-TI_EDMA-in-omap2plus_defconfig.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0019-DMA-EDMA-Add-comments-for-A-sync-case-calculations.patch"
	${git} "${DIR}/patches/mainline-dma-devel/0020-am33xx-edma-Always-update-unused-channel-list.patch"
}

mainline_mmc_fixes () {
	echo "dir: mainline-mmc-fixes"
	${git} "${DIR}/patches/mainline-mmc-fixes/0001-omap-hsmmc-Correct-usage-of-of_find_node_by_name.patch"
	${git} "${DIR}/patches/mainline-mmc-fixes/0002-omap_hsmmc-Add-reset-gpio.patch"
}

mainline_dts_fixes () {
	echo "dir: mainline-dts-fixes"
	${git} "${DIR}/patches/mainline-dts-fixes/0001-am335x-dts-Add-beaglebone-black-DTS.patch"
	${git} "${DIR}/patches/mainline-dts-fixes/0002-dts-beaglebone-Add-I2C-definitions-for-EEPROMs-capes.patch"
	${git} "${DIR}/patches/mainline-dts-fixes/0003-arm-beaglebone-dts-Add-capemanager-to-the-DTS.patch"
}

mainline_i2c_fixes () {
	echo "dir: mainline-i2c-fixes"
	${git} "${DIR}/patches/mainline-i2c-fixes/0001-i2c-EEPROM-In-kernel-memory-accessor-interface.patch"
	${git} "${DIR}/patches/mainline-i2c-fixes/0002-grove-i2c-Add-rudimentary-grove-i2c-motor-control-dr.patch"
}

mainline_pinctrl_fixes () {
	echo "dir: mainline-pinctrl-fixes"
	${git} "${DIR}/patches/mainline-pinctrl-fixes/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
}

mainline_capemgr () {
	echo "dir: mainline-capemgr"
	${git} "${DIR}/patches/mainline-capemgr/0001-capemgr-Capemgr-makefiles-and-Kconfig-fragments.patch"
	${git} "${DIR}/patches/mainline-capemgr/0002-capemgr-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/mainline-capemgr/0003-capemgr-Remove-__devinit-__devexit.patch"
	${git} "${DIR}/patches/mainline-capemgr/0004-bone-capemgr-Make-sure-cape-removal-works.patch"
	${git} "${DIR}/patches/mainline-capemgr/0005-bone-capemgr-Fix-crash-when-trying-to-remove-non-exi.patch"
	${git} "${DIR}/patches/mainline-capemgr/0006-bone-capemgr-Force-a-slot-to-load-unconditionally.patch"
	${git} "${DIR}/patches/mainline-capemgr/0007-capemgr-Added-module-param-descriptions.patch"
	${git} "${DIR}/patches/mainline-capemgr/0008-capemgr-Implement-disable-overrides-on-the-cmd-line.patch"
	${git} "${DIR}/patches/mainline-capemgr/0009-capemgr-Implement-cape-priorities.patch"
	${git} "${DIR}/patches/mainline-capemgr/0010-bone-capemgr-Introduce-simple-resource-tracking.patch"
	${git} "${DIR}/patches/mainline-capemgr/0011-capemgr-Add-enable_partno-parameter.patch"
}

mainline_reset () {
	echo "dir: mainline-reset"
	${git} "${DIR}/patches/mainline-reset/0001-reset-Add-driver-for-gpio-controlled-reset-pins.patch"
}

mainline_capes () {
	echo "dir: mainline-capes"
	${git} "${DIR}/patches/mainline-capes/0001-capemgr-firmware-makefiles-for-DT-objects.patch"
}

mainline_fixes
mainline_dtc_fixes
mainline_dtc_overlays
mainline_of_fixes
mainline_pdev_fixes
mainline_dma_devel
mainline_mmc_fixes
mainline_dts_fixes
mainline_i2c_fixes
mainline_pinctrl_fixes
mainline_capemgr
mainline_reset
mainline_capes

echo "patch.sh ran successful"
