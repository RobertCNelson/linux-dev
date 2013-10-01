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
	${git} "${DIR}/patches/drivers/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_next () {
	echo "dir: imx_next"
	#From: https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=shortlog;h=refs/heads/for-next
	#git pull --no-edit git://git.linaro.org/people/shawnguo/linux-2.6.git for-next

	${git} "${DIR}/patches/imx_next/0001-ARM-dts-imx6sl-reuses-imx6q-sdma-firmware.patch"
	${git} "${DIR}/patches/imx_next/0002-ARM-dts-i.MX51-Separate-TXD-RXD-and-RTS-CTS-pinmux-e.patch"
	${git} "${DIR}/patches/imx_next/0003-ARM-dts-i.MX51-Add-IRAM-devicetree-node.patch"
	${git} "${DIR}/patches/imx_next/0004-ARM-dts-i.MX51-Add-W1-devicetree-node.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-dts-imx6qdl-wandboard-Add-usbotg-support.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-dts-imx28-evk-Allow-usb-peripheral-mode-to-work.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-dts-imx53-qsb-Allow-usb-peripheral-mode-to-work.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-dts-imx6q-sabrelite-Put-the-nodes-in-alphabetica.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-dts-imx6q-sabrelite-Add-LVDS-support.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-dts-vf610-Add-DSPI-nodes.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-dts-vf610-twr-Enable-DSPI0-devices-and-Flash-at2.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-imx6qdl-wandboard-Add-spdif-support.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-dts-add-iomuxc-gpr-device-node-for-imx6sl.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-imx-mx6sl-evk-Enable-USB-function.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-dts-imx6sl-Add-spi-aliases.patch"
	${git} "${DIR}/patches/imx_next/0016-ARM-dts-imx6qdl-add-uhs-pinctrl-state-for-usdhc3.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-dts-imx6qdl-sabresd-SDHC-ports-are-8-bit-wide.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-dts-imx28-evk-Enable-touchscreen-support.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-dts-mxs-add-pinctrl-header-files.patch"
	${git} "${DIR}/patches/imx_next/0020-ARM-dts-mxs-modify-mx23-mx28-dts-files-to-use-pinctr.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-dts-mxs-modify-mx23-mx28-dts-files-to-use-padcon.patch"
	${git} "${DIR}/patches/imx_next/0022-ARM-dts-imx6q-add-quirky-select-input-for-USB_OTG_ID.patch"
	${git} "${DIR}/patches/imx_next/0023-ARM-dts-tx28-restructure-and-update-DTS-file.patch"
	${git} "${DIR}/patches/imx_next/0024-ARM-dts-mxs-convert-usb0_id_pins_a-to-use-symbolic-p.patch"
	${git} "${DIR}/patches/imx_next/0025-ARM-dts-add-initial-VF610-Cosmic-Cosmic-board-suppor.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-imx6q-Add-pll4_audio_div-to-clock-tree.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-imx6sl-add-imx6sl-iomux-gpr-field-define.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-imx6sl-config-iomux-gpr1-to-select-clock-for-fec.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-imx-remove-IRQF_DISABLED.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-imx-add-low-level-debug-for-vybrid.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-imx-add-soc-revision-helper-functions.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-imx6q-use-common-soc-revision-helpers.patch"
	${git} "${DIR}/patches/imx_next/0033-ARM-imx-add-a-common-function-to-initialize-revision.patch"
	${git} "${DIR}/patches/imx_next/0034-ARM-imx-use-imx_init_revision_from_anatop-on-imx6sl.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-imx6-report-soc-info-via-soc-device.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-imx-remove-stale-mx53_display_revision-declarati.patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-dts-mxs-Add-muxing-options-for-the-SSP2-MMC.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-dts-imx6q-udoo-Add-initial-board-support.patch"
	${git} "${DIR}/patches/imx_next/0039-ARM-dts-imx6qdl-add-pcie-device-node.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-imx-Add-LVDS-general-purpose-clocks-to-i.MX6Q.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-imx6q-clock-and-Kconfig-update-for-PCIe-support.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-dts-imx6q-sabrelite-Add-ethernet-phy-reset-pin-i.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-dts-imx6qdl-sabresd-Provide-phy-reset-gpios.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-dts-imx6qdl-wandboard-Provide-phy-reset-gpios.patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-imx_v6_v7_defconfig-Add-SPDIF-support.patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-imx_v6_v7_defconfig-Add-CHIPIDEA_UDC-support.patch"

}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts

	${git} "${DIR}/patches/omap_next/0001-ARM-dts-N900-Add-device-tree.patch"
	${git} "${DIR}/patches/omap_next/0002-ARM-dts-omap3-igep-add-pinmux-node-for-GPIO-LED-conf.patch"
	${git} "${DIR}/patches/omap_next/0003-ARM-dts-omap3-igep0020-add-mux-conf-for-GPIO-LEDs.patch"
	${git} "${DIR}/patches/omap_next/0004-ARM-dts-omap3-igep0030-add-mux-conf-for-GPIO-LED.patch"
	${git} "${DIR}/patches/omap_next/0005-ARM-dts-AM33XX-Add-PMU-support.patch"
	${git} "${DIR}/patches/omap_next/0006-ARM-dts-AM33xx-Correct-gpio-interrupt-cells-property.patch"
	${git} "${DIR}/patches/omap_next/0007-ARM-dts-omap5-uevm-Split-SMPS10-in-two-nodes.patch"
	${git} "${DIR}/patches/omap_next/0008-ARM-dts-Remove-0x-s-from-OMAP2420-H4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0009-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0020-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0010-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0030-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0011-ARM-dts-Remove-0x-s-from-OMAP3-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0012-ARM-dts-Remove-0x-s-from-OMAP3430-SDP-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0013-ARM-dts-Remove-0x-s-from-OMAP4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0014-ARM-dts-Remove-0x-s-from-OMAP5-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0015-ARM-dts-twl6030-Move-common-configuration-for-OMAP4-.patch"
	${git} "${DIR}/patches/omap_next/0016-ARM-dts-DRA7-Add-the-dts-files-for-dra7-SoC-and-dra7.patch"
	${git} "${DIR}/patches/omap_next/0017-ARM-dts-AM4372-cpu-s-node-per-latest-binding.patch"
	${git} "${DIR}/patches/omap_next/0018-ARM-dts-AM4372-add-few-nodes.patch"
	${git} "${DIR}/patches/omap_next/0019-ARM-dts-Add-devicetree-for-gta04-board.patch"
	${git} "${DIR}/patches/omap_next/0020-ARM-dts-omap3-beagle-Make-USB-host-pin-naming-consis.patch"
	${git} "${DIR}/patches/omap_next/0021-ARM-OMAP5-dts-add-palmas-usb-node.patch"
	${git} "${DIR}/patches/omap_next/0022-ARM-OMAP5-hwmod-add-missing-ocp2scp-hwmod-data.patch"
	${git} "${DIR}/patches/omap_next/0023-ARM-configs-omap2plus_defconfig-enable-dwc3-and-depe.patch"
	${git} "${DIR}/patches/omap_next/0024-ARM-dts-AM33XX-Add-EDMA-support.patch"
	${git} "${DIR}/patches/omap_next/0025-ARM-dts-AM33XX-Add-SPI-DMA-support.patch"
	${git} "${DIR}/patches/omap_next/0026-ARM-dts-AM33XX-Add-MMC-support-and-documentation.patch"
	${git} "${DIR}/patches/omap_next/0027-ARM-dts-am335x-bone-add-CD-for-mmc1.patch"
	${git} "${DIR}/patches/omap_next/0028-ARM-dts-am335x-boneblack-add-eMMC-DT-entry.patch"
	${git} "${DIR}/patches/omap_next/0029-ARM-dts-am335x-bone-common-switch-mmc1-to-4-bit-mode.patch"
	${git} "${DIR}/patches/omap_next/0030-ARM-dts-am335x-bone-common-add-cpu0-and-mmc1-trigger.patch"
	${git} "${DIR}/patches/omap_next/0031-ARM-dts-AM33XX-use-pinmux-node-defined-in-included-f.patch"
	${git} "${DIR}/patches/omap_next/0032-ARM-dts-AM33XX-don-t-redefine-OCP-bus-and-device-nod.patch"
}

