#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

#Bisected from 2.6.35 -> 2.6.36 to find this..
#This commit breaks some lcd monitors..
#rcn-ee Feb 26, 2011...
#Still needs more work for 2.6.38, causes:
#[   14.962829] omapdss DISPC error: GFX_FIFO_UNDERFLOW, disabling GFX
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-OMAP-DSS2-OMAPFB-swap-front-and-back-porches-.patch"

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

#should fix gcc-4.6 ehci problems..
patch -s -p1 < "${DIR}/patches/trivial/0001-USB-ehci-use-packed-aligned-4-instead-of-removing-th.patch"

#fixed in 3.0.0-rc7
#ehci crashes on startup/init
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-mfd-Add-omap-usbhs-runtime-PM-support.patch"

#smp broken in 3.0-git4
#this may be a config problem, as omap2plus_defconfig seems to work fine..
#`.exit.text' referenced in section `.alt.smp.init' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
#`.exit.text' referenced in section `.alt.smp.init' of net/built-in.o: defined in discarded section `.exit.text' of net/built-in.o
patch -s -p1 < "${DIR}/patches/trivial/smp/0001-Revert-ARM-vmlinux.lds-use-_text-and-_stext-the-same.patch"
patch -s -p1 < "${DIR}/patches/trivial/smp/0002-Revert-ARM-vmlinux.lds-move-init-sections-between-te.patch"
patch -s -p1 < "${DIR}/patches/trivial/smp/0003-Revert-ARM-vmlinux.lds-remove-.rodata-.rodata1-from-.patch"
patch -s -p1 < "${DIR}/patches/trivial/smp/0004-Revert-ARM-vmlinux.lds-rearrange-.init-output-sectio.patch"
patch -s -p1 < "${DIR}/patches/trivial/smp/0005-Revert-ARM-vmlinux.lds-move-discarded-sections-to-be.patch"

#nfs broken in 3.0-git14
#In file included from fs/nfs/client.c:51:0:
#fs/nfs/pnfs.h:384:1: error: expected identifier or ‘(’ before ‘{’ token
#fs/nfs/pnfs.h:382:51: warning: ‘set_pnfs_layoutdriver’ used but never defined
#make[2]: *** [fs/nfs/client.o] Error 1
#make[1]: *** [fs/nfs] Error 2
#fixed in 3.0-git15
#fix: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=a00ed25cce6fe856388f89c7cd40da0eee7666a6
#patch -s -p1 < "${DIR}/patches/trivial/0001-NFS-Re-enable-compilation-of-nfs-with-CONFIG_NFS_V4-.patch"

#broken in 3.0-git19
#arch/arm/kernel/process.c: In function ‘cpu_idle’:
#arch/arm/kernel/process.c:200:5: error: implicit declaration of function ‘cpuidle_call_idle’
#make[1]: *** [arch/arm/kernel/process.o] Error 1
#fixed with 3.0-git21
#patch -s -p1 < "${DIR}/patches/trivial/0001-cpuidle-Fix-build-on-ARM-and-SH.patch"

}

function dss2_next {
echo "dss2 from for-next"

}

function dspbridge_next {
echo "dspbridge from for-next"

}

function omap_fixes {
echo "omap fixes"
#fixes broken vout
patch -s -p1 < "${DIR}/patches/trivial/0001-OMAP_VOUT-Fix-build-break-caused-by-update_mode-remo.patch"

}

function for_next {
echo "for_next from tmlind's tree.."

#in 3.0-git8
#patch -s -p1 < "${DIR}/patches/beagle/0001-OMAP3-beagle-add-support-for-beagleboard-xM-revision.patch"
}


