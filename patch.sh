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

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
patch -s -p1 < "${DIR}/patches/trivial/0001-Fixed-gpio-polarity-of-gpio-USB-phy-reset.patch"
}

function dss2_next {
echo "dss2 from for-next"

#patch -s -p1 < "${DIR}/patches/dss2_next/0146-OMAP-3430SDP-Remove-unused-vdda_dac-supply.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0147-OMAP2-3-DSS2-remove-forced-clk-disable-from-omap_dss.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0148-OMAP2-3-DSS2-Build-omap_device-for-each-DSS-HWIP.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0149-OMAP2-3-DSS2-DSS-create-platform_driver-move-init-ex.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0150-OMAP2-3-DSS2-Move-clocks-from-core-driver-to-dss-dri.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0151-OMAP2-3-DSS2-RFBI-create-platform_driver-move-init-e.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0152-OMAP2-3-DSS2-DISPC-create-platform_driver-move-init-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0153-OMAP2-3-DSS2-VENC-create-platform_driver-move-init-e.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0154-OMAP2-3-DSS2-DSI-create-platform_driver-move-init-ex.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0155-OMAP2-3-DSS2-replace-printk-with-dev_dbg-in-init.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0156-OMAP2-3-DSS2-Use-platform-device-to-get-baseaddr.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0157-OMAP2-3-DSS2-Get-DSS-IRQ-from-platform-device.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0158-OMAP2PLUS-clocks-Align-DSS-clock-names-and-roles.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0159-OMAP2PLUS-DSS2-Generalize-naming-of-PRCM-related-clo.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0160-OMAP2PLUS-DSS2-Generalize-external-clock-names-in-st.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0161-OMAP4-DSS2-clocks-Add-ick-as-dummy-clock.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0162-OMAP2PLUS-DSS2-Add-OMAP4-Kconfig-support.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0163-OMAP4-DSS2-Add-hwmod-device-names-for-OMAP4.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0164-OMAP-DSS2-Fix-def_disp-module-param-description.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0165-OMAP-DSS2-Delay-regulator_get-calls.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0166-OMAP-DSS2-Support-for-Samsung-LTE430WQ-F0C.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0167-OMAPFB-Adding-a-check-for-timings-in-set_def_mode.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0168-OMAP-DSS2-Have-separate-irq-handlers-for-DISPC-and-D.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0169-MAINTAINERS-Update-OMAP-DSS-maintainer.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0170-OMAP2-3-4-DSS2-Enable-Display-SubSystem-as-modules.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0171-OMAP-DSS2-Clean-up-a-switch-case.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0172-OMAP-DSS2-FEATURES-Remove-SDI-from-3630-displays.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0173-OMAP-DSS2-FEATURES-Remove-DSI-SDI-from-OMAP2.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0174-OMAP-DSS2-Check-for-SDI-HW-before-accessing-SDI-regi.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0175-OMAP-OMAPFB-Adding-help-for-FB_OMAP_LCD_VGA-option.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0176-OMAP-DSS2-Remove-unused-list.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0177-OMAP-DSS2-DSI-remove-unused-function.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0178-OMAP2PLUS-DSS2-add-opt_clock_available-in-pdata.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0179-OMAP2PLUS-DSS2-Use-opt_clock_available-from-pdata.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0180-omapfb-Fix-linker-error-in-drivers-video-omap-lcd_24.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0181-OMAP2PLUS-DSS2-FEATURES-DISPC-overlay-code-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0182-OMAP2PLUS-DSS2-FEATURES-Function-to-Provide-the-max-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0183-OMAP2PLUS-DSS2-Make-members-of-dss_clk_source-generi.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0184-OMAP2PLUS-DSS2-Use-dss-features-to-get-clock-source-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0185-OMAP2PLUS-DSS2-DSI-Generalize-DSI-PLL-Clock-Naming.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0186-OMAP-DSS2-Remove-FB_OMAP_BOOTLOADER_INIT-support.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0187-OMAP-DSS2-Remove-pdev-argument-from-dpi_init.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0188-OMAP-DSS2-Move-DPI-SDI-init-into-DSS-plat-driver.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0189-OMAP-DSS2-Remove-unneeded-cpu_is_xxx-checks.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0190-OMAP-DSS2-Functions-to-request-release-DSI-VCs.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0191-OMAP-DSS2-Use-request-release-calls-in-Taal-for-DSI-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0192-HACK-OMAP-DSS2-Fix-OMAP2_DSS_USE_DSI_PLL.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0193-HACK-OMAP-DSS2-add-delay-after-enabling-clocks.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0194-OMAP-DSS2-Adding-dss_features-for-independent-core-c.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0195-OMAP-DSS2-Renaming-register-macro-DISPC_DIVISOR-ch.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0196-OMAP4-DSS2-Using-dss_features-to-set-independent-cor.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0197-OMAP-DSS2-fix-omap_dispc_register_isr-fail-path.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0198-OMAP-DSS2-Add-support-for-LG-Philips-LB035Q02-panel.patch"

#updated for 2.6.38-git4
#patch -s -p1 < "${DIR}/patches/dss2_next/0199-OMAP-DSS2-Add-DSS2-support-for-Overo.patch"

#patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP2PLUS-DSS2-Cleanup-clock-source-related-code.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0002-OMAP4-DSS2-Clock-source-changes-for-OMAP4.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0003-omap-overo-Add-regulator-for-ads7846.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0004-OMAP-Add-gpio-leds-support-for-Overo.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0005-OMAP-Add-gpio-keys-support-for-Overo.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0006-HACK-OMAP-DSS2-VENC-disable-VENC-on-OMAP4-to-prevent.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0007-OMAP2PLUS-DSS2-FEATURES-Fix-usage-of-dss_reg_field-a.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0008-OMAP-DSS2-FEATURES-Functions-to-return-min-and-max-v.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0009-OMAP-DSS2-FEATURES-DSI-PLL-parameter-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0010-OMAP-DSS2-DSI-Restructure-IRQ-handler.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0011-OMAP-DSS2-DSI-Add-ISR-support.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0012-OMAP-DSS2-DSI-use-ISR-in-send_bta_sync.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0013-OMAP-DSS2-DSI-use-ISR-for-BTA-in-framedone.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0014-OMAP-DSS2-DSI-catch-DSI-errors-in-send_bta_sync.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0015-OMAP-DSS2-DSI-fix-IRQ-debug-prints.patch"

#patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP4-DSS2-Add-display-type-HDMI-to-DSS2.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0002-OMAP4-DSS2-HDMI-Select-between-HDMI-VENC-clock-sourc.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0003-OMAP4-DSS2-HDMI-Dispc-gamma-enable-set-reset-functio.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0004-OMAP4-DSS2-HDMI-HDMI-driver-header-file-addition.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0005-OMAP4-DSS2-HDMI-HDMI-driver-addition-in-the-DSS.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0006-OMAP4-DSS2-HDMI-HDMI-panel-driver-addition-in-the-DS.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0007-OMAP4-DSS2-HDMI-Add-makefile-and-kconfig-changes-to-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0008-OMAP4-DSS-HDMI-Call-to-HDMI-module-init-to-register-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0009-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0010-OMAP4-HDMI-Add-HDMI-structure-in-the-board-file-for-.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0011-OMAP-DSS2-Clean-up-for-dpll4_m4_ck-handling.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0012-OMAP-DSS2-Implement-OMAP4-DSS-fclk-support.patch"
#patch -s -p1 < "${DIR}/patches/dss2_next/0013-OMAP4-PandaBoard-Adding-DVI-support.patch"

patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP4-DSS2-Register-configuration-changes-for-DSI.patch"

}

