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

drivers () {
	echo "dir: drivers"
	${git} "${DIR}/patches/drivers/0001-thermal-add-imx-thermal-driver-support.patch"
	${git} "${DIR}/patches/drivers/0002-ASoC-sglt5000-Provide-the-reg_stride-field.patch"
	${git} "${DIR}/patches/drivers/0003-ASoC-imx-sgtl5000-fix-error-return-code-in-imx_sgtl5.patch"
#v3.11-rc3:
#	${git} "${DIR}/patches/drivers/0004-ASoC-sgtl5000-defer-the-probe-if-clock-is-not-found.patch"
	${git} "${DIR}/patches/drivers/0005-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_dts () {
	echo "dir: imx_dts"
	#With all the imx6*.dtsi changes, its eaiser to just pull the for-next then try to manually rebase
	#https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=shortlog;h=refs/heads/for-next

#v3.11-rc3:
#	${git} "${DIR}/patches/imx_dts/0001-ARM-i.MX53-Fix-UART-pad-configuration.patch"
#	${git} "${DIR}/patches/imx_dts/0002-ARM-imx27-Fix-documentation-for-SPLL-clock.patch"
#	${git} "${DIR}/patches/imx_dts/0003-ARM-i.MX27-Typo-fix.patch"
#	${git} "${DIR}/patches/imx_dts/0004-ARM-i.MX6Q-Fix-IOMUXC-GPR1-defines-for-ENET_CLK_SEL-.patch"
#	${git} "${DIR}/patches/imx_dts/0005-ARM-i.MX6Q-correct-emi_sel-clock-muxing.patch"
#	${git} "${DIR}/patches/imx_dts/0006-ARM-mxs-saif0-is-the-clock-provider-to-sgtl5000.patch"
#	${git} "${DIR}/patches/imx_dts/0007-ARM-imx-fix-vf610-enet-module-clock-selection.patch"
#	${git} "${DIR}/patches/imx_dts/0008-ARM-i.MX53-mba53-Fix-PWM-backlight-DT-node.patch"
	${git} "${DIR}/patches/imx_dts/0009-ARM-dts-imx6dl-add-a-new-pinctrl-for-ecspi1.patch"
	${git} "${DIR}/patches/imx_dts/0010-ARM-dts-imx6q-add-a-new-pinctrl-for-ecspi1.patch"
	${git} "${DIR}/patches/imx_dts/0011-ARM-dts-imx6qdl-sabresd-enable-the-SPI-NOR.patch"
	${git} "${DIR}/patches/imx_dts/0012-apf27dev-add-rtc-ds1374-to-the-device-tree.patch"
	${git} "${DIR}/patches/imx_dts/0013-ARM-dts-imx27-Add-SAHARA2-devicetree-node.patch"
	${git} "${DIR}/patches/imx_dts/0014-ARM-dts-imx27-Add-AUDMUX-devicetree-node.patch"
	${git} "${DIR}/patches/imx_dts/0015-ARM-dts-imx27-Rename-PWM-devicetree-node.patch"
	${git} "${DIR}/patches/imx_dts/0016-ARM-dts-imx27-Sort-entries-by-address.patch"
	${git} "${DIR}/patches/imx_dts/0017-ARM-dts-imx27-phytec-phycore-som-Define-minimal-memo.patch"
	${git} "${DIR}/patches/imx_dts/0018-ARM-dts-imx27-Add-kpp-devicetree-node.patch"
	${git} "${DIR}/patches/imx_dts/0019-ARM-dts-i.MX6-sync-imx6q-and-imx6dl-pinmux-entries.patch"
	${git} "${DIR}/patches/imx_dts/0020-ARM-dts-i.MX6qdl-Add-compatible-and-clock-to-flexcan.patch"
	${git} "${DIR}/patches/imx_dts/0021-ARM-dts-i.MX6qdl-Add-i.MX31-compatible-to-gpt-node.patch"
	${git} "${DIR}/patches/imx_dts/0022-ARM-dts-i.MX27-Add-iim-node.patch"
	${git} "${DIR}/patches/imx_dts/0023-ARM-dts-i.MX31-Add-iim-node.patch"
	${git} "${DIR}/patches/imx_dts/0024-ARM-dts-i.MX25-Add-iim-node.patch"
	${git} "${DIR}/patches/imx_dts/0025-ARM-dts-i.MX51-Add-iim-node.patch"
	${git} "${DIR}/patches/imx_dts/0026-ARM-dts-i.MX53-Add-iim-node.patch"
	${git} "${DIR}/patches/imx_dts/0027-ARM-dts-i.MX25-Add-i2c-and-spi-aliases.patch"
	${git} "${DIR}/patches/imx_dts/0028-ARM-dts-i.MX27-Add-i2c-aliases.patch"
	${git} "${DIR}/patches/imx_dts/0029-ARM-dts-i.MX51-Add-i2c-and-spi-aliases.patch"
	${git} "${DIR}/patches/imx_dts/0030-ARM-dts-i.MX53-Add-i2c-and-spi-aliases.patch"
	${git} "${DIR}/patches/imx_dts/0031-ARM-dts-i.MX6-Add-i2c-and-spi-aliases.patch"
	${git} "${DIR}/patches/imx_dts/0032-ARM-dts-i.MX51-move-kpp-pinmux-entry.patch"
	${git} "${DIR}/patches/imx_dts/0033-ARM-dts-i.MX51-babbage-Add-spi-cs-high-property-to-p.patch"
	${git} "${DIR}/patches/imx_dts/0034-ARM-dts-i.MX51-Add-USB-host1-2-pinmux-entries.patch"
	${git} "${DIR}/patches/imx_dts/0035-ARM-imx27-Use-AITC-for-the-interrupt-controller-name.patch"
	${git} "${DIR}/patches/imx_dts/0036-ARM-dts-imx27-Add-imx-framebuffer-device.patch"
	${git} "${DIR}/patches/imx_dts/0037-ARM-dts-imx27-Add-1-wire.patch"
	${git} "${DIR}/patches/imx_dts/0038-ARM-dts-imx27-cpufreq-cpu0-frequencies.patch"
	${git} "${DIR}/patches/imx_dts/0039-ARM-dts-Add-device-tree-support-for-phycard-pca100.patch"
	${git} "${DIR}/patches/imx_dts/0040-ARM-dts-add-sram-for-imx53-and-imx6q.patch"
	${git} "${DIR}/patches/imx_dts/0041-ARM-dts-mx53qsb-Enable-VPU-support.patch"
	${git} "${DIR}/patches/imx_dts/0042-ARM-i.MX6DL-dts-add-clock-and-mux-configuration-for-.patch"
	${git} "${DIR}/patches/imx_dts/0043-ARM-dts-imx-add-dma-cells-property-for-sdma.patch"
	${git} "${DIR}/patches/imx_dts/0044-ARM-dts-i.MX27-Move-IIM-node-under-AIPI2-bus.patch"
	${git} "${DIR}/patches/imx_dts/0045-ARM-dts-i.MX27-Add-WEIM-node.patch"
	${git} "${DIR}/patches/imx_dts/0046-ARM-dts-imx27-phytec-phycore-som-Add-WEIM-node.patch"
	${git} "${DIR}/patches/imx_dts/0047-ARM-dts-imx27-phytec-phycore-som-Add-SRAM-node.patch"
	${git} "${DIR}/patches/imx_dts/0048-ARM-dts-imx27-phytec-phycore-rdk-Add-CAN-node.patch"
	${git} "${DIR}/patches/imx_dts/0049-ARM-dts-imx27-phytec-phycore-som-Using-labels-for-re.patch"
	${git} "${DIR}/patches/imx_dts/0050-ARM-dts-imx27-phyCARD-S-remove-wrong-I2C-RTC.patch"
	${git} "${DIR}/patches/imx_dts/0051-ARM-dts-imx6dl-wandboard-Add-audio-support.patch"
	${git} "${DIR}/patches/imx_dts/0052-ARM-dts-imx-Add-the-missing-cpus-node.patch"
	${git} "${DIR}/patches/imx_dts/0053-ARM-dts-imx27-phyCARD-S-SOM-remove-wrong-i2c-sensor.patch"
	${git} "${DIR}/patches/imx_dts/0054-ARM-dts-imx27-phyCARD-S-move-i2c1-and-owire-to-rdk.patch"
	${git} "${DIR}/patches/imx_dts/0055-ARM-dts-imx27-phyCARD-S-i2c-ADC-device-node.patch"
	${git} "${DIR}/patches/imx_dts/0056-ARM-dts-imx6sl-add-fsl-imx6q-uart-for-uart-compatibl.patch"
	${git} "${DIR}/patches/imx_dts/0057-ARM-dts-imx6q-dl-add-DTE-pads-for-uart.patch"
	${git} "${DIR}/patches/imx_dts/0058-ARM-dts-imx6q-dl-add-a-DTE-uart-pinctrl-for-uart2.patch"
	${git} "${DIR}/patches/imx_dts/0059-ARM-dts-enable-the-uart2-for-imx6q-arm2.patch"
	${git} "${DIR}/patches/imx_dts/0060-ARM-dts-imx-share-pad-macro-names-between-imx6q-and-.patch"
	${git} "${DIR}/patches/imx_dts/0061-ARM-dts-add-more-imx6q-dl-pin-groups.patch"
	${git} "${DIR}/patches/imx_dts/0062-ARM-dts-imx6qdl-add-a-new-pinctrl-for-uart3.patch"
	${git} "${DIR}/patches/imx_dts/0063-ARM-dts-imx25-Make-lcdc-compatible-to-imx21-fb.patch"
	${git} "${DIR}/patches/imx_dts/0064-ARM-dts-imx6qdl-imx6sl-add-the-dma-property-for-uart.patch"
	${git} "${DIR}/patches/imx_dts/0065-ARM-dts-imx6qdl.dtsi-Add-usdhc1-pin-groups.patch"
	${git} "${DIR}/patches/imx_dts/0066-ARM-dts-imx6qdl.dtsi-Add-another-uart3-pin-group.patch"
	${git} "${DIR}/patches/imx_dts/0067-ARM-dts-imx6dl-wandboard-Add-SDHC1-and-SDHC2-ports.patch"
	${git} "${DIR}/patches/imx_dts/0068-ARM-dts-imx6dl-wandboard-Add-support-for-UART3.patch"
	${git} "${DIR}/patches/imx_dts/0069-ARM-dts-i.MX51-Add-WEIM-node.patch"
	${git} "${DIR}/patches/imx_dts/0070-ARM-dts-imx27-Add-core-voltages.patch"

#v3.11-rc3
#	${git} "${DIR}/patches/imx_dts/0071-ARM-dts-imx51-babbage-Pass-a-real-clock-to-the-codec.patch"

	${git} "${DIR}/patches/imx_dts/0072-ARM-dtsi-enable-ahci-sata-on-imx6q-platforms.patch"
	${git} "${DIR}/patches/imx_dts/0073-drivers-bus-imx-weim-Remove-private-driver-data.patch"
	${git} "${DIR}/patches/imx_dts/0074-drivers-bus-imx-weim-Simplify-error-path.patch"
	${git} "${DIR}/patches/imx_dts/0075-drivers-bus-imx-weim-use-module_platform_driver_prob.patch"
	${git} "${DIR}/patches/imx_dts/0076-drivers-bus-imx-weim-Add-missing-platform_driver.own.patch"
	${git} "${DIR}/patches/imx_dts/0077-drivers-bus-imx-weim-Add-support-for-i.MX1-21-25-27-.patch"
	${git} "${DIR}/patches/imx_dts/0078-ARM-i.MX6-call-ksz9021-phy-fixup-for-all-i.MX6-board.patch"
	${git} "${DIR}/patches/imx_dts/0079-ARM-i.MX6-add-ethernet-phy-fixup-for-AR8031.patch"
	${git} "${DIR}/patches/imx_dts/0080-ARM-i.MX6-add-ethernet-phy-fixup-for-KSZ9031.patch"
	${git} "${DIR}/patches/imx_dts/0081-ARM-imx_v6_v7_defconfig-Select-CONFIG_NOP_USB_XCEIV-.patch"
	${git} "${DIR}/patches/imx_dts/0082-ARM-i.MX6Q-Use-ENET_CLK_SEL-defines-in-imx6q_1588_in.patch"
	${git} "${DIR}/patches/imx_dts/0083-ARM-imx_v6_v7_defconfig-Enable-FSL_LPUART-support.patch"
	${git} "${DIR}/patches/imx_dts/0084-ARM-imx_v6_v7_defconfig-Enable-LVDS-Display-Bridge.patch"
	${git} "${DIR}/patches/imx_dts/0085-ARM-i.MX6DL-parent-LDB-DI-clocks-to-PLL5-on-i.MX6S-D.patch"
	${git} "${DIR}/patches/imx_dts/0086-ARM-imx_v6_v7_defconfig-Enable-VPU-driver.patch"
	${git} "${DIR}/patches/imx_dts/0087-ARM-imx_v4_v5_defconfig-Select-CONFIG_MACH_IMX25_DT.patch"
	${git} "${DIR}/patches/imx_dts/0088-ARM-imx-let-L2-initialization-be-a-common-function.patch"
	${git} "${DIR}/patches/imx_dts/0089-ARM-imx-use-imx-specific-L2-init-function-on-imx6sl.patch"
	${git} "${DIR}/patches/imx_dts/0090-ARM-imx_v6_v7_defconfig-enable-WEIM-driver.patch"
	${git} "${DIR}/patches/imx_dts/0091-ARM-imx-fix-imx_init_l2cache-storage-class.patch"
	${git} "${DIR}/patches/imx_dts/0092-ARM-imx-Select-MIGHT_HAVE_CACHE_L2X0.patch"
	${git} "${DIR}/patches/imx_dts/0093-ARM-imx-add-common-clock-support-for-fixup-div.patch"
	${git} "${DIR}/patches/imx_dts/0094-ARM-imx-add-common-clock-support-for-fixup-mux.patch"
	${git} "${DIR}/patches/imx_dts/0095-ARM-imx6-change-some-clocks-to-fixup-clocks.patch"
	${git} "${DIR}/patches/imx_dts/0096-ARM-imx-clk-pllv3-improve-the-timeout-waiting-method.patch"
	${git} "${DIR}/patches/imx_dts/0097-ARM-mxs-Simplify-detection-of-CrystalFontz-boards.patch"
	${git} "${DIR}/patches/imx_dts/0098-ARM-mxs-dt-Add-Crystalfontz-CFA-10056-device-tree.patch"
	${git} "${DIR}/patches/imx_dts/0099-ARM-mxs-dt-Add-Crystalfontz-CFA-10058-device-tree.patch"
	${git} "${DIR}/patches/imx_dts/0100-ARM-mxs-dt-cfa10037-make-hogpins-grabbed-by-respecti.patch"
	${git} "${DIR}/patches/imx_dts/0101-ARM-mxs-dt-cfa10049-make-hogpins-grabbed-by-respecti.patch"
	${git} "${DIR}/patches/imx_dts/0102-ARM-mxs-dt-cfa10055-make-hogpins-grabbed-by-respecti.patch"
	${git} "${DIR}/patches/imx_dts/0103-ARM-mxs-dt-cfa10057-remove-hogpins.patch"
	${git} "${DIR}/patches/imx_dts/0104-ARM-mxs-dt-cfa10036-make-hogpins-grabbed-by-respecti.patch"
	${git} "${DIR}/patches/imx_dts/0105-ARM-mxs-Add-backlight-support-for-M28EVK.patch"
	${git} "${DIR}/patches/imx_dts/0106-ARM-dts-mxs-remove-old-DMA-binding-data-from-client-.patch"
	${git} "${DIR}/patches/imx_dts/0107-ARM-dts-imx-remove-old-DMA-binding-data-from-gpmi-no.patch"
	${git} "${DIR}/patches/imx_dts/0108-ARM-dts-imx-add-tempmon-node-for-imx6q-thermal-suppo.patch"
	${git} "${DIR}/patches/imx_dts/0109-ARM-mxs-pm-Include-pm.h.patch"
	${git} "${DIR}/patches/imx_dts/0110-ARM-dts-imx23-evk-enable-USB-PHY-and-controller.patch"
	${git} "${DIR}/patches/imx_dts/0111-ARM-dts-imx23-evk-enable-Low-Resolution-ADC.patch"
	${git} "${DIR}/patches/imx_dts/0112-ARM-dts-imx23-olinuxino-enable-Low-Resolution-ADC.patch"
	${git} "${DIR}/patches/imx_dts/0113-ARM-imx-add-low-level-debug-for-vybrid.patch"
	${git} "${DIR}/patches/imx_dts/0114-ARM-dts-imx6-Add-support-for-imx6q-wandboard.patch"
	${git} "${DIR}/patches/imx_dts/0115-ARM-dts-imx6q-wandboard-Add-sata-support.patch"
	${git} "${DIR}/patches/imx_dts/0116-ARM-dts-imx-add-LVDS-panel-for-imx6qdl-sabresd.patch"
	${git} "${DIR}/patches/imx_dts/0117-ARM-dts-imx-use-generic-DMA-bindings-for-SSI-nodes.patch"
	${git} "${DIR}/patches/imx_dts/0118-ARM-imx6q-add-spdif-gate-clock.patch"
	${git} "${DIR}/patches/imx_dts/0119-ARM-imx6q-add-cko2-clocks.patch"
	${git} "${DIR}/patches/imx_dts/0120-ARM-imx6q-add-the-missing-cko-output-selection.patch"
	${git} "${DIR}/patches/imx_dts/0121-ARM-imx6q-remove-board-specific-CLKO-setup.patch"
	${git} "${DIR}/patches/imx_dts/0122-ARM-dts-imx6qdl-sabresd-Allow-buttons-to-wake-up-the.patch"
	${git} "${DIR}/patches/imx_dts/0123-ARM-dts-i.MX27-Using-wdog_ipg_gate-clock-source-for-.patch"
	${git} "${DIR}/patches/imx_dts/0124-ARM-dts-i.MX27-Remove-optional-ptp-clock-source-for-.patch"
	${git} "${DIR}/patches/imx_dts/0125-ARM-dts-i.MX27-Add-label-to-CPU-node.patch"
	${git} "${DIR}/patches/imx_dts/0126-ARM-dts-i.MX27-Increase-clock-latency-value.patch"
	${git} "${DIR}/patches/imx_dts/0127-ARM-dts-i.MX27-Remove-clock-name-from-CPU-node.patch"
	${git} "${DIR}/patches/imx_dts/0128-ARM-dts-imx27-phytec-phycore-som-Fix-regulator-setti.patch"
	${git} "${DIR}/patches/imx_dts/0129-ARM-imx6q-add-vdoa-gate-clock.patch"
	${git} "${DIR}/patches/imx_dts/0130-ARM-dts-mxs-Add-spi-alias.patch"
	${git} "${DIR}/patches/imx_dts/0131-ARM-dts-imx-ocram-size-is-different-between-imx6q-an.patch"
	${git} "${DIR}/patches/imx_dts/0132-ARM-imx-add-ocram-clock-for-imx53.patch"
	${git} "${DIR}/patches/imx_dts/0133-ARM-dts-imx6qdl-sabresd-Add-touchscreen-support.patch"
	${git} "${DIR}/patches/imx_dts/0134-ARM-i.MX6Q-dts-Enable-SPI-NOR-flash-on-Phytec-phyFLE.patch"
	${git} "${DIR}/patches/imx_dts/0135-ARM-i.MX6Q-dts-Enable-I2C1-with-EEPROM-and-PMIC-on-P.patch"
	${git} "${DIR}/patches/imx_dts/0136-ARM-imx_v6_v7_defconfig-Select-CONFIG_TOUCHSCREEN_EG.patch"
	${git} "${DIR}/patches/imx_dts/0137-ARM-dts-imx53-qsb-Make-USBH1-functional.patch"
	${git} "${DIR}/patches/imx_dts/0138-ARM-mach-imx-Select-ARM_CPU_SUSPEND-at-ARCH_MXC-leve.patch"
	${git} "${DIR}/patches/imx_dts/0139-ARM-mx53-Allow-suspend-resume.patch"
	${git} "${DIR}/patches/imx_dts/0140-ARM-i.MX5-clocks-Remove-optional-clock-setup-CKIH1-f.patch"
	${git} "${DIR}/patches/imx_dts/0141-dts-wandboard-Add-support-for-SDIO-bcm4329.patch"
	${git} "${DIR}/patches/imx_dts/0142-ARM-imx_v6_v7_defconfig-Cleanup-imx_v6_v7_defconfig.patch"
	${git} "${DIR}/patches/imx_dts/0143-ARM-imx_v6_v7_defconfig-Add-SATA-support.patch"
	${git} "${DIR}/patches/imx_dts/0144-ARM-imx_v4_v5_defconfig-Cleanup-imx_v4_v5_defconfig.patch"
	${git} "${DIR}/patches/imx_dts/0145-ARM-mxs_defconfig-Cleanup-mxs_defconfig.patch"
	${git} "${DIR}/patches/imx_dts/0146-ARM-mxs-Allow-DT-clock-providers.patch"
	${git} "${DIR}/patches/imx_dts/0147-ARM-imx_v6_v7_defconfig-Enable-wireless-support.patch"
	${git} "${DIR}/patches/imx_dts/0148-ARM-mxs-Fix-BUG-when-invoking-mxs_restart-from-inter.patch"
	${git} "${DIR}/patches/imx_dts/0149-ARM-dts-i.MX27-Disable-AUDMUX-in-the-template.patch"
	${git} "${DIR}/patches/imx_dts/0150-ARM-dts-imx27-phytec-phycore-som-Enable-AUDMUX.patch"
	${git} "${DIR}/patches/imx_dts/0151-ARM-dtsi-imx6qdl-sabresd-Add-USB-host-1-VBUS-regulat.patch"
	${git} "${DIR}/patches/imx_dts/0152-ARM-dtsi-imx6qdl-sabresd-Add-USB-OTG-vbus-pin-to-pin.patch"
	${git} "${DIR}/patches/imx_dts/0153-ARM-dts-mxs-whitespace-cleanup.patch"
	${git} "${DIR}/patches/imx_dts/0154-ARM-dts-mxs-add-labels-to-most-nodes-for-easier-refe.patch"
	${git} "${DIR}/patches/imx_dts/0155-ARM-dts-mxs-add-another-set-of-saif0_pins-without-MC.patch"
	${git} "${DIR}/patches/imx_dts/0156-ARM-dts-mxs-add-pin-config-for-SSP3-interface.patch"
	${git} "${DIR}/patches/imx_dts/0157-ARM-dts-mxs-add-pin-config-for-LCD-sync-and-clock-pi.patch"
	${git} "${DIR}/patches/imx_dts/0158-ARM-imx-Move-anatop-related-from-board-file-to-anato.patch"
	${git} "${DIR}/patches/imx_dts/0159-ARM-imx-Re-select-CONFIG_SND_SOC_IMX_MC13783-option.patch"
	${git} "${DIR}/patches/imx_dts/0160-ARM-mach-mxs-Remove-TO-string-from-revision-field.patch"
	${git} "${DIR}/patches/imx_dts/0161-phy-micrel-Add-definitions-for-common-Micrel-PHY-reg.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.12/dts
	${git} "${DIR}/patches/omap_next/0001-ARM-dts-omap3-beagle-xm-fix-string-error-in-compatib.patch"
	${git} "${DIR}/patches/omap_next/0002-ARM-dts-N900-Add-device-tree.patch"
	${git} "${DIR}/patches/omap_next/0003-ARM-dts-omap3-igep-add-pinmux-node-for-GPIO-LED-conf.patch"
	${git} "${DIR}/patches/omap_next/0004-ARM-dts-omap3-igep0020-add-mux-conf-for-GPIO-LEDs.patch"
	${git} "${DIR}/patches/omap_next/0005-ARM-dts-omap3-igep0030-add-mux-conf-for-GPIO-LED.patch"
	${git} "${DIR}/patches/omap_next/0006-ARM-dts-AM33XX-Add-PMU-support.patch"
	${git} "${DIR}/patches/omap_next/0007-ARM-dts-AM33xx-Correct-gpio-interrupt-cells-property.patch"
	${git} "${DIR}/patches/omap_next/0008-ARM-dts-omap5-uevm-Split-SMPS10-in-two-nodes.patch"
	${git} "${DIR}/patches/omap_next/0009-ARM-dts-Remove-0x-s-from-OMAP2420-H4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0010-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0020-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0011-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0030-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0012-ARM-dts-Remove-0x-s-from-OMAP3-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0013-ARM-dts-Remove-0x-s-from-OMAP3430-SDP-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0014-ARM-dts-Remove-0x-s-from-OMAP4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0015-ARM-dts-Remove-0x-s-from-OMAP5-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0016-ARM-dts-twl6030-Move-common-configuration-for-OMAP4-.patch"
	${git} "${DIR}/patches/omap_next/0017-ARM-dts-omap4-var-som-configure-connection-to-PMIC-o.patch"
	${git} "${DIR}/patches/omap_next/0018-ARM-dts-DRA7-Add-the-dts-files-for-dra7-SoC-and-dra7.patch"
	${git} "${DIR}/patches/omap_next/0019-ARM-dts-omap3-beagle-Use-reset-gpios-for-hsusb2_rese.patch"
	${git} "${DIR}/patches/omap_next/0020-ARM-dts-omap4-panda-Use-reset-gpios-for-hsusb1_reset.patch"
	${git} "${DIR}/patches/omap_next/0021-ARM-dts-omap5-uevm-Use-reset-gpios-for-hsusb2_reset.patch"
	${git} "${DIR}/patches/omap_next/0022-ARM-dts-omap3-beagle-Make-USB-host-pin-naming-consis.patch"
	${git} "${DIR}/patches/omap_next/0023-ARM-dts-omap3-beagle-xm-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/omap_next/0024-ARM-dts-AM4372-cpu-s-node-per-latest-binding.patch"
	${git} "${DIR}/patches/omap_next/0025-ARM-dts-AM4372-add-few-nodes.patch"
	${git} "${DIR}/patches/omap_next/0026-ARM-dts-Add-devicetree-for-gta04-board.patch"
	${git} "${DIR}/patches/omap_next/0027-ARM-dts-AM33XX-use-pinmux-node-defined-in-included-f.patch"
	${git} "${DIR}/patches/omap_next/0028-ARM-dts-AM33XX-don-t-redefine-OCP-bus-and-device-nod.patch"
}

