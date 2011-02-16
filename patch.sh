#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'Testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

patch -s -p1 < "${DIR}/patches/trivial/0001-staging-add-airlink-awll7025-id-for-rt2860.patch"
#2.6.37-git2
#patch -s -p1 < "${DIR}/patches/trivial/0001-OMAP4-enable-smc-instruction-in-new-assembler-versio.patch"
#2.6.37-git3
#2.6.37-git12
#patch -s -p1 < "${DIR}/patches/trivial/0001-omap3-clocks-Fix-build-error-CK_3430ES2-undeclared-h.patch"

#http://www.spinics.net/lists/linux-omap/msg44289.html
patch -s -p1 < "${DIR}/patches/trivial/0001-arm-fix-oops-in-sched_clock_poll.patch"
}

function sakoman {
echo "sakoman's patches"

#2.6.37-git10
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0001-video-add-timings-for-hd720.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0001-video-add-timings-for-hd720.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0003-Don-t-turn-SDIO-cards-off-to-save-power.-Doing-so-wi.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0004-mmc-don-t-display-single-block-read-console-messages.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0005-scripts-Makefile.fwinst-fix-typo-missing-space-in-se.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0006-drivers-net-smsc911x-return-ENODEV-if-device-is-not-.patch"

#2.6.38-rc5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0007-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0007-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0008-ASoC-enable-audio-capture-by-default-for-twl4030.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0011-ARM-OMAP-Make-beagle-u-boot-partition-writable.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.37/0012-MFD-enable-madc-clock.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0013-MFD-add-twl4030-madc-driver.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0014-ARM-OMAP-Add-twl4030-madc-support-to-Overo.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0015-ARM-OMAP-Add-twl4030-madc-support-to-Beagle.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0016-OMAP-DSS2-Add-support-for-Samsung-LTE430WQ-F0C-panel.patch"

#2.6.37-git10
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0017-OMAP-DSS2-Add-support-for-LG-Philips-LB035Q02-panel.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0017-OMAP-DSS2-Add-support-for-LG-Philips-LB035Q02-panel.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0018-OMAP-DSS2-Add-DSS2-support-for-Overo.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0019-OMAP-DSS2-add-bootarg-for-selecting-svideo-or-compos.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0020-ARM-OMAP2-mmc-twl4030-move-clock-input-selection-pri.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0021-RTC-add-support-for-backup-battery-recharge.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0026-ARM-OMAP-Add-macros-for-comparing-silicon-revision.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0027-OMAP-DSS2-check-for-both-cpu-type-and-revision-rathe.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0028-OMAP-DSS2-enable-hsclk-in-dsi_pll_init-for-OMAP36XX.patch"

#2.6.37-git12
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0029-ARM-OMAP-Beagle-support-twl-gpio-differences-on-xM.patch"

#2.6.38-rc5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.37/0030-Revert-Input-ads7846-add-regulator-support.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.38/0030-Revert-Input-ads7846-add-regulator-support.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0031-Revert-omap2_mcspi-Flush-posted-writes.patch"
}

