#!/bin/bash
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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

#git="git am"
git="git am --whitespace=fix"

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
	${git} "${DIR}/patches/dma/0002-regulator-tps65910-fix-BUG_ON-shown-with-vrtc-regula.patch"
	${git} "${DIR}/patches/dma/0003-dmaengine-add-helper-function-to-request-a-slave-DMA.patch"
	${git} "${DIR}/patches/dma/0004-of-Add-generic-device-tree-DMA-helpers.patch"
	${git} "${DIR}/patches/dma/0005-of-dma-fix-build-break-for-CONFIG_OF.patch"
	${git} "${DIR}/patches/dma/0006-of-dma-fix-typos-in-generic-dma-binding-definition.patch"
	${git} "${DIR}/patches/dma/0007-dmaengine-fix-build-failure-due-to-missing-semi-colo.patch"
	${git} "${DIR}/patches/dma/0008-dmaengine-edma-fix-slave-config-dependency-on-direct.patch"
	${git} "${DIR}/patches/dma/0009-ARM-davinci-move-private-EDMA-API-to-arm-common.patch"
	${git} "${DIR}/patches/dma/0010-ARM-edma-remove-unused-transfer-controller-handlers.patch"
	${git} "${DIR}/patches/dma/0011-ARM-edma-add-DT-and-runtime-PM-support-for-AM33XX.patch"
	${git} "${DIR}/patches/dma/0012-ARM-edma-add-AM33XX-crossbar-event-support.patch"
	${git} "${DIR}/patches/dma/0013-dmaengine-edma-enable-build-for-AM33XX.patch"
	${git} "${DIR}/patches/dma/0014-dmaengine-edma-Add-TI-EDMA-device-tree-binding.patch"
	${git} "${DIR}/patches/dma/0015-ARM-dts-add-AM33XX-EDMA-support.patch"
	${git} "${DIR}/patches/dma/0016-dmaengine-add-dma_request_slave_channel_compat.patch"
	${git} "${DIR}/patches/dma/0017-mmc-omap_hsmmc-convert-to-dma_request_slave_channel_.patch"
	${git} "${DIR}/patches/dma/0018-mmc-omap_hsmmc-limit-max_segs-with-the-EDMA-DMAC.patch"
	${git} "${DIR}/patches/dma/0019-mmc-omap_hsmmc-add-generic-DMA-request-support-to-th.patch"
	${git} "${DIR}/patches/dma/0020-ARM-dts-add-AM33XX-MMC-support.patch"
	${git} "${DIR}/patches/dma/0021-spi-omap2-mcspi-convert-to-dma_request_slave_channel.patch"
	${git} "${DIR}/patches/dma/0022-spi-omap2-mcspi-add-generic-DMA-request-support-to-t.patch"
	${git} "${DIR}/patches/dma/0023-ARM-dts-add-AM33XX-SPI-support.patch"
	${git} "${DIR}/patches/dma/0024-Documentation-bindings-add-spansion.patch"
	${git} "${DIR}/patches/dma/0025-ARM-dts-add-BeagleBone-Adafruit-1.8-LCD-support.patch"
	${git} "${DIR}/patches/dma/0026-misc-add-gpevt-driver.patch"
	${git} "${DIR}/patches/dma/0027-ARM-dts-add-BeagleBone-gpevt-support.patch"
	${git} "${DIR}/patches/dma/0028-misc-gpevt-null-terminate-the-of_match_table.patch"
	${git} "${DIR}/patches/dma/0029-proposed-probe-fix-works-for-me-on-evm.patch"
	${git} "${DIR}/patches/dma/0030-am33xx-remove-duplicate-SPI-nodes.patch"

	echo "dir: pinctrl"
	${git} "${DIR}/patches/pinctrl/0001-i2c-pinctrl-ify-i2c-omap.c.patch"
	${git} "${DIR}/patches/pinctrl/0002-arm-dts-AM33XX-Configure-pinmuxs-for-user-leds-contr.patch"
	${git} "${DIR}/patches/pinctrl/0003-beaglebone-DT-set-default-triggers-for-LEDS.patch"
	${git} "${DIR}/patches/pinctrl/0004-beaglebone-add-a-cpu-led-trigger.patch"

	echo "dir: cpufreq"
	${git} "${DIR}/patches/cpufreq/0001-am33xx-DT-add-commented-out-OPP-values-for-ES2.0.patch"

	echo "dir: adc"
	${git} "${DIR}/patches/adc/0001-input-TSC-ti_tscadc-Correct-register-usage.patch"
	${git} "${DIR}/patches/adc/0002-input-TSC-ti_tscadc-Add-Step-configuration-as-platfo.patch"
	${git} "${DIR}/patches/adc/0003-input-TSC-ti_tscadc-set-FIFO0-threshold-Interrupt.patch"
	${git} "${DIR}/patches/adc/0004-input-TSC-ti_tscadc-Remove-definition-of-End-Of-Inte.patch"
	${git} "${DIR}/patches/adc/0005-input-TSC-ti_tscadc-Rename-the-existing-touchscreen-.patch"
	${git} "${DIR}/patches/adc/0006-MFD-ti_tscadc-Add-support-for-TI-s-TSC-ADC-MFDevice.patch"
	${git} "${DIR}/patches/adc/0007-input-TSC-ti_tsc-Convert-TSC-into-a-MFDevice.patch"
	${git} "${DIR}/patches/adc/0008-IIO-ADC-tiadc-Add-support-of-TI-s-ADC-driver.patch"
	${git} "${DIR}/patches/adc/0009-input-ti_am335x_tsc-Make-steps-enable-configurable.patch"
	${git} "${DIR}/patches/adc/0010-input-ti_am335x_tsc-Order-of-TSC-wires-connect-made-.patch"
	${git} "${DIR}/patches/adc/0011-input-ti_am335x_tsc-Add-variance-filters.patch"
	${git} "${DIR}/patches/adc/0012-ti_tscadc-Update-with-IIO-map-interface-deal-with-pa.patch"
	${git} "${DIR}/patches/adc/0013-ti_tscadc-Match-mfd-sub-devices-to-regmap-interface.patch"

	echo "dir: pwm"
	${git} "${DIR}/patches/pwm/0001-ARM-OMAP3-hwmod-Corrects-resource-data-for-PWM-devic.patch"
	${git} "${DIR}/patches/pwm/0002-pwm_backlight-Add-device-tree-support-for-Low-Thresh.patch"
	${git} "${DIR}/patches/pwm/0003-pwm-pwm-tiecap-Add-device-tree-binding-support-in-AP.patch"
	${git} "${DIR}/patches/pwm/0004-Control-module-EHRPWM-clk-enabling.patch"
	${git} "${DIR}/patches/pwm/0005-pwm-pwm-tiecap-Enable-clock-gating.patch"
	${git} "${DIR}/patches/pwm/0006-PWM-ti-ehrpwm-fix-up-merge-conflict.patch"
	${git} "${DIR}/patches/pwm/0007-pwm-pwm_test-Driver-support-for-PWM-module-testing.patch"
	${git} "${DIR}/patches/pwm/0008-arm-dts-DT-support-for-EHRPWM-and-ECAP-device.patch"
	${git} "${DIR}/patches/pwm/0009-pwm-pwm-tiehrpwm-Add-device-tree-binding-support-EHR.patch"
	${git} "${DIR}/patches/pwm/0010-ARM-OMAP2-PWM-limit-am33xx_register_ehrpwm-to-soc_is.patch"

	echo "dir: i2c"
	${git} "${DIR}/patches/i2c/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
	${git} "${DIR}/patches/i2c/0002-Bone-DTS-working-i2c2-i2c3-in-the-tree.patch"
	${git} "${DIR}/patches/i2c/0003-am33xx-Convert-I2C-from-omap-to-am33xx-names.patch"
	${git} "${DIR}/patches/i2c/0004-beaglebone-fix-backlight-entry-in-DT.patch"
	${git} "${DIR}/patches/i2c/0005-am335x-evm-hack-around-i2c-node-names.patch"

	echo "dir: da8xx-fb"
	${git} "${DIR}/patches/da8xx-fb/0001-omap2-clk-Add-missing-lcdc-clock-definition.patch"
	${git} "${DIR}/patches/da8xx-fb/0002-da8xx-Allow-use-by-am33xx-based-devices.patch"
	${git} "${DIR}/patches/da8xx-fb/0003-da8xx-Fix-revision-check-on-the-da8xx-driver.patch"
	${git} "${DIR}/patches/da8xx-fb/0004-da8xx-De-constify-members-in-the-platform-config.patch"
	${git} "${DIR}/patches/da8xx-fb/0005-da8xx-Add-standard-panel-definition.patch"
	${git} "${DIR}/patches/da8xx-fb/0006-da8xx-Add-CDTech_S035Q01-panel-used-by-LCD3-bone-cap.patch"
	${git} "${DIR}/patches/da8xx-fb/0007-da8xx-fb-add-panel-definition-for-beaglebone-LCD7-ca.patch"
	${git} "${DIR}/patches/da8xx-fb/0008-video-da8xx-fb-fb_check_var-enhancement.patch"
	${git} "${DIR}/patches/da8xx-fb/0009-video-da8xx-fb-clk_get-on-connection-id-fck.patch"

	echo "dir: mmc"
	${git} "${DIR}/patches/mmc/0001-am33xx.dtsi-enable-MMC-HSPE-bit-for-all-3-controller.patch"
	${git} "${DIR}/patches/mmc/0002-omap-hsmmc-Correct-usage-of-of_find_node_by_name.patch"

	echo "dir: f2fs"
	${git} "${DIR}/patches/f2fs/0001-f2fs-add-document.patch"
	${git} "${DIR}/patches/f2fs/0002-f2fs-add-on-disk-layout.patch"
	${git} "${DIR}/patches/f2fs/0003-f2fs-add-superblock-and-major-in-memory-structure.patch"
	${git} "${DIR}/patches/f2fs/0004-f2fs-add-super-block-operations.patch"
	${git} "${DIR}/patches/f2fs/0005-f2fs-add-checkpoint-operations.patch"
	${git} "${DIR}/patches/f2fs/0006-f2fs-add-node-operations.patch"
	${git} "${DIR}/patches/f2fs/0007-f2fs-add-segment-operations.patch"
	${git} "${DIR}/patches/f2fs/0008-f2fs-add-file-operations.patch"
	${git} "${DIR}/patches/f2fs/0009-f2fs-add-address-space-operations-for-data.patch"
	${git} "${DIR}/patches/f2fs/0010-f2fs-add-core-inode-operations.patch"
	${git} "${DIR}/patches/f2fs/0011-f2fs-add-inode-operations-for-special-inodes.patch"
	${git} "${DIR}/patches/f2fs/0012-f2fs-add-core-directory-operations.patch"
	${git} "${DIR}/patches/f2fs/0013-f2fs-add-xattr-and-acl-functionalities.patch"
	${git} "${DIR}/patches/f2fs/0014-f2fs-add-garbage-collection-functions.patch"
	${git} "${DIR}/patches/f2fs/0015-f2fs-add-recovery-routines-for-roll-forward.patch"
	${git} "${DIR}/patches/f2fs/0016-f2fs-update-Kconfig-and-Makefile.patch"
	${git} "${DIR}/patches/f2fs/0017-f2fs-gc.h-make-should_do_checkpoint-inline.patch"
	${git} "${DIR}/patches/f2fs/0018-f2fs-move-statistics-code-into-one-file.patch"
	${git} "${DIR}/patches/f2fs/0019-f2fs-move-proc-files-to-debugfs.patch"
	${git} "${DIR}/patches/f2fs/0020-f2fs-compile-fix.patch"

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
	${git} "${DIR}/patches/capebus/0005-pwm-export-of_pwm_request.patch"
	${git} "${DIR}/patches/capebus/0006-i2c-Export-capability-to-probe-devices.patch"
	${git} "${DIR}/patches/capebus/0007-pwm-backlight-Pinctrl-fy.patch"
	${git} "${DIR}/patches/capebus/0008-spi-Export-OF-interfaces-for-capebus-use.patch"
	${git} "${DIR}/patches/capebus/0009-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/capebus/0010-beaglebone-create-a-shared-dtsi-for-beaglebone-based.patch"
	${git} "${DIR}/patches/capebus/0011-beaglebone-enable-emmc-for-bonelt.patch"
	${git} "${DIR}/patches/capebus/0012-da8xx-dt-Create-da8xx-DT-adapter-device.patch"
	${git} "${DIR}/patches/capebus/0013-ti-tscadc-dt-Create-ti-tscadc-dt-DT-adapter-device.patch"
	${git} "${DIR}/patches/capebus/0014-capebus-Add-beaglebone-board-support.patch"
	${git} "${DIR}/patches/capebus/0015-capebus-Beaglebone-generic-cape-support.patch"
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

	#Status: v2 Review:
	#http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/112440.html
	${git} "${DIR}/patches/arm/0002-arm-add-definition-of-strstr-to-decompress.c.patch"
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

	echo "dir: spi"
	${git} "${DIR}/patches/spi/0001-spi-spidev-Add-device-tree-bindings.patch"
}

merge () {
	echo "dir: merge"
	${git} "${DIR}/patches/merge/0001-merge-cleanup-ispvideo.c-remove-includes.patch"
#	${git} "${DIR}/patches/merge/0002-merge-clock-and-omap_device-includes-in-board-direct.patch"

}

sprz319_erratum () {
	echo "sprz319 erratum 2.1"
	#Breaks: Beagle C4, hardlocks on bootup...
	#Status: no response from users:
	#https://groups.google.com/forum/#!topic/beagleboard/m7DLkYMKNkg
	${git} "${DIR}/patches/omap_sprz319-erratum-2.1/0001-Fix-sprz319-erratum-2.1.patch"
}

#am33x
arm
omap
#am33x_after
merge

#disabled as it breaks beagle c4...
#sprz319_erratum

echo "patch.sh ran successful"
