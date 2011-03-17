#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

patch -s -p1 < "${DIR}/patches/trivial/0001-staging-add-airlink-awll7025-id-for-rt2860.patch"

#Bisected from 2.6.35 -> 2.6.36 to find this..
#This commit breaks some lcd monitors..
#rcn-ee Feb 26, 2011...
#Still needs more work for 2.6.38, causes:
#[   14.962829] omapdss DISPC error: GFX_FIFO_UNDERFLOW, disabling GFX
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-OMAP-DSS2-OMAPFB-swap-front-and-back-porches-.patch"

}

function for_next {
echo "for_next from tmlind's tree.."

patch -s -p1 < "${DIR}/patches/for_next/0001-omap-Start-using-CONFIG_SOC_OMAP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0002-arm-omap-i2c-fix-compile-warning.patch"
patch -s -p1 < "${DIR}/patches/for_next/0003-arm-omap1-fix-compile-warning.patch"
patch -s -p1 < "${DIR}/patches/for_next/0004-arm-omap1-fix-compile-warnings.patch"
patch -s -p1 < "${DIR}/patches/for_next/0005-arm-omap1-fix-a-bunch-of-section-mismatches.patch"
patch -s -p1 < "${DIR}/patches/for_next/0006-arm-omap2-irq-fix-compile-warning.patch"
patch -s -p1 < "${DIR}/patches/for_next/0007-arm-plat-omap-dma-make-omap_dma_in_1510_mode-static.patch"
patch -s -p1 < "${DIR}/patches/for_next/0008-arm-mach-omap1-board-h2-make-h2_nand_platdata-static.patch"
patch -s -p1 < "${DIR}/patches/for_next/0009-arm-mach-omap1-board-innovator-make-innovator_mmc_in.patch"
patch -s -p1 < "${DIR}/patches/for_next/0010-arm-mach-omap1-board-htcherald-make-htcpld_chips-and.patch"
patch -s -p1 < "${DIR}/patches/for_next/0011-arm-mach-omap1-board-h3-make-nand_platdata-static.patch"
patch -s -p1 < "${DIR}/patches/for_next/0012-ARM-OMAP-Allow-platforms-to-hook-reset-cleanly.patch"
patch -s -p1 < "${DIR}/patches/for_next/0013-arm-mach-omap1-board-voiceblue-add-missing-include.patch"
patch -s -p1 < "${DIR}/patches/for_next/0014-ARM-omap1-nokia770-mark-some-functions-__init.patch"
patch -s -p1 < "${DIR}/patches/for_next/0015-ARM-omap-move-omap_get_config-et-al.-to-.init.text.patch"
patch -s -p1 < "${DIR}/patches/for_next/0016-ARM-omap-move-omap_board_config_kernel-to-.init.data.patch"
patch -s -p1 < "${DIR}/patches/for_next/0017-wip-fix-section-mismatches-in-omap1_defconfig.patch"
patch -s -p1 < "${DIR}/patches/for_next/0018-omap-McBSP-Remove-unused-audio-macros-in-mcbsp.h.patch"
patch -s -p1 < "${DIR}/patches/for_next/0019-ARM-OMAP2-use-early-init-hook.patch"
patch -s -p1 < "${DIR}/patches/for_next/0020-omap2-Make-omap_hwmod_late_init-into-core_initcall.patch"
patch -s -p1 < "${DIR}/patches/for_next/0021-omap2-Fix-omap_serial_early_init-to-work-with-init_e.patch"
patch -s -p1 < "${DIR}/patches/for_next/0022-omap-hwmod-Populate-_mpu_rt_va-later-on-in-omap_hwmo.patch"
patch -s -p1 < "${DIR}/patches/for_next/0023-TI816X-Update-common-omap-platform-files.patch"
patch -s -p1 < "${DIR}/patches/for_next/0024-TI816X-Update-common-OMAP-machine-specific-sources.patch"
patch -s -p1 < "${DIR}/patches/for_next/0025-TI816X-Create-board-support-and-enable-build-for-TI8.patch"
patch -s -p1 < "${DIR}/patches/for_next/0026-TI816X-Add-low-level-debug-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0027-TI816X-Update-to-use-init_early.patch"
patch -s -p1 < "${DIR}/patches/for_next/0028-arm-omap2-clksel-fix-compile-warningOrganization-Tex.patch"
patch -s -p1 < "${DIR}/patches/for_next/0029-OMAP4-hwmod-data-Add-hwspinlock.patch"
patch -s -p1 < "${DIR}/patches/for_next/0030-usb-musb-AM35x-moving-internal-phy-functions-out-of-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0031-arm-omap4-usb-explicitly-configure-MUSB-pads.patch"
patch -s -p1 < "${DIR}/patches/for_next/0032-arm-omap4-4430sdp-drop-ehci-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0033-OMAP2430-hwmod-data-Add-USBOTG.patch"
patch -s -p1 < "${DIR}/patches/for_next/0034-OMAP3xxx-hwmod-data-Add-USBOTG.patch"
patch -s -p1 < "${DIR}/patches/for_next/0035-AM35xx-hwmod-data-Add-USBOTG.patch"
patch -s -p1 < "${DIR}/patches/for_next/0036-OMAP2-musb-hwmod-adaptation-for-musb-registration.patch"
patch -s -p1 < "${DIR}/patches/for_next/0037-OMAP4-hwmod-data-Add-McSPI.patch"
patch -s -p1 < "${DIR}/patches/for_next/0038-OMAP4-hwmod-data-Add-timer.patch"
patch -s -p1 < "${DIR}/patches/for_next/0039-OMAP4-hwmod-data-Add-DSS-DISPC-DSI1-2-RFBI-HDMI-and-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0040-OMAP4-hwmod-data-Add-mailbox.patch"
patch -s -p1 < "${DIR}/patches/for_next/0041-OMAP4-hwmod-data-Add-DMIC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0042-OMAP4-hwmod-data-Add-McBSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0043-OMAP4-hwmod-data-Add-AESS-McPDM-bandgap-counter_32k-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0044-OMAP4-hwmod-data-Add-USBOTG.patch"
patch -s -p1 < "${DIR}/patches/for_next/0045-drivers-hwspinlock-add-framework.patch"
patch -s -p1 < "${DIR}/patches/for_next/0046-drivers-hwspinlock-add-OMAP-implementation.patch"
patch -s -p1 < "${DIR}/patches/for_next/0047-omap-add-hwspinlock-device.patch"
patch -s -p1 < "${DIR}/patches/for_next/0048-OMAP2420-hwmod-data-Add-McSPI.patch"
patch -s -p1 < "${DIR}/patches/for_next/0049-OMAP2430-hwmod-data-Add-McSPI.patch"
patch -s -p1 < "${DIR}/patches/for_next/0050-OMAP3-hwmod-data-Add-McSPI.patch"
patch -s -p1 < "${DIR}/patches/for_next/0051-OMAP-devices-Modify-McSPI-device-to-adapt-to-hwmod-f.patch"
patch -s -p1 < "${DIR}/patches/for_next/0052-OMAP-runtime-McSPI-driver-runtime-conversion.patch"
patch -s -p1 < "${DIR}/patches/for_next/0053-omap2plus-omap4-Set-NR_CPU-to-2-instead-of-default-4.patch"
patch -s -p1 < "${DIR}/patches/for_next/0054-omap4-Remove-FIXME-omap44xx_sram_init-not-implemente.patch"
patch -s -p1 < "${DIR}/patches/for_next/0055-OMAP4-keypad-Add-the-board-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0056-omap3evm-add-support-for-the-WL12xx-WLAN-module-to-t.patch"
patch -s -p1 < "${DIR}/patches/for_next/0057-OMAP3EVM-Reset-the-smsc911x-ethernet-controller-in-b.patch"
patch -s -p1 < "${DIR}/patches/for_next/0058-omap3evm-Change-TWL-related-gpio-API-s-to-gpio-_cans.patch"
patch -s -p1 < "${DIR}/patches/for_next/0059-OMAP3EVM-Add-vio-regulator-supply-required-for-ads78.patch"
patch -s -p1 < "${DIR}/patches/for_next/0060-AM-DM37x-DSS-mux-configuration-for-Rev-B-processor-c.patch"
patch -s -p1 < "${DIR}/patches/for_next/0061-OMAP3EVM-Made-backlight-GPIO-default-state-to-off.patch"
patch -s -p1 < "${DIR}/patches/for_next/0062-OMAP3EVM-Set-TSC-wakeup-option-in-pad-config.patch"
patch -s -p1 < "${DIR}/patches/for_next/0063-omap3630-nand-fix-device-size-to-work-in-polled-mode.patch"
patch -s -p1 < "${DIR}/patches/for_next/0064-omap3-nand-configurable-transfer-type-per-board.patch"
patch -s -p1 < "${DIR}/patches/for_next/0065-omap-gpmc-enable-irq-mode-in-gpmc.patch"
patch -s -p1 < "${DIR}/patches/for_next/0066-omap3-nand-prefetch-in-irq-mode-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0067-omap3-nand-configurable-fifo-threshold-to-gain-the-t.patch"
patch -s -p1 < "${DIR}/patches/for_next/0068-omap3-nand-ecc-layout-select-from-board-file.patch"
patch -s -p1 < "${DIR}/patches/for_next/0069-omap3-nand-making-ecc-layout-as-compatible-with-romc.patch"
patch -s -p1 < "${DIR}/patches/for_next/0070-omap3sdp-Fix-regulator-mapping-for-ads7846-TS-contro.patch"
patch -s -p1 < "${DIR}/patches/for_next/0071-OMAP-OneNAND-fix-104MHz-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0072-OMAP-OneNAND-determine-frequency-in-one-place.patch"
patch -s -p1 < "${DIR}/patches/for_next/0073-OMAP-OneNAND-let-boards-determine-OneNAND-frequency.patch"
patch -s -p1 < "${DIR}/patches/for_next/0074-mtd-OneNAND-OMAP2-increase-multiblock-erase-verify-t.patch"
patch -s -p1 < "${DIR}/patches/for_next/0075-omap-IOMMU-add-missing-function-declaration.patch"
patch -s -p1 < "${DIR}/patches/for_next/0076-omap3-fix-minor-typos.patch"
patch -s -p1 < "${DIR}/patches/for_next/0077-omap3-flash-use-pr_err-instead-of-printk.patch"
patch -s -p1 < "${DIR}/patches/for_next/0078-omap-Add-chip-id-recognition-for-OMAP4-ES2.1-and-ES2.patch"
patch -s -p1 < "${DIR}/patches/for_next/0079-OMAP4-hwmod-data-Add-rev-and-dev_attr-fields-in-McSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0080-omap3sdp-clean-regulator-supply-mapping-in-board-fil.patch"
patch -s -p1 < "${DIR}/patches/for_next/0081-OMAP4-Fix-EINVAL-for-vana-vcxio-vdac.patch"
patch -s -p1 < "${DIR}/patches/for_next/0082-OMAP2-add-regulator-for-MMC1.patch"
patch -s -p1 < "${DIR}/patches/for_next/0083-omap-panda-wlan-board-muxing.patch"
patch -s -p1 < "${DIR}/patches/for_next/0084-omap-select-REGULATOR_FIXED_VOLTAGE-by-default-for-p.patch"
patch -s -p1 < "${DIR}/patches/for_next/0085-omap-panda-add-fixed-regulator-device-for-wlan.patch"
patch -s -p1 < "${DIR}/patches/for_next/0086-omap-panda-add-mmc5-wl1271-device-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0087-OMAP-hsmmc-Enable-MMC4-and-MMC5-on-OMAP4-platforms.patch"
patch -s -p1 < "${DIR}/patches/for_next/0088-OMAP4-hwmod-data-Prevent-timer1-to-be-reset-and-idle.patch"
patch -s -p1 < "${DIR}/patches/for_next/0089-OMAP2420-hwmod-data-add-DSS-DISPC-RFBI-VENC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0090-OMAP2430-hwmod-data-add-DSS-DISPC-RFBI-VENC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0091-OMAP3-hwmod-data-add-DSS-DISPC-RFBI-DSI-VENC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0092-OMAP2-3-DSS2-Use-Regulator-init-with-driver-name.patch"
patch -s -p1 < "${DIR}/patches/for_next/0093-OMAP2-3-DSS2-Create-new-file-display.c-for-central-d.patch"
patch -s -p1 < "${DIR}/patches/for_next/0094-OMAP2-3-DSS2-board-files-replace-platform_device_reg.patch"
patch -s -p1 < "${DIR}/patches/for_next/0095-omap-iommu-Gracefully-fail-iommu_enable-if-no-arch_i.patch"
patch -s -p1 < "${DIR}/patches/for_next/0096-omap-iommu-print-module-name-on-error-messages.patch"
patch -s -p1 < "${DIR}/patches/for_next/0097-OMAP2-hwmod-data-add-mailbox-data.patch"
patch -s -p1 < "${DIR}/patches/for_next/0098-OMAP3-hwmod-data-add-mailbox-data.patch"
patch -s -p1 < "${DIR}/patches/for_next/0099-OMAP-mailbox-build-device-using-omap_device-omap_hwm.patch"
patch -s -p1 < "${DIR}/patches/for_next/0100-OMAP-mailbox-use-runtime-pm-for-clk-and-sysc-handlin.patch"
patch -s -p1 < "${DIR}/patches/for_next/0101-OMAP-hwmod-allow-hwmod-to-provide-address-space-acce.patch"
patch -s -p1 < "${DIR}/patches/for_next/0102-OMAP-McBSP-Convert-McBSP-to-platform-device-model.patch"
patch -s -p1 < "${DIR}/patches/for_next/0103-OMAP2420-hwmod-data-Add-McBSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0104-OMAP2430-hwmod-data-Add-McBSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0105-OMAP3-hwmod-data-Add-McBSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0106-OMAP4-hwmod-Naming-of-address-space.patch"
patch -s -p1 < "${DIR}/patches/for_next/0107-OMAP3-hwmod-add-dev_attr-for-McBSP-sidetone.patch"
patch -s -p1 < "${DIR}/patches/for_next/0108-OMAP2-McBSP-hwmod-adaptation-for-McBSP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0109-OMAP-McBSP-use-omap_device-APIs-to-modify-SYSCONFIG.patch"
patch -s -p1 < "${DIR}/patches/for_next/0110-OMAP-McBSP-Add-pm-runtime-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0111-OMAP-McBSP-APIs-to-pass-DMA-params-from-McBSP-driver.patch"
patch -s -p1 < "${DIR}/patches/for_next/0112-ASoC-McBSP-get-hw-params-from-McBSP-driver.patch"
patch -s -p1 < "${DIR}/patches/for_next/0113-OMAP-hwmod-Removal-of-macros-for-data-that-is-obtain.patch"
patch -s -p1 < "${DIR}/patches/for_next/0114-OMAP2-IOMMU-don-t-print-fault-warning-on-specific-la.patch"
patch -s -p1 < "${DIR}/patches/for_next/0115-omap-IOMMU-add-support-to-callback-during-fault-hand.patch"
patch -s -p1 < "${DIR}/patches/for_next/0116-omap-Fix-compile-if-MTD_NAND_OMAP2-is-not-selected.patch"
patch -s -p1 < "${DIR}/patches/for_next/0117-omap-rx51-Add-SI4713-FM-transmitter.patch"
patch -s -p1 < "${DIR}/patches/for_next/0118-OMAP3-Touchbook-fix-board-initialization.patch"
patch -s -p1 < "${DIR}/patches/for_next/0119-omap2-Minimize-board-specific-init_early-calls.patch"
patch -s -p1 < "${DIR}/patches/for_next/0120-OMAP-powerdomain-remove-unused-func-declaration.patch"
patch -s -p1 < "${DIR}/patches/for_next/0121-OMAP-clockdomain-Infrastructure-to-put-arch-specific.patch"
patch -s -p1 < "${DIR}/patches/for_next/0122-OMAP-clockdomain-Arch-specific-funcs-to-handle-deps.patch"
patch -s -p1 < "${DIR}/patches/for_next/0123-OMAP-clockdomain-Arch-specific-funcs-for-sleep-wakeu.patch"
patch -s -p1 < "${DIR}/patches/for_next/0124-OMAP-clockdomain-Arch-specific-funcs-for-hwsup-contr.patch"
patch -s -p1 < "${DIR}/patches/for_next/0125-OMAP-clockdomain-Arch-specific-funcs-for-clkdm_clk_e.patch"
patch -s -p1 < "${DIR}/patches/for_next/0126-OMAP4-clockdomain-Add-clkdm-static-dependency-srcs.patch"
patch -s -p1 < "${DIR}/patches/for_next/0127-OMAP4-CM-Add-CM-accesor-api-for-bitwise-control.patch"
patch -s -p1 < "${DIR}/patches/for_next/0128-OMAP4-clockdomain-Add-wkup-sleep-dependency-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0129-OMAP4-clockdomain-Remove-pr_errs-stating-unsupported.patch"
patch -s -p1 < "${DIR}/patches/for_next/0130-omap-clock-Check-for-enable-disable-ops-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0131-omap3-dpll-Populate-clkops-for-dpll1_ck.patch"
patch -s -p1 < "${DIR}/patches/for_next/0132-OMAP-clock-Add-allow_idle-deny_idle-support-in-clkop.patch"
patch -s -p1 < "${DIR}/patches/for_next/0133-OMAP3-4-DPLL-Add-allow_idle-deny_idle-support-for-al.patch"
patch -s -p1 < "${DIR}/patches/for_next/0134-OMAP2-clock-autoidle-as-many-clocks-as-possible-if-C.patch"
patch -s -p1 < "${DIR}/patches/for_next/0135-OMAP4-DPLL-Add-dpll-api-to-control-GATE_CTRL.patch"
patch -s -p1 < "${DIR}/patches/for_next/0136-omap4-dpll-Enable-auto-gate-control-for-all-MX-postd.patch"
patch -s -p1 < "${DIR}/patches/for_next/0137-OMAP2-clock-disable-autoidle-on-all-clocks-during-cl.patch"
patch -s -p1 < "${DIR}/patches/for_next/0138-OMAP2420-hwmod-data-add-dmtimer.patch"
patch -s -p1 < "${DIR}/patches/for_next/0139-OMAP2430-hwmod-data-add-dmtimer.patch"
patch -s -p1 < "${DIR}/patches/for_next/0140-OMAP3-hwmod-data-add-dmtimer.patch"
patch -s -p1 < "${DIR}/patches/for_next/0141-OMAP2-hwmod-allow-multiple-calls-to-omap_hwmod_init.patch"
patch -s -p1 < "${DIR}/patches/for_next/0142-OMAP2-hwmod-rename-some-init-functions.patch"
patch -s -p1 < "${DIR}/patches/for_next/0143-OMAP2-hwmod-find-MPU-initiator-hwmod-during-in-_regi.patch"
patch -s -p1 < "${DIR}/patches/for_next/0144-OMAP2-hwmod-ignore-attempts-to-re-setup-a-hwmod.patch"
patch -s -p1 < "${DIR}/patches/for_next/0145-OMAP2-hwmod-add-ability-to-setup-individual-hwmods.patch"
patch -s -p1 < "${DIR}/patches/for_next/0146-OMAP2-clockevent-set-up-GPTIMER-clockevent-hwmod-rig.patch"
patch -s -p1 < "${DIR}/patches/for_next/0147-OMAP2-sdrc-fix-compile-break-on-OMAP4-only-config-on.patch"
patch -s -p1 < "${DIR}/patches/for_next/0148-omap-omap3evm-add-support-for-the-WL12xx-WLAN-module.patch"
patch -s -p1 < "${DIR}/patches/for_next/0149-omap-mmc-split-out-init-for-2420.patch"
patch -s -p1 < "${DIR}/patches/for_next/0150-OMAP2430-hwmod-data-Add-HSMMC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0151-OMAP3-hwmod-data-Add-HSMMC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0152-OMAP4-hwmod-data-enable-HSMMC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0153-OMAP-hwmod-data-Add-dev_attr-and-use-in-the-host-dri.patch"
patch -s -p1 < "${DIR}/patches/for_next/0154-OMAP-hsmmc-Move-mux-configuration-to-hsmmc.c.patch"
patch -s -p1 < "${DIR}/patches/for_next/0155-OMAP-adapt-hsmmc-to-hwmod-framework.patch"
patch -s -p1 < "${DIR}/patches/for_next/0156-OMAP-hsmmc-Rename-the-device-and-driver.patch"
patch -s -p1 < "${DIR}/patches/for_next/0157-omap4-clockdomain-Fix-the-CPUx-domain-name.patch"
patch -s -p1 < "${DIR}/patches/for_next/0158-omap4-powerdomain-Use-intended-PWRSTS_-flags-instead.patch"
patch -s -p1 < "${DIR}/patches/for_next/0159-OMAP2-omap_device-clock-Do-not-expect-an-entry-in-cl.patch"
patch -s -p1 < "${DIR}/patches/for_next/0160-MMC-omap_hsmmc-enable-interface-clock-before-calling.patch"
patch -s -p1 < "${DIR}/patches/for_next/0161-arm-omap-fix-section-mismatch-warning.patch"
patch -s -p1 < "${DIR}/patches/for_next/0162-ldp-Fix-regulator-mapping-for-ads7846-TS-controller.patch"
patch -s -p1 < "${DIR}/patches/for_next/0163-omap-panda-Add-TI-ST-driver-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0164-omap-rx51-Add-support-for-vibra.patch"
patch -s -p1 < "${DIR}/patches/for_next/0165-omap-Remove-unnecessary-twl4030_codec_audio-settings.patch"
patch -s -p1 < "${DIR}/patches/for_next/0166-mfd-twl4030_codec-Remove-unused-and-duplicate-audio_.patch"
patch -s -p1 < "${DIR}/patches/for_next/0167-Revert-OMAP4-hwmod-data-Prevent-timer1-to-be-reset-a.patch"
patch -s -p1 < "${DIR}/patches/for_next/0168-OMAP2-3-WKUP-powerdomain-mark-as-being-always-on.patch"
patch -s -p1 < "${DIR}/patches/for_next/0169-OMAP2-powerdomain-fix-bank-power-state-bitfields.patch"
patch -s -p1 < "${DIR}/patches/for_next/0170-OMAP2-powerdomain-add-pwrdm_can_ever_lose_context.patch"
patch -s -p1 < "${DIR}/patches/for_next/0171-OMAP2-clock-add-DPLL-autoidle-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0172-OMAP2xxx-clock-add-clockfw-autoidle-support-for-APLL.patch"
patch -s -p1 < "${DIR}/patches/for_next/0173-OMAP2-clock-comment-that-osc_ck-osc_sys_ck-should-us.patch"
patch -s -p1 < "${DIR}/patches/for_next/0174-OMAP2-clock-add-interface-clock-type-code-with-autoi.patch"
patch -s -p1 < "${DIR}/patches/for_next/0175-OMAP2420-clock-add-sdrc_ick.patch"
patch -s -p1 < "${DIR}/patches/for_next/0176-OMAP2420-clock-use-autoidle-clkops-for-all-autoidle-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0177-OMAP2430-3xxx-clock-add-modem-clock-autoidle-support.patch"
patch -s -p1 < "${DIR}/patches/for_next/0178-OMAP2430-clock-use-autoidle-clkops-for-all-autoidle-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0179-OMAP3-clock-use-autoidle-clkops-for-all-autoidle-con.patch"
patch -s -p1 < "${DIR}/patches/for_next/0180-OMAP2-3-PM-remove-manual-CM_AUTOIDLE-bit-setting-in-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0181-OMAP-smartreflex-move-plat-smartreflex.h-to-mach-oma.patch"
patch -s -p1 < "${DIR}/patches/for_next/0182-OMAP-voltage-move-plat-voltage.h-to-mach-omap2-volta.patch"
patch -s -p1 < "${DIR}/patches/for_next/0183-OMAP2xxx-clock-fix-parents-for-L3-derived-clocks.patch"
patch -s -p1 < "${DIR}/patches/for_next/0184-OMAP2xxx-clock-fix-low-frequency-oscillator-clock-ra.patch"
patch -s -p1 < "${DIR}/patches/for_next/0185-OMAP2xxx-clock-fix-interface-clocks-and-clockdomains.patch"
patch -s -p1 < "${DIR}/patches/for_next/0186-OMAP-clock-bail-out-early-if-arch_clock-functions-no.patch"
patch -s -p1 < "${DIR}/patches/for_next/0187-OMAP2-clock-remove-the-DPLL-rate-tolerance-code.patch"
patch -s -p1 < "${DIR}/patches/for_next/0188-OMAP2xxx-clock-remove-dsp_irate_ick.patch"
patch -s -p1 < "${DIR}/patches/for_next/0189-omap2-3-clockdomains-fix-compile-time-warnings.patch"
patch -s -p1 < "${DIR}/patches/for_next/0190-OMAP2xxx-clock-fix-clockdomains-on-gpt7_ick-2430-mmc.patch"
patch -s -p1 < "${DIR}/patches/for_next/0191-OMAP2xxx-clock-data-clean-up-some-comments.patch"
patch -s -p1 < "${DIR}/patches/for_next/0192-OMAP1-McBSP-fix-build-break-for-non-multi-OMAP1-conf.patch"
patch -s -p1 < "${DIR}/patches/for_next/0193-audio-AM3517-Adding-i2c-info-for-AIC23-codec.patch"
patch -s -p1 < "${DIR}/patches/for_next/0194-OMAP3-hwmod_data-Add-address-space-and-irq-in-L3-hwm.patch"
patch -s -p1 < "${DIR}/patches/for_next/0195-OMAP3-devices-Initialise-the-l3-device-with-the-hwmo.patch"
patch -s -p1 < "${DIR}/patches/for_next/0196-OMAP3-l3-Introduce-l3-interconnect-error-handling-dr.patch"
patch -s -p1 < "${DIR}/patches/for_next/0197-OMAP4-hwmod_data-Add-address-space-and-irq-in-L3-hwm.patch"
patch -s -p1 < "${DIR}/patches/for_next/0198-OMAP4-Initialise-the-l3-device-with-the-hwmod-data.patch"
patch -s -p1 < "${DIR}/patches/for_next/0199-OMAP4-l3-Introduce-l3-interconnect-error-handling-dr.patch"
patch -s -p1 < "${DIR}/patches/for_next/0200-OMAP2-3-VENC-hwmod-add-OCPIF_SWSUP_IDLE-flag-to-inte.patch"
patch -s -p1 < "${DIR}/patches/for_next/0201-MAINTAINERS-update-Kevin-s-email-for-OMAP-PM-section.patch"
patch -s -p1 < "${DIR}/patches/for_next/0202-OMAP3630-PM-don-t-warn-the-user-with-a-trace-in-case.patch"
patch -s -p1 < "${DIR}/patches/for_next/0203-OMAP3-4-OPP-make-omapx_opp_init-non-static.patch"
patch -s -p1 < "${DIR}/patches/for_next/0204-OMAP3-beagle-xm-enable-up-to-800MHz-OPP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0205-OMAP-PM-SmartReflex-fix-potential-NULL-dereference.patch"
patch -s -p1 < "${DIR}/patches/for_next/0206-OMAP2-remove-unused-UART-base-addresses-from-omap_gl.patch"
patch -s -p1 < "${DIR}/patches/for_next/0207-OMAP2-3-PM-remove-unnecessary-wakeup-sleep-dependenc.patch"
patch -s -p1 < "${DIR}/patches/for_next/0208-omap3-pm-Use-exported-set_cr-instead-of-a-custom-one.patch"
patch -s -p1 < "${DIR}/patches/for_next/0209-omap3-cpuidle-Add-description-field-to-each-C-state.patch"
patch -s -p1 < "${DIR}/patches/for_next/0210-OMAP3-PM-Set-clear-T2-bit-for-Smartreflex-on-TWL.patch"
patch -s -p1 < "${DIR}/patches/for_next/0211-OMAP3-PM-Initialize-IVA-only-if-available.patch"
patch -s -p1 < "${DIR}/patches/for_next/0212-ARM-omap4-Provide-do_wfi-for-Thumb-2.patch"
patch -s -p1 < "${DIR}/patches/for_next/0213-ARM-omap4-Convert-END-to-ENDPROC-for-correct-linkage.patch"
patch -s -p1 < "${DIR}/patches/for_next/0214-ARM-omap3-Remove-hand-encoded-SMC-instructions.patch"
patch -s -p1 < "${DIR}/patches/for_next/0215-ARM-omap3-Thumb-2-compatibility-for-sram34xx.S.patch"
patch -s -p1 < "${DIR}/patches/for_next/0216-ARM-omap3-Thumb-2-compatibility-for-sleep34xx.S.patch"
patch -s -p1 < "${DIR}/patches/for_next/0217-OMAP2-smartreflex-remove-SR-debug-directory-in-omap_.patch"
patch -s -p1 < "${DIR}/patches/for_next/0218-OMAP-clock-fix-compile-warning.patch"
patch -s -p1 < "${DIR}/patches/for_next/0219-MAINTAINERS-add-entry-for-OMAP-powerdomain-clockdoma.patch"
patch -s -p1 < "${DIR}/patches/for_next/0220-OMAP3-hwmod-data-Fix-incorrect-SmartReflex-L4-CORE-i.patch"
patch -s -p1 < "${DIR}/patches/for_next/0221-OMAP3-hwmod-data-Remove-masters-port-links-for-inter.patch"
patch -s -p1 < "${DIR}/patches/for_next/0222-OMAP2-hwmod-fix-incorrect-computation-of-autoidle_ma.patch"
patch -s -p1 < "${DIR}/patches/for_next/0223-omap-hwmod-add-syss-reset-done-flags-to-omap2-omap3-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0224-OMAP2-hwmod-Fix-what-_init_clock-returns.patch"
patch -s -p1 < "${DIR}/patches/for_next/0225-OMAP2-hwmod-fix-a-documentation-bug-with-HWMOD_NO_OC.patch"
patch -s -p1 < "${DIR}/patches/for_next/0226-OMAP2-hwmod-use-status-bit-info-for-reset-line.patch"
patch -s -p1 < "${DIR}/patches/for_next/0227-OMAP2-hwmod-allow-board-files-to-prevent-devices-fro.patch"
patch -s -p1 < "${DIR}/patches/for_next/0228-OMAP2-hwmod-add-API-to-handle-autoidle-mode.patch"
patch -s -p1 < "${DIR}/patches/for_next/0229-OMAP2-clockdomain-add-flag-that-will-block-autodeps-.patch"
patch -s -p1 < "${DIR}/patches/for_next/0230-omap2-3-dmtimer-Enable-autoidle.patch"
patch -s -p1 < "${DIR}/patches/for_next/0231-omap-Fix-H4-init_irq-to-not-call-h4_init_flash.patch"
patch -s -p1 < "${DIR}/patches/for_next/0232-OMAP3-PM-Use-ARMv7-supported-instructions-instead-of.patch"
patch -s -p1 < "${DIR}/patches/for_next/0233-OMAP3-PM-Fix-the-MMU-on-sequence-in-the-asm-code.patch"
patch -s -p1 < "${DIR}/patches/for_next/0234-OMAP3-PM-Allow-the-cache-clean-when-L1-is-lost.patch"
patch -s -p1 < "${DIR}/patches/for_next/0235-OMAP3-PM-Remove-un-necessary-cp15-registers-form-low.patch"
patch -s -p1 < "${DIR}/patches/for_next/0236-OMAP3-PM-Clear-the-SCTLR-C-bit-in-asm-code-to-preven.patch"
patch -s -p1 < "${DIR}/patches/for_next/0237-OMAP2-voltage-reorganize-split-code-from-data.patch"
patch -s -p1 < "${DIR}/patches/for_next/0238-Watchdog-omap_wdt-add-fine-grain-runtime-pm.patch"
patch -s -p1 < "${DIR}/patches/for_next/0239-OMAP3-wdtimer-Fix-CORE-idle-transition.patch"
patch -s -p1 < "${DIR}/patches/for_next/0240-OMAP3-OPP-Replace-voltage-values-with-Macros.patch"
patch -s -p1 < "${DIR}/patches/for_next/0241-OMAP4-Enable-800-MHz-and-1-GHz-MPU-OPP.patch"
patch -s -p1 < "${DIR}/patches/for_next/0242-OMAP4-Update-Voltage-Rail-Values-for-MPU-IVA-and-COR.patch"
patch -s -p1 < "${DIR}/patches/for_next/0243-OMAP4-Add-IVA-OPP-enteries.patch"
patch -s -p1 < "${DIR}/patches/for_next/0244-perf-add-OMAP-support-for-the-new-power-events.patch"
patch -s -p1 < "${DIR}/patches/for_next/0245-omap2-Add-separate-list-for-dynamic-pads-to-mux.patch"
patch -s -p1 < "${DIR}/patches/for_next/0246-omap2-mux-Remove-the-use-of-IDLE-flag.patch"
patch -s -p1 < "${DIR}/patches/for_next/0247-omap2-mux-Add-macro-for-configuring-static-with-omap.patch"
patch -s -p1 < "${DIR}/patches/for_next/0248-omap4-board-4430sdp-Initialise-the-serial-pads.patch"
patch -s -p1 < "${DIR}/patches/for_next/0249-omap3-board-3430sdp-Initialise-the-serial-pads.patch"
patch -s -p1 < "${DIR}/patches/for_next/0250-omap4-board-omap4panda-Initialise-the-serial-pads.patch"
patch -s -p1 < "${DIR}/patches/for_next/0251-omap2-mux-Fix-compile-when-CONFIG_OMAP_MUX-is-not-se.patch"
patch -s -p1 < "${DIR}/patches/for_next/0252-omap-iovmm-disallow-mapping-NULL-address-when-IOVMF_.patch"
patch -s -p1 < "${DIR}/patches/for_next/0253-omap-iovmm-don-t-check-da-to-set-IOVMF_DA_FIXED-flag.patch"
patch -s -p1 < "${DIR}/patches/for_next/0254-omap4-mux-Remove-duplicate-mux-modes.patch"
patch -s -p1 < "${DIR}/patches/for_next/0255-OMAP2-Common-CPU-DIE-ID-reading-code-reads-wrong-reg.patch"
patch -s -p1 < "${DIR}/patches/for_next/0256-arm-plat-omap-iommu-fix-request_mem_region-error-pat.patch"
patch -s -p1 < "${DIR}/patches/for_next/0257-omap-zoom-host-should-not-pull-up-wl1271-s-irq-line.patch"
patch -s -p1 < "${DIR}/patches/for_next/0258-merge-changes-missed-in-rebase.patch"

#patches needed after merge
patch -s -p1 < "${DIR}/patches/trivial/0001-arm-sleep34xx.o-has-smc-so-needs-plus_sec-binutils-e.patch"

}

