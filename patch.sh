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

revert () {
	echo "dir: revert"
}

drivers () {
	echo "dir: drivers"
	${git} "${DIR}/patches/drivers/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_next () {
	echo "dir: imx_next"
	#From: https://git.linaro.org/people/shawn.guo/linux-2.6.git
	#git pull --no-edit git://git.linaro.org/people/shawn.guo/linux-2.6.git for-next

	${git} "${DIR}/patches/imx_next/0001-ARM-imx_v6_v7_defconfig-Select-PCI-support.patch"
	${git} "${DIR}/patches/imx_next/0002-ARM-imx-Use-INT_MEM_CLK_LPM-as-the-bit-name.patch"
	${git} "${DIR}/patches/imx_next/0003-ARM-imx-AHB-rate-must-be-set-to-132MHz-on-i.mx6sl.patch"
	${git} "${DIR}/patches/imx_next/0004-ARM-imx-add-cpuidle-support-for-i.mx6sl.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-imx_v6_v7_defconfig-Enable-backlight-gpio-suppor.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-i.MX35-build-in-pinctrl-support.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-imx_v6_v7_defconfig-Enable-some-drivers-used-on-.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-imx-add-select-on-ARCH_MXC-for-cpufreq-support.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-imx-clk-imx6sl-Suppress-duplicate-const-sparse-w.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-imx-clk-vf610-Suppress-duplicate-const-sparse-wa.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-i.MX-remove-PWM-platform-support.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-imx-add-suspend-in-ocram-support-for-i.mx6q.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-imx-add-suspend-in-ocram-support-for-i.mx6dl.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-imx-add-suspend-in-ocram-support-for-i.mx6sl.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-imx-add-always-on-clock-array-for-i.mx6sl-to-mai.patch"
	${git} "${DIR}/patches/imx_next/0016-ARM-imx-enable-delaytimer-on-the-imx-timer.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-dts-i.MX53-Internal-keyboard-controller.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-dts-disable-flexcan-by-default.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-dts-add-Gateworks-Ventana-support.patch"
	${git} "${DIR}/patches/imx_next/0020-ARM-dts-imx6q-arm2-enable-USB-OTG.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-dts-Add-initial-support-for-cm-fx6.patch"
	${git} "${DIR}/patches/imx_next/0022-ARM-dts-imx6qdl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0023-ARM-dts-imx6sl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0024-ARM-dts-imx6-use-generic-node-name-for-fixed-regulat.patch"
	${git} "${DIR}/patches/imx_next/0025-DT-Add-Data-Modul-vendor-prefix.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-dts-imx6-Add-support-for-imx6q-dmo-edmqmx6.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-dts-imx6q-udoo-Add-Ethernet-support.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-dts-imx6q-sabrelite-Remove-duplicate-GPIO-entry.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-dts-imx-specify-the-value-of-audmux-pinctrl-inst.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-dts-imx-pinfunc-add-MX6QDL_PAD_SD1_CLK__OSC32K_3.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-dts-imx-imx6qdl.dtsi-add-mipi_csi-tag.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-dts-imx-imx6q.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0033-ARM-dts-imx-imx6dl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0034-ARM-dts-imx-imx6sl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-dts-imx-imx6qdl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-dts-imx6q-sabrelite-Place-status-as-the-last-nod.patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-dts-imx6q-sabrelite-Enable-PCI-express.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-dts-imx6qdl-add-aliases-for-can-interfaces.patch"
	${git} "${DIR}/patches/imx_next/0039-ARM-dts-imx-sabrelite-add-Dual-Lite-Solo-support.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-dts-imx6qdl-sabrelite-Add-uart1-support.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-dts-imx6qdl-sabrelite-remove-usdhc4-wp-gpio.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-dts-imx6qdl-add-spdif-support-for-sabreauto.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-dts-imx6qdl-sabrelite-move-USDHC4-CD-to-pinctrl_.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-dts-imx6qdl-sabrelite-move-USDHC3-CD-WP-to-pinct.patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-dts-imx6qdl-sabrelite-move-spi-nor-CS-to-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-dts-imx6qdl-sabrelite-move-usbotg-power-enable-t.patch"
	${git} "${DIR}/patches/imx_next/0047-ARM-dts-imx6qdl-sabrelite-move-phy-reset-to-pinctrl_.patch"
	${git} "${DIR}/patches/imx_next/0048-ARM-dts-imx6qdl-sabrelite-explicitly-set-pad-for-SGT.patch"
	${git} "${DIR}/patches/imx_next/0049-ARM-dts-imx6qdl-sabrelite-add-pwms-for-backlights.patch"
	${git} "${DIR}/patches/imx_next/0050-ARM-dts-imx6qdl-sabrelite-add-skews-for-Micrel-phy.patch"
	${git} "${DIR}/patches/imx_next/0051-ARM-dts-imx6qdl-sabrelite-fix-ENET-group.patch"
	${git} "${DIR}/patches/imx_next/0052-ARM-dts-imx6qdl-sabrelite-Add-over-current-pin-to-us.patch"
	${git} "${DIR}/patches/imx_next/0053-ARM-dts-imx-add-nitrogen6x-board.patch"
	${git} "${DIR}/patches/imx_next/0054-ARM-dts-imx6qdl-sabrelite-add-gpio-keys.patch"
	${git} "${DIR}/patches/imx_next/0055-ARM-dts-imx6q-update-setting-of-VDDARM_CAP-voltage.patch"
	${git} "${DIR}/patches/imx_next/0056-ARM-dts-imx6q-add-vddsoc-pu-setpoint-info.patch"
	${git} "${DIR}/patches/imx_next/0057-ARM-dts-imx6dl-enable-cpufreq-support.patch"
	${git} "${DIR}/patches/imx_next/0058-ARM-dts-imx6qdl-add-necessary-thermal-clk.patch"
	${git} "${DIR}/patches/imx_next/0059-ARM-dts-imx6sl-Adding-cpu-frequency-and-VDDSOC-PU-ta.patch"
	${git} "${DIR}/patches/imx_next/0060-ARM-dts-imx6qdl-sabresd-Add-power-key-support.patch"
	${git} "${DIR}/patches/imx_next/0061-ARM-dts-imx6-Use-vddarm-as-the-regulator-name.patch"
	${git} "${DIR}/patches/imx_next/0062-ARM-dts-imx6q-sabrelite-PHY-reset-is-active-low.patch"
	${git} "${DIR}/patches/imx_next/0063-ARM-dts-imx-pinfunc-add-MX6QDL_PAD_GPIO_6__ENET_IRQ.patch"
	${git} "${DIR}/patches/imx_next/0064-ARM-dts-imx6qdl-use-interrupts-extended-for-fec.patch"
	${git} "${DIR}/patches/imx_next/0065-ARM-dts-mxs-add-auart2-pinmux-to-imx28.dtsi.patch"
	${git} "${DIR}/patches/imx_next/0066-of-add-vendor-prefix-for-Eukrea-Electromatique.patch"
	${git} "${DIR}/patches/imx_next/0067-ARM-dts-i.MX25-Add-ssi-clocks-and-DMA-events.patch"
	${git} "${DIR}/patches/imx_next/0068-ARM-dts-i.MX25-Add-sdma-script-path.patch"
	${git} "${DIR}/patches/imx_next/0069-ARM-dts-imx25.dtsi-Add-a-label-for-the-Audio-Multipl.patch"
	${git} "${DIR}/patches/imx_next/0070-ARM-dts-Add-support-for-the-cpuimx51-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0071-ARM-dts-imx-add-device-tree-pin-definitions-for-the-.patch"
	${git} "${DIR}/patches/imx_next/0072-ARM-dts-imx-add-IMX50-SoC-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0073-ARM-dts-imx-add-device-tree-support-for-Freescale-im.patch"
	${git} "${DIR}/patches/imx_next/0074-ARM-dts-Add-vendor-prefix-for-Voipac-Technologies-s..patch"
	${git} "${DIR}/patches/imx_next/0075-ARM-dts-i.MX53-dts-for-Voipac-x53-dmm-668-module.patch"
	${git} "${DIR}/patches/imx_next/0076-ARM-dts-i.MX53-Devicetree-for-Voipac-Baseboard-using.patch"
	${git} "${DIR}/patches/imx_next/0077-ARM-dts-imx53-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0078-ARM-dts-imx51-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0079-ARM-dts-vf610-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0080-ARM-dts-imx53-mba53-create-a-container-for-fixed-reg.patch"
	${git} "${DIR}/patches/imx_next/0081-ARM-dts-imx-use-generic-node-name-for-fixed-regulato.patch"
	${git} "${DIR}/patches/imx_next/0082-ARM-dts-imx25-Add-pinctrl-functions.patch"
	${git} "${DIR}/patches/imx_next/0083-ARM-dts-imx25.dtsi-label-the-iomuxc.patch"
	${git} "${DIR}/patches/imx_next/0084-ARM-mxs-add-support-for-I2SE-s-duckbill-series.patch"
	${git} "${DIR}/patches/imx_next/0085-ARM-dts-i.MX51-Update-CPU-node.patch"
	${git} "${DIR}/patches/imx_next/0086-ARM-dts-i.MX51-Add-dummy-clock-to-AUDMUX.patch"
	${git} "${DIR}/patches/imx_next/0087-ARM-dts-i.MX51-Switch-to-use-standard-IRQ-flags-defi.patch"
	${git} "${DIR}/patches/imx_next/0088-ARM-imx27-apf27dev-Add-sdhci-support.patch"
	${git} "${DIR}/patches/imx_next/0089-ARM-dts-imx27-pin-functions.patch"
	${git} "${DIR}/patches/imx_next/0090-ARM-imx53-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0091-ARM-imx51-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0092-ARM-imx50-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0093-ARM-dts-imx53-Fix-display-pinmux-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0094-ARM-dts-imx53-Fix-backlight-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0095-ARM-dts-imx53-Add-USB-support-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0096-ARM-mxs-cfa10049-Add-NAU7802-ADCs-to-the-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0097-ARM-dts-cfa10036-Add-dr_mode-and-phy_type-properties.patch"
	${git} "${DIR}/patches/imx_next/0098-ARM-dts-i.MX51-Move-usbphy0-node-from-AIPS1.patch"
	${git} "${DIR}/patches/imx_next/0099-ARM-dts-i.MX51-boards-Switch-to-use-standard-GPIO-fl.patch"
	${git} "${DIR}/patches/imx_next/0100-ARM-dts-imx53-Add-AHCI-SATA-DT-node.patch"
	${git} "${DIR}/patches/imx_next/0101-ARM-dts-imx53-Enable-AHCI-SATA-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0102-ARM-dts-imx27-iomux-device-node.patch"
	${git} "${DIR}/patches/imx_next/0103-ARM-dts-imx27-phyCARD-S-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0104-ARM-dts-imx27-phycore-move-uart1-to-rdk.patch"
	${git} "${DIR}/patches/imx_next/0105-ARM-dts-imx27-phycore-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0106-ARM-dts-imx27-apf27dev-fix-display-size.patch"
	${git} "${DIR}/patches/imx_next/0107-ARM-dts-imx28-evk-Run-I2C0-at-400kHz.patch"
	${git} "${DIR}/patches/imx_next/0108-ARM-dts-imx51-babbage-Fix-chipselect-level-for-dataf.patch"
	${git} "${DIR}/patches/imx_next/0109-ARM-dts-imx51-babbage-Define-FEC-reset-pin.patch"
	${git} "${DIR}/patches/imx_next/0110-ARM-dts-imx27-imx27-apf27-add-pinctrl-for-fec-and-ua.patch"
	${git} "${DIR}/patches/imx_next/0111-ARM-dts-imx27-imx27-apf27dev-add-pinctrl-for-cspi-i2.patch"
	${git} "${DIR}/patches/imx_next/0112-ARM-dts-imx27-phytec-phycore-som-Add-on-flash-BBT-su.patch"
	${git} "${DIR}/patches/imx_next/0113-ARM-dts-imx27-phytec-phycore-rdk-Add-DT-node-for-cam.patch"
	${git} "${DIR}/patches/imx_next/0114-ARM-dts-imx27-phytec-phycore-som-Update-FEC-node.patch"
	${git} "${DIR}/patches/imx_next/0115-ARM-dts-i.MX27-boards-Switch-to-use-standard-GPIO-an.patch"
	${git} "${DIR}/patches/imx_next/0116-ARM-dts-apf28dev-set-gpio-polarity-for-usb-regulator.patch"
	${git} "${DIR}/patches/imx_next/0117-ARM-imx28-add-apf28-specific-initialization-macaddr.patch"
	${git} "${DIR}/patches/imx_next/0118-ARM-dts-apf27dev-Add-pwm-support.patch"
	${git} "${DIR}/patches/imx_next/0119-ARM-dts-imx27-apf27dev-Add-pinctrl-for-cspi-sdhci-le.patch"
	${git} "${DIR}/patches/imx_next/0120-ARM-dts-i.MX27-Configure-GPIOs-as-input-by-default.patch"
	${git} "${DIR}/patches/imx_next/0121-ARM-dts-imx53-Enable-AHCI-SATA-for-imx53-qsb.patch"
	${git} "${DIR}/patches/imx_next/0122-ARM-dts-mxs-Add-18bit-pin-config-for-lcdif.patch"
	${git} "${DIR}/patches/imx_next/0123-ARM-dts-mxs-Add-a-new-pin-config-for-the-usb0-ID.patch"
	${git} "${DIR}/patches/imx_next/0124-ARM-mxs-Add-support-for-the-eukrea-cpuimx28.patch"
	${git} "${DIR}/patches/imx_next/0125-ARM-dts-Add-support-for-the-cpuimx25-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0126-ARM-i.MX28-dts-rename-usbphy-pin-names.patch"
	${git} "${DIR}/patches/imx_next/0127-ARM-dts-mxs-add-io-channel-cells-to-mx28-lradc.patch"
	${git} "${DIR}/patches/imx_next/0128-ARM-dts-imx27-phytec-phycore-som-Add-pinctrl-for-CSP.patch"
	${git} "${DIR}/patches/imx_next/0129-ARM-dts-imx27-phytec-phycore-som-Rename-file-to-.dts.patch"
	${git} "${DIR}/patches/imx_next/0130-ARM-dts-mxs-Add-iio-hwmon-to-mx28-soc.patch"
	${git} "${DIR}/patches/imx_next/0131-ARM-dts-mxs-Add-iio-hwmon-to-mx23-soc.patch"
	${git} "${DIR}/patches/imx_next/0132-ARM-dts-Add-support-for-the-i.MX35.patch"
	${git} "${DIR}/patches/imx_next/0133-ARM-dts-imx27-phytec-phycore-som-Add-NFC-pin-group.patch"
	${git} "${DIR}/patches/imx_next/0134-ARM-dts-imx27-phytec-phycore-rdk-Enable-1-Wire-modul.patch"
	${git} "${DIR}/patches/imx_next/0135-ARM-dts-imx27-phytec-phycore-som-Add-spi-cs-high-pro.patch"
	${git} "${DIR}/patches/imx_next/0136-ARM-dts-imx27-phytec-phycore-rdk-Add-pingrp-for-SDHC.patch"
	${git} "${DIR}/patches/imx_next/0137-ARM-dts-imx27-phytec-phycore-rdk-Add-pinctrl-definit.patch"
	${git} "${DIR}/patches/imx_next/0138-ARM-dts-mxs-add-mxs-phy-controller-id.patch"
	${git} "${DIR}/patches/imx_next/0139-ARM-dts-i.MX27-Add-SSI-nodes.patch"
	${git} "${DIR}/patches/imx_next/0140-ARM-dts-imx53-Add-gpio-and-input-dt-includes.patch"
	${git} "${DIR}/patches/imx_next/0141-ARM-dts-vf610-use-the-interrupt-macros.patch"
	${git} "${DIR}/patches/imx_next/0142-ARM-dts-imx53-evk-Remove-board-support.patch"
	${git} "${DIR}/patches/imx_next/0143-ARM-dts-i.MX53-move-common-QSB-nodes-to-new-file.patch"
	${git} "${DIR}/patches/imx_next/0144-ARM-dts-i.MX53-add-support-for-MCIMX53-START-R.patch"
	${git} "${DIR}/patches/imx_next/0145-ARM-dts-i.MX51-Switch-to-use-standard-definitions-fo.patch"
	${git} "${DIR}/patches/imx_next/0146-ARM-dts-imx28-apf28dev-add-user-button.patch"
	${git} "${DIR}/patches/imx_next/0147-ARM-dts-Add-support-for-the-cpuimx35-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0148-ARM-dts-imx53-add-support-for-Ka-Ro-TX53-modules.patch"
	${git} "${DIR}/patches/imx_next/0149-ARM-dts-imx53-Add-mmc-aliases.patch"
	${git} "${DIR}/patches/imx_next/0150-ARM-dts-imx51-Add-mmc-aliases.patch"
	${git} "${DIR}/patches/imx_next/0151-ARM-dts-imx5-use-imx51-ssi.patch"
	${git} "${DIR}/patches/imx_next/0152-ARM-dts-imx28-m28cu3-Remove-reset-active-high.patch"
	${git} "${DIR}/patches/imx_next/0153-ARM-imx_v4_v5_defconfig-Select-CONFIG_MMC_UNSAFE_RES.patch"
	${git} "${DIR}/patches/imx_next/0154-ARM-imx_v6_v7_defconfig-Select-CONFIG_MMC_UNSAFE_RES.patch"
	${git} "${DIR}/patches/imx_next/0155-ARM-dts-imx27-phytec-phycard-s-som-Sort-entries.patch"
	${git} "${DIR}/patches/imx_next/0156-ARM-dts-imx27-phytec-phycard-s-som-Add-NFC-node.patch"
	${git} "${DIR}/patches/imx_next/0157-ARM-dts-imx27-phytec-phycard-s-rdk-Add-pinctrl-defin.patch"
	${git} "${DIR}/patches/imx_next/0158-ARM-dts-mx53-Remove-enable-active-low-property.patch"
	${git} "${DIR}/patches/imx_next/0159-ARM-dts-imx28-tx28-Remove-enable-active-low-property.patch"
	${git} "${DIR}/patches/imx_next/0160-ARM-imx6q-remove-unneeded-clk-lookups.patch"
	${git} "${DIR}/patches/imx_next/0161-ARM-imx6q-support-ptp-and-rmii-clock-from-pad.patch"
	${git} "${DIR}/patches/imx_next/0162-ARM-dts-i.MX51-babbage-Support-diagnostic-LED.patch"
	${git} "${DIR}/patches/imx_next/0163-ARM-dts-imx6qdl-sabrelite-use-GPIO_6-for-FEC-interru.patch"
	${git} "${DIR}/patches/imx_next/0164-ARM-dts-imx6qdl-sabreauto-use-GPIO_6-for-FEC-interru.patch"
	${git} "${DIR}/patches/imx_next/0165-ARM-dts-imx6q-arm2-use-GPIO_6-for-FEC-interrupt.patch"
	${git} "${DIR}/patches/imx_next/0166-ARM-dts-imx6-add-anatop-phandle-for-usbphy.patch"
	${git} "${DIR}/patches/imx_next/0167-ARM-dts-imx6-add-mxs-phy-controller-id.patch"
	${git} "${DIR}/patches/imx_next/0168-ARM-dts-imx6qdl-sabresd-Add-PFUZE100-support.patch"
	${git} "${DIR}/patches/imx_next/0169-ARM-dts-imx6qdl-enable-dma-for-spi.patch"
	${git} "${DIR}/patches/imx_next/0170-ARM-dts-imx6sl-add-ocram-device-support.patch"
	${git} "${DIR}/patches/imx_next/0171-ARM-dts-imx6sl-add-keypad-support-for-i.mx6sl-evk-bo.patch"
	${git} "${DIR}/patches/imx_next/0172-ARM-dts-imx6qdl-sabreauto-Add-LVDS-support.patch"
	${git} "${DIR}/patches/imx_next/0173-ARM-dts-imx6q-Add-spi4-alias.patch"
	${git} "${DIR}/patches/imx_next/0174-ARM-dts-imx6qdl-Add-mmc-aliases.patch"
	${git} "${DIR}/patches/imx_next/0175-ARM-dts-imx6-use-imx51-ssi.patch"
	${git} "${DIR}/patches/imx_next/0176-ARM-dts-imx6-Add-DFI-FS700-M60-board-support.patch"
	${git} "${DIR}/patches/imx_next/0177-ARM-dts-imx6q-Add-support-for-Zealz-GK802.patch"
	${git} "${DIR}/patches/imx_next/0178-ARM-dts-imx6qdl-sabresd-correct-gpio-key-s-active-st.patch"
	${git} "${DIR}/patches/imx_next/0179-ARM-dts-imx6sl-evk-Add-PFUZE100-support.patch"
	${git} "${DIR}/patches/imx_next/0180-ARM-dts-imx6sl-evk-Add-audio-support.patch"
	${git} "${DIR}/patches/imx_next/0181-ARM-dts-imx6qdl-sabreauto-Add-PFUZE100-support.patch"
	${git} "${DIR}/patches/imx_next/0182-ARM-dts-imx6sl-evk-Add-debug-LED-support.patch"
	${git} "${DIR}/patches/imx_next/0183-ARM-dts-imx6qdl-wandboard-use-GPIO_6-for-FEC-interru.patch"
	${git} "${DIR}/patches/imx_next/0184-ARM-imx-avoid-calling-clk-APIs-in-idle-thread-which-.patch"
	${git} "${DIR}/patches/imx_next/0185-ARM-dts-imx27-phytec-phycard-s-som-Rename-file-to-.d.patch"
	${git} "${DIR}/patches/imx_next/0186-ARM-dts-imx6q-add-852MHz-setpoint-for-CPU-freq.patch"
	${git} "${DIR}/patches/imx_next/0187-ARM-imx-add-speed-grading-check-for-i.mx6-soc.patch"
	${git} "${DIR}/patches/imx_next/0188-ARM-dts-imx27-phytec-phycore-Add-diagnostic-PMIC-LED.patch"
	${git} "${DIR}/patches/imx_next/0189-ARM-mach-imx-Select-CONFIG_SRAM-at-ARCH_MXC-level.patch"
	${git} "${DIR}/patches/imx_next/0190-ARM-imx_v6_v7_defconfig-Select-CONFIG_DEBUG_FS.patch"
	${git} "${DIR}/patches/imx_next/0191-ARM-dts-vf610-Add-eDMA-node.patch"
	${git} "${DIR}/patches/imx_next/0192-ARM-dts-vf610-lpuart-Add-eDMA-support.patch"
	${git} "${DIR}/patches/imx_next/0193-ARM-dts-vf610-Add-edma-mux-Tx-and-Rx-support-for-SAI.patch"
	${git} "${DIR}/patches/imx_next/0194-ARM-dts-vf610-twr-Enable-SAI-ALSA-SoC-DAI-device.patch"
	${git} "${DIR}/patches/imx_next/0195-ARM-dts-vf610-twr-Enable-SGTL5000-codec.patch"
	${git} "${DIR}/patches/imx_next/0196-ARM-dts-vf610-twr-Add-simple-card-support.patch"
	${git} "${DIR}/patches/imx_next/0197-ARM-dts-imx6qdl-sabreauto-Support-debug-LED.patch"
	${git} "${DIR}/patches/imx_next/0198-ARM-dts-imx6sl-evk-Keep-VGEN1-regulator-always-enabl.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

omap_dt_dss () {
	echo "dir: omap_dt_dss"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tomba/linux.git/log/?h=work/dss-dt

	${git} "${DIR}/patches/omap_dt_dss/0001-ARM-OMAP2-add-omapdss_init_of.patch"
	${git} "${DIR}/patches/omap_dt_dss/0002-ARM-OMAP2-DT-compatible-tweak-for-displays.patch"
	${git} "${DIR}/patches/omap_dt_dss/0003-OMAPDSS-add-label-support-for-DT.patch"
	${git} "${DIR}/patches/omap_dt_dss/0004-OMAPDSS-get-dssdev-alias-from-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0005-OMAPFB-clean-up-default-display-search.patch"
	${git} "${DIR}/patches/omap_dt_dss/0006-OMAPFB-search-for-default-display-with-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0007-OMAPDSS-add-of-helpers.patch"
	${git} "${DIR}/patches/omap_dt_dss/0008-OMAPDSS-Improve-regulator-names-for-DT.patch"
	${git} "${DIR}/patches/omap_dt_dss/0009-OMAPDSS-Add-DT-support-to-DSS.patch"
	${git} "${DIR}/patches/omap_dt_dss/0010-OMAPDSS-Add-DT-support-to-DISPC.patch"
	${git} "${DIR}/patches/omap_dt_dss/0011-OMAPDSS-Add-DT-support-to-HDMI.patch"
	${git} "${DIR}/patches/omap_dt_dss/0012-OMAPDSS-Add-DT-support-to-VENC.patch"
	${git} "${DIR}/patches/omap_dt_dss/0013-OMAPDSS-Add-DT-support-to-DSI.patch"
	${git} "${DIR}/patches/omap_dt_dss/0014-OMAPDSS-panel-dsi-cm-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0015-OMAPDSS-encoder-tfp410-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0016-OMAPDSS-connector-dvi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0017-OMAPDSS-encoder-tpd12s015-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0018-OMAPDSS-hdmi-connector-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0019-OMAPDSS-panel-dpi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0020-OMAPDSS-connector-analog-tv-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0021-OMAPDSS-acx565akm-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0022-ARM-omap2.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0023-ARM-omap3.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0024-ARM-omap4.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0025-ARM-omap4-panda.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0026-ARM-omap4-sdp.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0027-ARM-omap3-beagle.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0028-ARM-omap3-beagle-xm.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0029-ARM-omap3-igep0020.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0030-ARM-omap3-n900.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0031-OMAPDSS-remove-DT-hacks-for-regulators.patch"
	${git} "${DIR}/patches/omap_dt_dss/0032-ARM-OMAP2-remove-pdata-quirks-for-displays.patch"
	${git} "${DIR}/patches/omap_dt_dss/0033-Doc-DT-Add-OMAP-DSS-DT-Bindings.patch"
	${git} "${DIR}/patches/omap_dt_dss/0034-Doc-DT-Add-DT-binding-documentation-for-Analog-TV-Co.patch"
	${git} "${DIR}/patches/omap_dt_dss/0035-Doc-DT-Add-DT-binding-documentation-for-DVI-Connecto.patch"
	${git} "${DIR}/patches/omap_dt_dss/0036-Doc-DT-Add-DT-binding-documentation-for-HDMI-Connect.patch"
	${git} "${DIR}/patches/omap_dt_dss/0037-Doc-DT-Add-DT-binding-documentation-for-MIPI-DPI-Pan.patch"
	${git} "${DIR}/patches/omap_dt_dss/0038-Doc-DT-Add-DT-binding-documentation-for-MIPI-DSI-CM-.patch"
	${git} "${DIR}/patches/omap_dt_dss/0039-Doc-DT-Add-DT-binding-documentation-for-Sony-acx565a.patch"
	${git} "${DIR}/patches/omap_dt_dss/0040-Doc-DT-Add-DT-binding-documentation-for-TFP410-encod.patch"
	${git} "${DIR}/patches/omap_dt_dss/0041-Doc-DT-Add-DT-binding-documentation-for-tpd12s015-en.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0042-OMAPDSS-DISPC-decimation-rounding-fix.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0043-OMAPDSS-fix-fck-field-types.patch"
	${git} "${DIR}/patches/omap_dt_dss/0044-clk-divider-fix-rate-calculation-for-fractional-rate.patch"
	${git} "${DIR}/patches/omap_dt_dss/0045-clk-ti-divider-fix-rate-calculation-for-fractional-r.patch"
	${git} "${DIR}/patches/omap_dt_dss/0046-ARM-OMAP2-clock-fix-clkoutx2-with-CLK_SET_RATE_PAREN.patch"
	${git} "${DIR}/patches/omap_dt_dss/0047-ARM-dts-fix-omap3-dss-clock-handle-names.patch"
	${git} "${DIR}/patches/omap_dt_dss/0048-ARM-dts-fix-DPLL4-x2-clkouts-on-3630.patch"
	${git} "${DIR}/patches/omap_dt_dss/0049-ARM-dts-use-ti-fixed-factor-clock-for-dpll4_m4x2_mul.patch"
	${git} "${DIR}/patches/omap_dt_dss/0050-ARM-dts-set-ti-set-rate-parent-for-dpll4_m4-path.patch"
	${git} "${DIR}/patches/omap_dt_dss/0051-OMAPDSS-fix-rounding-when-calculating-fclk-rate.patch"
}

clock () {
	echo "dir: clock"
	${git} "${DIR}/patches/clock/0001-clk-ti-am335x-remove-unecessary-cpu0-clk-node.patch"
	${git} "${DIR}/patches/clock/0002-ARM-dts-OMAP3-add-clock-nodes-for-CPU.patch"

	${git} "${DIR}/patches/clock/0003-ARM-dts-OMAP36xx-Add-device-node-for-ABB.patch"
	${git} "${DIR}/patches/clock/0004-ARM-dts-OMAP4-Add-device-nodes-for-ABB.patch"
	${git} "${DIR}/patches/clock/0005-ARM-dts-OMAP5-Add-device-nodes-for-ABB.patch"
	${git} "${DIR}/patches/clock/0006-ARM-dts-DRA7-Add-device-nodes-for-ABB.patch"

	#wip:
	${git} "${DIR}/patches/clock/0007-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
}

usb () {
	echo "dir: usb"
	${git} "${DIR}/patches/usb/0001-mfd-omap-usb-host-Use-resource-managed-clk_get.patch"
	${git} "${DIR}/patches/usb/0002-mfd-omap-usb-host-Get-clocks-based-on-hardware-revis.patch"
	${git} "${DIR}/patches/usb/0003-mfd-omap-usb-host-Use-clock-names-as-per-function-fo.patch"
	${git} "${DIR}/patches/usb/0004-mfd-omap-usb-host-Update-DT-clock-binding-informatio.patch"
	${git} "${DIR}/patches/usb/0005-mfd-omap-usb-tll-Update-DT-clock-binding-information.patch"
	${git} "${DIR}/patches/usb/0006-ARM-dts-omap4-Update-omap-usb-host-node.patch"
	${git} "${DIR}/patches/usb/0007-ARM-dts-omap5-Update-omap-usb-host-node.patch"
	${git} "${DIR}/patches/usb/0008-ARM-dts-omap4-panda-Provide-USB-PHY-clock.patch"
	${git} "${DIR}/patches/usb/0009-ARM-dts-omap5-uevm-Provide-USB-PHY-clock.patch"
	${git} "${DIR}/patches/usb/0010-ARM-OMAP2-Remove-legacy_init_ehci_clk.patch"
	${git} "${DIR}/patches/usb/0011-ARM-dts-OMAP2-Get-rid-of-incompatible-ids-for-USB-ho.patch"
	${git} "${DIR}/patches/usb/0012-usb-omap-dts-Update-DT-binding-example-usage.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

	${git} "${DIR}/patches/dts/0005-ARM-dts-omap3-beagle-add-i2c2.patch"

	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0008-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0009-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0011-hack-wand-enable-hdmi.patch"
}

imx_drm () {
	echo "dir: imx_drm"

	${git} "${DIR}/patches/imx_drm/0001-imx-drm-imx-hdmi-convert-HDMI-clock-settings-to-tabu.patch"
	${git} "${DIR}/patches/imx_drm/0002-imx-drm-imx-hdmi-clean-up-setting-CSC-registers.patch"
	${git} "${DIR}/patches/imx_drm/0003-imx-drm-imx-hdmi-provide-register-modification-funct.patch"
	${git} "${DIR}/patches/imx_drm/0004-imx-drm-imx-hdmi-clean-up-setting-of-vp_conf.patch"
	${git} "${DIR}/patches/imx_drm/0005-imx-drm-imx-hdmi-fix-CTS-N-setup-at-init-time.patch"
	${git} "${DIR}/patches/imx_drm/0006-imx-drm-ipu-v3-more-inteligent-DI-clock-selection.patch"
	${git} "${DIR}/patches/imx_drm/0007-imx-drm-ipu-v3-don-t-use-clk_round_rate-before-clk_s.patch"
	${git} "${DIR}/patches/imx_drm/0008-imx-drm-ipu-v3-more-clocking-fixes.patch"
	${git} "${DIR}/patches/imx_drm/0009-imx-drm-add-imx6-DT-configuration-for-HDMI.patch"
	${git} "${DIR}/patches/imx_drm/0010-imx-drm-update-and-fix-imx6-DT-descriptions-for-v3-H.patch"
	${git} "${DIR}/patches/imx_drm/0011-imx-drm-imx-drm-core-sanitise-imx_drm_encoder_get_mu.patch"
	${git} "${DIR}/patches/imx_drm/0012-imx-drm-imx-drm-core-use-array-instead-of-list-for-C.patch"
	${git} "${DIR}/patches/imx_drm/0013-imx-drm-provide-common-connector-mode-validation-fun.patch"
	${git} "${DIR}/patches/imx_drm/0014-imx-drm-simplify-setup-of-panel-format.patch"
	${git} "${DIR}/patches/imx_drm/0015-imx-drm-convert-to-componentised-device-support.patch"
	${git} "${DIR}/patches/imx_drm/0016-imx-drm-delay-publishing-sysfs-connector-entries.patch"
	${git} "${DIR}/patches/imx_drm/0017-imx-drm-remove-separate-imx-fbdev.patch"
	${git} "${DIR}/patches/imx_drm/0018-imx-drm-remove-imx-fb.c.patch"
	${git} "${DIR}/patches/imx_drm/0019-imx-drm-use-supplied-drm_device-where-possible.patch"
	${git} "${DIR}/patches/imx_drm/0020-imx-drm-imx-drm-core-provide-helper-function-to-pars.patch"
	${git} "${DIR}/patches/imx_drm/0021-imx-drm-imx-drm-core-provide-common-connector-and-en.patch"
	${git} "${DIR}/patches/imx_drm/0022-imx-drm-initialise-drm-components-directly.patch"
	${git} "${DIR}/patches/imx_drm/0023-imx-drm-imx-drm-core-remove-imx_drm_connector-and-im.patch"
	${git} "${DIR}/patches/imx_drm/0024-imx-drm-imx-drm-core-get-rid-of-drm_mode_group_init_.patch"
	${git} "${DIR}/patches/imx_drm/0025-imx-drm-imx-drm-core-kill-off-mutex.patch"
	${git} "${DIR}/patches/imx_drm/0026-imx-drm-imx-drm-core-move-allocation-of-imxdrm-devic.patch"
	${git} "${DIR}/patches/imx_drm/0027-imx-drm-imx-drm-core-various-cleanups.patch"
	${git} "${DIR}/patches/imx_drm/0028-imx-drm-imx-drm-core-add-core-hotplug-connector-supp.patch"
	${git} "${DIR}/patches/imx_drm/0029-imx-drm-imx-hdmi-add-hotplug-support-to-HDMI-compone.patch"
}

imx_drm_dts () {
	echo "dir: imx_drm_dts"
	${git} "${DIR}/patches/imx_drm_dts/0001-ARM-dts-imx6qdl-sabresd-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_drm_dts/0002-arm-dts-wandboard-enable-hdmi-quad-has-to-force-edid.patch"
}

imx_video_staging () {
	echo "dir: imx_video_staging"
	${git} "${DIR}/patches/imx_video_staging/0001-ARM-dts-mx6qdl-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0002-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	#${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"

	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-ab.dts
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab.dtb-copy-from-omap3-beagl.patch"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0003-ARM-dts-omap3-beagle-xm-ab.dtb-build.patch"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0004-ARM-dts-omap3-beagle-xm-ab.dtb-invert-usb-host.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
#	${git} "${DIR}/patches/fixes/0002-fix-compilation-of-imx-hdmi.patch"
	${git} "${DIR}/patches/fixes/0003-Makefile-extra.patch"
}

vivante () {
	echo "dir: vivante"
	#http://git.freescale.com/git/cgit.cgi/imx/linux-2.6-imx.git/
	#git checkout v3.10.17 -b freescale
	#git pull --no-edit git://git.freescale.com/imx/linux-2.6-imx.git imx_3.10.17_1.0.0_beta
	#git format-patch -1 -o /opt/github/linux-dev/patches/vivante/ 3b934d57da5637f4edabb5504bd668debdbb03b3
	#git format-patch -1 -o /opt/github/linux-dev/patches/vivante/ 2d570481f146218b5148930b573401070526cc1a
	#git checkout master -f ; git branch -D freescale

	${git} "${DIR}/patches/vivante/0001-ENGR00240988-drm-copy-vivante-driver-from-3.5.7-kern.patch"
	${git} "${DIR}/patches/vivante/0002-ENGR00240988-drm-vivante-remove-reclaim_buffers-call.patch"

	#fixes:
	${git} "${DIR}/patches/vivante/0003-drm-vivante-build-fixes.patch"
}

saucy () {
	echo "dir: saucy"
	#need to be re-tested with v3.14-rcX
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

#revert
drivers
imx_next
omap_next

omap_dt_dss
clock
usb

dts

imx_drm
imx_drm_dts
#imx_video_staging
omap_sprz319_erratum

omap3_beagle_xm_rework

fixes
vivante
#saucy

echo "patch.sh ran successful"
