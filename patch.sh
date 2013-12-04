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
	#From: https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=shortlog;h=refs/heads/for-next
	#git pull --no-edit git://git.linaro.org/people/shawnguo/linux-2.6.git for-next

	${git} "${DIR}/patches/imx_next/0001-ARM-imx-add-PCI-fixup-for-PEX860X-on-Gateworks-board.patch"
	${git} "${DIR}/patches/imx_next/0002-ARM-imx_v4_v5_defconfig-Enable-gpio-regulator-and-gp.patch"
	${git} "${DIR}/patches/imx_next/0003-ARM-imx-add-debug-uart-support-for-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0004-ARM-imx-add-clocking-support-code-for-the-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-imx-allow-configuration-of-the-IMX50-SoC.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-imx_v6_v7_defconfig-Enable-tsc2007-support.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-imx-remove-mxc_iomux_v3_init-call-from-imx53_ini.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-imx-drop-support-for-irq-priorisation.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-imx-add-support-code-for-IMX50-based-machines.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-i.MX53-remove-duplicated-include-from-clk-imx51-.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-i.MX25-build-in-pinctrl-support.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-i.MX5x-Add-SAHARA-clock-for-i.MX5x-CPUs.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-imx-Add-DMAMUX-clock-for-Vybrid-vf610-SoC.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-imx27-enable-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-imx_v6_v7_defconfig-Select-CONFIG_HIGHMEM.patch"
	${git} "${DIR}/patches/imx_next/0016-clk-imx5-introduce-DT-includes-for-clock-provider.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-imx-clk-correct-arm-clock-usecount.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-imx-select-PINCTRL-at-sub-architecure-level.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-imx-rename-IMX6SL_CLK_CLK_END-to-IMX6SL_CLK_END.patch"
	${git} "${DIR}/patches/imx_next/0020-ARM-imx_v6_v7_defconfig-Enable-STMPE-touchscreen.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-imx-imx53-Add-SATA-PHY-clock.patch"
	${git} "${DIR}/patches/imx_next/0022-sh-pfc-r8a7791-Fix-DU-pin-groups-organisation.patch"
	${git} "${DIR}/patches/imx_next/0023-pinctrl-nomadik-always-display-IRQ-in-debugfs.patch"
	${git} "${DIR}/patches/imx_next/0024-pinctrl-imx-drop-redundant-OF-dependency.patch"
	${git} "${DIR}/patches/imx_next/0025-pinctrl-imx1-core-populate-subdevices.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-i.MX5-fix-shift-value-for-lp_apm_sel-on-i.MX50-a.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-dts-i.MX53-Add-alternate-pinmux-option-for-i2c_3.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-dts-i.MX53-Internal-keyboard-controller.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-dts-disable-flexcan-by-default.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-dts-added-several-new-imx-pinmux-groups.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-dts-add-Gateworks-Ventana-support.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-dts-mxs-add-auart2-pinmux-to-imx28.dtsi.patch"
	${git} "${DIR}/patches/imx_next/0033-of-add-vendor-prefix-for-Eukrea-Electromatique.patch"
	${git} "${DIR}/patches/imx_next/0034-ARM-dts-i.MX25-Add-ssi-clocks-and-DMA-events.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-dts-i.MX25-Add-sdma-script-path.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-dts-imx25.dtsi-Add-a-label-for-the-Audio-Multipl.patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-dts-imx51.dtsi-Add-some-pinmux-pins.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-dts-Add-support-for-the-cpuimx51-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0039-ARM-dts-imx6q-arm2-enable-USB-OTG.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-dts-imx-add-device-tree-pin-definitions-for-the-.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-dts-imx-add-IMX50-SoC-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-dts-imx-add-device-tree-support-for-Freescale-im.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-dts-Add-initial-support-for-cm-fx6.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-dts-Add-vendor-prefix-for-Voipac-Technologies-s..patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-dts-i.MX53-dts-for-Voipac-x53-dmm-668-module.patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-dts-i.MX53-Devicetree-for-Voipac-Baseboard-using.patch"
	${git} "${DIR}/patches/imx_next/0047-ARM-dts-imx6qdl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0048-ARM-dts-imx6sl-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0049-ARM-dts-imx53-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0050-ARM-dts-imx51-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0051-ARM-dts-imx50-make-pinctrl-nodes-board-specific.patch"
	${git} "${DIR}/patches/imx_next/0052-ARM-dts-voipac-Improve-fixed-voltage-regulator-defin.patch"
	${git} "${DIR}/patches/imx_next/0053-ARM-dts-imx53-mba53-create-a-container-for-fixed-reg.patch"
	${git} "${DIR}/patches/imx_next/0054-ARM-dts-imx-use-generic-node-name-for-fixed-regulato.patch"
	${git} "${DIR}/patches/imx_next/0055-ARM-dts-imx25-Add-pinctrl-functions-and-groups.patch"
	${git} "${DIR}/patches/imx_next/0056-ARM-dts-imx25.dtsi-label-the-iomuxc.patch"
	${git} "${DIR}/patches/imx_next/0057-DT-Add-Data-Modul-vendor-prefix.patch"
	${git} "${DIR}/patches/imx_next/0058-ARM-dts-imx6-Add-support-for-imx6q-dmo-edmqmx6.patch"
	${git} "${DIR}/patches/imx_next/0059-ARM-mxs-add-support-for-I2SE-s-duckbill-series.patch"
	${git} "${DIR}/patches/imx_next/0060-ARM-dts-i.MX51-Update-CPU-node.patch"
	${git} "${DIR}/patches/imx_next/0061-ARM-dts-i.MX51-Add-dummy-clock-to-AUDMUX.patch"
	${git} "${DIR}/patches/imx_next/0062-ARM-dts-i.MX51-Switch-to-use-standard-IRQ-flags-defi.patch"
	${git} "${DIR}/patches/imx_next/0063-ARM-imx27-apf27dev-Add-sdhci-support.patch"
	${git} "${DIR}/patches/imx_next/0064-ARM-dts-imx27-pin-functions.patch"
	${git} "${DIR}/patches/imx_next/0065-ARM-dts-imx27-pingroups.patch"
	${git} "${DIR}/patches/imx_next/0066-ARM-dts-imx6q-udoo-Add-Ethernet-support.patch"
	${git} "${DIR}/patches/imx_next/0067-ARM-dts-imx6q-sabrelite-Remove-duplicate-GPIO-entry.patch"
	${git} "${DIR}/patches/imx_next/0068-ARM-imx53-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0069-ARM-imx51-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0070-ARM-imx50-use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0071-ARM-dts-imx-specify-the-value-of-audmux-pinctrl-inst.patch"
	${git} "${DIR}/patches/imx_next/0072-ARM-dts-imx-pinfunc-add-MX6QDL_PAD_SD1_CLK__OSC32K_3.patch"
	${git} "${DIR}/patches/imx_next/0073-ARM-dts-imx-imx6qdl.dtsi-add-mipi_csi-tag.patch"
	${git} "${DIR}/patches/imx_next/0074-ARM-dts-imx-imx6q.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0075-ARM-dts-imx-imx6dl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0076-ARM-dts-imx-imx6sl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0077-ARM-dts-imx-imx6qdl.dtsi-use-IRQ_TYPE_LEVEL_HIGH.patch"
	${git} "${DIR}/patches/imx_next/0078-ARM-dts-imx53-Fix-display-pinmux-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0079-ARM-dts-imx53-Fix-backlight-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0080-ARM-dts-imx53-Add-USB-support-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0081-ARM-mxs-cfa10049-Add-NAU7802-ADCs-to-the-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0082-ARM-dts-cfa10036-Add-dr_mode-and-phy_type-properties.patch"
	${git} "${DIR}/patches/imx_next/0083-ARM-dts-i.MX51-Move-usbphy0-node-from-AIPS1.patch"
	${git} "${DIR}/patches/imx_next/0084-ARM-dts-i.MX51-boards-Switch-to-use-standard-GPIO-fl.patch"
	${git} "${DIR}/patches/imx_next/0085-ARM-dts-imx6q-sabrelite-Place-status-as-the-last-nod.patch"
	${git} "${DIR}/patches/imx_next/0086-ARM-dts-imx-imx6sl-qdl-pingrp-reorganize-USDHCx-pad-.patch"
	${git} "${DIR}/patches/imx_next/0087-ARM-dts-imx53-Add-AHCI-SATA-DT-node.patch"
	${git} "${DIR}/patches/imx_next/0088-ARM-dts-imx53-Enable-AHCI-SATA-for-M53EVK.patch"
	${git} "${DIR}/patches/imx_next/0089-ARM-dts-imx27-iomux-device-node.patch"
	${git} "${DIR}/patches/imx_next/0090-ARM-dts-imx27-phyCARD-S-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0091-ARM-dts-imx27-phycore-move-uart1-to-rdk.patch"
	${git} "${DIR}/patches/imx_next/0092-ARM-dts-imx27-phycore-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0093-ARM-dts-imx27-apf27dev-fix-display-size.patch"
	${git} "${DIR}/patches/imx_next/0094-ARM-dts-imx28-evk-Run-I2C0-at-400kHz.patch"
	${git} "${DIR}/patches/imx_next/0095-ARM-i.MX53-dts-NAND-flash-controller.patch"
	${git} "${DIR}/patches/imx_next/0096-ARM-i.MX53-dts-USB-host-controller.patch"
	${git} "${DIR}/patches/imx_next/0097-ARM-dts-imx51-babbage-Fix-chipselect-level-for-dataf.patch"
	${git} "${DIR}/patches/imx_next/0098-ARM-dts-imx51-babbage-Define-FEC-reset-pin.patch"
	${git} "${DIR}/patches/imx_next/0099-ARM-imx27-add-pingroups-for-cspi-sdhc-and-framebuffe.patch"
	${git} "${DIR}/patches/imx_next/0100-ARM-dts-imx27-imx27-apf27-add-pinctrl-for-fec-and-ua.patch"
	${git} "${DIR}/patches/imx_next/0101-ARM-dts-imx27-imx27-apf27dev-add-pinctrl-for-cspi-i2.patch"