function dss2_next {
echo "dss2 from for-next"

patch -s -p1 < "${DIR}/patches/dss2_next/0146-OMAP-3430SDP-Remove-unused-vdda_dac-supply.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0147-OMAP2-3-DSS2-remove-forced-clk-disable-from-omap_dss.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0148-OMAP2-3-DSS2-Build-omap_device-for-each-DSS-HWIP.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0149-OMAP2-3-DSS2-DSS-create-platform_driver-move-init-ex.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0150-OMAP2-3-DSS2-Move-clocks-from-core-driver-to-dss-dri.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0151-OMAP2-3-DSS2-RFBI-create-platform_driver-move-init-e.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0152-OMAP2-3-DSS2-DISPC-create-platform_driver-move-init-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0153-OMAP2-3-DSS2-VENC-create-platform_driver-move-init-e.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0154-OMAP2-3-DSS2-DSI-create-platform_driver-move-init-ex.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0155-OMAP2-3-DSS2-replace-printk-with-dev_dbg-in-init.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0156-OMAP2-3-DSS2-Use-platform-device-to-get-baseaddr.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0157-OMAP2-3-DSS2-Get-DSS-IRQ-from-platform-device.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0158-OMAP2PLUS-clocks-Align-DSS-clock-names-and-roles.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0159-OMAP2PLUS-DSS2-Generalize-naming-of-PRCM-related-clo.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0160-OMAP2PLUS-DSS2-Generalize-external-clock-names-in-st.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0161-OMAP4-DSS2-clocks-Add-ick-as-dummy-clock.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0162-OMAP2PLUS-DSS2-Add-OMAP4-Kconfig-support.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0163-OMAP4-DSS2-Add-hwmod-device-names-for-OMAP4.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0164-OMAP-DSS2-Fix-def_disp-module-param-description.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0165-OMAP-DSS2-Delay-regulator_get-calls.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0166-OMAP-DSS2-Support-for-Samsung-LTE430WQ-F0C.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0167-OMAPFB-Adding-a-check-for-timings-in-set_def_mode.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0168-OMAP-DSS2-Have-separate-irq-handlers-for-DISPC-and-D.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0169-MAINTAINERS-Update-OMAP-DSS-maintainer.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0170-OMAP2-3-4-DSS2-Enable-Display-SubSystem-as-modules.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0171-OMAP-DSS2-Clean-up-a-switch-case.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0172-OMAP-DSS2-FEATURES-Remove-SDI-from-3630-displays.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0173-OMAP-DSS2-FEATURES-Remove-DSI-SDI-from-OMAP2.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0174-OMAP-DSS2-Check-for-SDI-HW-before-accessing-SDI-regi.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0175-OMAP-OMAPFB-Adding-help-for-FB_OMAP_LCD_VGA-option.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0176-OMAP-DSS2-Remove-unused-list.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0177-OMAP-DSS2-DSI-remove-unused-function.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0178-OMAP2PLUS-DSS2-add-opt_clock_available-in-pdata.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0179-OMAP2PLUS-DSS2-Use-opt_clock_available-from-pdata.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0180-omapfb-Fix-linker-error-in-drivers-video-omap-lcd_24.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0181-OMAP2PLUS-DSS2-FEATURES-DISPC-overlay-code-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0182-OMAP2PLUS-DSS2-FEATURES-Function-to-Provide-the-max-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0183-OMAP2PLUS-DSS2-Make-members-of-dss_clk_source-generi.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0184-OMAP2PLUS-DSS2-Use-dss-features-to-get-clock-source-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0185-OMAP2PLUS-DSS2-DSI-Generalize-DSI-PLL-Clock-Naming.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0186-OMAP-DSS2-Remove-FB_OMAP_BOOTLOADER_INIT-support.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0187-OMAP-DSS2-Remove-pdev-argument-from-dpi_init.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0188-OMAP-DSS2-Move-DPI-SDI-init-into-DSS-plat-driver.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0189-OMAP-DSS2-Remove-unneeded-cpu_is_xxx-checks.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0190-OMAP-DSS2-Functions-to-request-release-DSI-VCs.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0191-OMAP-DSS2-Use-request-release-calls-in-Taal-for-DSI-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0192-HACK-OMAP-DSS2-Fix-OMAP2_DSS_USE_DSI_PLL.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0193-HACK-OMAP-DSS2-add-delay-after-enabling-clocks.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0194-OMAP-DSS2-Adding-dss_features-for-independent-core-c.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0195-OMAP-DSS2-Renaming-register-macro-DISPC_DIVISOR-ch.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0196-OMAP4-DSS2-Using-dss_features-to-set-independent-cor.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0197-OMAP-DSS2-fix-omap_dispc_register_isr-fail-path.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0198-OMAP-DSS2-Add-support-for-LG-Philips-LB035Q02-panel.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0199-OMAP-DSS2-Add-DSS2-support-for-Overo.patch"

patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP2PLUS-DSS2-Cleanup-clock-source-related-code.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0002-OMAP4-DSS2-Clock-source-changes-for-OMAP4.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0003-omap-overo-Add-regulator-for-ads7846.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0004-OMAP-Add-gpio-leds-support-for-Overo.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0005-OMAP-Add-gpio-keys-support-for-Overo.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0006-HACK-OMAP-DSS2-VENC-disable-VENC-on-OMAP4-to-prevent.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0007-OMAP2PLUS-DSS2-FEATURES-Fix-usage-of-dss_reg_field-a.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0008-OMAP-DSS2-FEATURES-Functions-to-return-min-and-max-v.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0009-OMAP-DSS2-FEATURES-DSI-PLL-parameter-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0010-OMAP-DSS2-DSI-Restructure-IRQ-handler.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0011-OMAP-DSS2-DSI-Add-ISR-support.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0012-OMAP-DSS2-DSI-use-ISR-in-send_bta_sync.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0013-OMAP-DSS2-DSI-use-ISR-for-BTA-in-framedone.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0014-OMAP-DSS2-DSI-catch-DSI-errors-in-send_bta_sync.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0015-OMAP-DSS2-DSI-fix-IRQ-debug-prints.patch"

patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP4-DSS2-Add-display-type-HDMI-to-DSS2.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0002-OMAP4-DSS2-HDMI-Select-between-HDMI-VENC-clock-sourc.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0003-OMAP4-DSS2-HDMI-Dispc-gamma-enable-set-reset-functio.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0004-OMAP4-DSS2-HDMI-HDMI-driver-header-file-addition.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0005-OMAP4-DSS2-HDMI-HDMI-driver-addition-in-the-DSS.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0006-OMAP4-DSS2-HDMI-HDMI-panel-driver-addition-in-the-DS.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0007-OMAP4-DSS2-HDMI-Add-makefile-and-kconfig-changes-to-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0008-OMAP4-DSS-HDMI-Call-to-HDMI-module-init-to-register-.patch"
patch -s -p1 < "${DIR}/patches/dss2_next/0009-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0010-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"

}

