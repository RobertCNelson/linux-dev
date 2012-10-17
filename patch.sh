#!/bin/bash
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

function bugs_trivial {
	echo "bugs and trivial stuff"
	${git} "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
	${git} "${DIR}/patches/trivial/0001-kbuild-Fix-link-to-headers-in-make-deb-pkg.patch"
}

function am33x-cleanup {
	echo "[git] am33x-cleanup"
	echo "pulling ti_am33x_v3.2-staging_8"
	git pull ${GIT_OPTS} git://github.com/RobertCNelson/linux.git ti_am33x_v3.2-staging_8

	#Breaks: BeagleBone: eth0: dhcp doesn't get ip address...
	${git} "${DIR}/patches/3.2.30/0137-Revert-ARM-OMAP2-Fix-dmtimer-set-source-clock-failur.patch"

	#Just a place holder to make diff-ing easier...
	${git} "${DIR}/patches/3.2.31/0109-Linux-3.2.31.patch"

	${git} "${DIR}/patches/3.2.32/0001-isci-fix-isci_pci_probe-generates-warning-on-efi-fai.patch"
	${git} "${DIR}/patches/3.2.32/0002-mtd-nand-Use-the-mirror-BBT-descriptor-when-reading-.patch"
	${git} "${DIR}/patches/3.2.32/0003-drm-i915-prevent-possible-pin-leak-on-error-path.patch"
	${git} "${DIR}/patches/3.2.32/0004-workqueue-add-missing-smp_wmb-in-process_one_work.patch"
	${git} "${DIR}/patches/3.2.32/0005-TTY-ttyprintk-don-t-touch-behind-tty-write_buf.patch"
	${git} "${DIR}/patches/3.2.32/0006-Remove-BUG_ON-from-n_tty_read.patch"
	${git} "${DIR}/patches/3.2.32/0007-n_gsm.c-Implement-3GPP27.010-DLC-start-up-procedure-.patch"
	${git} "${DIR}/patches/3.2.32/0008-n_gsm-uplink-SKBs-accumulate-on-list.patch"
	${git} "${DIR}/patches/3.2.32/0009-n_gsm-Flow-control-handling-in-Mux-driver.patch"
	${git} "${DIR}/patches/3.2.32/0010-char-n_gsm-remove-message-filtering-for-contipated-D.patch"
	${git} "${DIR}/patches/3.2.32/0011-n_gsm-added-interlocking-for-gsm_data_lock-for-certa.patch"
	${git} "${DIR}/patches/3.2.32/0012-n_gsm-avoid-accessing-freed-memory-during-CMD_FCOFF-.patch"
	${git} "${DIR}/patches/3.2.32/0013-n_gsm-replace-kfree_skb-w-appropriate-dev_-versions.patch"
	${git} "${DIR}/patches/3.2.32/0014-n_gsm-memory-leak-in-uplink-error-path.patch"
	${git} "${DIR}/patches/3.2.32/0015-UBI-fix-autoresize-handling-in-R-O-mode.patch"
	${git} "${DIR}/patches/3.2.32/0016-UBI-erase-free-PEB-with-bitflip-in-EC-header.patch"
	${git} "${DIR}/patches/3.2.32/0017-firmware-Add-missing-attributes-to-EFI-variable-attr.patch"
	${git} "${DIR}/patches/3.2.32/0018-tools-hv-Fix-exit-error-code.patch"
	${git} "${DIR}/patches/3.2.32/0019-slab-fix-the-DEADLOCK-issue-on-l3-alien-lock.patch"
	${git} "${DIR}/patches/3.2.32/0020-gspca_pac7302-Add-usb-id-for-145f-013c.patch"
	${git} "${DIR}/patches/3.2.32/0021-gspca_pac7302-add-support-for-device-1ae7-2001-Speed.patch"
	${git} "${DIR}/patches/3.2.32/0022-xhci-Warn-when-hosts-don-t-halt.patch"
	${git} "${DIR}/patches/3.2.32/0023-xHCI-add-cmd_ring_state.patch"
	${git} "${DIR}/patches/3.2.32/0024-xHCI-add-aborting-command-ring-function.patch"
	${git} "${DIR}/patches/3.2.32/0025-xHCI-cancel-command-after-command-timeout.patch"
	${git} "${DIR}/patches/3.2.32/0026-hpsa-Use-LUN-reset-instead-of-target-reset.patch"
	${git} "${DIR}/patches/3.2.32/0027-rc-ite-cir-Initialise-ite_dev-rdev-earlier.patch"
	${git} "${DIR}/patches/3.2.32/0028-staging-speakup_soft-Fix-reading-of-init-string.patch"
	${git} "${DIR}/patches/3.2.32/0029-target-fix-return-code-in-target_core_init_configfs-.patch"
	${git} "${DIR}/patches/3.2.32/0030-powerpc-eeh-Lock-module-while-handling-EEH-event.patch"
	${git} "${DIR}/patches/3.2.32/0031-intel-iommu-Default-to-non-coherent-for-domains-unat.patch"
	${git} "${DIR}/patches/3.2.32/0032-workqueue-fix-possible-stall-on-try_to_grab_pending-.patch"
	${git} "${DIR}/patches/3.2.32/0033-PCI-Check-P2P-bridge-for-invalid-secondary-subordina.patch"
	${git} "${DIR}/patches/3.2.32/0034-Bluetooth-Add-USB_VENDOR_AND_INTERFACE_INFO-for-Broa.patch"
	${git} "${DIR}/patches/3.2.32/0035-staging-comedi-don-t-dereference-user-memory-for-INS.patch"
	${git} "${DIR}/patches/3.2.32/0036-SUNRPC-Ensure-that-the-TCP-socket-is-closed-when-in-.patch"
	${git} "${DIR}/patches/3.2.32/0037-ext4-fix-potential-deadlock-in-ext4_nonda_switch.patch"
	${git} "${DIR}/patches/3.2.32/0038-staging-comedi-fix-memory-leak-for-saved-channel-lis.patch"
	${git} "${DIR}/patches/3.2.32/0039-USB-option-blacklist-QMI-interface-on-ZTE-MF683.patch"
	${git} "${DIR}/patches/3.2.32/0040-USB-qcaux-add-Pantech-vendor-class-match.patch"
	${git} "${DIR}/patches/3.2.32/0041-can-mscan-mpc5xxx-fix-return-value-check-in-mpc512x_.patch"
	${git} "${DIR}/patches/3.2.32/0042-iscsi-target-Correctly-set-0xffffffff-field-within-I.patch"
	${git} "${DIR}/patches/3.2.32/0043-rcu-Fix-day-one-dyntick-idle-stall-warning-bug.patch"
	${git} "${DIR}/patches/3.2.32/0044-zfcp-Make-trace-record-tags-unique.patch"
	${git} "${DIR}/patches/3.2.32/0045-zfcp-Bounds-checking-for-deferred-error-trace.patch"
	${git} "${DIR}/patches/3.2.32/0046-zfcp-Do-not-wakeup-while-suspended.patch"
	${git} "${DIR}/patches/3.2.32/0047-zfcp-remove-invalid-reference-to-list-iterator-varia.patch"
	${git} "${DIR}/patches/3.2.32/0048-zfcp-restore-refcount-check-on-port_remove.patch"
	${git} "${DIR}/patches/3.2.32/0049-zfcp-only-access-zfcp_scsi_dev-for-valid-scsi_device.patch"
	${git} "${DIR}/patches/3.2.32/0050-ibmvscsi-Fix-host-config-length-field-overflow.patch"
	${git} "${DIR}/patches/3.2.32/0051-scsi_remove_target-fix-softlockup-regression-on-hot-.patch"
	${git} "${DIR}/patches/3.2.32/0052-scsi_dh_alua-Enable-STPG-for-unavailable-ports.patch"
	${git} "${DIR}/patches/3.2.32/0053-Increase-XHCI-suspend-timeout-to-16ms.patch"
	${git} "${DIR}/patches/3.2.32/0054-usb-host-xhci-Fix-Null-pointer-dereferencing-with-71.patch"
	${git} "${DIR}/patches/3.2.32/0055-USB-ftdi_sio-add-TIAO-USB-Multi-Protocol-Adapter-TUM.patch"
	${git} "${DIR}/patches/3.2.32/0056-ACPI-run-_OSC-after-ACPI_FULL_INITIALIZATION.patch"
	${git} "${DIR}/patches/3.2.32/0057-ath9k-Disable-ASPM-only-for-AR9285.patch"
	${git} "${DIR}/patches/3.2.32/0058-xhci-Intel-Panther-Point-BEI-quirk.patch"
	${git} "${DIR}/patches/3.2.32/0059-drm-i915-add-some-barriers-when-changing-DIPs.patch"
	${git} "${DIR}/patches/3.2.32/0060-drm-i915-make-sure-we-write-all-the-DIP-data-bytes.patch"
	${git} "${DIR}/patches/3.2.32/0061-ext4-move_extent-code-cleanup.patch"
	${git} "${DIR}/patches/3.2.32/0062-ext4-online-defrag-is-not-supported-for-journaled-fi.patch"
	${git} "${DIR}/patches/3.2.32/0063-staging-comedi-s626-don-t-dereference-insn-data.patch"
	${git} "${DIR}/patches/3.2.32/0064-serial-set-correct-baud_base-for-EXSYS-EX-41092-Dual.patch"
	${git} "${DIR}/patches/3.2.32/0065-serial-pl011-handle-corruption-at-high-clock-speeds.patch"
	${git} "${DIR}/patches/3.2.32/0066-ext4-always-set-i_op-in-ext4_mknod.patch"
	${git} "${DIR}/patches/3.2.32/0067-ext4-fix-fdatasync-for-files-with-only-i_size-change.patch"
	${git} "${DIR}/patches/3.2.32/0068-coredump-prevent-double-free-on-an-error-path-in-cor.patch"
	${git} "${DIR}/patches/3.2.32/0069-drm-i915-use-adjusted_mode-instead-of-mode-for-check.patch"
	${git} "${DIR}/patches/3.2.32/0070-drm-radeon-only-adjust-default-clocks-on-NI-GPUs.patch"
	${git} "${DIR}/patches/3.2.32/0071-drm-radeon-Add-MSI-quirk-for-gateway-RS690.patch"
	${git} "${DIR}/patches/3.2.32/0072-drm-radeon-force-MSIs-on-RS690-asics.patch"
	${git} "${DIR}/patches/3.2.32/0073-kbuild-Do-not-package-boot-and-lib-in-make-tar-pkg.patch"
	${git} "${DIR}/patches/3.2.32/0074-staging-comedi-jr3_pci-fix-iomem-dereference.patch"
	${git} "${DIR}/patches/3.2.32/0075-Input-synaptics-adjust-threshold-for-treating-positi.patch"
	${git} "${DIR}/patches/3.2.32/0076-mtd-autcpu12-nvram-Fix-compile-breakage.patch"
	${git} "${DIR}/patches/3.2.32/0077-mtd-mtdpart-break-it-as-soon-as-we-parse-out-the-par.patch"
	${git} "${DIR}/patches/3.2.32/0078-mtd-omap2-fix-omap_nand_remove-segfault.patch"
	${git} "${DIR}/patches/3.2.32/0079-JFFS2-don-t-fail-on-bitflips-in-OOB.patch"
	${git} "${DIR}/patches/3.2.32/0080-mtd-nandsim-bugfix-fail-if-overridesize-is-too-big.patch"
	${git} "${DIR}/patches/3.2.32/0081-IPoIB-Fix-use-after-free-of-multicast-object.patch"
	${git} "${DIR}/patches/3.2.32/0082-IB-srp-Fix-use-after-free-in-srp_reset_req.patch"
	${git} "${DIR}/patches/3.2.32/0083-IB-srp-Avoid-having-aborted-requests-hang.patch"
	${git} "${DIR}/patches/3.2.32/0084-localmodconfig-Fix-localyesconfig-to-set-to-y-not-m.patch"
	${git} "${DIR}/patches/3.2.32/0085-lockd-use-rpc-client-s-cl_nodename-for-id-encoding.patch"
	${git} "${DIR}/patches/3.2.32/0086-pnfsblock-fix-partial-page-buffer-wirte.patch"
	${git} "${DIR}/patches/3.2.32/0087-drm-i915-Flush-the-pending-flips-on-the-CRTC-before-.patch"
	${git} "${DIR}/patches/3.2.32/0088-target-file-Re-enable-optional-fd_buffered_io-1-oper.patch"
	${git} "${DIR}/patches/3.2.32/0089-iscsi-target-Add-explicit-set-of-cache_dynamic_acls-.patch"
	${git} "${DIR}/patches/3.2.32/0090-iscsit-remove-incorrect-unlock-in-iscsit_build_sendt.patch"
	${git} "${DIR}/patches/3.2.32/0091-scripts-Kbuild.include-Fix-portability-problem-of-ec.patch"
	${git} "${DIR}/patches/3.2.32/0092-kbuild-Fix-gcc-x-syntax.patch"
	${git} "${DIR}/patches/3.2.32/0093-mmc-omap_hsmmc-Pass-on-the-suspend-failure-to-the-PM.patch"
	${git} "${DIR}/patches/3.2.32/0094-mmc-sh-mmcif-avoid-oops-on-spurious-interrupts.patch"
	${git} "${DIR}/patches/3.2.32/0095-iscsi-target-Bump-defaults-for-nopin_timeout-nopin_r.patch"
	${git} "${DIR}/patches/3.2.32/0096-lguest-fix-occasional-crash-in-example-launcher.patch"
	${git} "${DIR}/patches/3.2.32/0097-drm-i915-call-drm_handle_vblank-before-finish_page_f.patch"
	${git} "${DIR}/patches/3.2.32/0098-drm-i915-Fix-GT_MODE-default-value.patch"
	${git} "${DIR}/patches/3.2.32/0099-mn10300-only-add-mmem-funcs-to-KBUILD_CFLAGS-if-gcc-.patch"
	${git} "${DIR}/patches/3.2.32/0100-drivers-dma-dmaengine.c-lower-the-priority-of-failed.patch"
	${git} "${DIR}/patches/3.2.32/0101-kbuild-make-fix-if_changed-when-command-contains-bac.patch"
	${git} "${DIR}/patches/3.2.32/0102-drivers-scsi-atp870u.c-fix-bad-use-of-udelay.patch"
	${git} "${DIR}/patches/3.2.32/0103-kernel-sys.c-call-disable_nonboot_cpus-in-kernel_res.patch"
	${git} "${DIR}/patches/3.2.32/0104-lib-gcd.c-prevent-possible-div-by-0.patch"
	${git} "${DIR}/patches/3.2.32/0105-rapidio-rionet-fix-multicast-packet-transmit-logic.patch"
	${git} "${DIR}/patches/3.2.32/0106-ALSA-hda-Fix-internal-mic-for-Lenovo-Ideapad-U300s.patch"
	${git} "${DIR}/patches/3.2.32/0107-ALSA-HDA-Add-inverted-internal-mic-quirk-for-Lenovo-.patch"
	${git} "${DIR}/patches/3.2.32/0108-ALSA-hda-Add-inverted-internal-mic-quirk-for-Lenovo-.patch"
	${git} "${DIR}/patches/3.2.32/0109-ALSA-aloop-add-locking-to-timer-access.patch"
	${git} "${DIR}/patches/3.2.32/0110-mmc-sdhci-s3c-fix-the-wrong-number-of-max-bus-clocks.patch"
	${git} "${DIR}/patches/3.2.32/0111-ARM-OMAP-counter-add-locking-to-read_persistent_cloc.patch"
	${git} "${DIR}/patches/3.2.32/0112-mm-fix-invalidate_complete_page2-lock-ordering.patch"
	${git} "${DIR}/patches/3.2.32/0113-mm-thp-fix-pmd_present-for-split_huge_page-and-PROT_.patch"
	${git} "${DIR}/patches/3.2.32/0114-mm-hugetlb-fix-pgoff-computation-when-unmapping-page.patch"
	${git} "${DIR}/patches/3.2.32/0115-hugetlb-do-not-use-vma_hugecache_offset-for-vma_prio.patch"
	${git} "${DIR}/patches/3.2.32/0116-firewire-cdev-fix-user-memory-corruption-i386-userla.patch"
	${git} "${DIR}/patches/3.2.32/0117-autofs4-fix-reset-pending-flag-on-mount-fail.patch"
	${git} "${DIR}/patches/3.2.32/0118-udf-fix-retun-value-on-error-path-in-udf_load_logica.patch"
	${git} "${DIR}/patches/3.2.32/0119-eCryptfs-Unlink-lower-inode-when-ecryptfs_create-fai.patch"
	${git} "${DIR}/patches/3.2.32/0120-eCryptfs-Initialize-empty-lower-files-when-opening-t.patch"
	${git} "${DIR}/patches/3.2.32/0121-eCryptfs-Revert-to-a-writethrough-cache-model.patch"
	${git} "${DIR}/patches/3.2.32/0122-eCryptfs-Write-out-all-dirty-pages-just-before-relea.patch"
	${git} "${DIR}/patches/3.2.32/0123-eCryptfs-Call-lower-flush-from-ecryptfs_flush.patch"
	${git} "${DIR}/patches/3.2.32/0124-drm-radeon-properly-handle-mc_stop-mc_resume-on-ever.patch"
	${git} "${DIR}/patches/3.2.32/0125-efi-initialize-efi.runtime_version-to-make-query_var.patch"
	${git} "${DIR}/patches/3.2.32/0126-mempolicy-remove-mempolicy-sharing.patch"
	${git} "${DIR}/patches/3.2.32/0127-mempolicy-fix-a-race-in-shared_policy_replace.patch"
	${git} "${DIR}/patches/3.2.32/0128-mempolicy-fix-refcount-leak-in-mpol_set_shared_polic.patch"
	${git} "${DIR}/patches/3.2.32/0129-mempolicy-fix-a-memory-corruption-by-refcount-imbala.patch"
	${git} "${DIR}/patches/3.2.32/0130-r8169-Config1-is-read-only-on-8168c-and-later.patch"
	${git} "${DIR}/patches/3.2.32/0131-r8169-8168c-and-later-require-bit-0x20-to-be-set-in-.patch"
	${git} "${DIR}/patches/3.2.32/0132-hpsa-dial-down-lockup-detection-during-firmware-flas.patch"
	${git} "${DIR}/patches/3.2.32/0133-sched-Fix-migration-thread-runtime-bogosity.patch"
	${git} "${DIR}/patches/3.2.32/0134-netfilter-nf_ct_ipv4-packets-with-wrong-ihl-are-inva.patch"
	${git} "${DIR}/patches/3.2.32/0135-netfilter-nf_nat_sip-fix-incorrect-handling-of-EBUSY.patch"
	${git} "${DIR}/patches/3.2.32/0136-netfilter-nf_nat_sip-fix-via-header-translation-with.patch"
	${git} "${DIR}/patches/3.2.32/0137-netfilter-nf_ct_expect-fix-possible-access-to-uninit.patch"
	${git} "${DIR}/patches/3.2.32/0138-ipvs-fix-oops-on-NAT-reply-in-br_nf-context.patch"
	${git} "${DIR}/patches/3.2.32/0139-netfilter-limit-hashlimit-avoid-duplicated-inline.patch"
	${git} "${DIR}/patches/3.2.32/0140-netfilter-xt_limit-have-r-cost-0-case-work.patch"
	${git} "${DIR}/patches/3.2.32/0141-e1000-fix-lockdep-splat-in-shutdown-handler.patch"
	${git} "${DIR}/patches/3.2.32/0142-xHCI-handle-command-after-aborting-the-command-ring.patch"
	${git} "${DIR}/patches/3.2.32/0143-drm-i915-fix-swizzle-detection-for-gen3.patch"
	${git} "${DIR}/patches/3.2.32/0144-drm-i915-Mark-untiled-BLT-commands-as-fenced-on-gen2.patch"
	${git} "${DIR}/patches/3.2.32/0145-drm-i915-clear-fencing-tracking-state-when-retiring-.patch"
	${git} "${DIR}/patches/3.2.32/0146-Linux-3.2.32.patch"

	${git} "${DIR}/patches/led/0001-leds-heartbeat-stop-on-shutdown-reboot-or-panic.patch"
	${git} "${DIR}/patches/led/0002-led-triggers-rename-trigger-to-trig-for-unified-nami.patch"
	${git} "${DIR}/patches/led/0003-led-triggers-create-a-trigger-for-CPU-activity.patch"
	${git} "${DIR}/patches/led/0004-ARM-use-new-LEDS-CPU-trigger-stub-to-replace-old-one.patch"

	${git} "${DIR}/patches/libertas/0001-USB-convert-drivers-net-to-use-module_usb_driver.patch"
	${git} "${DIR}/patches/libertas/0002-net-fix-assignment-of-0-1-to-bool-variables.patch"
	${git} "${DIR}/patches/libertas/0003-switch-debugfs-to-umode_t.patch"
	${git} "${DIR}/patches/libertas/0004-drivers-net-Remove-unnecessary-k.alloc-v.alloc-OOM-m.patch"
	${git} "${DIR}/patches/libertas/0005-libertas-remove-dump_survey-implementation.patch"
	${git} "${DIR}/patches/libertas/0006-wireless-libertas-remove-redundant-NULL-tests-before.patch"
	${git} "${DIR}/patches/libertas/0007-libertas-fix-signedness-bug-in-lbs_auth_to_authtype.patch"
	${git} "${DIR}/patches/libertas/0008-drivers-net-wireless-libertas-if_usb.c-add-missing-d.patch"
	${git} "${DIR}/patches/libertas/0009-libertas-Firmware-loading-simplifications.patch"
	${git} "${DIR}/patches/libertas/0010-libertas-harden-up-exit-paths.patch"
	${git} "${DIR}/patches/libertas/0011-libertas-add-asynchronous-firmware-loading-capabilit.patch"
	${git} "${DIR}/patches/libertas/0012-libertas-SDIO-convert-to-asynchronous-firmware-loadi.patch"
	${git} "${DIR}/patches/libertas/0013-libertas-USB-convert-to-asynchronous-firmware-loadin.patch"
	${git} "${DIR}/patches/libertas/0014-libertas-CS-convert-to-asynchronous-firmware-loading.patch"
	${git} "${DIR}/patches/libertas/0015-libertas-add-missing-include.patch"
	${git} "${DIR}/patches/libertas/0016-remove-debug-msgs-due-to-missing-in_interrupt.patch"

	${git} "${DIR}/patches/pwm/0001-PWM-ecap-Correct-configuration-of-polarity.patch"
	${git} "${DIR}/patches/pwm/0002-ARM-OMAP2-am335x-mux-add-ecap2_in_pwm2_out-string-en.patch"
	${git} "${DIR}/patches/pwm/0003-ARM-OMAP2-AM335x-hwmod-Remove-PRCM-entries-for-PWMSS.patch"
	${git} "${DIR}/patches/pwm/0004-PWM-ecap-Resets-the-PWM-output-to-low-on-stop.patch"
	${git} "${DIR}/patches/pwm/0005-PWM-ecap-Fix-for-throwing-PWM-output-before-running.patch"
	${git} "${DIR}/patches/pwm/0006-pwm-ehrpwm-Configure-polarity-on-pwm_start.patch"

	${git} "${DIR}/patches/mfd/0001-Add-TPS65217-Backlight-Driver.patch"

	${git} "${DIR}/patches/beaglebone/0001-f_rndis-HACK-around-undefined-variables.patch"
	${git} "${DIR}/patches/beaglebone/0002-da8xx-fb-add-DVI-support-for-beaglebone.patch"
	${git} "${DIR}/patches/beaglebone/0003-beaglebone-rebase-everything-onto-3.2-WARNING-MEGAPA.patch"
	${git} "${DIR}/patches/beaglebone/0004-more-beaglebone-merges.patch"
	${git} "${DIR}/patches/beaglebone/0005-beaglebone-disable-tsadc.patch"
	${git} "${DIR}/patches/beaglebone/0006-tscadc-Add-general-purpose-mode-untested-with-touchs.patch"
	${git} "${DIR}/patches/beaglebone/0007-tscadc-Add-board-file-mfd-support-fix-warning.patch"
	${git} "${DIR}/patches/beaglebone/0008-AM335X-init-tsc-bone-style-for-new-boards.patch"
	${git} "${DIR}/patches/beaglebone/0009-tscadc-make-stepconfig-channel-configurable.patch"
	${git} "${DIR}/patches/beaglebone/0010-tscadc-Trigger-through-sysfs.patch"
	${git} "${DIR}/patches/beaglebone/0011-meta-ti-Remove-debug-messages-for-meta-ti.patch"
	${git} "${DIR}/patches/beaglebone/0012-tscadc-switch-to-polling-instead-of-interrupts.patch"
	${git} "${DIR}/patches/beaglebone/0013-beaglebone-fix-ADC-init.patch"
	${git} "${DIR}/patches/beaglebone/0014-AM335x-MUX-add-ehrpwm1A.patch"
	${git} "${DIR}/patches/beaglebone/0015-beaglebone-enable-PWM-for-lcd-backlight-backlight-is.patch"
	${git} "${DIR}/patches/beaglebone/0016-omap_hsmmc-Set-dto-to-max-value-of-14-to-avoid-SD-Ca.patch"
	${git} "${DIR}/patches/beaglebone/0017-beaglebone-set-default-brightness-to-50-for-pwm-back.patch"
	${git} "${DIR}/patches/beaglebone/0018-st7735fb-WIP-framebuffer-driver-supporting-Adafruit-.patch"
	${git} "${DIR}/patches/beaglebone/0019-beaglebone-use-P8_6-gpio1_3-as-w1-bus.patch"
	${git} "${DIR}/patches/beaglebone/0020-beaglebone-add-support-for-Towertech-TT3201-CAN-cape.patch"
	${git} "${DIR}/patches/beaglebone/0021-beaglebone-add-more-beagleboardtoys-cape-partnumbers.patch"
	${git} "${DIR}/patches/beaglebone/0022-beaglebone-add-gpio-keys-for-lcd7-add-notes-for-miss.patch"
	${git} "${DIR}/patches/beaglebone/0023-beaglebone-add-enter-key-for-lcd7-cape.patch"
	${git} "${DIR}/patches/beaglebone/0024-beaglebone-add-gpio-keys-for-lcd.patch"
	${git} "${DIR}/patches/beaglebone/0025-beaglebone-fix-direction-of-gpio-keys.patch"
	${git} "${DIR}/patches/beaglebone/0026-beaglebone-fix-3.5-lcd-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/0027-beaglebone-decrease-PWM-frequency-to-old-value-LCD7-.patch"
	${git} "${DIR}/patches/beaglebone/0028-beaglebone-fix-ehrpwm-backlight.patch"
	${git} "${DIR}/patches/beaglebone/0029-beaglebone-also-report-cape-revision.patch"
	${git} "${DIR}/patches/beaglebone/0030-beaglebone-don-t-compare-undefined-characters-it-mak.patch"
	${git} "${DIR}/patches/beaglebone/0031-beaglebone-fix-3.5-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/0032-beaglebone-connect-batterycape-GPIO-to-gpio-charger.patch"
	${git} "${DIR}/patches/beaglebone/0033-beaglebone-add-support-for-CAN-and-RS232-cape.patch"
	${git} "${DIR}/patches/beaglebone/0034-beaglebone-add-support-for-DVI-rev.-A2-capes.patch"
	${git} "${DIR}/patches/beaglebone/0035-beaglebone-enable-LEDs-for-DVI-LCD3-and-LCD7-capes.patch"
	${git} "${DIR}/patches/beaglebone/0036-Beaglebone-Fixed-compiletime-warnings.patch"
	${git} "${DIR}/patches/beaglebone/0037-Beaglebone-Added-missing-termination-record-to-bone_.patch"
	${git} "${DIR}/patches/beaglebone/0038-board-am335xevm.c-Beaglebone-expose-all-pwms-through.patch"
	${git} "${DIR}/patches/beaglebone/0039-ARM-OMAP-Mux-Fixed-debugfs-mux-output-always-reporti.patch"
	${git} "${DIR}/patches/beaglebone/0040-beaglebone-export-SPI2-as-spidev-when-no-capes-are-u.patch"
	${git} "${DIR}/patches/beaglebone/0041-st7735fb-Working-WIP-changes-to-make-DMA-safe-and-ad.patch"
	${git} "${DIR}/patches/beaglebone/0042-omap-hwmod-silence-st_shift-error.patch"
	${git} "${DIR}/patches/beaglebone/0043-cpsw-phy_device-demote-PHY-message-to-INFO.patch"
	${git} "${DIR}/patches/beaglebone/0044-beaglebone-add-support-for-7-LCD-cape-revision-A2.patch"
	${git} "${DIR}/patches/beaglebone/0045-beaglebone-allow-capes-to-disable-w1-gpio.patch"
	${git} "${DIR}/patches/beaglebone/0046-beaglebone-add-stub-for-the-camera-cape-to-disable-w.patch"
	${git} "${DIR}/patches/beaglebone/0047-Adding-many-of-the-missing-signals-to-the-mux-table.patch"
	${git} "${DIR}/patches/beaglebone/0048-Fixed-reversed-part-of-LCD-bus.-Added-even-more-miss.patch"
	${git} "${DIR}/patches/beaglebone/0049-ts_tscadc-add-defines-for-4x-and-16x-oversampling.patch"
	${git} "${DIR}/patches/beaglebone/0050-ts_tscadc-switch-to-4x-oversampling.patch"
	${git} "${DIR}/patches/beaglebone/0051-Fixed-size-of-pinmux-data-array-in-EEPROM-data-struc.patch"
	${git} "${DIR}/patches/beaglebone/0052-Implemented-Bone-Cape-configuration-from-EEPROM.-Onl.patch"
	${git} "${DIR}/patches/beaglebone/0053-Replaced-conditional-debug-code-by-pr_debug-statemen.patch"
	${git} "${DIR}/patches/beaglebone/0054-Workaround-for-boards-with-mistaken-ASCII-interpreta.patch"
	${git} "${DIR}/patches/beaglebone/0055-Workaround-for-EEPROM-contents-blocking-further-I2C-.patch"
	${git} "${DIR}/patches/beaglebone/0056-Added-check-on-EEPROM-revision-to-prevent-interpreti.patch"
	${git} "${DIR}/patches/beaglebone/0057-i2c-prescalar-fix-i2c-fixed-prescalar-setting-issue.patch"
	${git} "${DIR}/patches/beaglebone/0058-beaglebone-annotate-default-beaglebone-pinmux.patch"
	${git} "${DIR}/patches/beaglebone/0059-beaglebone-fix-pin-free-thinko-this-method-doesn-t-g.patch"
	${git} "${DIR}/patches/beaglebone/0060-beaglebone-switch-RS232-cape-to-ttyO2.patch"
	${git} "${DIR}/patches/beaglebone/0061-beaglebone-make-uart2-pinmux-match-the-uart0-pinmux.patch"
	${git} "${DIR}/patches/beaglebone/0062-da8xx-fb-Rounding-FB-size-to-satisfy-SGX-buffer-requ.patch"
	${git} "${DIR}/patches/beaglebone/0063-beaglebone-dvi-cape-audio-hacks.patch"
	${git} "${DIR}/patches/beaglebone/0064-beaglebone-always-execute-the-pin-free-checks.patch"
	${git} "${DIR}/patches/beaglebone/0065-ti_tscadc-switch-to-16x-averaging.patch"
	${git} "${DIR}/patches/beaglebone/0066-video-da8xx-fb-Add-Newhaven-LCD-Panel-details.patch"
	${git} "${DIR}/patches/beaglebone/0067-beaglebone-add-support-for-the-4.3-lcd-cape-with-res.patch"
	${git} "${DIR}/patches/beaglebone/0068-beaglebone-add-support-for-LCD3-rev-A1.patch"
	${git} "${DIR}/patches/beaglebone/0069-beaglebone-fix-buttons-spidev-clash-when-using-mcasp.patch"
	${git} "${DIR}/patches/beaglebone/0070-beaglebone-fix-LCD3-led-key-overlap.patch"
	${git} "${DIR}/patches/beaglebone/0071-beaglebone-fix-audio-spi-clash.patch"
	${git} "${DIR}/patches/beaglebone/0072-beaglebone-add-support-for-QuickLogic-Camera-interfa.patch"
	${git} "${DIR}/patches/beaglebone/0073-beaglebone-add-support-for-DVI-audio-and-audio-only-.patch"
	${git} "${DIR}/patches/beaglebone/0074-beaglebone-disable-LBO-GPIO-for-battery-cape.patch"
	${git} "${DIR}/patches/beaglebone/0075-video-da8xx-fb-calculate-pixel-clock-period-for-the-.patch"
	${git} "${DIR}/patches/beaglebone/0076-beaglebone-improve-GPMC-bus-timings-for-camera-cape.patch"
	${git} "${DIR}/patches/beaglebone/0077-beaglebone-disable-UYVY-VYUY-and-YVYU-modes-in-camer.patch"
	${git} "${DIR}/patches/beaglebone/0078-beaglebone-error-handling-for-DMA-completion-in-cssp.patch"
	${git} "${DIR}/patches/beaglebone/0079-AM335X-errata-OPP50-on-MPU-domain-is-not-supported.patch"
	${git} "${DIR}/patches/beaglebone/0080-vfs-Add-a-trace-point-in-the-mark_inode_dirty-functi.patch"
	${git} "${DIR}/patches/beaglebone/0081-beaglebone-add-support-for-LCD7-A3.patch"
	${git} "${DIR}/patches/beaglebone/0082-beaglebone-add-rudimentary-support-for-eMMC-cape.patch"
	${git} "${DIR}/patches/beaglebone/0083-beaglebone-add-extra-partnumber-for-camera-cape.patch"
	${git} "${DIR}/patches/beaglebone/0084-beaglebone-cssp_camera-driver-cleanup.patch"
	${git} "${DIR}/patches/beaglebone/0085-beaglebone-mux-camera-cape-orientation-pin-to-gpio.patch"
	${git} "${DIR}/patches/beaglebone/0086-board-am335xevm-Add-Beaglebone-Motor-Cape-Support.patch"
	${git} "${DIR}/patches/beaglebone/0087-mux33xx-Fix-MUXENTRYs-for-MCASP0_ACLKX-FSX-to-add-eh.patch"
	${git} "${DIR}/patches/beaglebone/0088-beaglebone-add-a-method-to-skip-mmc-init.patch"
	${git} "${DIR}/patches/beaglebone/0089-beaglebone-do-mmc-init-in-TT3202-setup-method.patch"
	${git} "${DIR}/patches/beaglebone/0090-beaglebone-map-LCD7-A4-to-A3-for-the-time-being.patch"
	${git} "${DIR}/patches/beaglebone/0091-beaglebone-add-support-for-LCD3-rev-A2.patch"
	${git} "${DIR}/patches/beaglebone/0092-beaglebone-add-support-for-LCD4-rev-A1-button-suppor.patch"
	${git} "${DIR}/patches/beaglebone/0093-beaglebone-update-cssp_camera-driver-to-support-revi.patch"
	${git} "${DIR}/patches/beaglebone/0094-beaglebone-make-LCD4-Rev-A1-display-work-no-button-s.patch"
	${git} "${DIR}/patches/beaglebone/0095-beaglebone-convert-LCD4-to-16-bit-add-button-support.patch"
	${git} "${DIR}/patches/beaglebone/0096-beaglebone-camera-cape-sensor-orientation-support-fo.patch"

#	${git} "${DIR}/patches/beaglebone/0001-bone-disable-OPPTURBO.patch"
	${git} "${DIR}/patches/beaglebone/0002-BeagleBone-A2-fixup-eeprom-and-initialization.patch"

#	${git} "${DIR}/patches/beaglebone/0001-ARM-omap-am335x-BeagleBone-userspace-SPI-support.patch"
#	${git} "${DIR}/patches/fixes/0001-rt2x00-Add-support-for-D-Link-DWA-127-to-rt2800usb.patch"
}

rt_patchset () {
	#Unsupported: enable at your own peril
	${git} "${DIR}/patches/rt/0001-rt-patch-3.2.30-rt45.patch"
}

xenomai_patchset () {
	#Unsupported: enable at your own peril
	${git} "${DIR}/patches/xenomai/0001-ipipe-core-3.2.21-arm-1.patch"
}

am33x-cleanup
bugs_trivial

#rt_patchset
#xenomai_patchset

echo "patch.sh ran successful"