#	${git} "${DIR}/patches/imx_next/0102-Merge-branches-imx-soc-and-imx-dt-into-for-next.patch"
	${git} "${DIR}/patches/imx_next/0103-ARM-dts-imx27-phytec-phycore-som-Add-on-flash-BBT-su.patch"
	${git} "${DIR}/patches/imx_next/0104-ARM-dts-imx27-phytec-phycore-rdk-Add-DT-node-for-cam.patch"
	${git} "${DIR}/patches/imx_next/0105-ARM-dts-imx27-phytec-phycore-som-Update-FEC-node.patch"
	${git} "${DIR}/patches/imx_next/0106-ARM-dts-i.MX27-boards-Switch-to-use-standard-GPIO-an.patch"
	${git} "${DIR}/patches/imx_next/0107-ARM-dts-apf28dev-set-gpio-polarity-for-usb-regulator.patch"
	${git} "${DIR}/patches/imx_next/0108-ARM-imx-pllv1-Fix-PLL-calculation-for-i.MX27.patch"
	${git} "${DIR}/patches/imx_next/0109-ARM-imx28-add-apf28-specific-initialization-macaddr.patch"
	${git} "${DIR}/patches/imx_next/0110-ARM-imx27-add-pwm-pingrp.patch"
	${git} "${DIR}/patches/imx_next/0111-ARM-dts-apf27dev-Add-pwm-support.patch"
	${git} "${DIR}/patches/imx_next/0112-ARM-dts-imx27-apf27dev-Add-pinctrl-for-cspi-sdhci-le.patch"
	${git} "${DIR}/patches/imx_next/0113-ARM-dts-i.MX27-Configure-GPIOs-as-input-by-default.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