function dspbridge_next {
echo "dspbridge from for-next"

patch -s -p1 < "${DIR}/patches/dspbridge/0001-staging-tidspbridge-make-sync_wait_on_event-interrup.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0002-staging-tidspbridge-overwrite-DSP-error-codes.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0003-staging-tidspbridge-Eliminate-direct-manipulation-of.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0004-staging-tidspbridge-fix-mgr_enum_node_info.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0005-staging-tidspbridge-mgr_enum_node_info-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0006-staging-tidspbridge-fix-kernel-oops-in-bridge_io_get.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0007-staging-tidspbridge-remove-gs-memory-allocator.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0008-staging-tidspbridge-remove-utildefs.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0009-staging-tidspbridge-switch-to-linux-bitmap-API.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0010-staging-tidspbridge-remove-gb-bitmap-implementation.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0011-staging-tidspbridge-convert-core-to-list_head.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0012-staging-tidspbridge-convert-pmgr-to-list_head.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0013-staging-tidspbridge-convert-rmgr-to-list_head.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0014-staging-tidspbridge-remove-custom-linked-list.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0015-staging-tidspbridge-core-code-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0016-staging-tidspbridge-pmgr-code-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0017-staging-tidspbridge-use-the-right-type-for-list_is_l.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0018-staging-tidspbridge-rmgr-node.c-code-cleanup.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0019-staging-tidspbridge-Fix-atoi-to-support-hexadecimal-.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0020-staging-tidspbridge-Remove-unused-defined-constants.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0021-staging-tidspbridge-Remove-unused-functions.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0022-staging-tidspbridge-Remove-unused-structs.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0023-staging-tidspbridge-Remove-unused-typedefs.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0024-staging-tidspbridge-Remove-trivial-header-files.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0025-staging-tidspbridge-remove-code-referred-by-OPT_ZERO.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0026-staging-tidspbridge-set1-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0027-staging-tidspbridge-set2-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0028-staging-tidspbridge-set3-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0029-staging-tidspbridge-set4-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0030-staging-tidspbridge-set5-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0031-staging-tidspbridge-set6-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0032-staging-tidspbridge-set7-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0033-staging-tidspbridge-set8-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0034-staging-tidspbridge-set9-remove-hungarian-from-struc.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0035-staging-tidspbridge-set10-remove-hungarian-from-stru.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0036-staging-tidspbridge-set11-remove-hungarian-from-stru.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0037-staging-tidspbridge-set12-remove-hungarian-from-stru.patch"

}