function sakoman {
echo "sakoman's patches"


patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0006-OMAP-DSS2-add-bootarg-for-selecting-svideo-or-compos.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0007-video-add-timings-for-hd720.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0008-drivers-net-smsc911x-return-ENODEV-if-device-is-not-.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.40/0009-drivers-input-touchscreen-ads7846-return-ENODEV-if-d.patch"

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

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0025-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0026-OMAP-Overo-Add-support-for-spidev.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/3.0.0/0029-OMAP3-beagle-add-support-for-expansionboards.patch"
#for 3.0-git5, still needs tweaks for wifi board
patch -s -p1 < "${DIR}/patches/sakoman/3.1.0/0029-OMAP3-beagle-add-support-for-expansionboards.patch"

#TESTING
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0030-omap-beagle-Add-support-for-1GHz.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0031-omap-Change-omap_device-activate-dectivate-latency-m.patch"
patch -s -p1 < "${DIR}/patches/sakoman/3.0.0/0032-omap-overo-Add-opp-init.patch"

#drop in 3.0-git8
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0033-ARM-OMAP-Overo-remove-duplicate-call-to-overo_ads784.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0035-mtd-nand-Eliminate-noisey-uncorrectable-error-messag.patch"

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

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0060-OMAP2-cpufreq-free-up-table-on-exit.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0061-OMAP2-cpufreq-handle-invalid-cpufreq-table.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0062-OMAP2-cpufreq-minor-comment-cleanup.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0063-OMAP2-cpufreq-use-clk_init_cpufreq_table-if-OPPs-not.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0064-OMAP2-cpufreq-use-cpufreq_frequency_table_target.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0065-OMAP2-cpufreq-fix-freq_table-leak.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/3.1.0/0066-OMAP2-clockdomain-Add-an-api-to-read-idle-mode.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0067-OMAP2-clockdomain-Add-SoC-support-for-clkdm_is_idle.patch"

#in 3.0-git8
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0068-OMAP2-PM-Initialise-sleep_switch-to-a-non-valid-valu.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0069-OMAP2-PM-idle-clkdms-only-if-already-in-idle.patch"

#drop with 3.0-git5
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0070-OMAP2-hwmod-Follow-the-recomended-PRCM-sequence.patch"

#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0071-OMAP-Serial-Check-wk_st-only-if-present.patch"
#patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0072-omap3-Add-basic-support-for-720MHz-part.patch"

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
patch -s -p1 < "${DIR}/patches/display/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

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
#drop with 3.0-git16
#patch -s -p1 < "${DIR}/patches/panda/0001-OMAP4-DSS2-add-dss_dss_clk.patch"
patch -s -p1 < "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
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

#4.03.00.01 (adds omap4 libs)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-4-SGX-Merge-TI-4.04.00.01-into-TI-4.03.00.02.patch"

#4.03.00.02
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.32-PSP.patch"

#4.03.00.02 + 2.6.38-merge (2.6.37-git5)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.38-merge-AUTOCONF_INCLUD.patch"

#4.03.00.02 + 2.6.38-rc3
#updated for 4.04.00.01
#use: for updating patch:
#sed -i -e 's:acquire_console_sem:console_lock:g' drivers/staging/omap3-sgx/services4/3rdparty/*/*.c
#sed -i -e 's:release_console_sem:console_unlock:g' drivers/staging/omap3-sgx/services4/3rdparty/*/*.c
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-4-SGX-TI-4.04.00.01-2.6.38-rc3-_console_sem-to-c.patch"

#4.03.00.01
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.01-add-outer_cache.clean_all.patch"

#4.03.00.02
#omap3 doesn't work on omap3630
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-use-omap3630-as-TI_PLATFORM.patch"

#4.03.00.02 + 2.6.39 (2.6.38-git2)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.39-rc-SPIN_LOCK_UNLOCKED.patch"

#4.03.00.02 + 2.6.40 (2.6.39-git11)
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-SGX-TI-4.03.00.02-2.6.40-display.h-to-omapdss..patch"

#4.04.00.01 fix Kbuild
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-4-SGX-TI-4.04.00.01-fix-Kbuild.patch"

#4.04.00.01 fix another linux/config.h reference
patch -s -p1 < "${DIR}/patches/sgx/0001-OMAP3-4-SGX-TI-4.04.00.01-remove-config.h-reference.patch"

#with v3.0-git16
#drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.c:324:15: error: ‘OMAP_DSS_UPDATE_AUTO’ undeclared (first use in this function)
#drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.c:327:15: error: ‘OMAP_DSS_UPDATE_MANUAL’ undeclared (first use in this function)
#drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.c:330:15: error: ‘OMAP_DSS_UPDATE_DISABLED’ undeclared (first use in this function)
#drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.c:337:16: error: ‘struct omap_dss_driver’ has no member named ‘set_update_mode’
#drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.c:312:28: warning: unused variable ‘eDSSMode’
#make[4]: *** [drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux/omaplfb_linux.o] Error 1
#make[3]: *** [drivers/staging/omap3-sgx/services4/3rdparty/dc_omapfb3_linux] Error 2
#make[2]: *** [drivers/staging/omap3-sgx] Error 2
patch -s -p1 < "${DIR}/patches/sgx/0001-Revert-OMAP-DSS2-remove-update_mode-from-omapdss.patch"

}

bugs_trivial

#for_next tree's
dss2_next
omap_fixes
#dspbridge_next
for_next

#work in progress
#

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

