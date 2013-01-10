#!/bin/bash
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
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

am33x () {
	echo "dir: dma"
	${git} "${DIR}/patches/dma/0001-video-st7735fb-add-st7735-framebuffer-driver.patch"
	${git} "${DIR}/patches/dma/0002-dmaengine-add-helper-function-to-request-a-slave-DMA.patch"
	${git} "${DIR}/patches/dma/0003-of-Add-generic-device-tree-DMA-helpers.patch"
	${git} "${DIR}/patches/dma/0004-of-dma-fix-build-break-for-CONFIG_OF.patch"
	${git} "${DIR}/patches/dma/0005-of-dma-fix-typos-in-generic-dma-binding-definition.patch"
	${git} "${DIR}/patches/dma/0006-dmaengine-fix-build-failure-due-to-missing-semi-colo.patch"
	${git} "${DIR}/patches/dma/0007-dmaengine-edma-fix-slave-config-dependency-on-direct.patch"
	${git} "${DIR}/patches/dma/0008-ARM-davinci-move-private-EDMA-API-to-arm-common.patch"
	${git} "${DIR}/patches/dma/0009-ARM-edma-remove-unused-transfer-controller-handlers.patch"
	${git} "${DIR}/patches/dma/0010-ARM-edma-add-DT-and-runtime-PM-support-for-AM33XX.patch"
	${git} "${DIR}/patches/dma/0011-ARM-edma-add-AM33XX-crossbar-event-support.patch"
	${git} "${DIR}/patches/dma/0012-dmaengine-edma-enable-build-for-AM33XX.patch"
	${git} "${DIR}/patches/dma/0013-dmaengine-edma-Add-TI-EDMA-device-tree-binding.patch"
	${git} "${DIR}/patches/dma/0014-ARM-dts-add-AM33XX-EDMA-support.patch"
	${git} "${DIR}/patches/dma/0015-dmaengine-add-dma_request_slave_channel_compat.patch"
	${git} "${DIR}/patches/dma/0016-mmc-omap_hsmmc-convert-to-dma_request_slave_channel_.patch"
	${git} "${DIR}/patches/dma/0017-mmc-omap_hsmmc-limit-max_segs-with-the-EDMA-DMAC.patch"
	${git} "${DIR}/patches/dma/0018-mmc-omap_hsmmc-add-generic-DMA-request-support-to-th.patch"
	${git} "${DIR}/patches/dma/0019-ARM-dts-add-AM33XX-MMC-support.patch"
	${git} "${DIR}/patches/dma/0020-spi-omap2-mcspi-convert-to-dma_request_slave_channel.patch"
	${git} "${DIR}/patches/dma/0021-spi-omap2-mcspi-add-generic-DMA-request-support-to-t.patch"
	${git} "${DIR}/patches/dma/0022-ARM-dts-add-AM33XX-SPI-support.patch"
	${git} "${DIR}/patches/dma/0023-Documentation-bindings-add-spansion.patch"
	${git} "${DIR}/patches/dma/0024-ARM-dts-add-BeagleBone-Adafruit-1.8-LCD-support.patch"
	${git} "${DIR}/patches/dma/0025-misc-add-gpevt-driver.patch"
	${git} "${DIR}/patches/dma/0026-ARM-dts-add-BeagleBone-gpevt-support.patch"
	${git} "${DIR}/patches/dma/0027-misc-gpevt-null-terminate-the-of_match_table.patch"
	${git} "${DIR}/patches/dma/0028-proposed-probe-fix-works-for-me-on-evm.patch"
	${git} "${DIR}/patches/dma/0029-am33xx-remove-duplicate-SPI-nodes.patch"

	echo "dir: pinctrl"
	${git} "${DIR}/patches/pinctrl/0001-i2c-pinctrl-ify-i2c-omap.c.patch"
	${git} "${DIR}/patches/pinctrl/0002-arm-dts-AM33XX-Configure-pinmuxs-for-user-leds-contr.patch"
	${git} "${DIR}/patches/pinctrl/0003-beaglebone-DT-set-default-triggers-for-LEDS.patch"
	${git} "${DIR}/patches/pinctrl/0004-beaglebone-add-a-cpu-led-trigger.patch"

	echo "dir: cpufreq"
	${git} "${DIR}/patches/cpufreq/0001-am33xx-DT-add-commented-out-OPP-values-for-ES2.0.patch"

	echo "dir: adc"
	${git} "${DIR}/patches/adc/0001-input-ti_am335x_tsc-Make-steps-enable-configurable.patch"
	${git} "${DIR}/patches/adc/0002-input-ti_am335x_tsc-Order-of-TSC-wires-connect-made-.patch"
	${git} "${DIR}/patches/adc/0003-input-ti_am335x_tsc-Add-variance-filters.patch"
	${git} "${DIR}/patches/adc/0004-ti_tscadc-Update-with-IIO-map-interface-deal-with-pa.patch"
	${git} "${DIR}/patches/adc/0005-ti_tscadc-Match-mfd-sub-devices-to-regmap-interface.patch"

	echo "dir: pwm"
	${git} "${DIR}/patches/pwm/0001-ARM-OMAP3-hwmod-Corrects-resource-data-for-PWM-devic.patch"
	${git} "${DIR}/patches/pwm/0002-pwm_backlight-Add-device-tree-support-for-Low-Thresh.patch"
	${git} "${DIR}/patches/pwm/0003-Control-module-EHRPWM-clk-enabling.patch"
	${git} "${DIR}/patches/pwm/0004-pwm-pwm_test-Driver-support-for-PWM-module-testing.patch"
	${git} "${DIR}/patches/pwm/0005-ARM-OMAP2-PWM-limit-am33xx_register_ehrpwm-to-soc_is.patch"
	${git} "${DIR}/patches/pwm/0006-pwm-export-of_pwm_request.patch"

	echo "dir: i2c"
	${git} "${DIR}/patches/i2c/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
	${git} "${DIR}/patches/i2c/0002-Bone-DTS-working-i2c2-i2c3-in-the-tree.patch"
	${git} "${DIR}/patches/i2c/0003-am33xx-Convert-I2C-from-omap-to-am33xx-names.patch"
	${git} "${DIR}/patches/i2c/0004-am335x-evm-hack-around-i2c-node-names.patch"

	echo "dir: da8xx-fb"
	${git} "${DIR}/patches/da8xx-fb/0001-da8xx-Allow-use-by-am33xx-based-devices.patch"
	${git} "${DIR}/patches/da8xx-fb/0002-da8xx-De-constify-members-in-the-platform-config.patch"
	${git} "${DIR}/patches/da8xx-fb/0003-da8xx-Add-standard-panel-definition.patch"
	${git} "${DIR}/patches/da8xx-fb/0004-da8xx-Add-CDTech_S035Q01-panel-used-by-LCD3-bone-cap.patch"
	${git} "${DIR}/patches/da8xx-fb/0005-da8xx-fb-add-panel-definition-for-beaglebone-LCD7-ca.patch"
	${git} "${DIR}/patches/da8xx-fb/0006-video-da8xx-fb-fb_check_var-enhancement.patch"
	${git} "${DIR}/patches/da8xx-fb/0007-Update-to-latest-PSP-kernel-changes.patch"

	echo "dir: mmc"
	${git} "${DIR}/patches/mmc/0001-am33xx.dtsi-enable-MMC-HSPE-bit-for-all-3-controller.patch"
	${git} "${DIR}/patches/mmc/0002-omap-hsmmc-Correct-usage-of-of_find_node_by_name.patch"

	echo "dir: 6lowpan"
	${git} "${DIR}/patches/6lowpan/0001-6lowpan-lowpan_is_iid_16_bit_compressable-does-not-d.patch"
	${git} "${DIR}/patches/6lowpan/0002-6lowpan-next-header-is-not-properly-set-upon-decompr.patch"
	${git} "${DIR}/patches/6lowpan/0003-6lowpan-always-enable-link-layer-acknowledgments.patch"
	${git} "${DIR}/patches/6lowpan/0004-mac802154-turn-on-ACK-when-enabled-by-the-upper-laye.patch"
	${git} "${DIR}/patches/6lowpan/0005-6lowpan-use-short-IEEE-802.15.4-addresses-for-broadc.patch"
	${git} "${DIR}/patches/6lowpan/0006-6lowpan-fix-first-fragment-FRAG1-handling.patch"
	${git} "${DIR}/patches/6lowpan/0007-6lowpan-store-fragment-tag-values-per-device-instead.patch"
	${git} "${DIR}/patches/6lowpan/0008-6lowpan-obtain-IEEE802.15.4-sequence-number-from-the.patch"
	${git} "${DIR}/patches/6lowpan/0009-6lowpan-add-a-new-parameter-in-sysfs-to-turn-on-off-.patch"
	${git} "${DIR}/patches/6lowpan/0010-6lowpan-use-the-PANID-provided-by-the-device-instead.patch"
	${git} "${DIR}/patches/6lowpan/0011-6lowpan-modify-udp-compression-uncompression-to-matc.patch"
	${git} "${DIR}/patches/6lowpan/0012-6lowpan-make-memory-allocation-atomic-during-6lowpan.patch"
	${git} "${DIR}/patches/6lowpan/0013-mac802154-make-mem-alloc-ATOMIC-to-prevent-schedulin.patch"
	${git} "${DIR}/patches/6lowpan/0014-mac802154-remove-unnecessary-spinlocks.patch"
	${git} "${DIR}/patches/6lowpan/0015-mac802154-re-introduce-MAC-primitives-required-to-se.patch"
	${git} "${DIR}/patches/6lowpan/0016-serial-initial-import-of-the-IEEE-802.15.4-serial-dr.patch"

	echo "dir: capebus"
	${git} "${DIR}/patches/capebus/0001-i2c-EEPROM-Export-memory-accessor.patch"
	${git} "${DIR}/patches/capebus/0002-omap-Export-omap_hwmod_lookup-omap_device_build-omap.patch"
	${git} "${DIR}/patches/capebus/0003-gpio-keys-Pinctrl-fy.patch"
	${git} "${DIR}/patches/capebus/0004-tps65217-Allow-placement-elsewhere-than-parent-mfd-d.patch"
	${git} "${DIR}/patches/capebus/0005-i2c-Export-capability-to-probe-devices.patch"
	${git} "${DIR}/patches/capebus/0006-pwm-backlight-Pinctrl-fy.patch"
	${git} "${DIR}/patches/capebus/0007-spi-Export-OF-interfaces-for-capebus-use.patch"
	${git} "${DIR}/patches/capebus/0008-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/capebus/0009-beaglebone-create-a-shared-dtsi-for-beaglebone-based.patch"
	${git} "${DIR}/patches/capebus/0010-beaglebone-enable-emmc-for-bonelt.patch"
	${git} "${DIR}/patches/capebus/0011-ti-tscadc-dt-Create-ti-tscadc-dt-DT-adapter-device.patch"
	${git} "${DIR}/patches/capebus/0012-capebus-Add-beaglebone-board-support.patch"
	${git} "${DIR}/patches/capebus/0013-capebus-Beaglebone-generic-cape-support.patch"
	${git} "${DIR}/patches/capebus/0014-Fix-appended-dtb-rule.patch"
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

	#Status: v2 Review:
	#http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/112440.html
	${git} "${DIR}/patches/arm/0002-arm-add-definition-of-strstr-to-decompress.c.patch"
	${git} "${DIR}/patches/arm/0003-Without-MACH_-option-Early-printk-DEBUG_LL.patch"
}