function wip_to_be_pushed_git  {
echo "wip patches for mainline"

git_add
git am "${DIR}/patches/wip_to_be_pushed/0001-omap3-beagle-convert-printk-KERN_INFO-to-pr_info.patch"
git am "${DIR}/patches/wip_to_be_pushed/0002-omap3-beagle-convert-printk-KERN_ERR-to-pr_err.patch"
git am "${DIR}/patches/wip_to_be_pushed/0003-omap3-beagle-detect-new-xM-revision-B.patch"
git am "${DIR}/patches/wip_to_be_pushed/0004-omap3-beagle-detect-new-xM-revision-C.patch"
git am "${DIR}/patches/wip_to_be_pushed/0005-omap3-beagle-if-rev-unknown-assume-xM-revision-C.patch"
git am "${DIR}/patches/wip_to_be_pushed/0006-omap3-beagle-add-i2c-bus2.patch"
git am "${DIR}/patches/wip_to_be_pushed/0007-omap3-beagle-add-initial-expansionboard-infrastructu.patch"
git am "${DIR}/patches/wip_to_be_pushed/0008-omap3-beagle-expansionboard-zippy.patch"
git am "${DIR}/patches/wip_to_be_pushed/0009-omap3-beagle-expansionboard-zippy2.patch"

}

