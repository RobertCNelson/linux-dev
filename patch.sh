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
	#From: https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git for-next

	${git} "${DIR}/patches/imx_next/0001-ARM-dts-mbimxsd35-Add-sound-support.patch"
	${git} "${DIR}/patches/imx_next/0002-ARM-dts-imx-Add-alias-for-ethernet-controller.patch"
	${git} "${DIR}/patches/imx_next/0003-ARM-dts-imx27-phytec-phycore-rdk-Add-missing-pinctrl.patch"
	${git} "${DIR}/patches/imx_next/0004-ARM-dts-imx27-phytec-phycore-som-Enable-SSI1.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-dts-imx6qdl-sabresd.dtsi-Add-red-led.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-dts-imx25-pdk-Sort-the-dt-nodes.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-dts-imx25-pdk-Add-UART1-pins.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-dts-imx25-pdk-Add-FEC-pins.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-dts-imx25-pdk-Provide-a-regulator-for-Ethernet-P.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-dts-imx25-pdk-Provide-an-Ethernet-PHY-reset.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-dts-imx25-pdk-Add-esdhc1-support.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-dts-vf610-twr-Add-support-for-sdhc1.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-dts-mx25-USB-block-requires-only-one-clock.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-dts-mx35-USB-block-requires-only-one-clock.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-dts-imx25.dtsi-Fix-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0016-ARM-dts-mbimxsd25-baseboard-Add-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-dts-i.MX35-Add-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-dts-mbimxsd35-baseboard-Add-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-mx25-Add-CLKO-support.patch"
	${git} "${DIR}/patches/imx_next/0020-ARM-dts-imx25-pdk-Add-audio-support.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-dts-imx25-pdk-Add-keypad-support.patch"
	${git} "${DIR}/patches/imx_next/0022-ARM-dts-imx25-pdk-Add-CAN-support.patch"
	${git} "${DIR}/patches/imx_next/0023-ARM-dts-imx27-phytec-phycore-rdk-Add-display-support.patch"
	${git} "${DIR}/patches/imx_next/0024-ARM-dts-imx25-pdk-Add-USB-Host1-support.patch"
	${git} "${DIR}/patches/imx_next/0025-ARM-dts-i.MX53-Enable-CODA7541-VPU.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-dts-i.MX53-Add-reset-line-to-VPU-device-node.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-dts-vf610-Add-Freescale-FTM-PWM-node.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-dts-vf610-twr-Add-PWM0-s-pinctrl-node.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-dts-vf610-twr-Enables-FTM-PWM-device.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-dts-imx35-pdk-Add-initial-device-tree-support.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-dts-imx51-babbage-Add-USB-Host1-support.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-dts-imx51-babbage-Add-USB-OTG-support.patch"
	${git} "${DIR}/patches/imx_next/0033-ARM-dts-imx28-duckbill-fix-mmc-settings.patch"
	${git} "${DIR}/patches/imx_next/0034-ARM-dts-imx28-include-gpio.h-to-allow-use-of-symboli.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-dts-imx28-duckbill-fix-phy-reset-gpio.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-dts-imx28-duckbill-use-symbolic-names-from-gpio..patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-dts-imx27-phytec-phycore-rdk-Add-display-control.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-dts-imx27-pdk-Pass-the-memory-range.patch"
	${git} "${DIR}/patches/imx_next/0039-of-add-vendor-prefix-for-Toradex-AG.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-dts-add-initial-Colibri-VF61-board-support.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-dts-mbimxsd51-baseboard-Add-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-dts-cpuimx35-Add-touchscreen-support.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-dts-cpuimx51-Add-touchscreen-support.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-dts-i.MX-Use-single-naming-style-for-i.MX-WEIM-d.patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-i.MX51-Add-Digi-ConnectCore-devicetree.patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-dts-imx27-pdk-Keep-the-dt-nodes-sorted.patch"
	${git} "${DIR}/patches/imx_next/0047-ARM-dts-imx27-pdk-Pass-the-UART1-pin-configuration.patch"
	${git} "${DIR}/patches/imx_next/0048-ARM-dts-imx27-pdk-Pass-the-FEC-pin-configuration.patch"
	${git} "${DIR}/patches/imx_next/0049-ARM-dts-Add-Phytec-pfla02-with-i.MX6-DualLite-Solo.patch"
	${git} "${DIR}/patches/imx_next/0050-ARM-dts-Add-Phytec-pbab01-with-i.MX6-DualLite-Solo.patch"
	${git} "${DIR}/patches/imx_next/0051-ARM-dts-pfla02-Add-GPIO-LEDs.patch"
	${git} "${DIR}/patches/imx_next/0052-ARM-dts-pfla02-PHY-reset-is-active-low.patch"
	${git} "${DIR}/patches/imx_next/0053-ARM-dts-pbab01-Set-linux-stdout-path-to-UART4.patch"
	${git} "${DIR}/patches/imx_next/0054-ARM-dts-pbab01-Add-I2C2-and-I2C3.patch"
	${git} "${DIR}/patches/imx_next/0055-ARM-dts-pbab01-Add-I2C-devices.patch"
	${git} "${DIR}/patches/imx_next/0056-ARM-dts-pfla02-Add-UART1-uart3.patch"
	${git} "${DIR}/patches/imx_next/0057-ARM-dts-pbab01-Enable-UART1.patch"
	${git} "${DIR}/patches/imx_next/0058-ARM-dts-pbab01-Enable-DVI.patch"
	${git} "${DIR}/patches/imx_next/0059-ARM-dts-i.MX51-Allow-to-define-partitions-onto-NFC.patch"
	${git} "${DIR}/patches/imx_next/0060-ARM-dts-imx51-babbage-Move-hog-pins-into-corresponde.patch"
	${git} "${DIR}/patches/imx_next/0061-ARM-dts-imx51-babbage-Add-missing-pingroup-for-PMIC.patch"
	${git} "${DIR}/patches/imx_next/0062-ARM-dts-imx51-babbage-Use-predefined-constants-for-k.patch"
	${git} "${DIR}/patches/imx_next/0063-ARM-dts-imx51-babbage-Add-USB-OTG-regulator-node.patch"
	${git} "${DIR}/patches/imx_next/0064-ARM-dts-imx51-babbage-Sort-nodes-by-name.patch"
	${git} "${DIR}/patches/imx_next/0065-ARM-dts-imx51-babbage-Add-devicetree-node-for-I2C1.patch"
	${git} "${DIR}/patches/imx_next/0066-ARM-dts-imx51-babbage-Use-predefined-constants-for-c.patch"
	${git} "${DIR}/patches/imx_next/0067-ARM-dts-imx27-pdk-Add-PMIC-support.patch"
	${git} "${DIR}/patches/imx_next/0068-ARM-dts-imx27-phytec-phycore-som-Move-PMIC-IRQ-GPIO-.patch"
	${git} "${DIR}/patches/imx_next/0069-ARM-dts-imx27-Use-the-correct-usb-clock-gate.patch"
	${git} "${DIR}/patches/imx_next/0070-ARM-dts-imx27-Place-the-usb-phy-nodes-in-the-board-d.patch"
	${git} "${DIR}/patches/imx_next/0071-ARM-dts-imx27-pdk-Add-USB-OTG-support.patch"
	${git} "${DIR}/patches/imx_next/0072-ARM-dts-imx6q-gk802-Enable-HDMI.patch"
	${git} "${DIR}/patches/imx_next/0073-ARM-dts-imx27-pdk-Add-NAND-support.patch"
	${git} "${DIR}/patches/imx_next/0074-ARM-dts-imx27-pdk-Add-keypad-support.patch"
	${git} "${DIR}/patches/imx_next/0075-ARM-dts-imx6qdl-sabresd-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_next/0076-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_next/0077-ARM-dts-imx6qdl-sabresd-Add-PCIe-support.patch"
	${git} "${DIR}/patches/imx_next/0078-ARM-dts-ventana-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_next/0079-ARM-dts-imx27-phytec-phycore-rdk-Remove-duplicate-en.patch"
	${git} "${DIR}/patches/imx_next/0080-ARM-dts-imx27-phytec-phycore-som-Fix-active-level-fo.patch"
	${git} "${DIR}/patches/imx_next/0081-ARM-dts-imx27-phytec-phycore-som-Disable-PM-pins-for.patch"
	${git} "${DIR}/patches/imx_next/0082-ARM-dts-imx-Remove-excess-entries-for-PMIC.patch"
	${git} "${DIR}/patches/imx_next/0083-ARM-dts-imx27-phytec-phycore-rdk-Add-CSI-enable-swit.patch"
	${git} "${DIR}/patches/imx_next/0084-ARM-dts-imx27-phytec-phycore-rdk-Fix-reg-property-fo.patch"
	${git} "${DIR}/patches/imx_next/0085-ARM-dts-imx53-qsb-common-Add-TVE-support.patch"
	${git} "${DIR}/patches/imx_next/0086-ARM-i.MX-mx21ads-Replace-direct-handling-of-peripher.patch"
	${git} "${DIR}/patches/imx_next/0087-ARM-vf610-add-UART-choice-for-low-level-debug.patch"
	${git} "${DIR}/patches/imx_next/0088-ARM-i.MX-mx21ads-Use-fixed-voltage-regulator-for-LCD.patch"
	${git} "${DIR}/patches/imx_next/0089-ARM-i.MX-mx21ads-Cleanup-board.patch"
	${git} "${DIR}/patches/imx_next/0090-ARM-imx_v4_v5_defconfig-Enable-drivers-for-i.MX25-i..patch"
	${git} "${DIR}/patches/imx_next/0091-ARM-i.MX5-Remove-outdated-VPU-clock-lookups.patch"
	${git} "${DIR}/patches/imx_next/0092-ARM-imx-Remove-mx51_babbage-board-file.patch"
	${git} "${DIR}/patches/imx_next/0093-ARM-imx-factor-device-tree-timer-initialization.patch"
	${git} "${DIR}/patches/imx_next/0094-ARM-mxs_defconfig-Select-CONFIG_CRYPTO_DEV_MXS_DCP.patch"
	${git} "${DIR}/patches/imx_next/0095-ARM-imx_v6_v7_defconfig-Add-more-drm-drivers.patch"
	${git} "${DIR}/patches/imx_next/0096-ARM-imx_v6_v7_defconfig-Enable-drivers-for-i.MX51-US.patch"
	${git} "${DIR}/patches/imx_next/0097-ARM-imx_v6_v7_defconfig-enable-cpufreq-and-CMA-suppo.patch"
	${git} "${DIR}/patches/imx_next/0098-ARM-imx6-clk-i.MX6-DualLite-Solo-i2c4-clock.patch"
	${git} "${DIR}/patches/imx_next/0099-ARM-imx-drop-CONFIG_MMC_UNSAFE_RESUME-from-defconfig.patch"
	${git} "${DIR}/patches/imx_next/0100-ARM-imx_v6_v7_defconfig-enable-option-CONFIG_LOCALVE.patch"
	${git} "${DIR}/patches/imx_next/0101-ARM-i.MX-Remove-ifdef-CONFIG_OF.patch"
	${git} "${DIR}/patches/imx_next/0102-ARM-imx-define-struct-clk_gate2-on-our-own.patch"
	${git} "${DIR}/patches/imx_next/0103-ARM-imx-lock-is-always-valid-for-clk_gate2.patch"
	${git} "${DIR}/patches/imx_next/0104-ARM-imx-add-shared-gate-clock-support.patch"
	${git} "${DIR}/patches/imx_next/0105-ARM-imx6q-add-the-missing-esai_ahb-clock.patch"
	${git} "${DIR}/patches/imx_next/0106-ARM-i.MX27-clk-Add-missing-clocks-for-MSHC-and-RTIC.patch"
	${git} "${DIR}/patches/imx_next/0107-ARM-i.MX27-clk-Remove-clk_register_clkdev-for-unused.patch"
	${git} "${DIR}/patches/imx_next/0108-ARM-imx_v4_v5_defconfig-drop-CONFIG_COMMON_CLK_DEBUG.patch"
	${git} "${DIR}/patches/imx_next/0109-ARM-i.MX-Fix-eMMa-PrP-resource-size.patch"
	${git} "${DIR}/patches/imx_next/0110-ARM-dts-imx6-update-pcie-to-bring-in-line-with-new-b.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

