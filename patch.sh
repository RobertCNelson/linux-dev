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

patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP4-DSS2-Register-configuration-changes-for-DSI.patch"

}

function dspbridge_next {
echo "dspbridge from for-next"

}

function omap_fixes {
echo "omap fixes"

}

function for_next_40 {
echo "for_next from tmlind's tree.."
patch -s -p1 < "${DIR}/patches/for_next_40/0003-OMAP3-voltage-remove-spurious-pr_notice-for-debugfs.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0004-OMAP4-PM-remove-redundant-ifdef-CONFIG_PM.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0005-OMAP3-smartreflex-fix-sr_late_init-error-path-in-pro.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0006-OMAP3-smartreflex-request-the-memory-region.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0007-OMAP3-smartreflex-fix-ioremap-leak-on-probe-error.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0008-OMAP3-smartreflex-delete-instance-from-sr_list-on-pr.patch"
patch -s -p1 < "${DIR}/patches/for_next_40/0009-OMAP3-smartreflex-delete-debugfs-entries-on-probe-er.patch"
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
#omap_fixes
#dspbridge_next
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

