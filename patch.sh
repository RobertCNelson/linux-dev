#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

#gone in 2.6.39-git8
#patch -s -p1 < "${DIR}/patches/trivial/0001-staging-add-airlink-awll7025-id-for-rt2860.patch"

#Bisected from 2.6.35 -> 2.6.36 to find this..
#This commit breaks some lcd monitors..
#rcn-ee Feb 26, 2011...
#Still needs more work for 2.6.38, causes:
#[   14.962829] omapdss DISPC error: GFX_FIFO_UNDERFLOW, disabling GFX
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-OMAP-DSS2-OMAPFB-swap-front-and-back-porches-.patch"

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

#for 2.6.39-git1
#In file included from include/linux/seqlock.h:29:0,
#                 from include/linux/time.h:8,
#                 from include/linux/timex.h:56,
#                 from include/linux/sched.h:57,
#                 from arch/arm/kernel/asm-offsets.c:13:
#include/linux/spinlock.h: In function ‘spin_unlock_wait’:
#include/linux/spinlock.h:360:2: error: implicit declaration of function ‘cpu_relax’
#make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
#fixed in 2.6.39-git3
#patch -s -p1 < "${DIR}/patches/trivial/0001-spinlock_up.h-include-asm-processor.h-in-for-cpu_rel.patch"
#fixed in 2.6.39-git8
#patch -s -p1 < "${DIR}/patches/trivial/0001-spinlock.h-needs-cpu_relax-too.patch"


#for 2.6.39-git3
#net/sctp/bind_addr.c: In function ‘sctp_bind_addr_clean’:
#net/sctp/bind_addr.c:148:30: error: ‘sctp_local_addr_free’ undeclared (first use in this function)
#net/sctp/bind_addr.c:148:30: note: each undeclared identifier is reported only once for each function it appears in
#make[2]: *** [net/sctp/bind_addr.o] Error 1
#make[1]: *** [net/sctp] Error 2
#make[1]: *** Waiting for unfinished jobs....
#fixed in 2.6.39-git4
#patch -s -p1 < "${DIR}/patches/trivial/0001-sctp-Fix-build-failure.patch"

#should fix gcc-4.6 ehci problems..
patch -s -p1 < "${DIR}/patches/trivial/0001-USB-ehci-use-packed-aligned-4-instead-of-removing-th.patch"

#fixed in 3.0.0-rc7
#ehci crashes on startup/init
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-mfd-Add-omap-usbhs-runtime-PM-support.patch"
}

function dss2_next {
echo "dss2 from for-next"

#fixed in 2.6.39-git11
#patch -s -p1 < "${DIR}/patches/dss2_next/0001-OMAP4-DSS2-Register-configuration-changes-for-DSI.patch"

}

function dspbridge_next {
echo "dspbridge from for-next"

}

function omap_fixes {
echo "omap fixes"

}