omap_dt_dss () {
	echo "dir: omap_dt_dss"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tomba/linux.git/log/?h=work/dss-dt

	${git} "${DIR}/patches/omap_dt_dss/0001-ARM-OMAP-remove-DSS-DT-hack.patch"
	${git} "${DIR}/patches/omap_dt_dss/0002-OMAPDSS-remove-DT-hacks-for-regulators.patch"
	${git} "${DIR}/patches/omap_dt_dss/0003-ARM-OMAP2-add-omapdss_init_of.patch"
	${git} "${DIR}/patches/omap_dt_dss/0004-OMAPDSS-if-dssdev-name-NULL-use-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0005-OMAPDSS-get-dssdev-alias-from-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0006-OMAPFB-clean-up-default-display-search.patch"
	${git} "${DIR}/patches/omap_dt_dss/0007-OMAPFB-search-for-default-display-with-DT-alias.patch"
	${git} "${DIR}/patches/omap_dt_dss/0008-OMAPDSS-Add-DT-support-to-DSS-DISPC-DPI-HDMI-VENC.patch"
	${git} "${DIR}/patches/omap_dt_dss/0009-OMAPDSS-Add-DT-support-to-DSI.patch"
	${git} "${DIR}/patches/omap_dt_dss/0010-ARM-omap3.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0011-ARM-omap4.dtsi-add-omapdss-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0012-ARM-omap4-panda.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0013-ARM-omap4-sdp.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0014-ARM-omap3-tobi.dts-add-lcd-TEST.patch"
	${git} "${DIR}/patches/omap_dt_dss/0015-ARM-omap3-beagle.dts-add-display-information.patch"
	${git} "${DIR}/patches/omap_dt_dss/0016-OMAPDSS-panel-dsi-cm-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0017-OMAPDSS-encoder-tfp410-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0018-OMAPDSS-connector-dvi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0019-OMAPDSS-encoder-tpd12s015-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0020-OMAPDSS-hdmi-connector-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0021-OMAPDSS-panel-dpi-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0022-OMAPDSS-connector-analog-tv-Add-DT-support.patch"
	${git} "${DIR}/patches/omap_dt_dss/0023-test-ARM-omap3-beagle-xm.dts-add-display-information.patch"
}

