#!/bin/sh
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/version.sh
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

git="git am"
#git_patchset=""
#git_opts

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

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
}

#external_git
#local_patch

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

#	${git} "${DIR}/patches/imx_next/0001-ARM-clk-imx6q-parent-lvds_sel-input-from-upstream-cl.patch"
	${git} "${DIR}/patches/imx_next/0002-ARM-i.MX-Select-HAVE_IMX_SRC-for-i.MX5-globally.patch"
	${git} "${DIR}/patches/imx_next/0003-ARM-imx-remove-unused-defines.patch"
	${git} "${DIR}/patches/imx_next/0004-ARM-i.MX1-clk-Add-devicetree-support.patch"
	${git} "${DIR}/patches/imx_next/0005-ARM-i.MX-Remove-registration-helper-for-i.MX1-USB-UD.patch"
	${git} "${DIR}/patches/imx_next/0006-ARM-imx-move-EHCI-platform-defines-out-of-platform_d.patch"
	${git} "${DIR}/patches/imx_next/0007-ARM-imx5-move-SOC_IMX5-and-SOC_IMX51-into-Device-tre.patch"
	${git} "${DIR}/patches/imx_next/0008-ARM-imx5-drop-option-MACH_IMX51_DT.patch"
	${git} "${DIR}/patches/imx_next/0009-ARM-imx5-remove-imx51-non-DT-support-files.patch"
	${git} "${DIR}/patches/imx_next/0010-ARM-imx5-remove-i.MX5-non-DT-device-registration-hel.patch"
	${git} "${DIR}/patches/imx_next/0011-ARM-imx5-make-mx51_clocks_init-a-DT-call.patch"
	${git} "${DIR}/patches/imx_next/0012-ARM-imx5-drop-arguments-from-mx5_clocks_common_init.patch"
	${git} "${DIR}/patches/imx_next/0013-ARM-imx5-tzic_init_irq-can-directly-be-.init_irq-hoo.patch"
	${git} "${DIR}/patches/imx_next/0014-ARM-imx5-remove-function-imx51_soc_init.patch"
	${git} "${DIR}/patches/imx_next/0015-ARM-imx5-call-mxc_timer_init_dt-on-imx51.patch"
	${git} "${DIR}/patches/imx_next/0016-ARM-imx5-retrieve-iim-base-from-device-tree.patch"
	${git} "${DIR}/patches/imx_next/0017-ARM-imx5-remove-header-crm-regs-imx5.h.patch"
	${git} "${DIR}/patches/imx_next/0018-ARM-imx5-use-dynamic-mapping-for-CCM-block.patch"
	${git} "${DIR}/patches/imx_next/0019-ARM-imx5-use-dynamic-mapping-for-DPLL-block.patch"
	${git} "${DIR}/patches/imx_next/0020-ARM-imx5-reuse-clock-CCM-mapping-in-pm-code.patch"
	${git} "${DIR}/patches/imx_next/0021-ARM-imx5-use-dynamic-mapping-for-Cortex-and-GPC-bloc.patch"
	${git} "${DIR}/patches/imx_next/0022-ARM-imx5-move-init-hooks-into-mach-imx5x.c.patch"
	${git} "${DIR}/patches/imx_next/0023-ARM-imx5-remove-file-mm-imx5.c.patch"
	${git} "${DIR}/patches/imx_next/0024-ARM-imx5-clean-function-declarations-in-mx51.h.patch"
	${git} "${DIR}/patches/imx_next/0025-ARM-imx5-remove-mx51.h-and-mx53.h.patch"
	${git} "${DIR}/patches/imx_next/0026-ARM-imx-defconfig-Select-CONFIG_FHANDLE.patch"
	${git} "${DIR}/patches/imx_next/0027-ARM-i.MX-Use-of_clk_get_by_name-for-timer-clocks-for.patch"
	${git} "${DIR}/patches/imx_next/0028-ARM-i.MX-Remove-excess-variable.patch"
	${git} "${DIR}/patches/imx_next/0029-ARM-i.MX27-clk-Separate-DT-and-non-DT-init-procedure.patch"
	${git} "${DIR}/patches/imx_next/0030-ARM-i.MX27-clk-Use-of_clk_init-for-DT-case.patch"
	${git} "${DIR}/patches/imx_next/0031-ARM-i.MX-clk-Move-clock-check-function-in-common-loc.patch"
	${git} "${DIR}/patches/imx_next/0032-ARM-imx_v6_v7_defconfig-Select-CONFIG_SOC_IMX6SX.patch"
	${git} "${DIR}/patches/imx_next/0033-ARM-i.MX-system-Simplify-handling-watchdog-clock.patch"
	${git} "${DIR}/patches/imx_next/0034-ARM-i.MX-system-Add-a-reset-fallback-if-base-address.patch"
	${git} "${DIR}/patches/imx_next/0035-ARM-i.MX-Remove-Freescale-i.MX27-IP-Camera-board-sup.patch"
	${git} "${DIR}/patches/imx_next/0036-ARM-imx-add-suspend-support-for-i.mx6sx.patch"
	${git} "${DIR}/patches/imx_next/0037-ARM-imx-add-cpuidle-support-for-i.mx6sx.patch"
	${git} "${DIR}/patches/imx_next/0038-ARM-imx6qdl-switch-to-use-macro-for-clock-ID.patch"
	${git} "${DIR}/patches/imx_next/0039-ARM-imx-mem-bit-must-be-cleared-before-entering-DSM-.patch"
	${git} "${DIR}/patches/imx_next/0040-ARM-imx-add-standby-mode-support-for-suspend.patch"
	${git} "${DIR}/patches/imx_next/0041-ARM-clk-imx51-imx53-Remove-clk_register_clkdev.patch"
	${git} "${DIR}/patches/imx_next/0042-ARM-i.MX21-clk-Clock-initialization-rework.patch"
	${git} "${DIR}/patches/imx_next/0043-ARM-i.MX21-clk-Remove-clk_register_clkdev-for-unused.patch"
	${git} "${DIR}/patches/imx_next/0044-ARM-i.MX21-clk-Cleanup-driver.patch"
	${git} "${DIR}/patches/imx_next/0045-ARM-i.MX21-clk-Add-devicetree-support.patch"
	${git} "${DIR}/patches/imx_next/0046-ARM-i.MX25-clk-Fix-gpt-timer-clock.patch"
	${git} "${DIR}/patches/imx_next/0047-ARM-i.MX25-clk-Use-of_clk_init-for-DT-case.patch"
	${git} "${DIR}/patches/imx_next/0048-ARM-imx_v4_v5_defconfig-Add-USB-device-options.patch"
	${git} "${DIR}/patches/imx_next/0049-ARM-mx6-Only-check-for-1.2GHz-for-mx6quad.patch"
	${git} "${DIR}/patches/imx_next/0050-ARM-imx-mark-.dt_compat-as-const.patch"
	${git} "${DIR}/patches/imx_next/0051-ARM-imx_v6_v7_defconfig-Enable-STMPE-gpio-support.patch"
	${git} "${DIR}/patches/imx_next/0052-ARM-imx_v6_v7_defconfig-Enable-flexcan-driver-for-ca.patch"
	${git} "${DIR}/patches/imx_next/0053-ARM-imx-clk-imx6sx-register-SSI-SSI_IPG-as-shared-ga.patch"
	${git} "${DIR}/patches/imx_next/0054-ARM-imx_v6_v7_defconfig-add-FSL_EDMA-and-PRINTK_TIME.patch"
	${git} "${DIR}/patches/imx_next/0055-ARM-imx-drop-PL310-errata-588369-and-727915.patch"
	${git} "${DIR}/patches/imx_next/0056-ARM-imx-imx6sx-uses-imx6q-cpuidle-code.patch"
	${git} "${DIR}/patches/imx_next/0057-ARM-imx-build-cpu_is_imx6sl-function-conditionally.patch"
	${git} "${DIR}/patches/imx_next/0058-bus-imx-weim-populate-devices-on-a-simple-bus.patch"
	${git} "${DIR}/patches/imx_next/0059-ARM-imx-use-PTR_ERR_OR_ZERO.patch"
	${git} "${DIR}/patches/imx_next/0060-ARM-i.MX-Remove-i.MX1-camera-support.patch"
	${git} "${DIR}/patches/imx_next/0061-ARM-i.MX-Remove-excess-symbols-ARCH_MX1-ARCH_MX25-an.patch"
	${git} "${DIR}/patches/imx_next/0062-ARM-i.MX-Remove-Freescale-Logic-Product-Development-.patch"
	${git} "${DIR}/patches/imx_next/0063-ARM-i.MX27-clk-Introduce-DT-include-for-clock-provid.patch"
	${git} "${DIR}/patches/imx_next/0064-ARM-i.MX27-clk-Remove-unused-definitions.patch"
	${git} "${DIR}/patches/imx_next/0065-ARM-i.MX27-clk-Add-26-MHz-oscillator-circuit-clock-g.patch"
	${git} "${DIR}/patches/imx_next/0066-ARM-i.MX-allow-disabling-supervisor-protect-via-DT.patch"
	${git} "${DIR}/patches/imx_next/0067-ARM-i.MX53-globally-disable-supervisor-protect.patch"
	${git} "${DIR}/patches/imx_next/0068-ARM-i.MX-Use-CLOCKSOURCE_OF_DECLARE-for-DT-targets.patch"
	${git} "${DIR}/patches/imx_next/0069-ARM-imx-clk-vf610-fix-FlexCAN-clock-gating.patch"
	${git} "${DIR}/patches/imx_next/0070-ARM-dts-imx-add-pin-function-header-for-imx6sx.patch"
	${git} "${DIR}/patches/imx_next/0071-ARM-dts-imx-add-initial-imx6sx-device-tree-source.patch"
	${git} "${DIR}/patches/imx_next/0072-ARM-dts-imx-add-initial-imx6sx-sdb-board-support.patch"
	${git} "${DIR}/patches/imx_next/0073-ARM-dts-Add-support-for-the-cpuimx27-board-from-Eukr.patch"
	${git} "${DIR}/patches/imx_next/0074-ARM-dts-imx6qdl-sabresd-Configure-the-ECSPI1-chip-se.patch"
	${git} "${DIR}/patches/imx_next/0075-ARM-dts-imx6sl-add-fec-sleep-pinctrl-for-pin-PM-stat.patch"
	${git} "${DIR}/patches/imx_next/0076-ARM-dt-imx28-cfa10036-introduce-a-regulator-for-mmc0.patch"
	${git} "${DIR}/patches/imx_next/0077-ARM-dts-imx6-ventana-change-sound-device-name.patch"
	${git} "${DIR}/patches/imx_next/0078-ARM-dts-imx6-ventana-update-model-to-reflect-Dual-So.patch"
	${git} "${DIR}/patches/imx_next/0079-ARM-dts-imx51-babbage-Add-PMIC-RTC-support.patch"
	${git} "${DIR}/patches/imx_next/0080-ARM-dts-pfla02-Add-ethernet-phy-supply-regulator.patch"
	${git} "${DIR}/patches/imx_next/0081-ARM-dts-imx6qdl-Add-CSI-device-tree-port-nodes-for-I.patch"
	${git} "${DIR}/patches/imx_next/0082-ARM-dts-imx25-mbimxsd25-Add-displays-support.patch"
	${git} "${DIR}/patches/imx_next/0083-ARM-dts-imx6q-udoo-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/imx_next/0084-ARM-dts-imx6-add-missing-compatible-and-clock-proper.patch"
	${git} "${DIR}/patches/imx_next/0085-ARM-dts-i.MX35-Add-GPT-node.patch"
	${git} "${DIR}/patches/imx_next/0086-ARM-dts-imx6-add-support-for-Ka-Ro-TX6-modules.patch"
	${git} "${DIR}/patches/imx_next/0087-ARM-dts-imx6-remove-wrong-spdif-rxtx2-clock.patch"
	${git} "${DIR}/patches/imx_next/0088-ARM-dts-imx6-remove-non-working-spdif-rxtx4-and-rxtx.patch"
	${git} "${DIR}/patches/imx_next/0089-ARM-dts-imx6sx-Use-vddarm-as-the-regulator-name.patch"
	${git} "${DIR}/patches/imx_next/0090-ARM-dts-imx50-add-ssi-dma-properties.patch"
	${git} "${DIR}/patches/imx_next/0091-ARM-dts-imx5-remove-fsl-ssi-dma-events.patch"
	${git} "${DIR}/patches/imx_next/0092-ARM-dts-imx6qdl-remove-fsl-ssi-dma-events.patch"
	${git} "${DIR}/patches/imx_next/0093-ARM-dts-imx-remove-ssi-fsl-mode-for-audio-cards.patch"
	${git} "${DIR}/patches/imx_next/0094-ARM-dts-mbimxsd25-cmo-qvga-Fix-lcd-regulator.patch"
	${git} "${DIR}/patches/imx_next/0095-ARM-dts-imx6-add-aristainetos-board-support.patch"
	${git} "${DIR}/patches/imx_next/0096-ARM-dts-imx6sx-sdb-add-gpio-key-support.patch"
	${git} "${DIR}/patches/imx_next/0097-ARM-dts-imx6qdl-use-DT-macro-for-clock-ID.patch"
	${git} "${DIR}/patches/imx_next/0098-ARM-dts-imx6sx-iomux-gpr-syscon-is-compatible-to-imx.patch"
	${git} "${DIR}/patches/imx_next/0099-ARM-dts-imx6sx-Fix-usbmisc-compatible-string.patch"
	${git} "${DIR}/patches/imx_next/0100-ARM-dts-imx6sx-sdb-Add-USB-support.patch"
	${git} "${DIR}/patches/imx_next/0101-ARM-dts-imx6sx-sdb-Add-PMIC-support.patch"
	${git} "${DIR}/patches/imx_next/0102-ARM-dts-cubox-i-add-eSATA-DT-configuration.patch"
	${git} "${DIR}/patches/imx_next/0103-ARM-dts-cubox-i-disable-spread-spectrum-for-Cubox-i-.patch"
	${git} "${DIR}/patches/imx_next/0104-ARM-dts-mx6-Disable-the-keypad-in-the-dtsi-files.patch"
	${git} "${DIR}/patches/imx_next/0105-ARM-dts-i.MX25-Fix-gpt-timers-clocks.patch"
	${git} "${DIR}/patches/imx_next/0106-ARM-dts-mxs-Split-M28EVK-into-SoM-and-EVK-parts.patch"
	${git} "${DIR}/patches/imx_next/0107-ARM-dts-i.MX53-add-aipstz-nodes.patch"
	${git} "${DIR}/patches/imx_next/0108-ARM-dts-imx25-pdk-Add-USB-OTG-support.patch"
	${git} "${DIR}/patches/imx_next/0109-ARM-dts-imx6-edmqmx6-Add-PCIe-support.patch"
	${git} "${DIR}/patches/imx_next/0110-ARM-dts-imx6-edmqmx6-Add-two-other-i2c-buses.patch"
	${git} "${DIR}/patches/imx_next/0111-ARM-dts-imx6-edmqmx6-Add-can-bus.patch"
	${git} "${DIR}/patches/imx_next/0112-ARM-dts-imx6sx-Fix-sdma-node.patch"
	${git} "${DIR}/patches/imx_next/0113-ARM-dts-imx6sx-Pass-the-fsl-fifo-depth-property.patch"
	${git} "${DIR}/patches/imx_next/0114-ARM-dts-imx6sx-sdb-Add-audio-support.patch"
	${git} "${DIR}/patches/imx_next/0115-ARM-dts-imx-correct-sdma-compatbile-for-imx6sl-and-i.patch"
	${git} "${DIR}/patches/imx_next/0116-ARM-i.MX27-clk-dts-Use-clock-defines-in-DTS-files.patch"
	${git} "${DIR}/patches/imx_next/0117-ARM-imx6-Align-ssi-nodes-between-mx6-variants.patch"
	${git} "${DIR}/patches/imx_next/0118-ARM-dts-imx53-correct-clock-names-of-SATA-node.patch"