omap_dt_dss () {
	echo "dir: omap_dt_dss"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tomba/linux.git/log/?h=work/dss-dt

	${git} "${DIR}/patches/omap_dt_dss/0001-OMAPDSS-rename-display-sysfs-name-entry.patch"
	${git} "${DIR}/patches/omap_dt_dss/0002-OMAPDSS-DSI-fix-fifosize.patch"
	${git} "${DIR}/patches/omap_dt_dss/0003-ARM-OMAP-remove-DSS-DT-hack.patch"
	${git} "${DIR}/patches/omap_dt_dss/0004-OMAPDSS-remove-DT-hacks-for-regulators.patch"
	${git} "${DIR}/patches/omap_dt_dss/0005-ARM-OMAP2-add-omapdss_init_of.patch"
	${git} "${DIR}/patches/omap_dt_dss/0006-OMAPDSS-if-dssdev-name-NULL-use-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0007-OMAPDSS-get-dssdev-alias-from-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0008-OMAPFB-clean-up-default-display-search.patch"
	${git} "${DIR}/patches/omap_dt_dss/0009-OMAPFB-search-for-default-display-with-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0010-OMAPDSS-add-of-helpers.patch"
	${git} "${DIR}/patches/omap_dt_dss/0011-OMAPDSS-Add-DT-support-to-DSS-DISPC-DPI-HDMI-VENC.patch"
	${git} "${DIR}/patches/omap_dt_dss/0012-OMAPDSS-Add-DT-support-to-DSI.patch"
	${git} "${DIR}/patches/omap_dt_dss/0013-ARM-omap3.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0014-ARM-omap4.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0015-ARM-omap4-panda.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0016-ARM-omap4-sdp.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0017-ARM-omap3-tobi.dts-add-lcd-TEST.patch"
	${git} "${DIR}/patches/omap_dt_dss/0018-ARM-omap3-beagle.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0019-ARM-omap3-beagle-xm.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0020-OMAPDSS-panel-dsi-cm-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0021-OMAPDSS-encoder-tfp410-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0022-OMAPDSS-connector-dvi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0023-OMAPDSS-encoder-tpd12s015-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0024-OMAPDSS-hdmi-connector-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0025-OMAPDSS-panel-dpi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0026-OMAPDSS-connector-analog-tv-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0027-ARM-dts-omap3-beagle-Fix-USB-host-on-beagle-boards-f.patch"
	${git} "${DIR}/patches/omap_dt_dss/0028-omap4-sdp.dts-add-power-supply-for-backlight.patch"
}