function for_next {
echo "for_next from tmlind's tree.."

patch -s -p1 < "${DIR}/patches/beagle/0001-OMAP3-beagle-add-support-for-beagleboard-xM-revision.patch"
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


#fixed in 2.6.39-git11
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0001-OMAP-DSS2-DSI-fix-use_sys_clk-highfreq.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0002-OMAP-DSS2-DSI-fix-dsi_dump_clocks.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0003-OMAP2PLUS-DSS2-Fix-Return-correct-lcd-clock-source-f.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.40/0004-OMAP-DSS-DSI-Fix-DSI-PLL-power-bug.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0005-OMAP-DSS2-fix-panel-Kconfig-dependencies.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0006-OMAP-DSS2-add-bootarg-for-selecting-svideo-or-compos.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0007-video-add-timings-for-hd720.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0008-drivers-net-smsc911x-return-ENODEV-if-device-is-not-.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.40/0009-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"

#drop with 3.0-rc5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0010-Revert-omap2_mcspi-Flush-posted-writes.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0011-Revert-omap_hsmmc-improve-interrupt-synchronisation.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0012-Don-t-turn-SDIO-cards-off-to-save-power.-Doing-so-wi.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0013-Enable-the-use-of-SDIO-card-interrupts.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0014-soc-codecs-Enable-audio-capture-by-default-for-twl40.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0015-soc-codecs-twl4030-Turn-on-mic-bias-by-default.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0016-RTC-add-support-for-backup-battery-recharge.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0017-ARM-OMAP2-mmc-twl4030-move-clock-input-selection-pri.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0018-Add-power-off-support-for-the-TWL4030-companion.patch"

#drop with 3.0-git5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0019-ARM-OMAP-Add-twl4030-madc-support-to-Beagle.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0020-ARM-OMAP-Add-twl4030-madc-support-to-Overo.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0021-Enabling-Hwmon-driver-for-twl4030-madc.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0022-mfd-twl-core-enable-madc-clock.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0023-rtc-twl-Switch-to-using-threaded-irq.patch"

#in 2.6.39-git13
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0024-ARM-OMAP-automatically-set-musb-mode-in-platform-dat.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0025-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0026-OMAP-Overo-Add-support-for-spidev.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0027-unionfs-Add-support-for-unionfs-2.5.9.patch"

#in 2.6.39-git15
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0028-OMAP3-beagle-add-support-for-beagleboard-xM-revision.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/3.0.0/0029-OMAP3-beagle-add-support-for-expansionboards.patch"
#for 3.0-git5, still needs tweaks for wifi board
patch -s -p1 < "${DIR}/patches/sakoman/3.1.0/0029-OMAP3-beagle-add-support-for-expansionboards.patch"

#TESTING
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0030-omap-beagle-Add-support-for-1GHz.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0031-omap-Change-omap_device-activate-dectivate-latency-m.patch"
patch -s -p1 < "${DIR}/patches/sakoman/3.0.0/0032-omap-overo-Add-opp-init.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0033-ARM-OMAP-Overo-remove-duplicate-call-to-overo_ads784.patch"

#in 2.6.39-git15
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0034-omap-nand-fix-subpage-ecc-issue-with-prefetch.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0035-mtd-nand-Eliminate-noisey-uncorrectable-error-messag.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0036-mtd-return-badblockbits-back.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0037-omap-Add-omap3_defconfig.patch"

#in 2.6.39-git13
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0038-OMAP3-voltage-remove-spurious-pr_notice-for-debugfs.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0039-OMAP4-PM-remove-redundant-ifdef-CONFIG_PM.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0040-OMAP3-smartreflex-fix-sr_late_init-error-path-in-pro.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0041-OMAP3-smartreflex-request-the-memory-region.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0042-OMAP3-smartreflex-fix-ioremap-leak-on-probe-error.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0043-OMAP3-smartreflex-delete-instance-from-sr_list-on-pr.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0044-OMAP3-smartreflex-delete-debugfs-entries-on-probe-er.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0045-OMAP3-cpuidle-remove-useless-SDP-specific-timings.patch"

#in 3.0-git5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0046-OMAP3-SR-make-notify-independent-of-class.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0047-OMAP3-SR-disable-interrupt-by-default.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0048-OMAP3-SR-enable-disable-SR-only-on-need.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0049-OMAP3-SR-fix-cosmetic-indentation.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0050-OMAP-CPUfreq-ensure-driver-initializes-after-cpufreq.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0051-OMAP-CPUfreq-ensure-policy-is-fully-initialized.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0052-OMAP3-PM-CPUFreq-driver-for-OMAP3.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0053-OMAP-PM-CPUFREQ-Fix-conditional-compilation.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0054-cpufreq-fixup-after-new-OPP-layer-merged.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0055-OMAP-cpufreq-Split-OMAP1-and-OMAP2PLUS-CPUfreq-drive.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0056-OMAP2PLUS-cpufreq-Add-SMP-support-to-cater-OMAP4430.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0057-OMAP2PLUS-cpufreq-Fix-typo-when-attempting-to-set-mp.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0058-cpufreq-helpers-for-walking-the-frequency-table.patch"

#in 2.6.39-git[1-9]
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0059-cpufreq-introduce-hotplug-governor.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0060-OMAP2-cpufreq-free-up-table-on-exit.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0061-OMAP2-cpufreq-handle-invalid-cpufreq-table.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0062-OMAP2-cpufreq-minor-comment-cleanup.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0063-OMAP2-cpufreq-use-clk_init_cpufreq_table-if-OPPs-not.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0064-OMAP2-cpufreq-use-cpufreq_frequency_table_target.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0065-OMAP2-cpufreq-fix-freq_table-leak.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0066-OMAP2-clockdomain-Add-an-api-to-read-idle-mode.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0067-OMAP2-clockdomain-Add-SoC-support-for-clkdm_is_idle.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0068-OMAP2-PM-Initialise-sleep_switch-to-a-non-valid-valu.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0069-OMAP2-PM-idle-clkdms-only-if-already-in-idle.patch"

#drop with 3.0-git5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0070-OMAP2-hwmod-Follow-the-recomended-PRCM-sequence.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0071-OMAP-Serial-Check-wk_st-only-if-present.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0072-omap3-Add-basic-support-for-720MHz-part.patch"

##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0073-Revert-Enable-the-use-of-SDIO-card-interrupts.patch"
##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0074-mfd-Fix-omap-usbhs-crash-when-rmmoding-ehci-or-ohci.patch"
##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0075-mfd-Fix-omap_usbhs_alloc_children-error-handling.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0076-mfd-Add-omap-usbhs-runtime-PM-support.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0077-arm-omap-usb-ehci-and-ohci-hwmod-structures-for-omap.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0078-arm-omap-usb-register-hwmods-of-usbhs.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0079-arm-omap-usb-device-name-change-for-the-clk-names-of.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0080-mfd-global-Suspend-and-resume-support-of-ehci-and-oh.patch"
##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0081-MFD-TWL4030-Correct-the-warning-print-during-script-.patch"
##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0082-MFD-TWL4030-Modifying-the-macro-name-Main_Ref-to-all.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/3.0.0/0083-MFD-TWL4030-power-scripts-for-OMAP3-boards.patch"

##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0084-MFD-TWL4030-TWL-version-checking.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0085-MFD-TWL4030-workaround-changes-for-Erratum-27.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0086-MFD-TWL4030-optimizing-resource-configuration.patch"
##patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0087-omap-pm-related-changes-to-omap3_defconfig.patch"

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
#patch -s -p1 < "${DIR}/patches/beagle/0001-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
#gone in 2.6.39-git8
#patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-alsa-soc-Remove-restrictive-checks-for-cpu-typ.patch"
patch -s -p1 < "${DIR}/patches/display/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"
#patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-beaglexm-fix-user-button.patch"

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
#patch -s -p1 < "${DIR}/patches/touchbook/0001-touchbook-add-madc.patch"
#patch -s -p1 < "${DIR}/patches/touchbook/0002-touchbook-add-twl4030-bci-battery.patch"
}