function dspbridge_next {
echo "dspbridge from for-next"

#in 2.6.38-git4
#patch -s -p1 < "${DIR}/patches/dspbridge/0001-staging-tidspbridge-make-sync_wait_on_event-interrup.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0002-staging-tidspbridge-overwrite-DSP-error-codes.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0003-staging-tidspbridge-Eliminate-direct-manipulation-of.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0004-staging-tidspbridge-fix-mgr_enum_node_info.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0005-staging-tidspbridge-mgr_enum_node_info-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0006-staging-tidspbridge-fix-kernel-oops-in-bridge_io_get.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0007-staging-tidspbridge-remove-gs-memory-allocator.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0008-staging-tidspbridge-remove-utildefs.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0009-staging-tidspbridge-switch-to-linux-bitmap-API.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0010-staging-tidspbridge-remove-gb-bitmap-implementation.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0011-staging-tidspbridge-convert-core-to-list_head.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0012-staging-tidspbridge-convert-pmgr-to-list_head.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0013-staging-tidspbridge-convert-rmgr-to-list_head.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0014-staging-tidspbridge-remove-custom-linked-list.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0015-staging-tidspbridge-core-code-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0016-staging-tidspbridge-pmgr-code-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0017-staging-tidspbridge-use-the-right-type-for-list_is_l.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0018-staging-tidspbridge-rmgr-node.c-code-cleanup.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0019-staging-tidspbridge-Fix-atoi-to-support-hexadecimal-.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0020-staging-tidspbridge-Remove-unused-defined-constants.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0021-staging-tidspbridge-Remove-unused-functions.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0022-staging-tidspbridge-Remove-unused-structs.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0023-staging-tidspbridge-Remove-unused-typedefs.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0024-staging-tidspbridge-Remove-trivial-header-files.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0025-staging-tidspbridge-remove-code-referred-by-OPT_ZERO.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0026-staging-tidspbridge-set1-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0027-staging-tidspbridge-set2-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0028-staging-tidspbridge-set3-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0029-staging-tidspbridge-set4-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0030-staging-tidspbridge-set5-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0031-staging-tidspbridge-set6-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0032-staging-tidspbridge-set7-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0033-staging-tidspbridge-set8-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0034-staging-tidspbridge-set9-remove-hungarian-from-struc.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0035-staging-tidspbridge-set10-remove-hungarian-from-stru.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0036-staging-tidspbridge-set11-remove-hungarian-from-stru.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0037-staging-tidspbridge-set12-remove-hungarian-from-stru.patch"

}