imx () {
	echo "dir: imx"
#v3.11-rc3
	#v8:
	#https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/commit/?h=for-3.11-fixes&id=6a6c21ef487be47b300a0b24cd6afeb69d8b9a1a
#	${git} "${DIR}/patches/imx/0001-ARM-imx6q-update-the-sata-bits-definitions-of-gpr13.patch"
	#https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/commit/?h=for-3.11-fixes&id=9e54eae23bc9cca0d8a955018c35b1250e09a73a
#	${git} "${DIR}/patches/imx/0002-ahci_imx-add-ahci-sata-support-on-imx-platforms.patch"

	#sata for the imx53-qsb
#	${git} "${DIR}/patches/imx/0003-ahci-imx53-ahci-enable-on-imx53-qsb.patch"

	#usb for the imx53-qsb
#	${git} "${DIR}/patches/imx/0004-ARM-dts-imx53-qsb-Make-USBH1-functional.patch"
	${git} "${DIR}/patches/imx/0005-chipidea-core-Move-hw_phymode_configure-into-probe.patch"
}

omap_usb_phy_reset () {
	echo "dir: omap_usb_phy_reset"
	${git} "${DIR}/patches/omap_usb_phy_reset/0001-usb-phy-nop-Add-gpio_reset-to-platform-data.patch"
	${git} "${DIR}/patches/omap_usb_phy_reset/0002-usb-phy-nop-Don-t-use-regulator-framework-for-RESET-.patch"
	${git} "${DIR}/patches/omap_usb_phy_reset/0003-ARM-OMAP2-omap-usb-host-Get-rid-of-platform_data-fro.patch"
	${git} "${DIR}/patches/omap_usb_phy_reset/0004-ARM-OMAP2-usb-host-Adapt-to-USB-phy-nop-RESET-line-c.patch"
}