function dspbridge {
echo "dspbridge fixes"
#broken in 3.0-git5
#drivers/staging/tidspbridge/core/dsp-clock.c: In function ‘dsp_clk_enable’:
#drivers/staging/tidspbridge/core/dsp-clock.c:212:3: error: implicit declaration of function ‘omap_mcbsp_set_io_type’
#drivers/staging/tidspbridge/core/dsp-clock.c:212:42: error: ‘OMAP_MCBSP_POLL_IO’ undeclared (first use in this function)
#drivers/staging/tidspbridge/core/dsp-clock.c:212:42: note: each undeclared identifier is reported only once for each function it appears in
#make[3]: *** [drivers/staging/tidspbridge/core/dsp-clock.o] Error 1
#make[2]: *** [drivers/staging/tidspbridge] Error 2
patch -s -p1 < "${DIR}/patches/dspbridge/0001-Revert-omap-mcbsp-Remove-port-number-enums.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0002-Revert-omap-mcbsp-Remove-rx_-tx_word_length-variable.patch"
patch -s -p1 < "${DIR}/patches/dspbridge/0003-Revert-omap-mcbsp-Drop-in-driver-transfer-support.patch"
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

#4.03.00.02 + 2.6.40 (2.6.39-git11)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.40-display.h-to-omapdss..patch"
}

bugs_trivial

#for_next tree's
dss2_next
omap_fixes
#dspbridge_next
for_next

#work in progress
#wip_to_be_pushed_git
#wip_to_be_pushed

#external tree's
sakoman
musb
micrel

#random board patches
beagle
igepv2
devkit8000
touchbook
dspbridge

#omap4/dvfs still needs more testing..
omap4

#no chance of being pushed ever tree's
sgx

echo "patch.sh ran successful"