function omap_fixes {
echo "omap fixes"

#in 2.6.38-git19
#patch -s -p1 < "${DIR}/patches/omap-fixes/0001-arm-mach-omap2-devices-fix-omap3_l3_init-return-valu.patch"
#patch -s -p1 < "${DIR}/patches/omap-fixes/0002-arm-mach-omap2-omap_l3_smx-fix-irq-handler-setup.patch"
#patch -s -p1 < "${DIR}/patches/omap-fixes/0003-OMAP4-PandaBoard-remove-unused-power-regulators.patch"
#patch -s -p1 < "${DIR}/patches/omap-fixes/0004-ARM-OMAP2-Fix-warnings-for-GPMC-interrupt.patch"
#patch -s -p1 < "${DIR}/patches/omap-fixes/0005-hwspinlock-depend-on-OMAP4.patch"

}

function for_next_40 {
echo "for_next from tmlind's tree.."
#patch -s -p1 < "${DIR}/patches/for_next_40/0001-OMAP4-Intialize-IVA-Device-in-addition-to-DSP-device.patch"
#patch -s -p1 < "${DIR}/patches/for_next_40/0002-OMAP3-voltage-remove-initial-voltage.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0003-OMAP3-voltage-remove-spurious-pr_notice-for-debugfs.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0004-OMAP4-PM-remove-redundant-ifdef-CONFIG_PM.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0005-OMAP3-smartreflex-fix-sr_late_init-error-path-in-pro.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0006-OMAP3-smartreflex-request-the-memory-region.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0007-OMAP3-smartreflex-fix-ioremap-leak-on-probe-error.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0008-OMAP3-smartreflex-delete-instance-from-sr_list-on-pr.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0009-OMAP3-smartreflex-delete-debugfs-entries-on-probe-er.patch"
#patch -s -p1 < "${DIR}/patches/for_next_40/0010-omap-rx51-mark-reserved-memory-earlier.patch"
#patch -s -p1 < "${DIR}/patches/for_next_40/0011-arm-omap2-enable-smc-instruction-for-sleep34xx.patch"
#patch -s -p1 < "${DIR}/patches/for_next_40/0012-OMAP3-l3-fix-for-irq-10-nobody-cared-message.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0013-omap-gpmc-smsc911x-always-set-irq-flags-to-IORESOURC.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0014-omap-convert-boards-that-use-SMSC911x-to-use-gpmc-sm.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0015-OMAP3-4-l3-fix-omap3_l3_probe-error-path.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0016-OMAP3-4-l3-minor-cleanup-for-parenthesis-and-extra-s.patch"
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
patch -s -p1 < "${DIR}/patches/wip_to_be_pushed/0001-omap-beagle-irq_set_irq_type-over-set_irq_type.patch"

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

#in v2.6.38-git15
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0013-MFD-add-twl4030-madc-driver.patch"

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
patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-alsa-soc-Remove-restrictive-checks-for-cpu-typ.patch"
patch -s -p1 < "${DIR}/patches/display/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-beaglexm-fix-user-button.patch"

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
#patch -s -p1 < "${DIR}/patches/touchbook/0003-omap3-touchbook-fix-ehci.patch"
#patch -s -p1 < "${DIR}/patches/touchbook/0004-omap3-touchbook-tesing-lcd-display.patch"
}