#	${git} "${DIR}/patches/imx_next/0119-ARM-dts-Restructure-imx6qdl-wandboard.dtsi-for-new-r.patch"
	${git} "${DIR}/patches/imx_next/0120-ARM-dts-vf610-fix-length-of-eshdc1-register-property.patch"
	${git} "${DIR}/patches/imx_next/0121-ARM-dts-imx6-RIoTboard-explicitly-define-pad-setting.patch"
	${git} "${DIR}/patches/imx_next/0122-ARM-dts-mx5-Split-M53EVK-into-SoM-and-EVK-parts.patch"
	${git} "${DIR}/patches/imx_next/0123-ARM-dts-add-initial-Rex-Pro-board-support.patch"
	${git} "${DIR}/patches/imx_next/0124-ARM-dts-add-initial-Rex-Basic-board-support.patch"
	${git} "${DIR}/patches/imx_next/0125-ARM-dts-vf610-add-FlexCAN-node.patch"
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/

	${git} "${DIR}/patches/omap_next/0001-irqchip-crossbar-Dont-use-0-to-mark-reserved-interru.patch"
	${git} "${DIR}/patches/omap_next/0002-irqchip-crossbar-Check-for-premapped-crossbar-before.patch"
	${git} "${DIR}/patches/omap_next/0003-irqchip-crossbar-Introduce-ti-irqs-skip-to-skip-irqs.patch"
	${git} "${DIR}/patches/omap_next/0004-irqchip-crossbar-Initialise-the-crossbar-with-a-safe.patch"
	${git} "${DIR}/patches/omap_next/0005-irqchip-crossbar-Change-allocation-logic-by-reversin.patch"
	${git} "${DIR}/patches/omap_next/0006-irqchip-crossbar-Remove-IS_ERR_VALUE-check.patch"
	${git} "${DIR}/patches/omap_next/0007-irqchip-crossbar-Fix-sparse-and-checkpatch-warnings.patch"
	${git} "${DIR}/patches/omap_next/0008-irqchip-crossbar-Fix-kerneldoc-warning.patch"
	${git} "${DIR}/patches/omap_next/0009-irqchip-crossbar-Return-proper-error-value.patch"
	${git} "${DIR}/patches/omap_next/0010-irqchip-crossbar-Change-the-goto-naming.patch"
	${git} "${DIR}/patches/omap_next/0011-irqchip-crossbar-Set-cb-pointer-to-null-in-case-of-e.patch"
	${git} "${DIR}/patches/omap_next/0012-irqchip-crossbar-Add-kerneldoc-for-crossbar_domain_u.patch"
	${git} "${DIR}/patches/omap_next/0013-irqchip-crossbar-Introduce-ti-max-crossbar-sources-t.patch"
	${git} "${DIR}/patches/omap_next/0014-irqchip-crossbar-Introduce-centralized-check-for-cro.patch"
	${git} "${DIR}/patches/omap_next/0015-documentation-dt-omap-crossbar-Add-description-for-i.patch"
	${git} "${DIR}/patches/omap_next/0016-irqchip-crossbar-Allow-for-quirky-hardware-with-dire.patch"
	${git} "${DIR}/patches/omap_next/0017-ARM-dts-am4372-let-boards-access-all-nodes-through-l.patch"
	${git} "${DIR}/patches/omap_next/0018-ARM-dts-add-support-for-AM437x-StarterKit.patch"
	${git} "${DIR}/patches/omap_next/0019-ARM-OMAP2-convert-sys_ck-and-osc_ck-to-standard-cloc.patch"
	${git} "${DIR}/patches/omap_next/0020-ARM-dts-am335x-evmsk-enable-display-and-lcd-panel-su.patch"
	${git} "${DIR}/patches/omap_next/0021-ARM-OMAP2420-clock-get-rid-of-fixed-div-property-use.patch"
	${git} "${DIR}/patches/omap_next/0022-ARM-OMAP2-PRM-add-support-for-OMAP2-specific-clock-p.patch"
	${git} "${DIR}/patches/omap_next/0023-ARM-OMAP2-clock-use-DT-clock-boot-if-available.patch"
	${git} "${DIR}/patches/omap_next/0024-ARM-OMAP24xx-clock-remove-legacy-clock-data.patch"
	${git} "${DIR}/patches/omap_next/0025-ARM-dts-dra7-add-routable-irqs-property-for-gic-node.patch"
	${git} "${DIR}/patches/omap_next/0026-ARM-dts-dra7-add-crossbar-device-binding.patch"
	${git} "${DIR}/patches/omap_next/0027-ARM-dts-Add-devicetree-for-Gumstix-Pepper-board.patch"
	${git} "${DIR}/patches/omap_next/0028-ARM-dts-AM43x-Add-TPS65218-device-tree-nodes.patch"
	${git} "${DIR}/patches/omap_next/0029-ARM-dts-AM437x-Fix-i2c-nodes-indentation.patch"
	${git} "${DIR}/patches/omap_next/0030-ARM-dts-AM437x-Add-TPS65218-device-tree-nodes.patch"
	${git} "${DIR}/patches/omap_next/0031-ARM-omap2plus_defconfig-enable-TPS65218-configs.patch"
	${git} "${DIR}/patches/omap_next/0032-ARM-dts-dra7-evm-Add-regulator-information-to-USB2-P.patch"
	${git} "${DIR}/patches/omap_next/0033-ARM-dts-dra7xx-clocks-Add-divider-table-to-optfclk_p.patch"
	${git} "${DIR}/patches/omap_next/0034-ARM-dts-dra7xx-clocks-Change-the-parent-of-apll_pcie.patch"
	${git} "${DIR}/patches/omap_next/0035-ARM-dts-dra7xx-clocks-Add-missing-32KHz-clocks-used-.patch"
	${git} "${DIR}/patches/omap_next/0036-ARM-dts-dra7xx-clocks-rename-pcie-clocks-to-accommod.patch"
	${git} "${DIR}/patches/omap_next/0037-ARM-dts-dra7xx-clocks-Add-missing-clocks-for-second-.patch"
	${git} "${DIR}/patches/omap_next/0038-ARM-dts-dra7-Add-dt-data-for-PCIe-PHY-control-module.patch"
	${git} "${DIR}/patches/omap_next/0039-ARM-dts-dra7-Add-dt-data-for-PCIe-PHY.patch"
	${git} "${DIR}/patches/omap_next/0040-ARM-dts-dra7-Add-dt-data-for-PCIe-controller.patch"
	${git} "${DIR}/patches/omap_next/0041-ARM-DTS-omap5-uevm-Enable-palmas-clk32kgaudio-clock.patch"
	${git} "${DIR}/patches/omap_next/0042-ARM-DTS-omap5-uevm-Add-node-for-twl6040-audio-codec.patch"
	${git} "${DIR}/patches/omap_next/0043-ARM-DTS-omap5-uevm-Enable-basic-audio-McPDM-twl6040.patch"
}

