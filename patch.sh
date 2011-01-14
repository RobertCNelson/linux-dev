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
patch -s -p1 < "${DIR}/patches/trivial/0001-omap3-clocks-Fix-build-error-CK_3430ES2-undeclared-h.patch"

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
patch -s -p1 < "${DIR}/patches/sakoman/2.6.36/0007-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"
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
patch -s -p1 < "${DIR}/patches/sakoman/2.6.35/0029-ARM-OMAP-Beagle-support-twl-gpio-differences-on-xM.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.37/0030-Revert-Input-ads7846-add-regulator-support.patch"
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
}

function beagle {
echo "beagle patches"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-Beagle-detect-new-xM-revision-B.patch"
patch -s -p1 < "${DIR}/patches/arago-project/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
#2.6.37-git2
#patch -s -p1 < "${DIR}/patches/arago-project/0001-AM37x-Switch-SGX-clocks-to-200MHz.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-beagle-use-GPIO2-on-the-xM-A3-to-turn-DVI-on.patch"
#patch -s -p1 < "${DIR}/patches/beagle/0001-revert-audio-seems-to-work-on-the-beagle-with-gone.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-omap-hsmmc-increase-dto-value-and-print-value-to-dme.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-xM-audio-fix-from-Ashok.patch"
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
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.32-PSP.diff"
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-use-omap3630.diff"

#dropped with 4.00.00.01
#patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-Compile-Fixes.patch"

#3.01.00.06 + 2.6.36-rc1
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-3.01.00.06-2.6.36-rc1-Compile-Fixes.patch"

#4.00.00.01 + 2.6.37-rc1
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.00.00.01-2.6.37-rc1-use-semaphore-ove.patch"

#4.00.00.01 + 2.6.38-merge (2.6.37-git5): so needs to be tested... (jan 10 rcn-ee)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP4-SGX-TI-4.00.00.01-2.6.38-merge-AUTOCONF_INCLUD.patch"
}

function omap4 {
echo "omap4 related patches"

#2.6.37-git2
#ehci for omap4 from: http://dev.omapzoom.org/?p=anand/linux-omap-usb.git;a=shortlog;h=refs/heads/omap4-ehci-upstream-v1
#patch -s -p1 < "${DIR}/patches/panda/0001-usb-ehci-omap-update-clock-names-to-be-more-generic.patch"
#patch -s -p1 < "${DIR}/patches/panda/0002-usb-ehci-omap-don-t-hard-code-TLL-channel-count.patch"
#patch -s -p1 < "${DIR}/patches/panda/0003-usb-ehci-introduce-CONFIG_USB_EHCI_HCD_OMAP.patch"
#patch -s -p1 < "${DIR}/patches/panda/0004-omap-clock-add-clkdev-aliases-for-EHCI-clocks.patch"
#patch -s -p1 < "${DIR}/patches/panda/0005-usb-ehci-omap-use-clkdev-aliases-for-functional-cloc.patch"
#patch -s -p1 < "${DIR}/patches/panda/0006-usb-ehci-omap-add-helpers-for-checking-port-mode.patch"
#patch -s -p1 < "${DIR}/patches/panda/0007-omap-usb-ehci-introduce-HSIC-mode.patch"
#patch -s -p1 < "${DIR}/patches/panda/0008-usb-ehci-omap-Add-OMAP4-support.patch"
#patch -s -p1 < "${DIR}/patches/panda/0009-arm-omap4-add-USBHOST-and-related-base-addresses.patch"
#patch -s -p1 < "${DIR}/patches/panda/0010-arm-omap4-usb-add-platform-init-code-for-EHCI.patch"
#patch -s -p1 < "${DIR}/patches/panda/0011-arm-omap4-select-USB_ARCH_HAS_EHCI.patch"
#patch -s -p1 < "${DIR}/patches/panda/0012-omap4-4430sdp-enable-the-ehci-port-on-4430SDP.patch"

#patch -s -p1 < "${DIR}/patches/panda/0001-OMAP4-Pandaboard-Fixing-MMC-card-detect-gpio-line.patch"
#patch -s -p1 < "${DIR}/patches/panda/0002-OMAP4-Pandaboad-Add-omap_reserve-functionality.patch"

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

}

function dvfs {
echo "dvfs from dev.omapzoom"

#2.6.37-git2
#patch -s -p1 < "${DIR}/patches/dvfs/0001-omap-opp-add-OMAP3-OPP-table-data-and-common-init.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0002-omap4-opp-add-OPP-table-data-fixup-ehci.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0003-OMAP3-remove-OPP-interfaces-from-OMAP-PM-layer.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0004-OMAP4-clock-data-Add-missing-DPLL-x2-clock-nodes-fixup-ehci.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0005-OMAP-pm.c-correct-the-initcall-for-an-early-init.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0006-OMAP3-PM-Adding-voltage-driver-support-for-OMAP3.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0007-OMAP-Introduce-voltage-domain-information-in-the-hwm.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0008-OMAP3-PM-Adding-smartreflex-driver-support.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0009-OMAP3-PM-Adding-smartreflex-device-file.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0010-OMAP3-PM-Adding-smartreflex-hwmod-data.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0011-OMAP3-PM-Adding-smartreflex-class3-driver.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0012-OMAP3-PM-Adding-T2-enabling-of-smartreflex-support.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0013-OMAP3-PM-Register-TWL4030-pmic-info-with-the-voltage.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0014-OMAP3-PM-Adding-debug-support-to-Voltage-and-Smartre.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0015-OMAP3-PM-Program-correct-init-voltages-for-VDD1-and-.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0016-OMAP4-Register-voltage-PMIC-parameters-with-the-volt.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0017-OMAP4-Adding-voltage-driver-support.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0018-OMAP4-PM-Program-correct-init-voltages-for-scalable-.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0019-OMAP4-hwmod-Add-inital-data-for-smartreflex-modules.patch"
#patch -s -p1 < "${DIR}/patches/dvfs/0020-OMAP4-Smartreflex-framework-extensions.patch"

#patch -s -p1 < "${DIR}/patches/dspbridge/0001-omap-mailbox-fix-detection-for-previously-supported-.patch"

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