omap_video () {
	echo "dir: omap_video"
#v3.11-rc5
#	${git} "${DIR}/patches/omap_video/0001-ARM-OMAP-dss-common-fix-Panda-s-DVI-DDC-channel.patch"
	${git} "${DIR}/patches/omap_video/0002-ARM-OMAP2-Remove-legacy-DSS-initialization-for-omap4.patch"
	${git} "${DIR}/patches/omap_video/0003-dts-omap3-beagle-add-i2c2-i2c3.patch"
	${git} "${DIR}/patches/omap_video/0004-hack-beagle_xm-like-omap4-use-the-dss-common-transit.patch"
}

omap_clock () {
	echo "dir: omap_clock"
	#TI omap dts clock bindings driver
	${git} "${DIR}/patches/omap_clock/0001-Added-the-Texas-Instruments-OMAP-Clock-driver-origin.patch"

	#omap3: add device tree clock binding support
	${git} "${DIR}/patches/omap_clock/0002-Add-the-clock-bindings-to-omap3.dtsi-that-were-made-.patch"

	#omap: use cpu0-cpufreq SoC generic driver if performing dts boot, use old method if non dts
	${git} "${DIR}/patches/omap_clock/0003-Use-cpu0-cpufreq-in-a-device-tree-supported-boot.-Th.patch"

	#beagleboard-xm: add abb bindings and OPP1G operating point for 1 GHz operation
	${git} "${DIR}/patches/omap_clock/0004-Now-this-one-is-mine-lol.-Reading-through-the-ti-abb.patch"
}

