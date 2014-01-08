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

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

drivers () {
	echo "dir: drivers"
	${git} "${DIR}/patches/drivers/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_next () {
	echo "dir: imx_next"
	#From: https://git.linaro.org/people/shawn.guo/linux-2.6.git
	#git pull --no-edit git://git.linaro.org/people/shawn.guo/linux-2.6.git for-next

	${git} "${DIR}/patches/imx_next/0001-sh-pfc-r8a7791-Fix-DU-pin-groups-organisation.patch"
	${git} "${DIR}/patches/imx_next/0002-pinctrl-nomadik-always-display-IRQ-in-debugfs.patch"
	${git} "${DIR}/patches/imx_next/0003-pinctrl-imx-drop-redundant-OF-dependency.patch"
	${git} "${DIR}/patches/imx_next/0004-pinctrl-imx1-core-populate-subdevices.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-imx-add-PCI-fixup-for-PEX860X-on-Gateworks-board.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-imx_v4_v5_defconfig-Enable-gpio-regulator-and-gp.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-imx-add-debug-uart-support-for-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-imx-add-clocking-support-code-for-the-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-imx-allow-configuration-of-the-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-imx_v6_v7_defconfig-Enable-tsc2007-support.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-imx-remove-mxc_iomux_v3_init-call-from-imx53_ini.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-imx-drop-support-for-irq-priorisation.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-imx-add-support-code-for-IMX50-based-machines.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-i.MX53-remove-duplicated-include-from-clk-imx51-.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-i.MX25-build-in-pinctrl-support.patch"
	${git} "${DIR}/patches/imx_next/0016-ARM-i.MX5x-Add-SAHARA-clock-for-i.MX5x-CPUs.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-imx-Add-DMAMUX-clock-for-Vybrid-vf610-SoC.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-imx27-enable-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-imx_v6_v7_defconfig-Select-CONFIG_HIGHMEM.patch"
	${git} "${DIR}/patches/imx_next/0020-clk-imx5-introduce-DT-includes-for-clock-provider.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-imx-clk-correct-arm-clock-usecount.patch"
	${git} "${DIR}/patches/imx_next/0022-ARM-imx-select-PINCTRL-at-sub-architecure-level.patch"
	${git} "${DIR}/patches/imx_next/0023-ARM-imx-rename-IMX6SL_CLK_CLK_END-to-IMX6SL_CLK_END.patch"
	${git} "${DIR}/patches/imx_next/0024-ARM-imx_v6_v7_defconfig-Enable-STMPE-touchscreen.patch"
	${git} "${DIR}/patches/imx_next/0025-ARM-imx-imx53-Add-SATA-PHY-clock.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-i.MX5-fix-shift-value-for-lp_apm_sel-on-i.MX50-a.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-imx-pllv1-Fix-PLL-calculation-for-i.MX27.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-dts-i.MX53-Add-alternate-pinmux-option-for-i2c_3.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-dts-i.MX53-Internal-keyboard-controller.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-dts-disable-flexcan-by-default.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-dts-added-several-new-imx-pinmux-groups.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-dts-add-Gateworks-Ventana-support.patch"
	${git} "${DIR}/patches/imx_next/0033-ARM-dts-mxs-add-auart2-pinmux-to-imx28.dtsi.patch"
	${git} "${DIR}/patches/imx_next/0034-of-add-vendor-prefix-for-Eukrea-Electromatique.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-dts-i.MX25-Add-ssi-clocks-and-DMA-events.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-dts-i.MX25-Add-sdma-script-path.patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-dts-imx25.dtsi-Add-a-label-for-the-Audio-Multipl.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-dts-imx51.dtsi-Add-some-pinmux-pins.patch"
	${git} "${DIR}/patches/imx_next/0039-ARM-dts-Add-support-for-the-cpuimx51-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-dts-imx6q-arm2-enable-USB-OTG.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-dts-imx-add-device-tree-pin-definitions-for-the-.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-dts-imx-add-IMX50-SoC-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-dts-imx-add-device-tree-support-for-Freescale-im.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-dts-Add-initial-support-for-cm-fx6.patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-dts-Add-vendor-prefix-for-Voipac-Technologies-s..patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-dts-i.MX53-dts-for-Voipac-x53-dmm-668-module.patch"
	${git} "${DIR}/patches/imx_next/0047-ARM-dts-i.MX53-Devicetree-for-Voipac-Baseboard-using.patch"
	${git} "${DIR}/patches/imx_next/0048-ARM-dts-imx6qdl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0049-ARM-dts-imx6sl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0050-ARM-dts-imx53-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0051-ARM-dts-imx51-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0052-ARM-dts-imx50-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0053-ARM-dts-voipac-Improve-fixed-voltage-regulator-defin.patch"
	${git} "${DIR}/patches/imx_next/0054-ARM-dts-imx53-mba53-create-a-container-for-fixed-reg.patch"
	${git} "${DIR}/patches/imx_next/0055-ARM-dts-imx-use-generic-node-name-for-fixed-regulato.patch"
	${git} "${DIR}/patches/imx_next/0056-ARM-dts-imx25-Add-pinctrl-functions-and-groups.patch"
	${git} "${DIR}/patches/imx_next/0057-ARM-dts-imx25.dtsi-label-the-iomuxc.patch"
	${git} "${DIR}/patches/imx_next/0058-DT-Add-Data-Modul-vendor-prefix.patch"
	${git} "${DIR}/patches/imx_next/0059-ARM-dts-imx6-Add-support-for-imx6q-dmo-edmqmx6.patch"
	${git} "${DIR}/patches/imx_next/0060-ARM-mxs-add-support-for-I2SE-s-duckbill-series.patch"
	${git} "${DIR}/patches/imx_next/0061-ARM-dts-i.MX51-Update-CPU-node.patch"
	${git} "${DIR}/patches/imx_next/0062-ARM-dts-i.MX51-Add-dummy-clock-to-AUDMUX.patch"
	${git} "${DIR}/patches/imx_next/0063-ARM-dts-i.MX51-Switch-to-use-standard-IRQ-flags-defi.patch"
	${git} "${DIR}/patches/imx_next/0064-ARM-imx27-apf27dev-Add-sdhci-support.patch"
	${git} "${DIR}/patches/imx_next/0065-ARM-dts-imx27-pin-functions.patch"
	${git} "${DIR}/patches/imx_next/0066-ARM-dts-imx27-pingroups.patch"
	${git} "${DIR}/patches/imx_next/0067-ARM-dts-imx6q-udoo-Add-Ethernet-support.patch"
	${git} "${DIR}/patches/imx_next/0068-ARM-dts-imx6q-sabrelite-Remove-duplicate-GPIO-entry.patch"
	${git} "${DIR}/patches/imx_next/0069-ARM-imx53-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0070-ARM-imx51-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0071-ARM-imx50-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0072-ARM-dts-imx-specify-the-value-of-audmux-pinctrl-inst.patch"
	${git} "${DIR}/patches/imx_next/0073-ARM-dts-imx-pinfunc-add-MX6QDL_PAD_SD1_CLK__OSC32K_3.patch"
	${git} "${DIR}/patches/imx_next/0074-ARM-dts-imx-imx6qdl.dtsi-add-mipi_csi-tag.patch"
	${git} "${DIR}/patches/imx_next/0075-ARM-dts-imx-imx6q.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0076-ARM-dts-imx-imx6dl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0077-ARM-dts-imx-imx6sl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0078-ARM-dts-imx-imx6qdl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0079-ARM-dts-imx53-Fix-display-pinmux-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0080-ARM-dts-imx53-Fix-backlight-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0081-ARM-dts-imx53-Add-USB-support-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0082-ARM-mxs-cfa10049-Add-NAU7802-ADCs-to-the-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0083-ARM-dts-cfa10036-Add-dr_mode-and-phy_type-properties.patch"
	${git} "${DIR}/patches/imx_next/0084-ARM-dts-i.MX51-Move-usbphy0-node-from-AIPS1.patch"
	${git} "${DIR}/patches/imx_next/0085-ARM-dts-i.MX51-boards-Switch-to-use-standard-GPIO-fl.patch"
	${git} "${DIR}/patches/imx_next/0086-ARM-dts-imx6q-sabrelite-Place-status-as-the-last-nod.patch"
	${git} "${DIR}/patches/imx_next/0087-ARM-dts-imx-imx6sl-qdl-pingrp-reorganize-USDHCx-pad-.patch"
	${git} "${DIR}/patches/imx_next/0088-ARM-dts-imx53-Add-AHCI-SATA-DT-node.patch"
	${git} "${DIR}/patches/imx_next/0089-ARM-dts-imx53-Enable-AHCI-SATA-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0090-ARM-dts-imx27-iomux-device-node.patch"
	${git} "${DIR}/patches/imx_next/0091-ARM-dts-imx27-phyCARD-S-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0092-ARM-dts-imx27-phycore-move-uart1-to-rdk.patch"
	${git} "${DIR}/patches/imx_next/0093-ARM-dts-imx27-phycore-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0094-ARM-dts-imx27-apf27dev-fix-display-size.patch"
	${git} "${DIR}/patches/imx_next/0095-ARM-dts-imx28-evk-Run-I2C0-at-400kHz.patch"
	${git} "${DIR}/patches/imx_next/0096-ARM-i.MX53-dts-NAND-flash-controller.patch"
	${git} "${DIR}/patches/imx_next/0097-ARM-i.MX53-dts-USB-host-controller.patch"
	${git} "${DIR}/patches/imx_next/0098-ARM-dts-imx51-babbage-Fix-chipselect-level-for-dataf.patch"
	${git} "${DIR}/patches/imx_next/0099-ARM-dts-imx51-babbage-Define-FEC-reset-pin.patch"
	${git} "${DIR}/patches/imx_next/0100-ARM-imx27-add-pingroups-for-cspi-sdhc-and-framebuffe.patch"
	${git} "${DIR}/patches/imx_next/0101-ARM-dts-imx27-imx27-apf27-add-pinctrl-for-fec-and-ua.patch"
	${git} "${DIR}/patches/imx_next/0102-ARM-dts-imx27-imx27-apf27dev-add-pinctrl-for-cspi-i2.patch"
	${git} "${DIR}/patches/imx_next/0103-ARM-dts-imx27-phytec-phycore-som-Add-on-flash-BBT-su.patch"
	${git} "${DIR}/patches/imx_next/0104-ARM-dts-imx27-phytec-phycore-rdk-Add-DT-node-for-cam.patch"
	${git} "${DIR}/patches/imx_next/0105-ARM-dts-imx27-phytec-phycore-som-Update-FEC-node.patch"
	${git} "${DIR}/patches/imx_next/0106-ARM-dts-i.MX27-boards-Switch-to-use-standard-GPIO-an.patch"
	${git} "${DIR}/patches/imx_next/0107-ARM-dts-apf28dev-set-gpio-polarity-for-usb-regulator.patch"
	${git} "${DIR}/patches/imx_next/0108-ARM-imx28-add-apf28-specific-initialization-macaddr.patch"
	${git} "${DIR}/patches/imx_next/0109-ARM-imx27-add-pwm-pingrp.patch"
	${git} "${DIR}/patches/imx_next/0110-ARM-dts-apf27dev-Add-pwm-support.patch"
	${git} "${DIR}/patches/imx_next/0111-ARM-dts-imx27-apf27dev-Add-pinctrl-for-cspi-sdhci-le.patch"
	${git} "${DIR}/patches/imx_next/0112-ARM-dts-i.MX27-Configure-GPIOs-as-input-by-default.patch"
	${git} "${DIR}/patches/imx_next/0113-ARM-dts-imx53-Enable-AHCI-SATA-for-imx53-qsb.patch"
	${git} "${DIR}/patches/imx_next/0114-ARM-dts-mxs-Add-18bit-pin-config-for-lcdif.patch"
	${git} "${DIR}/patches/imx_next/0115-ARM-dts-mxs-Add-a-new-pin-config-for-the-usb0-ID.patch"
	${git} "${DIR}/patches/imx_next/0116-ARM-mxs-Add-support-for-the-eukrea-cpuimx28.patch"
	${git} "${DIR}/patches/imx_next/0117-ARM-dts-Add-support-for-the-cpuimx25-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0118-ARM-i.MX28-dts-rename-usbphy-pin-names.patch"
	${git} "${DIR}/patches/imx_next/0119-ARM-dts-mxs-add-io-channel-cells-to-mx28-lradc.patch"
	${git} "${DIR}/patches/imx_next/0120-ARM-dts-i.MX-Move-include-imxXX-pinfunc.h-into-imxXX.patch"
	${git} "${DIR}/patches/imx_next/0121-ARM-dts-imx27-phytec-phycore-rdk-Change-pinctrl-sett.patch"
	${git} "${DIR}/patches/imx_next/0122-ARM-dts-imx27-phytec-phycore-som-trivial-Typo-fix.patch"
	${git} "${DIR}/patches/imx_next/0123-ARM-dts-imx27-phytec-phycore-som-Add-pinctrl-for-CSP.patch"
	${git} "${DIR}/patches/imx_next/0124-ARM-dts-imx27-phytec-phycore-som-Rename-file-to-.dts.patch"
	${git} "${DIR}/patches/imx_next/0125-ARM-i.MX5-set-CAN-peripheral-clock-to-24-MHz-parent.patch"
	${git} "${DIR}/patches/imx_next/0126-ARM-dts-mbimxsd25-Add-sound-support.patch"
	${git} "${DIR}/patches/imx_next/0127-ARM-dts-mbimxsd51-Add-sound-support.patch"
	${git} "${DIR}/patches/imx_next/0128-ARM-i.MX5-fix-obvious-typo-in-ldb_di0_gate-clk-defin.patch"
	${git} "${DIR}/patches/imx_next/0129-ARM-imx-use-__initconst-for-const-init-definition.patch"
	${git} "${DIR}/patches/imx_next/0130-ARM-dts-vf610-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0131-ARM-dts-imx6q-sabrelite-Enable-PCI-express.patch"
	${git} "${DIR}/patches/imx_next/0132-ARM-dts-imx6qdl-add-aliases-for-can-interfaces.patch"
	${git} "${DIR}/patches/imx_next/0133-ARM-dts-imx6qdl-add-pingroup-for-enet-interface-in-R.patch"
	${git} "${DIR}/patches/imx_next/0134-ARM-dts-imx6qdl-add-new-pingroup-for-audmux.patch"
	${git} "${DIR}/patches/imx_next/0135-ARM-dts-imx-sabrelite-add-Dual-Lite-Solo-support.patch"
	${git} "${DIR}/patches/imx_next/0136-ARM-dts-imx6qdl-sabrelite-Add-uart1-support.patch"
	${git} "${DIR}/patches/imx_next/0137-ARM-dts-imx6qdl-sabrelite-remove-usdhc4-wp-gpio.patch"
	${git} "${DIR}/patches/imx_next/0138-ARM-imx6-Derive-spdif-clock-from-pll3_pfd3_454m.patch"
	${git} "${DIR}/patches/imx_next/0139-ARM-imx6sl-Add-missing-pll4_audio_div-to-the-clock-t.patch"
	${git} "${DIR}/patches/imx_next/0140-ARM-imx6sl-Add-missing-spba-clock-to-clock-tree.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

omap_dt_dss () {
	echo "dir: omap_dt_dss"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tomba/linux.git/log/?h=work/dss-dt

	${git} "${DIR}/patches/omap_dt_dss/0001-Revert-ARM-OMAP4-hwmod-data-add-DSS-data-back.patch"
	#${git} "${DIR}/patches/omap_dt_dss/0002-gpio-twl4030-Fix-regression-for-twl-gpio-LED-output.patch"
	${git} "${DIR}/patches/omap_dt_dss/0003-omap4-sdp.dts-add-power-supply-for-backlight.patch"
	${git} "${DIR}/patches/omap_dt_dss/0004-OMAPDSS-rename-display-sysfs-name-entry.patch"
	${git} "${DIR}/patches/omap_dt_dss/0005-OMAPDSS-DSI-fix-fifosize.patch"
	${git} "${DIR}/patches/omap_dt_dss/0006-ARM-OMAP-remove-DSS-DT-hack.patch"
	${git} "${DIR}/patches/omap_dt_dss/0007-OMAPDSS-remove-DT-hacks-for-regulators.patch"
	${git} "${DIR}/patches/omap_dt_dss/0008-Revert-ARM-dts-omap3-igep0020-name-twl4030-VPLL2-reg.patch"
	${git} "${DIR}/patches/omap_dt_dss/0009-ARM-OMAP2-add-omapdss_init_of.patch"
	${git} "${DIR}/patches/omap_dt_dss/0010-OMAPDSS-if-dssdev-name-NULL-use-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0011-OMAPDSS-get-dssdev-alias-from-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0012-OMAPFB-clean-up-default-display-search.patch"
	${git} "${DIR}/patches/omap_dt_dss/0013-OMAPFB-search-for-default-display-with-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0014-OMAPDSS-add-of-helpers.patch"
	${git} "${DIR}/patches/omap_dt_dss/0015-OMAPDSS-Add-DT-support-to-DSS-DISPC-DPI-HDMI-VENC.patch"
	${git} "${DIR}/patches/omap_dt_dss/0016-OMAPDSS-Add-DT-support-to-DSI.patch"
	${git} "${DIR}/patches/omap_dt_dss/0017-ARM-omap3.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0018-ARM-omap4.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0019-ARM-omap4-panda.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0020-ARM-omap4-sdp.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0021-ARM-omap3-tobi.dts-add-lcd-TEST.patch"
	${git} "${DIR}/patches/omap_dt_dss/0022-ARM-omap3-beagle.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0023-ARM-omap3-beagle-xm.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0024-ARM-omap3-igep0020.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0025-OMAPDSS-panel-dsi-cm-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0026-OMAPDSS-encoder-tfp410-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0027-OMAPDSS-connector-dvi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0028-OMAPDSS-encoder-tpd12s015-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0029-OMAPDSS-hdmi-connector-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0030-OMAPDSS-panel-dpi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0031-OMAPDSS-connector-analog-tv-Add-DT-support.patch"
}

imx () {
	echo "dir: imx"
	#${git} "${DIR}/patches/imx/0001-ahci-imx-Explicitly-clear-IMX6Q_GPR13_SATA_MPLL_CLK_.patch"
	${git} "${DIR}/patches/imx/0002-ahci-imx-Pull-out-the-clock-enable-disable-calls.patch"
	${git} "${DIR}/patches/imx/0003-ahci-imx-Add-i.MX53-support.patch"
}

omap_usb () {
	echo "dir: omap_usb"
	#${git} "${DIR}/patches/omap_usb/0001-ARM-dts-omap3-beagle-Fix-USB-host-on-beagle-boards-f.patch"
#	${git} "${DIR}/patches/omap_usb/0002-gpio-twl4030-Fix-regression-for-twl-gpio-LED-output.patch"
#	${git} "${DIR}/patches/omap_usb/0003-ARM-OMAP4-hwmod-data-Don-t-prevent-RESET-of-USB-Host.patch"
#	${git} "${DIR}/patches/omap_usb/0004-ARM-OMAP2-hwmod-Fix-RESET-logic.patch"
#	${git} "${DIR}/patches/omap_usb/0005-ARM-OMAP3-hwmod-data-Don-t-prevent-RESET-of-USB-Host.patch"
}

omap_video () {
	echo "dir: omap_video"
	${git} "${DIR}/patches/omap_video/0001-dts-omap3-beagle-add-i2c2-i2c3.patch"
}

omap_clock () {
	echo "dir: omap_clock"
	#TI omap dts clock bindings driver
	${git} "${DIR}/patches/omap_clock/0001-Added-the-Texas-Instruments-OMAP-Clock-driver-origin.patch"

	#omap3: add device tree clock binding support
	${git} "${DIR}/patches/omap_clock/0002-Add-the-clock-bindings-to-omap3.dtsi-that-were-made-.patch"

	#beagleboard-xm: add abb bindings and OPP1G operating point for 1 GHz operation
	${git} "${DIR}/patches/omap_clock/0003-Now-this-one-is-mine-lol.-Reading-through-the-ti-abb.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

bone () {
	echo "dir: bone"
	${git} "${DIR}/patches/bone/0001-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/bone/0002-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/bone/0003-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/bone/0004-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"
}

imx_video_staging () {
	echo "dir: imx_video_staging"
	${git} "${DIR}/patches/imx_video_staging/0001-imx-drm-Add-mx6-hdmi-transmitter-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0002-ARM-dts-mx6qdl-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0003-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-c.dts
	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-ab.dts
	#gedit arch/arm/boot/dts/Makefile add ^
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-split-omap3-beagle-xm-to-ab-and-c-variant.patch"
	#xm-ab has active high usb host power on...
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab-usb-host-is-active-high-t.patch"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0003-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
	${git} "${DIR}/patches/fixes/0002-crypto-omap-aes-add-error-check-for-pm_runtime_get_s.patch"
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
	#need to be re-tested with v3.13-rcX
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

#revert
arm
drivers
imx_next
omap_next
omap_dt_dss
imx
omap_usb
omap_video
omap_clock

dts
bone
imx_video_staging
omap3_beagle_xm_rework
omap_sprz319_erratum
fixes
vivante

#saucy

echo "patch.sh ran successful"