tegra_next () {
	echo "dir: tegra_next"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tegra/linux.git/log/?h=for-next
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git for-next

	${git} "${DIR}/patches/tegra_next/0001-ARM-tegra-add-Jetson-TK1-device-tree.patch"
	${git} "${DIR}/patches/tegra_next/0002-ARM-tegra-define-Jetson-TK1-regulators.patch"
	${git} "${DIR}/patches/tegra_next/0003-ARM-tegra-fix-Jetson-TK1-SD-card-supply.patch"
	${git} "${DIR}/patches/tegra_next/0004-ARM-tegra-make-Venice-s-3.3V_RUN-regulator-always-on.patch"
	${git} "${DIR}/patches/tegra_next/0005-ARM-tegra-fix-Venice2-SD-card-VQMMC-supply.patch"
	${git} "${DIR}/patches/tegra_next/0006-ARM-tegra-Add-Tegra124-HDMI-support.patch"
	${git} "${DIR}/patches/tegra_next/0007-ARM-tegra-venice2-Enable-HDMI.patch"
	${git} "${DIR}/patches/tegra_next/0008-ARM-tegra-jetson-tk1-Enable-HDMI-support.patch"
	${git} "${DIR}/patches/tegra_next/0009-ARM-tegra-harmony-Add-5V-HDMI-supply.patch"
	${git} "${DIR}/patches/tegra_next/0010-ARM-tegra-beaver-Add-5V-HDMI-supply.patch"
	${git} "${DIR}/patches/tegra_next/0011-ARM-tegra-dalmore-Add-5V-HDMI-supply.patch"
	${git} "${DIR}/patches/tegra_next/0012-ARM-tegra-dalmore-Add-DSI-power-supply.patch"
	${git} "${DIR}/patches/tegra_next/0013-ARM-tegra-use-correct-audio-CODEC-on-Jetson-TK1.patch"
	${git} "${DIR}/patches/tegra_next/0014-ARM-tegra-add-SD-wp-gpios-to-Jetson-TK1-DT.patch"
	${git} "${DIR}/patches/tegra_next/0015-ARM-tegra-add-SD-wp-gpios-to-Dalmore-DT.patch"
	${git} "${DIR}/patches/tegra_next/0016-ARM-tegra-add-Tegra-Note-7-device-tree.patch"
	${git} "${DIR}/patches/tegra_next/0017-ARM-tegra-add-SD-wp-gpios-to-Venice2-DT.patch"
	${git} "${DIR}/patches/tegra_next/0018-ARM-tegra-Support-reboot-modes.patch"
	${git} "${DIR}/patches/tegra_next/0019-ARM-tegra-add-device-tree-for-SHIELD.patch"
	${git} "${DIR}/patches/tegra_next/0020-ARM-tegra-tegra_defconfig-updates.patch"
	${git} "${DIR}/patches/tegra_next/0021-ARM-tegra-initial-add-of-Colibri-T30.patch"
}