function wip_to_be_pushed  {
echo "wip patches for mainline"

patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0001-omap3-beagle-convert-printk-KERN_INFO-to-pr_info.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0002-omap3-beagle-convert-printk-KERN_ERR-to-pr_err.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0003-omap3-beagle-detect-new-xM-revision-B.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0004-omap3-beagle-detect-new-xM-revision-C.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0005-omap3-beagle-if-rev-unknown-assume-xM-revision-C.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0006-omap3-beagle-add-i2c-bus2.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0007-omap3-beagle-add-initial-expansionboard-infrastructu.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0008-omap3-beagle-expansionboard-zippy.patch"
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0009-omap3-beagle-expansionboard-zippy2.patch"

}

function sakoman {
echo "sakoman's patches"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0001-video-add-timings-for-hd720.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0003-Don-t-turn-SDIO-cards-off-to-save-power.-Doing-so-wi.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0004-mmc-don-t-display-single-block-read-console-messages.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0005-scripts-Makefile.fwinst-fix-typo-missing-space-in-se.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0006-drivers-net-smsc911x-return-ENODEV-if-device-is-not-.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0007-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0008-ASoC-enable-audio-capture-by-default-for-twl4030.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0011-ARM-OMAP-Make-beagle-u-boot-partition-writable.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.37/0012-MFD-enable-madc-clock.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0013-MFD-add-twl4030-madc-driver.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0014-ARM-OMAP-Add-twl4030-madc-support-to-Overo.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0015-ARM-OMAP-Add-twl4030-madc-support-to-Beagle.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0016-OMAP-DSS2-Add-support-for-Samsung-LTE430WQ-F0C-panel.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0019-OMAP-DSS2-add-bootarg-for-selecting-svideo-or-compos.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0020-ARM-OMAP2-mmc-twl4030-move-clock-input-selection-pri.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0021-RTC-add-support-for-backup-battery-recharge.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0026-ARM-OMAP-Add-macros-for-comparing-silicon-revision.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0027-OMAP-DSS2-check-for-both-cpu-type-and-revision-rathe.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0028-OMAP-DSS2-enable-hsclk-in-dsi_pll_init-for-OMAP36XX.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0030-Revert-Input-ads7846-add-regulator-support.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0031-Revert-omap2_mcspi-Flush-posted-writes.patch"

}