function dss2 {
echo "dss2 patches"
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

function zippy {
echo "zippy support"
patch -s -p1 < "${DIR}/patches/angstrom/0003-ARM-OMAP-add-support-for-TCT-Zippy-to-Beagle-board-fixup.patch"
patch -s -p1 < "${DIR}/patches/angstrom/0043-ARM-OMAP-beagleboard-Add-infrastructure-to-do-fixups-fixup.patch"
patch -s -p1 < "${DIR}/patches/rcn/beagle-zippy-dont-load-i2c-on-boards-with-nozippy.diff"

#needed for 2.6.36-git7 + local patchset
patch -s -p1 < "${DIR}/patches/beagle/0001-arm-omap-beagle-use-caps-over-wires.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap3-beaglexm-fix-DVI-initialization.patch"
}

function beagle {
echo "beagle patches"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-Beagle-detect-new-xM-revision-B.patch"
patch -s -p1 < "${DIR}/patches/arago-project/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
#2.6.37-git2
#patch -s -p1 < "${DIR}/patches/arago-project/0001-AM37x-Switch-SGX-clocks-to-200MHz.patch"

#2.6.37-git12
#patch -s -p1 < "${DIR}/patches/beagle/0001-omap-beagle-use-GPIO2-on-the-xM-A3-to-turn-DVI-on.patch"

patch -s -p1 < "${DIR}/patches/beagle/0001-xM-audio-fix-from-Ashok.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
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

#3.01.00.06/07 & 4.00.00.01 Patches
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.32-PSP.patch"
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-use-omap3630.patch"

#dropped with 4.00.00.01
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-Compile-Fixes.patch"

#3.01.00.06 + 2.6.36-rc1
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.36-rc1-Compile-Fixes.patch"

#4.00.00.01 + 2.6.37-rc1
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.37-rc1-use-semaphore-ove.patch"

#4.00.00.01 + 2.6.38-merge (2.6.37-git5): so needs to be tested... (jan 10 rcn-ee)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.38-merge-AUTOCONF_INCLUD.patch"

#4.00.00.01 + 2.6.38-rc3
#http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ac751efa6a0d70f2c9daef5c7e3a92270f5c2dff
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.38-rc3-_console_sem-to-c.patch"
}

function omap4 {
echo "omap4 related patches"

#panda display from: http://dev.omapzoom.org/?p=anand/linux-omap-usb.git;a=shortlog;h=refs/heads/display-patches-for-v2.6.38-rc4
patch -s -p1 < "${DIR}/patches/panda/0001-OMAP2-3-DSS2-remove-forced-clk-disable-from-omap_dss.patch"
patch -s -p1 < "${DIR}/patches/panda/0002-OMAP2420-hwmod-data-add-DSS-DISPC-RFBI-VENC.patch"
patch -s -p1 < "${DIR}/patches/panda/0003-OMAP2430-hwmod-data-add-DSS-DISPC-RFBI-VENC.patch"
patch -s -p1 < "${DIR}/patches/panda/0004-OMAP3-hwmod-data-add-DSS-DISPC-RFBI-DSI-VENC.patch"
patch -s -p1 < "${DIR}/patches/panda/0005-OMAP2-3-DSS2-Change-driver-name-to-omap_display.patch"
patch -s -p1 < "${DIR}/patches/panda/0006-OMAP2-3-DSS2-Use-Regulator-init-with-driver-name.patch"
patch -s -p1 < "${DIR}/patches/panda/0007-OMAP2-3-DSS2-Create-new-file-display.c-for-central-d.patch"
patch -s -p1 < "${DIR}/patches/panda/0008-OMAP2-3-DSS2-board-files-replace-platform_device_reg.patch"
patch -s -p1 < "${DIR}/patches/panda/0009-OMAP2-3-DSS2-Build-omap_device-for-each-DSS-HWIP.patch"
patch -s -p1 < "${DIR}/patches/panda/0010-OMAP2-3-DSS2-DSS-create-platform_driver-move-init-ex.patch"
patch -s -p1 < "${DIR}/patches/panda/0011-OMAP2-3-DSS2-Move-clocks-from-core-driver-to-dss-dri.patch"
patch -s -p1 < "${DIR}/patches/panda/0012-OMAP2-3-DSS2-RFBI-create-platform_driver-move-init-e.patch"
patch -s -p1 < "${DIR}/patches/panda/0013-OMAP2-3-DSS2-DISPC-create-platform_driver-move-init-.patch"
patch -s -p1 < "${DIR}/patches/panda/0014-OMAP2-3-DSS2-VENC-create-platform_driver-move-init-e.patch"
patch -s -p1 < "${DIR}/patches/panda/0015-OMAP2-3-DSS2-DSI-create-platform_driver-move-init-ex.patch"
patch -s -p1 < "${DIR}/patches/panda/0016-OMAP2-3-DSS2-replace-printk-with-dev_dbg-in-init.patch"
patch -s -p1 < "${DIR}/patches/panda/0017-OMAP2-3-DSS2-Use-platform-device-to-get-baseaddr.patch"
patch -s -p1 < "${DIR}/patches/panda/0018-OMAP2-3-DSS2-Get-DSS-IRQ-from-platform-device.patch"
patch -s -p1 < "${DIR}/patches/panda/0019-OMAP2PLUS-clocks-Align-DSS-clock-names-and-roles.patch"

#the omap36xx dpi.c change from steve really needs to upstream..
#patch -s -p1 < "${DIR}/patches/panda/0020-OMAP2PLUS-DSS2-Generalize-naming-of-PRCM-related-clo.patch"
patch -s -p1 < "${DIR}/patches/panda/0020-OMAP2PLUS-DSS2-Generalize-naming-of-PRCM-related-clo-fixup.patch"

patch -s -p1 < "${DIR}/patches/panda/0021-OMAP2PLUS-DSS2-Generalize-external-clock-names-in-st.patch"
patch -s -p1 < "${DIR}/patches/panda/0022-OMAP4-DSS2-clocks-Add-ick-as-dummy-clock.patch"
patch -s -p1 < "${DIR}/patches/panda/0023-OMAP2PLUS-DSS2-Add-OMAP4-Kconfig-support.patch"
patch -s -p1 < "${DIR}/patches/panda/0024-OMAP4-hwmod-data-add-DSS-DISPC-DSI1-2-RFBI-HDMI-VENC.patch"
patch -s -p1 < "${DIR}/patches/panda/0025-OMAP4-DSS2-Add-hwmod-device-names-for-OMAP4.patch"
patch -s -p1 < "${DIR}/patches/panda/0026-OMAP-DSS2-Common-IRQ-handler-for-all-OMAPs.patch"
patch -s -p1 < "${DIR}/patches/panda/0027-OMAP-DSS2-Add-dss_feature-for-variable-DPLL-fclk.patch"
patch -s -p1 < "${DIR}/patches/panda/0028-OMAP-DSS-Renaming-the-dpll-clk-pointer-in-struct-dss.patch"
patch -s -p1 < "${DIR}/patches/panda/0029-OMAP-DSS2-Using-dss_features-to-clean-cpu-checks-for.patch"
patch -s -p1 < "${DIR}/patches/panda/0030-OMAP-DSS2-Get-OMAP4-DPLL-fclk-for-DPI-interface.patch"
patch -s -p1 < "${DIR}/patches/panda/0031-OMAP-DSS2-Adding-dss_features-for-independent-core-c.patch"
patch -s -p1 < "${DIR}/patches/panda/0032-OMAP-DSS2-Renaming-register-macro-DISPC_DIVISOR-ch.patch"
patch -s -p1 < "${DIR}/patches/panda/0033-OMAP-DSS2-Adding-macro-for-DISPC_DIVISOR-register.patch"
patch -s -p1 < "${DIR}/patches/panda/0034-OMAP4-DSS2-Using-dss_features-to-set-independent-cor.patch"
patch -s -p1 < "${DIR}/patches/panda/0035-OMAP4-PandaBoard-Adding-DVI-support.patch"

}

function igepv2 {
echo "igepv2 board related patches"
}

function devkit8000 {
echo "devkit8000"

#https://patchwork.kernel.org/patch/296132/
#patch -s -p1 < "${DIR}/patches/devkit8000/0001-OMAP2-Devkit8000-Fix-mmc-regulator-failure.patch"

#noticed by Robert Skretkowicz

#2.6.37-git10
#patch -s -p1 < "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel.patch"
patch -s -p1 < "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel-2.6.37-git10.patch"
}

function dspbridge {
echo "dspbridge from staging"

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

function dvfs {
echo "dvfs"

#from:http://gitorious.org/linux-omap-nm-sr/linux-omap-sr/commits/sr1.5
patch -s -p1 < "${DIR}/patches/dvfs/0001-MAINTAINERS-change-Kevin-s-email-for-OMAP-PM-section.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0002-OMAP3-CPUIdle-prevent-CORE-from-going-off-if-doing-s.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0003-OMAP-CPUfreq-ensure-driver-initializes-after-cpufreq.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0004-OMAP-CPUfreq-ensure-policy-is-fully-initialized.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0005-OMAP3-PM-CPUFreq-driver-for-OMAP3.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0006-OMAP-PM-CPUFREQ-Fix-conditional-compilation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0007-cpufreq-fixup-after-new-OPP-layer-merged.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0008-OMAP3630-PM-don-t-warn-the-user-with-a-trace-in-case.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0009-OMAP3-4-OPP-make-omapx_opp_init-non-static.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0010-OMAP3-beagle-xm-enable-up-to-800MHz-OPP.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0011-OMAP-PM-SmartReflex-fix-potential-NULL-dereference.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0012-OMAP2-remove-unused-UART-base-addresses-from-omap_gl.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0013-perf-add-OMAP-support-for-the-new-power-events.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0014-OMAP2-3-PM-remove-unnecessary-wakeup-sleep-dependenc.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0015-OMAP-Introduce-accessory-APIs-for-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0016-OMAP-Introduce-device-specific-set-rate-and-get-rate.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0017-OMAP-Implement-Basic-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0018-OMAP-Introduce-dependent-voltage-domain-support.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0019-OMAP-Introduce-device-scale-implementation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0020-OMAP-Disable-Smartreflex-across-DVFS.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0021-OMAP3-Introduce-custom-set-rate-and-get-rate-APIs-fo.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0022-OMAP3-cpufreq-driver-changes-for-DVFS-support.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0023-OMAP3-Introduce-voltage-domain-info-in-the-hwmod-str.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0024-OMAP3-Add-voltage-dependency-table-for-VDD1.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0025-OMAP2PLUS-Replace-voltage-values-with-Macros.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0026-OMAP2PLUS-Enable-various-options-in-defconfig.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0027-OMAP-Add-DVFS-Documentation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0028-OMAP3-PM-Set-clear-T2-bit-for-Smartreflex-on-TWL.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0029-omap3430-voltage-fix-depedency-table.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0030-omap3-hwmod-add-smartreflex-irqs.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0031-omap3630-hwmod-sr-enable-for-higher-ES-as-well.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0032-omap3-voltage-remove-initial-voltage.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0033-omap3-voltage-remove-spurious-pr_notice-for-debugfs.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0034-omap3-voltage-use-volt_data-pointer-instead-values.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0035-omap3-voltage-use-IS_ERR_OR_NULL.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0036-omap3-sr-make-notify-independent-of-class.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0037-omap3-sr-introduce-class-init-deinit-and-priv-data.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0038-omap3-sr-fix-cosmetic-indentation.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0039-omap3-sr-call-handler-with-interrupt-disabled.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0040-omap3-sr-disable-interrupt-by-default.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0041-omap3-sr-free-name-pointer-if-fail.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0042-omap3-sr-enable-disable-SR-only-on-need.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0043-omap3-sr-introduce-notifiers-flags.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0044-omap3-sr-introduce-notifier_control.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0045-omap3-sr-disable-spamming-interrupts.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0046-omap3-sr_device-warn-in-log-that-sr-ntargets-are-not.patch"
patch -s -p1 < "${DIR}/patches/dvfs/0047-omap3-sr-make-enable-patch-use-volt_data-pointer.patch"

patch -s -p1 < "${DIR}/patches/dvfs/0001-omap3-Add-basic-support-for-720MHz-part.patch"

}

bugs_trivial
sakoman
beagle
dss2
musb
micrel
zippy
sgx
igepv2
omap4
devkit8000
dspbridge
dvfs

echo "patch.sh ran successful"