omap_twl4030 () {
	echo "dir: omap_twl4030"
#	${git} "${DIR}/patches/omap_twl4030/0001-ARM-OMAP3-PM-remove-access-to-PRM_VOLTCTRL-register.patch"
	${git} "${DIR}/patches/omap_twl4030/0002-mfd-twl-core-Fix-idle-mode-signaling-for-omaps-when-.patch"
	${git} "${DIR}/patches/omap_twl4030/0003-ARM-OMAP3-Fix-idle-mode-signaling-for-sys_clkreq-and.patch"
	${git} "${DIR}/patches/omap_twl4030/0004-ARM-OMAP3-Disable-broken-omap3_set_off_timings-funct.patch"
	${git} "${DIR}/patches/omap_twl4030/0005-ARM-OMAP3-Fix-voltage-control-for-deeper-idle-states.patch"
	${git} "${DIR}/patches/omap_twl4030/0006-ARM-dts-Configure-omap3-twl4030-I2C4-pins-by-default.patch"
	${git} "${DIR}/patches/omap_twl4030/0007-ARM-OMAP2-Fix-voltage-scaling-init-for-device-tree.patch"
	${git} "${DIR}/patches/omap_twl4030/0008-ARM-dts-Enable-N900-keyboard-sleep-leds-by-default.patch"
	${git} "${DIR}/patches/omap_twl4030/0009-ARM-dts-Fix-omap-serial-wake-up-when-booted-with-dev.patch"
	${git} "${DIR}/patches/omap_twl4030/0010-ARM-OMAP2-Enable-CPUidle-in-omap2plus_defconfig.patch"
	${git} "${DIR}/patches/omap_twl4030/0011-mfd-twl4030-power-Add-generic-reset-configuration.patch"
	${git} "${DIR}/patches/omap_twl4030/0012-mfd-twl4030-power-Add-recommended-idle-configuration.patch"
	${git} "${DIR}/patches/omap_twl4030/0013-mfd-twl4030-power-Add-support-for-board-specific-con.patch"
	${git} "${DIR}/patches/omap_twl4030/0014-mfd-twl4030power-Add-a-configuration-to-turn-off-osc.patch"
	${git} "${DIR}/patches/omap_twl4030/0015-ARM-dts-Enable-twl4030-off-idle-configuration-for-se.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
#	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
#	${git} "${DIR}/patches/dts/0005-hack-wand-enable-hdmi.patch"

	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0008-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0009-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-add-i2c2.patch"

#	${git} "${DIR}/patches/dts/0011-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
	${git} "${DIR}/patches/dts/0012-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0013-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
#	${git} "${DIR}/patches/dts/0014-arch-omap3-add-xm-ab-variant.patch"

#	${git} "${DIR}/patches/dts/0015-arm-dts-vf610-twr-Add-support-for-sdhc1.patch"
	${git} "${DIR}/patches/dts/0016-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
	${git} "${DIR}/patches/dts/0017-arm-dts-add-imx6dl-udoo.patch"
	${git} "${DIR}/patches/dts/0018-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/dts/0019-ARM-dts-imx6q-udoo-Add-HDMI-support.patch"
	${git} "${DIR}/patches/dts/0020-ARM-dts-imx6dl-udoo-Add-HDMI-support.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
	${git} "${DIR}/patches/fixes/0002-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
#	${git} "${DIR}/patches/fixes/0003-ARM-OMAP4-Fix-the-boot-regression-with-CPU_IDLE-enab.patch"
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

next () {
	echo "dir: next"

	${git} "${DIR}/patches/next/0001-clk-sunxi-factors-automatic-reparenting-support.patch"
	${git} "${DIR}/patches/next/0002-clk-sunxi-Implement-MMC-phase-control.patch"
	${git} "${DIR}/patches/next/0003-ARM-sunxi-clk-export-clk_sunxi_mmc_phase_control.patch"
	${git} "${DIR}/patches/next/0004-ARM-sunxi-Add-driver-for-SD-MMC-hosts-found-on-Allwi.patch"
	${git} "${DIR}/patches/next/0005-ARM-dts-sun7i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0006-ARM-dts-sun4i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0007-ARM-dts-sun5i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0008-ARM-sunxi-Add-documentation-for-driver-for-SD-MMC-ho.patch"
	${git} "${DIR}/patches/next/0009-arm-dts-sun4i-a10-olinuxino-lime-enable-mmc0.patch"
}

#revert
drivers
imx_next
#omap_next
tegra_next
omap_twl4030

dts
omap_sprz319_erratum

fixes
vivante
next

echo "patch.sh ran successful"