function musb {
echo "musb patches"
patch -s -p1 < "${DIR}/patches/musb/0001-default-to-fifo-mode-5-for-old-musb-beagles.patch"
}

function micrel {
echo "micrel patches"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/01_eeprom_93cx6_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/02_eeprom_93cx6_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/03_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.38/04_ksz8851_2.6.38.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/06_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/07_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/08_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/09_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/10_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/11_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/12_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/15_ksz8851_2.6.35.patch"
patch -s -p1 < "${DIR}/patches/micrel/linux-2.6.35/18_ksz8851_2.6.35.patch"

}

function beagle {
echo "beagle patches"
patch -s -p1 < "${DIR}/patches/arago-project/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-alsa-soc-Remove-restrictive-check-for-cpu-type.patch"

#disabled in for_next merge
#patch -s -p1 < "${DIR}/patches/beagle/0001-xM-audio-fix-from-Ashok.patch"

#need more work
#patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-beaglexm-fix-DVI-initialization.patch"
#patch -s -p1 < "${DIR}/patches/beagle/0001-beaglexm-fix-DVI-updated-for-xMC.patch"

}

function igepv2 {
echo "igepv2 board related patches"
}

function devkit8000 {
echo "devkit8000"
patch -s -p1 < "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel-2.6.37-git10.patch"
}