omap_board () {
	echo "dir: omap_board"
	#Note: the plan is to move to device tree, so these will be dropped at some point..
	#omap3430: lockup on reset fix...
	${git} "${DIR}/patches/omap_board/0001-omap2-twl-common-Add-default-power-configuration.patch"
	${git} "${DIR}/patches/omap_board/0002-ARM-OMAP-Beagle-use-TWL4030-generic-reset-script.patch"
}

dts () {
	echo "dir: dts"
	#omap: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/
	#imx: https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=summary
	${git} "${DIR}/patches/dts/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c3.patch"
	${git} "${DIR}/patches/dts/0005-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0006-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

#	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-debug-led-for-headless.patch"
}

imx_video () {
	echo "dir: imx_video"
	#total wip...
	${git} "${DIR}/patches/imx_video/0001-imx-video-staging-Add-HDMI-support-to-imx-drm-driver.patch"
	${git} "${DIR}/patches/imx_video/0002-imx-enable-hdmi-video-for-imx6q-sabrelite-imx6q-sabr.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	#Still needs: CONFIG_NOP_USB_XCEIV=m but ehci works
	#cp omap3-beagle-xm.dts omap3-beagle-xm-c.dts
	#cp omap3-beagle-xm.dts omap3-beagle-xm-ab.dts
	#edit Makefile add ^
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-split-omap3-beagle-xm-to-ab-and-c-variant.patch"
	#xm-ab has active high usb host power on...
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab-usb-host-is-active-high-t.patch"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

omap_sprz319_erratum() {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

arm
drivers
imx_dts
omap_next
imx
omap_usb_phy_reset
omap_video
omap_clock
omap_board


dts
imx_video
omap3_beagle_xm_rework
saucy

#Fixes the dpll5 instability which usually results in the hard crash of the USB ports on Beagleboard xM.
#Uncomment to enable
#omap_sprz319_erratum

echo "patch.sh ran successful"