omap () {
	echo "dir: omap"
	${git} "${DIR}/patches/omap/0001-mach-omap2-board-igep0020.c-Fix-reboot-problem.patch"

	#Fixes 800Mhz boot lockup: http://www.spinics.net/lists/linux-omap/msg83737.html
	${git} "${DIR}/patches/omap/0002-regulator-core-if-voltage-scaling-fails-restore-orig.patch"

	echo "dir: omap/sakoman"
	${git} "${DIR}/patches/omap_sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	${git} "${DIR}/patches/omap_sakoman/0002-video-add-timings-for-hd720.patch"

	echo "dir: omap/beagle/expansion"
	${git} "${DIR}/patches/omap_beagle_expansion/0001-Beagle-expansion-add-buddy-param-for-expansionboard-.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0002-Beagle-expansion-add-zippy.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0003-Beagle-expansion-add-zippy2.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0004-Beagle-expansion-add-trainer.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0005-Beagle-expansion-add-CircuitCo-ulcd-Support.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0006-Beagle-expansion-add-wifi.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0007-Beagle-expansion-add-beaglefpga.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0008-Beagle-expansion-add-spidev.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0009-Beagle-expansion-add-Aptina-li5m03-camera.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0010-Beagle-expansion-add-LSR-COM6L-Adapter-Board.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0011-Beagle-expansion-LSR-COM6L-Adapter-Board-also-initia.patch"

	echo "dir: omap/beagle"
	#Status: for meego guys..
	${git} "${DIR}/patches/omap_beagle/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

	${git} "${DIR}/patches/omap_beagle/0002-backlight-Add-TLC59108-backlight-control-driver.patch"
	${git} "${DIR}/patches/omap_beagle/0003-tlc59108-adjust-for-beagleboard-uLCD7.patch"

	#Status: not for upstream
	${git} "${DIR}/patches/omap_beagle/0004-zeroMAP-Open-your-eyes.patch"

	${git} "${DIR}/patches/omap_beagle/0005-ARM-OMAP-Beagle-C4-fix-reboot-problem.patch"

	echo "dir: omap/panda"
	#Status: not for upstream: push device tree version upstream...
	${git} "${DIR}/patches/omap_panda/0001-panda-fix-wl12xx-regulator.patch"
	#Status: unknown: cherry picked from linaro
	${git} "${DIR}/patches/omap_panda/0002-ti-st-st-kim-fixing-firmware-path.patch"
}