function touchbook {
echo "touchbook patches"
patch -s -p1 < "${DIR}/patches/touchbook/0001-omap3-touchbook-remove-mmc-gpio_wp.patch"
patch -s -p1 < "${DIR}/patches/touchbook/0002-omap3-touchbook-drop-u-boot-readonly.patch"
patch -s -p1 < "${DIR}/patches/touchbook/0003-omap3-touchbook-fix-ehci.patch"
#patch -s -p1 < "${DIR}/patches/touchbook/0004-omap3-touchbook-tesing-lcd-display.patch"
}

function omap4 {
echo "omap4 related patches"
patch -s -p1 < "${DIR}/patches/panda/0001-OMAP4-PandaBoard-remove-unused-power-regulators.patch"


#patch -s -p1 < "${DIR}/patches/panda/0028-OMAP-DSS-Renaming-the-dpll-clk-pointer-in-struct-dss.patch"
#patch -s -p1 < "${DIR}/patches/panda/0029-OMAP-DSS2-Using-dss_features-to-clean-cpu-checks-for.patch"
#patch -s -p1 < "${DIR}/patches/panda/0030-OMAP-DSS2-Get-OMAP4-DPLL-fclk-for-DPI-interface.patch"
#patch -s -p1 < "${DIR}/patches/panda/0035-OMAP4-PandaBoard-Adding-DVI-support.patch"

#from: http://dev.omapzoom.org/?p=axelcx/kernel-display.git;a=shortlog;h=refs/heads/lo-dss2-Mar15
#patch -s -p1 < "${DIR}/patches/panda/0001-OMAP2PLUS-DSS2-Cleanup-clock-source-related-code.patch"
#patch -s -p1 < "${DIR}/patches/panda/0002-OMAP4-DSS2-Clock-source-changes-for-OMAP4.patch"
#patch -s -p1 < "${DIR}/patches/panda/0003-omap-overo-Add-regulator-for-ads7846.patch"
#patch -s -p1 < "${DIR}/patches/panda/0004-OMAP-Add-gpio-leds-support-for-Overo.patch"
#patch -s -p1 < "${DIR}/patches/panda/0005-OMAP-Add-gpio-keys-support-for-Overo.patch"
#patch -s -p1 < "${DIR}/patches/panda/0006-OMAP-DSS2-FEATURES-DSI-PLL-parameter-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/panda/0007-OMAP4-DSS2-Add-display-type-HDMI-to-DSS2.patch"
#patch -s -p1 < "${DIR}/patches/panda/0008-OMAP4-DSS2-HDMI-Select-between-HDMI-VENC-clock-sourc.patch"
#patch -s -p1 < "${DIR}/patches/panda/0009-OMAP4-DSS2-HDMI-Dispc-gamma-enable-set-reset-functio.patch"
#patch -s -p1 < "${DIR}/patches/panda/0010-OMAP4-DSS2-HDMI-HDMI-driver-header-file-addition.patch"
#patch -s -p1 < "${DIR}/patches/panda/0011-OMAP4-DSS2-HDMI-HDMI-driver-addition-in-the-DSS.patch"
#patch -s -p1 < "${DIR}/patches/panda/0012-OMAP4-DSS2-HDMI-HDMI-panel-driver-addition-in-the-DS.patch"
#patch -s -p1 < "${DIR}/patches/panda/0013-OMAP4-DSS2-HDMI-Add-makefile-and-kconfig-changes-to-.patch"
#patch -s -p1 < "${DIR}/patches/panda/0014-OMAP4-DSS-HDMI-Call-to-HDMI-module-init-to-register-.patch"
#patch -s -p1 < "${DIR}/patches/panda/0015-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"
#patch -s -p1 < "${DIR}/patches/panda/0016-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"

}