imx () {
	echo "dir: imx"
}

omap_usb () {
	echo "dir: omap_usb"
	${git} "${DIR}/patches/omap_usb/0001-usb-phy-generic-Add-gpio_reset-to-platform-data.patch"
	${git} "${DIR}/patches/omap_usb/0002-usb-phy-generic-Don-t-use-regulator-framework-for-RE.patch"
	${git} "${DIR}/patches/omap_usb/0003-ARM-OMAP2-omap-usb-host-Get-rid-of-platform_data-fro.patch"
	${git} "${DIR}/patches/omap_usb/0004-ARM-OMAP2-usb-host-Adapt-to-USB-phy-nop-RESET-line-c.patch"
	${git} "${DIR}/patches/omap_usb/0005-ARM-dts-omap3-beagle-Use-reset-gpios-for-hsusb2_rese.patch"
	${git} "${DIR}/patches/omap_usb/0006-ARM-dts-omap4-panda-Use-reset-gpios-for-hsusb1_reset.patch"
	${git} "${DIR}/patches/omap_usb/0007-ARM-dts-omap5-uevm-Use-reset-gpios-for-hsusb2_reset.patch"
	${git} "${DIR}/patches/omap_usb/0008-ARM-dts-omap3-beagle-xm-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/omap_usb/0009-ARM-dts-omap3-beagle-Add-USB-OTG-PHY-details.patch"
	${git} "${DIR}/patches/omap_usb/0010-hack-beagle-xm-NOP_USB_XCEIV-still-has-to-be-a-modul.patch"
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
	${git} "${DIR}/patches/dts/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0005-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
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

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

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
imx_video
omap3_beagle_xm_rework
omap_sprz319_erratum
#fixes

saucy

echo "patch.sh ran successful"