tegra_next () {
	echo "dir: tegra_next"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tegra/linux.git/log/?h=for-next
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git for-next

	${git} "${DIR}/patches/tegra_next/0001-ARM-tegra-rebuild-tegra_defconfig.patch"
	${git} "${DIR}/patches/tegra_next/0002-ARM-dts-Create-a-cros-ec-keyboard-fragment.patch"
	${git} "${DIR}/patches/tegra_next/0003-ARM-tegra-Use-the-cros-ec-keyboard-fragment-in-venic.patch"
	${git} "${DIR}/patches/tegra_next/0004-ARM-dts-Use-the-cros-ec-keyboard-fragment-in-exynos5.patch"
	${git} "${DIR}/patches/tegra_next/0005-PCI-tegra-Overhaul-regulator-usage.patch"
	${git} "${DIR}/patches/tegra_next/0006-ARM-tegra-Add-new-PCIe-regulator-properties.patch"
	${git} "${DIR}/patches/tegra_next/0007-kernel-add-calibration_delay_done.patch"
	${git} "${DIR}/patches/tegra_next/0008-ARM-choose-highest-resolution-delay-timer.patch"
	${git} "${DIR}/patches/tegra_next/0009-clocksource-tegra-Use-us-counter-as-delay-timer.patch"
	${git} "${DIR}/patches/tegra_next/0010-ARM-tegra-enable-igb-stmpe-i2c-chardev-lm95245-pwm-l.patch"
	${git} "${DIR}/patches/tegra_next/0011-of-Add-NVIDIA-Tegra-XUSB-pad-controller-binding.patch"
	${git} "${DIR}/patches/tegra_next/0012-pinctrl-Add-NVIDIA-Tegra-XUSB-pad-controller-support.patch"
	${git} "${DIR}/patches/tegra_next/0013-ARM-tegra-Move-includes-to-include-soc-tegra.patch"
	${git} "${DIR}/patches/tegra_next/0014-ARM-tegra-Sort-includes-alphabetically.patch"
	${git} "${DIR}/patches/tegra_next/0015-ARM-tegra-Use-a-function-to-get-the-chip-ID.patch"
	${git} "${DIR}/patches/tegra_next/0016-ARM-tegra-export-apb-dma-readl-writel.patch"
	${git} "${DIR}/patches/tegra_next/0017-ARM-tegra-move-fuse-exports-to-soc-tegra-fuse.h.patch"
	${git} "${DIR}/patches/tegra_next/0018-soc-tegra-Add-efuse-driver-for-Tegra.patch"
	${git} "${DIR}/patches/tegra_next/0019-soc-tegra-Add-efuse-and-apbmisc-bindings.patch"
	${git} "${DIR}/patches/tegra_next/0020-soc-tegra-fuse-move-APB-DMA-into-Tegra20-fuse-driver.patch"
	${git} "${DIR}/patches/tegra_next/0021-soc-tegra-fuse-fix-dummy-functions.patch"
	${git} "${DIR}/patches/tegra_next/0022-soc-tegra-Implement-runtime-check-for-Tegra-SoCs.patch"
	${git} "${DIR}/patches/tegra_next/0023-ARM-tegra-Setup-CPU-hotplug-in-a-pure-initcall.patch"
	${git} "${DIR}/patches/tegra_next/0024-ARM-tegra-Always-lock-the-CPU-reset-vector.patch"
	${git} "${DIR}/patches/tegra_next/0025-soc-tegra-fuse-Set-up-in-early-initcall.patch"
	${git} "${DIR}/patches/tegra_next/0026-ARM-tegra-Convert-PMC-to-a-driver.patch"
	${git} "${DIR}/patches/tegra_next/0027-ARM-tegra-Add-the-EC-i2c-tunnel-to-tegra124-venice2.patch"
	${git} "${DIR}/patches/tegra_next/0028-ARM-tegra-Add-Tegra124-HDA-support.patch"
	${git} "${DIR}/patches/tegra_next/0029-ARM-tegra-venice2-Enable-HDA.patch"
	${git} "${DIR}/patches/tegra_next/0030-ARM-tegra-jetson-tk1-mark-eMMC-as-non-removable.patch"
	${git} "${DIR}/patches/tegra_next/0031-ARM-tegra-initial-support-for-apalis-t30.patch"
	${git} "${DIR}/patches/tegra_next/0032-ARM-tegra-tamonten-add-the-base-board-regulators.patch"
	${git} "${DIR}/patches/tegra_next/0033-ARM-tegra-tamonten-add-the-display-to-the-Medcom-Wid.patch"
	${git} "${DIR}/patches/tegra_next/0034-ARM-tegra-Migrate-Apalis-T30-PCIe-power-supply-schem.patch"
	${git} "${DIR}/patches/tegra_next/0035-ARM-tegra-roth-fix-unsupported-pinmux-properties.patch"
	${git} "${DIR}/patches/tegra_next/0036-ARM-tegra-roth-enable-input-on-mmc-clock-pins.patch"
	${git} "${DIR}/patches/tegra_next/0037-ARM-tegra-of-add-GK20A-device-tree-binding.patch"
	${git} "${DIR}/patches/tegra_next/0038-ARM-tegra-add-GK20A-GPU-to-Tegra124-DT.patch"
	${git} "${DIR}/patches/tegra_next/0039-ARM-tegra-tegra124-Add-XUSB-pad-controller.patch"
	${git} "${DIR}/patches/tegra_next/0040-ARM-tegra-jetson-tk1-Add-XUSB-pad-controller.patch"
	${git} "${DIR}/patches/tegra_next/0041-ARM-tegra-Fix-typoed-ams-ext-control-properties.patch"
	${git} "${DIR}/patches/tegra_next/0042-ARM-tegra-roth-add-display-DT-node.patch"
	${git} "${DIR}/patches/tegra_next/0043-PCI-tegra-Implement-accurate-power-supply-scheme.patch"
	${git} "${DIR}/patches/tegra_next/0044-PCI-tegra-Remove-deprecated-power-supply-properties.patch"
	${git} "${DIR}/patches/tegra_next/0045-ARM-tegra-Remove-legacy-PCIe-power-supply-properties.patch"
}