am33x_after () {
	echo "dir: net"
	${git} "${DIR}/patches/net/0001-Attempted-SMC911x-BQL-patch.patch"

	echo "dir: merge"
	${git} "${DIR}/patches/merge/0001-merge-cleanup-ispvideo.c-remove-includes.patch"
	${git} "${DIR}/patches/merge/0002-merge-clock-and-omap_device-includes-in-board-direct.patch"
	${git} "${DIR}/patches/merge/0003-usb-musb-dsps-header-movement-build-error-fix.patch"

	echo "dir: drm"
	${git} "${DIR}/patches/drm/0001-add-dvi-pinmuxes-to-am33xx.dtsi.patch"
	${git} "${DIR}/patches/drm/0002-drm-cma-add-debugfs-helpers.patch"
	${git} "${DIR}/patches/drm/0003-drm-small-fix-in-drm_send_vblank_event.patch"
	${git} "${DIR}/patches/drm/0004-drm-i2c-encoder-helper-wrappers.patch"
	${git} "${DIR}/patches/drm/0005-drm-nouveau-use-i2c-encoder-helper-wrappers.patch"
	${git} "${DIR}/patches/drm/0006-RFC-drm-lcdc-add-TI-LCD-Controller-DRM-driver-v2.patch"
	${git} "${DIR}/patches/drm/0007-RFC-drm-lcdc-add-support-for-LCD-panels-v2.patch"
	${git} "${DIR}/patches/drm/0008-RFC-drm-i2c-nxp-tda998x.patch"
	${git} "${DIR}/patches/drm/0009-RFC-drm-lcdc-add-encoder-slave.patch"

	echo "dir: not-capebus"
	${git} "${DIR}/patches/not-capebus/0001-am33xx-musb-Add-OF-definitions.patch"
	${git} "${DIR}/patches/not-capebus/0002-da8xx-dt-Create-da8xx-DT-adapter-device.patch"
	${git} "${DIR}/patches/not-capebus/0003-ti-tscadc-dt-Create-ti-tscadc-dt-DT-adapter-device.patch"
	${git} "${DIR}/patches/not-capebus/0004-Mark-the-device-as-PRIVATE.patch"
	${git} "${DIR}/patches/not-capebus/0005-omap_hsmmc-Bug-fixes-pinctl-gpio-reset.patch"
	${git} "${DIR}/patches/not-capebus/0006-tps65217-bl-Locate-backlight-node-correctly.patch"
	${git} "${DIR}/patches/not-capebus/0007-arm-Export-cache-flush-management-symbols-when-MULTI.patch"
	${git} "${DIR}/patches/not-capebus/0008-am335x-bone-dtsi-Clean-up.patch"
	${git} "${DIR}/patches/not-capebus/0009-am335x-bone-dtsi-Introduce-new-I2C-entries.patch"
	${git} "${DIR}/patches/not-capebus/0010-am335x-dt-Add-I2C0-pinctrl-entries.patch"
	${git} "${DIR}/patches/not-capebus/0011-omap3beagle-compile-fix.patch"
	${git} "${DIR}/patches/not-capebus/0012-Cleanup-am33xx.dtsi.patch"
	${git} "${DIR}/patches/not-capebus/0013-Fix-platform-device-resource-linking.patch"
	${git} "${DIR}/patches/not-capebus/0014-Link-platform-device-resources-properly.patch"
	${git} "${DIR}/patches/not-capebus/0015-Properly-handle-resources-for-omap_devices.patch"
	${git} "${DIR}/patches/not-capebus/0016-omap-DT-node-Timer-iteration-fix.patch"
	${git} "${DIR}/patches/not-capebus/0017-omap-Avoid-crashes-in-the-case-of-hwmod-misconfigura.patch"
	${git} "${DIR}/patches/not-capebus/0018-i2c-EEPROM-In-kernel-memory-accessor-interface.patch"
	${git} "${DIR}/patches/not-capebus/0019-Fix-util_is_printable_string.patch"
	${git} "${DIR}/patches/not-capebus/0020-fdtdump-properly-handle-multi-string-properties.patch"
	${git} "${DIR}/patches/not-capebus/0021-dtc-Dynamic-symbols-fixup-support.patch"
	${git} "${DIR}/patches/not-capebus/0022-dtc-Add-DTCO-rule-for-DTB-objects.patch"
	${git} "${DIR}/patches/not-capebus/0023-OF-Compile-Device-Tree-sources-with-resolve-option.patch"
	${git} "${DIR}/patches/not-capebus/0024-firmware-update-.gitignore-with-dtbo-objects.patch"
	${git} "${DIR}/patches/not-capebus/0025-OF-Introduce-device-tree-node-flag-helpers.patch"
	${git} "${DIR}/patches/not-capebus/0026-OF-export-of_property_notify.patch"
	${git} "${DIR}/patches/not-capebus/0027-OF-Export-all-DT-proc-update-functions.patch"
	${git} "${DIR}/patches/not-capebus/0028-OF-Introduce-utility-helper-functions.patch"
	${git} "${DIR}/patches/not-capebus/0029-OF-Introduce-Device-Tree-resolve-support.patch"
	${git} "${DIR}/patches/not-capebus/0030-OF-Introduce-DT-overlay-support.patch"
	${git} "${DIR}/patches/not-capebus/0031-capemgr-Capemgr-makefiles-and-Kconfig-fragments.patch"
	${git} "${DIR}/patches/not-capebus/0032-capemgr-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/not-capebus/0033-capemgr-Add-beaglebone-s-cape-driver-bindings.patch"
	${git} "${DIR}/patches/not-capebus/0034-capemgr-am33xx-family-DT-bindings.patch"
	${git} "${DIR}/patches/not-capebus/0035-bone-geiger-Geiger-bone-driver.patch"
	${git} "${DIR}/patches/not-capebus/0036-capemgr-firmware-makefiles-for-DT-objects.patch"
	${git} "${DIR}/patches/not-capebus/0037-capemgr-emmc2-cape-definition.patch"
	${git} "${DIR}/patches/not-capebus/0038-capemgr-DVI-capes-definitions.patch"
	${git} "${DIR}/patches/not-capebus/0039-capemgr-Geiger-cape-definition.patch"
	${git} "${DIR}/patches/not-capebus/0040-capemgr-LCD3-cape-definition.patch"
	${git} "${DIR}/patches/not-capebus/0041-capemgr-Add-weather-cape-definition.patch"
	${git} "${DIR}/patches/not-capebus/0042-of-add-helper-to-parse-display-timings.patch"
	${git} "${DIR}/patches/not-capebus/0043-video-add-display_timing-struct-and-helpers.patch"
	${git} "${DIR}/patches/not-capebus/0044-OF-display-timings-helper-convert-to-get-child-node.patch"
	${git} "${DIR}/patches/not-capebus/0045-am33xx-Add-clock-for-the-lcdc-DRM-driver.patch"
	${git} "${DIR}/patches/not-capebus/0046-lcd3-cape-Change-into-using-the-lcdc-DRM-driver-inst.patch"
	${git} "${DIR}/patches/not-capebus/0047-ehrpwm-add-missing-dts-nodes.patch"
	${git} "${DIR}/patches/not-capebus/0048-ARM-am33xx-Fix-the-PWM-clocks-mess.patch"
	${git} "${DIR}/patches/not-capebus/0049-am33xx-DT-Update-am33xx.dsi-with-the-new-PWM-DT-bind.patch"
	${git} "${DIR}/patches/not-capebus/0050-geiger-cape-Update-to-using-the-new-PWM-interface.patch"
	${git} "${DIR}/patches/not-capebus/0051-am33xx_tsc_adc-DTify-all-the-drivers.patch"
	${git} "${DIR}/patches/not-capebus/0052-lcd3-cape-Convert-to-using-the-proper-touchscreen-dr.patch"
	${git} "${DIR}/patches/not-capebus/0053-geiger-cape-Convert-to-using-the-new-ADC-driver.patch"
}

am33x
arm
omap
am33x_after

echo "patch.sh ran successful"