function sgx {
echo "merge in ti sgx modules"
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-3.01.00.02-Kernel-Modules.patch"
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-enable-driver-building.patch"

#3.01.00.06
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-3.01.00.06-into-TI-3.01.00.02.patch"

#3.01.00.07 'the first wget-able release!!'
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-3.01.00.07-into-TI-3.01.00.06.patch"

#4.00.00.01 adds ti8168 support, drops bc_cat.c patch
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-4.00.00.01-into-TI-3.01.00.07.patch"

#4.03.00.01
#Note: git am has problems with this patch...
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-4.03.00.01-into-TI-4.00.00.01.patch"

#4.03.00.02 (main *.bin drops omap4)
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-4.03.00.02-into-TI-4.03.00.01.patch"

#3.01.00.06/07 & 4.00.00.01 Patches
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.32-PSP.patch"
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-use-omap3630.patch"
#tuned for 4.03.00.02
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.32-PSP.patch"

#dropped with 4.00.00.01
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-Compile-Fixes.patch"

#3.01.00.06 + 2.6.36-rc1
#dropped with 4.03.00.01/2
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.36-rc1-Compile-Fixes.patch"

#4.00.00.01 + 2.6.37-rc1
#dropped with 4.03.00.01/2
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.37-rc1-use-semaphore-ove.patch"

#4.00.00.01 but really 3.01.00.06+ could use it, annoying bug when you 'restart' the core..
#dropped with 4.03.00.01/2
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-remove-proc-without-debug.patch"

#4.00.00.01 + 2.6.38-merge (2.6.37-git5): so needs to be tested... (jan 10 rcn-ee)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.38-merge-AUTOCONF_INCLUD.patch"
#tuned for 4.03.00.02
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.38-merge-AUTOCONF_INCLUD.patch"

#4.00.00.01 + 2.6.38-rc3
#http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ac751efa6a0d70f2c9daef5c7e3a92270f5c2dff
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.38-rc3-_console_sem-to-c.patch"
#tuned for 4.03.00.02
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.38-rc3-_console_sem-to-c.patch"

#4.03.00.01
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.01-add-outer_cache.clean_all.patch"

}

function dvfs {
echo "dvfs"

#from:http://gitorious.org/linux-omap-nm-sr/linux-omap-sr/commits/sr-dvfs-1.5
patch -s -p1 < "${DIR}/patches/dvfs/0002-OMAP3-CPUIdle-prevent-CORE-from-going-off-if-doing-s.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0003-OMAP-CPUfreq-ensure-driver-initializes-after-cpufreq.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0004-OMAP-CPUfreq-ensure-policy-is-fully-initialized.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0005-OMAP3-PM-CPUFreq-driver-for-OMAP3.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0006-OMAP-PM-CPUFREQ-Fix-conditional-compilation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0007-cpufreq-fixup-after-new-OPP-layer-merged.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0008-OMAP3-PM-CPUFreq-driver-for-OMAP3.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0009-cpufreq-fixup-after-new-OPP-layer-merged.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0017-OMAP-Introduce-accessory-APIs-for-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0018-OMAP-Introduce-device-specific-set-rate-and-get-rate.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0019-OMAP-Implement-Basic-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0020-OMAP-Introduce-dependent-voltage-domain-support.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0021-OMAP-Introduce-device-scale-implementation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0022-OMAP-Disable-Smartreflex-across-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0023-OMAP3-Introduce-custom-set-rate-and-get-rate-APIs-fo.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0024-OMAP3-cpufreq-driver-changes-for-DVFS-support.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0025-OMAP3-Introduce-voltage-domain-info-in-the-hwmod-str.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0026-OMAP3-Add-voltage-dependency-table-for-VDD1.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0027-OMAP2PLUS-Replace-voltage-values-with-Macros.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0028-OMAP2PLUS-Enable-various-options-in-defconfig.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0029-OMAP-Add-DVFS-Documentation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0031-omap3430-voltage-fix-depedency-table.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0032-omap2-dvfs-fix-up-SR-enable-disable.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0033-omap3-hwmod-add-smartreflex-irqs.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0034-omap3630-hwmod-sr-enable-for-higher-ES-as-well.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0035-omap3-voltage-remove-initial-voltage.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0036-omap3-voltage-remove-spurious-pr_notice-for-debugfs.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0037-omap3-voltage-use-volt_data-pointer-instead-values.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0038-omap3-voltage-use-IS_ERR_OR_NULL.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0039-omap3-sr-make-notify-independent-of-class.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0040-omap3-sr-introduce-class-init-deinit-and-priv-data.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0041-omap3-sr-fix-cosmetic-indentation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0042-omap3-sr-call-handler-with-interrupt-disabled.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0043-omap3-sr-disable-interrupt-by-default.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0044-omap3-sr-free-name-pointer-if-fail.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0045-omap3-sr-enable-disable-SR-only-on-need.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0046-omap3-sr-introduce-notifiers-flags.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0047-omap3-sr-introduce-notifier_control.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0048-omap3-sr-disable-spamming-interrupts.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0049-omap3-sr_device-warn-in-log-that-sr-ntargets-are-not.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0050-omap3-sr-make-enable-patch-use-volt_data-pointer.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0051-omap3-voltage-add-transdone-apis.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0052-omap3-dvfs-introduce-api-to-protect-sr-ops.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0053-omap3630-sr-add-support-for-class-1.5.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0054-omap3430-sr-class3-restrict-cpu-to-run-on.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0055-omap3-smartreflex-enable-disable-iff-voltage-data-pr.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0056-sr1.5-dont-trust-sr-layer.patch"

#patch -s -p1 < "${DIR}/patches/dvfs/0001-OMAP3-beagle-xm-enable-upto-1GHz-OPP.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0001-omap3-Add-basic-support-for-720MHz-part.patch"

}

bugs_trivial

#for_next tree's
for_next
dss2_next
dspbridge_next

#work in progress
#wip_to_be_pushed_git
wip_to_be_pushed

#external tree's
sakoman
musb
micrel

#random board patches
beagle
igepv2
devkit8000
touchbook

#omap4/dvfs still needs more testing..
omap4
#dvfs

#no chance of being pushed ever tree's
sgx

echo "patch.sh ran successful"