function omap4 {
echo "omap4 related patches"
patch -s -p1 < "${DIR}/patches/panda/0001-OMAP4-DSS2-add-dss_dss_clk.patch"
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
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-4.03.00.01-into-TI-4.00.00.01.patch"

#4.03.00.02 (main *.bin drops omap4)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-Merge-TI-4.03.00.02-into-TI-4.03.00.01.patch"

#4.03.00.02
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.32-PSP.patch"

#4.03.00.02 + 2.6.38-merge (2.6.37-git5)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.38-merge-AUTOCONF_INCLUD.patch"

#4.03.00.02 + 2.6.38-rc3
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.38-rc3-_console_sem-to-c.patch"

#4.03.00.01
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.01-add-outer_cache.clean_all.patch"

#4.03.00.02
#omap3 doesn't work on omap3630
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-use-omap3630-as-TI_PLATFORM.patch"

#4.03.00.02 + 2.6.39 (2.6.38-git2)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.39-rc-SPIN_LOCK_UNLOCKED.patch"

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

function pm-wip-cpufreq {
echo "pm-wip-cpufreq"

patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0001-OMAP-CPUfreq-ensure-driver-initializes-after-cpufreq.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0002-OMAP-CPUfreq-ensure-policy-is-fully-initialized.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0003-OMAP3-PM-CPUFreq-driver-for-OMAP3.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0004-OMAP-PM-CPUFREQ-Fix-conditional-compilation.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0005-cpufreq-fixup-after-new-OPP-layer-merged.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0006-OMAP-cpufreq-Split-OMAP1-and-OMAP2PLUS-CPUfreq-drive.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0007-OMAP2PLUS-cpufreq-Add-SMP-support-to-cater-OMAP4430.patch"
patch -s -p1 < "${DIR}/patches/pm-wip-cpufreq/0008-OMAP2PLUS-cpufreq-Fix-typo-when-attempting-to-set-mp.patch"

}

bugs_trivial

#for_next tree's
dss2_next
dspbridge_next
omap_fixes
for_next_40

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
pm-wip-cpufreq

#no chance of being pushed ever tree's
sgx

echo "patch.sh ran successful"