dts () {
	echo "dir: dts"
#	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
#	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
#	${git} "${DIR}/patches/dts/0003-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

	${git} "${DIR}/patches/dts/0004-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0005-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0008-ARM-dts-omap3-beagle-add-i2c2.patch"

#	${git} "${DIR}/patches/dts/0009-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0011-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"

	${git} "${DIR}/patches/dts/0012-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
#	${git} "${DIR}/patches/dts/0013-arm-dts-add-imx6dl-udoo.patch"
	${git} "${DIR}/patches/dts/0014-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
#	${git} "${DIR}/patches/dts/0015-ARM-dts-imx6dl-udoo-Add-HDMI-support.patch"
#	${git} "${DIR}/patches/dts/0016-ARM-dts-imx6q-udoo-Add-USB-Host-support.patch"
#	${git} "${DIR}/patches/dts/0017-ARM-dts-imx6dl-udoo-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/dts/0018-arm-dts-omap4-move-emif-so-panda-es-b3-now-boots.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
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

	#v3.14.x+
	${git} "${DIR}/patches/vivante/0004-Fixed-vivante-driver-for-kernel-3.14.x.patch"
}

#revert
#drivers
#imx_next
#omap_next
#tegra_next

dts
#omap_sprz319_erratum

#fixes
vivante

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
}

packaging () {
	echo "dir: packaging"
	#${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
}

#packaging_setup
packaging
echo "patch.sh ran successful"