imx () {
	echo "dir: imx"
	${git} "${DIR}/patches/imx/0001-ahci-imx-Explicitly-clear-IMX6Q_GPR13_SATA_MPLL_CLK_.patch"
	${git} "${DIR}/patches/imx/0002-ahci-imx-Pull-out-the-clock-enable-disable-calls.patch"
	${git} "${DIR}/patches/imx/0003-ahci-imx-Add-i.MX53-support.patch"
	${git} "${DIR}/patches/imx/0004-ARM-dts-imx53-enable-ahci-sata-for-imx53-qsb.patch"
}

omap_usb () {
	echo "dir: omap_usb"
	#${git} "${DIR}/patches/omap_usb/0001-ARM-dts-omap3-beagle-Fix-USB-host-on-beagle-boards-f.patch"
	${git} "${DIR}/patches/omap_usb/0002-gpio-twl4030-Fix-regression-for-twl-gpio-LED-output.patch"
	${git} "${DIR}/patches/omap_usb/0003-ARM-OMAP4-hwmod-data-Don-t-prevent-RESET-of-USB-Host.patch"
	${git} "${DIR}/patches/omap_usb/0004-ARM-OMAP2-hwmod-Fix-RESET-logic.patch"
	${git} "${DIR}/patches/omap_usb/0005-ARM-OMAP3-hwmod-data-Don-t-prevent-RESET-of-USB-Host.patch"
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
	${git} "${DIR}/patches/dts/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0005-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

imx_video_staging () {
	echo "dir: imx_video_staging"
	${git} "${DIR}/patches/imx_video_staging/0001-imx-drm-Add-mx6-hdmi-transmitter-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0003-ARM-dts-mx6qdl-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0004-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
	#need to re-look at datasheet, and set the correct i2c pin group..
	#${git} "${DIR}/patches/imx_video_staging/0005-imx-enable-hdmi-video-for-imx6q-sabrelite-imx6q-sabr.patch"
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
omap_board

dts
imx_video_staging
omap3_beagle_xm_rework
omap_sprz319_erratum
fixes

#saucy

echo "patch.sh ran successful"
