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

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-Fix-link-to-headers-in-make-deb-pkg.patch"
}

function am33x-cleanup {
echo "[git] am33x-cleanup"
git pull git://github.com/RobertCNelson/linux.git ti_am33x_v3.2-staging_psp0

git am "${DIR}/patches/arago-am33x/0001-arm-omap-am33xx-add-missing-i2c-pin-mus-details.patch"
git am "${DIR}/patches/arago-am33x/0002-arm-omap-am33xx-add-i2c2-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0003-arm-omap-am33xx-register-i2c2-for-beaglebone.patch"
git am "${DIR}/patches/arago-am33x/0004-arm-omap-am33xx-update-TSC-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0005-ARM-OMAP-AM33XX-Keep-the-CLKDIV32K-module-enabled.patch"
git am "${DIR}/patches/arago-am33x/0006-arm-omap-am33xx-Check-device-features.patch"
git am "${DIR}/patches/arago-am33x/0007-arm-omap-am33xx-Register-SGX-device.patch"
git am "${DIR}/patches/arago-am33x/0008-Revert-usb-musb_gadget-cppi41-Use-pio-for-interrupt-.patch"
git am "${DIR}/patches/arago-am33x/0009-usb-musb-cppi41-fall-back-to-pio-for-interrupt-based.patch"
git am "${DIR}/patches/arago-am33x/0010-usb-musb-Let-PIO-option-visible-in-menuconfig.patch"
git am "${DIR}/patches/arago-am33x/0011-usb-defconfig-enable-file_storage-gadget-as-module.patch"
git am "${DIR}/patches/arago-am33x/0012-pwm-Correct-the-request-SYSFS-interface.patch"
git am "${DIR}/patches/arago-am33x/0013-pwm-fix-division-by-zero-error.patch"
git am "${DIR}/patches/arago-am33x/0014-pwm-corrects-return-values-to-handle-error-situation.patch"
git am "${DIR}/patches/arago-am33x/0015-pwm-ehrpwm-Fix-duty-cycle-inversion-eHRPWM-wave.patch"
#git am "${DIR}/patches/arago-am33x/0016-arm-omap-am335x-Correct-interrupt-signal-for-TSC.patch"
#git am "${DIR}/patches/arago-am33x/0017-arm-omap-am335x-Use-hwmod-data-to-register-TSC.patch"
#git am "${DIR}/patches/arago-am33x/0018-arm-omap-am335x-Add-ick-data-in-Hwmod-for-TSC.patch"
#git am "${DIR}/patches/arago-am33x/0019-input-TSC-Add-suspend-resume-feature-for-TSC.patch"
git am "${DIR}/patches/arago-am33x/0020-ARM-OMAP2-am33xx-fix-serial-mux-warnings-for-am33xx.patch"
git am "${DIR}/patches/arago-am33x/0021-ARM-OMAP2-am335x-Add-method-to-read-config-data-from.patch"
git am "${DIR}/patches/arago-am33x/0022-ARM-OMAP2-am335x-correct-McASP0-pin-mux-detail.patch"
git am "${DIR}/patches/arago-am33x/0023-ARM-OMAP2-edma-fix-coding-style-issue-related-to-bre.patch"
git am "${DIR}/patches/arago-am33x/0024-ARM-OMAP2-edma-clear-interrupt-status-for-interrupt-.patch"
git am "${DIR}/patches/arago-am33x/0025-ARM-OMAP2-edma-clear-events-in-edma_start.patch"

git am "${DIR}/patches/arago-am33x/0026-ARM-OMAP4-Remove-hardcoded-reg-offs-for-PWRSTCTRL-PW.patch"
git am "${DIR}/patches/arago-am33x/0027-ARM-OMAP4-prminst-Add-boot-time-__init-function-for-.patch"
git am "${DIR}/patches/arago-am33x/0028-ARM-OMAP-am33xx-Hook-up-am33xx-support-to-existing-p.patch"
git am "${DIR}/patches/arago-am33x/0029-ARM-OMAP4-cminst-Add-boot-time-__init-function-for-c.patch"
git am "${DIR}/patches/arago-am33x/0030-ARM-OMAP-am33xx-Hook-up-am33xx-support-to-existing-c.patch"
git am "${DIR}/patches/arago-am33x/0031-ARM-OMAP3-voltagedomainsam33xx_data-Remove-unnecessa.patch"
git am "${DIR}/patches/arago-am33x/0032-ARM-OMAP3-prmam33xx-Merge-upstream-changes.patch"
git am "${DIR}/patches/arago-am33x/0033-ARM-OMAP3-cminstam33xx-Merge-upstream-changes.patch"
git am "${DIR}/patches/arago-am33x/0034-ARM-OMAP2-Makefile-Remove-build-rule-for-deleted-fil.patch"

git am "${DIR}/patches/arago-am33x/0035-ARM-OMAP3-am33xx_hwmod-Merge-upstream-changes-merge.patch"
git am "${DIR}/patches/arago-am33x/0036-ARM-OMAP2-control-Add-missing-defination-for-AM33XX_.patch"
git am "${DIR}/patches/arago-am33x/0037-ARM-OMAP3-am33xx_hwmod-Do-not-idle-reset-debugss-mod.patch"

git am "${DIR}/patches/arago-am33x/0038-ARM-OMAP2-am33xx-Register-LCD-device-via-HWMOD-data-merge.patch"
git am "${DIR}/patches/arago-am33x/0039-video-da8xx-fb-rely-on-pm_runtime-API-for-clock-oper.patch"

git am "${DIR}/patches/bone-merge/0001-bone-arago-angstrom-merge.patch"
}

function am33x-meta-ti {
echo "[git] am33x-meta-ti"

git pull git://github.com/RobertCNelson/linux.git ti_am33x_v3.2-staging_psp0

git am "${DIR}/patches/arago-am33x/0001-arm-omap-am33xx-add-missing-i2c-pin-mus-details.patch"
git am "${DIR}/patches/arago-am33x/0002-arm-omap-am33xx-add-i2c2-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0003-arm-omap-am33xx-register-i2c2-for-beaglebone.patch"
git am "${DIR}/patches/arago-am33x/0004-arm-omap-am33xx-update-TSC-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0005-ARM-OMAP-AM33XX-Keep-the-CLKDIV32K-module-enabled.patch"
git am "${DIR}/patches/arago-am33x/0006-arm-omap-am33xx-Check-device-features.patch"
git am "${DIR}/patches/arago-am33x/0007-arm-omap-am33xx-Register-SGX-device.patch"
git am "${DIR}/patches/arago-am33x/0008-Revert-usb-musb_gadget-cppi41-Use-pio-for-interrupt-.patch"
git am "${DIR}/patches/arago-am33x/0009-usb-musb-cppi41-fall-back-to-pio-for-interrupt-based.patch"
git am "${DIR}/patches/arago-am33x/0010-usb-musb-Let-PIO-option-visible-in-menuconfig.patch"
git am "${DIR}/patches/arago-am33x/0011-usb-defconfig-enable-file_storage-gadget-as-module.patch"
git am "${DIR}/patches/arago-am33x/0012-pwm-Correct-the-request-SYSFS-interface.patch"
git am "${DIR}/patches/arago-am33x/0013-pwm-fix-division-by-zero-error.patch"
git am "${DIR}/patches/arago-am33x/0014-pwm-corrects-return-values-to-handle-error-situation.patch"
git am "${DIR}/patches/arago-am33x/0015-pwm-ehrpwm-Fix-duty-cycle-inversion-eHRPWM-wave.patch"

git am "${DIR}/patches/arago-am33x/0020-ARM-OMAP2-am33xx-fix-serial-mux-warnings-for-am33xx.patch"
git am "${DIR}/patches/arago-am33x/0022-ARM-OMAP2-am335x-correct-McASP0-pin-mux-detail.patch"

#angstrom
#BRANCH = "v3.2-staging"
#SRCREV = "09e9651bcf2ee8d86685f2a8075bc6557b1d3b91"

git am "${DIR}/patches/meta-ti/0002-f_rndis-HACK-around-undefined-variables.patch"
git am "${DIR}/patches/meta-ti/0003-da8xx-fb-add-DVI-support-for-beaglebone.patch"
git am "${DIR}/patches/meta-ti/0004-beaglebone-rebase-everything-onto-3.2-WARNING-MEGAPA.patch"
git am "${DIR}/patches/meta-ti/0005-more-beaglebone-merges.patch"
git am "${DIR}/patches/meta-ti/0006-beaglebone-disable-tsadc.patch"
git am "${DIR}/patches/meta-ti/0007-tscadc-Add-general-purpose-mode-untested-with-touchs.patch"
git am "${DIR}/patches/meta-ti/0008-tscadc-Add-board-file-mfd-support-fix-warning.patch"
git am "${DIR}/patches/meta-ti/0009-AM335X-init-tsc-bone-style-for-new-boards.patch"
git am "${DIR}/patches/meta-ti/0010-tscadc-make-stepconfig-channel-configurable.patch"
git am "${DIR}/patches/meta-ti/0011-tscadc-Trigger-through-sysfs.patch"
git am "${DIR}/patches/meta-ti/0012-meta-ti-Remove-debug-messages-for-meta-ti.patch"
git am "${DIR}/patches/meta-ti/0013-tscadc-switch-to-polling-instead-of-interrupts.patch"
git am "${DIR}/patches/meta-ti/0014-beaglebone-fix-ADC-init.patch"
git am "${DIR}/patches/meta-ti/0015-AM335x-MUX-add-ehrpwm1A.patch"
git am "${DIR}/patches/meta-ti/0016-beaglebone-enable-PWM-for-lcd-backlight-backlight-is.patch"
git am "${DIR}/patches/meta-ti/0017-omap_hsmmc-Set-dto-to-max-value-of-14-to-avoid-SD-Ca.patch"
git am "${DIR}/patches/meta-ti/0018-beaglebone-set-default-brightness-to-50-for-pwm-back.patch"
git am "${DIR}/patches/meta-ti/0019-st7735fb-WIP-framebuffer-driver-supporting-Adafruit-.patch"
git am "${DIR}/patches/meta-ti/0020-beaglebone-use-P8_6-gpio1_3-as-w1-bus.patch"
git am "${DIR}/patches/meta-ti/0021-beaglebone-add-support-for-Towertech-TT3201-CAN-cape.patch"

#these are already in the argo tree
#git am "${DIR}/patches/meta-ti/0022-ARM-OMAP2-am33xx-fix-serial-mux-warnings-for-am33xx.patch"
#git am "${DIR}/patches/meta-ti/0023-ARM-OMAP2-am335x-correct-McASP0-pin-mux-detail.patch"

}

function am33x {
#Pure: http://arago-project.org/git/projects/?p=linux-am33x.git;a=shortlog;h=refs/heads/v3.2-staging
echo "[git] am33x"
git pull git://github.com/RobertCNelson/linux.git ti_am33x_v3.2-staging_psp0

git am "${DIR}/patches/arago-am33x/0001-arm-omap-am33xx-add-missing-i2c-pin-mus-details.patch"
git am "${DIR}/patches/arago-am33x/0002-arm-omap-am33xx-add-i2c2-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0003-arm-omap-am33xx-register-i2c2-for-beaglebone.patch"
git am "${DIR}/patches/arago-am33x/0004-arm-omap-am33xx-update-TSC-hwmod-data.patch"
git am "${DIR}/patches/arago-am33x/0005-ARM-OMAP-AM33XX-Keep-the-CLKDIV32K-module-enabled.patch"
git am "${DIR}/patches/arago-am33x/0006-arm-omap-am33xx-Check-device-features.patch"
git am "${DIR}/patches/arago-am33x/0007-arm-omap-am33xx-Register-SGX-device.patch"
git am "${DIR}/patches/arago-am33x/0008-Revert-usb-musb_gadget-cppi41-Use-pio-for-interrupt-.patch"
git am "${DIR}/patches/arago-am33x/0009-usb-musb-cppi41-fall-back-to-pio-for-interrupt-based.patch"
git am "${DIR}/patches/arago-am33x/0010-usb-musb-Let-PIO-option-visible-in-menuconfig.patch"
git am "${DIR}/patches/arago-am33x/0011-usb-defconfig-enable-file_storage-gadget-as-module.patch"
git am "${DIR}/patches/arago-am33x/0012-pwm-Correct-the-request-SYSFS-interface.patch"
git am "${DIR}/patches/arago-am33x/0013-pwm-fix-division-by-zero-error.patch"
git am "${DIR}/patches/arago-am33x/0014-pwm-corrects-return-values-to-handle-error-situation.patch"
git am "${DIR}/patches/arago-am33x/0015-pwm-ehrpwm-Fix-duty-cycle-inversion-eHRPWM-wave.patch"
git am "${DIR}/patches/arago-am33x/0016-arm-omap-am335x-Correct-interrupt-signal-for-TSC.patch"
git am "${DIR}/patches/arago-am33x/0017-arm-omap-am335x-Use-hwmod-data-to-register-TSC.patch"
git am "${DIR}/patches/arago-am33x/0018-arm-omap-am335x-Add-ick-data-in-Hwmod-for-TSC.patch"
git am "${DIR}/patches/arago-am33x/0019-input-TSC-Add-suspend-resume-feature-for-TSC.patch"
git am "${DIR}/patches/arago-am33x/0020-ARM-OMAP2-am33xx-fix-serial-mux-warnings-for-am33xx.patch"
git am "${DIR}/patches/arago-am33x/0021-ARM-OMAP2-am335x-Add-method-to-read-config-data-from.patch"
git am "${DIR}/patches/arago-am33x/0022-ARM-OMAP2-am335x-correct-McASP0-pin-mux-detail.patch"
git am "${DIR}/patches/arago-am33x/0023-ARM-OMAP2-edma-fix-coding-style-issue-related-to-bre.patch"
git am "${DIR}/patches/arago-am33x/0024-ARM-OMAP2-edma-clear-interrupt-status-for-interrupt-.patch"
git am "${DIR}/patches/arago-am33x/0025-ARM-OMAP2-edma-clear-events-in-edma_start.patch"
git am "${DIR}/patches/arago-am33x/0026-ARM-OMAP4-Remove-hardcoded-reg-offs-for-PWRSTCTRL-PW.patch"
git am "${DIR}/patches/arago-am33x/0027-ARM-OMAP4-prminst-Add-boot-time-__init-function-for-.patch"
git am "${DIR}/patches/arago-am33x/0028-ARM-OMAP-am33xx-Hook-up-am33xx-support-to-existing-p.patch"
git am "${DIR}/patches/arago-am33x/0029-ARM-OMAP4-cminst-Add-boot-time-__init-function-for-c.patch"
git am "${DIR}/patches/arago-am33x/0030-ARM-OMAP-am33xx-Hook-up-am33xx-support-to-existing-c.patch"
git am "${DIR}/patches/arago-am33x/0031-ARM-OMAP3-voltagedomainsam33xx_data-Remove-unnecessa.patch"
git am "${DIR}/patches/arago-am33x/0032-ARM-OMAP3-prmam33xx-Merge-upstream-changes.patch"
git am "${DIR}/patches/arago-am33x/0033-ARM-OMAP3-cminstam33xx-Merge-upstream-changes.patch"
git am "${DIR}/patches/arago-am33x/0034-ARM-OMAP2-Makefile-Remove-build-rule-for-deleted-fil.patch"
git am "${DIR}/patches/arago-am33x/0035-ARM-OMAP3-am33xx_hwmod-Merge-upstream-changes.patch"
git am "${DIR}/patches/arago-am33x/0036-ARM-OMAP2-control-Add-missing-defination-for-AM33XX_.patch"
git am "${DIR}/patches/arago-am33x/0037-ARM-OMAP3-am33xx_hwmod-Do-not-idle-reset-debugss-mod.patch"
git am "${DIR}/patches/arago-am33x/0038-ARM-OMAP2-am33xx-Register-LCD-device-via-HWMOD-data.patch"
git am "${DIR}/patches/arago-am33x/0039-video-da8xx-fb-rely-on-pm_runtime-API-for-clock-oper.patch"
git am "${DIR}/patches/arago-am33x/0040-video-da8xx-fb-save-and-restore-LCDC-context-on-powe.patch"
git am "${DIR}/patches/arago-am33x/0041-ARM-OMAP2-edma-correct-edma-HWMOD-data.patch"
git am "${DIR}/patches/arago-am33x/0042-ARM-OMAP2-edma-move-edma-clock-setup-to-edma-driver.patch"
git am "${DIR}/patches/arago-am33x/0043-ARM-OMAP2-edma-add-support-for-suspend-resume.patch"
git am "${DIR}/patches/arago-am33x/0044-ARM-OMAP2-edma-use-omap_device-api-for-registration.patch"
git am "${DIR}/patches/arago-am33x/0045-ARM-OMAP2-edma-use-runtime-PM.patch"
git am "${DIR}/patches/arago-am33x/0046-ARM-OMAP-AM335X-evm-remove-default-initialization.patch"
git am "${DIR}/patches/arago-am33x/0047-ARM-OMAP-AM33XX-Cleanup-usb-hwmod.patch"
git am "${DIR}/patches/arago-am33x/0048-usb-musb-ti81xx-use-runtime-pm-API-for-clock.patch"
git am "${DIR}/patches/arago-am33x/0049-usb-musb-host-release-dma-channels-if-no-active-io.patch"
git am "${DIR}/patches/arago-am33x/0050-usb-musb-replace-__raw_read-writel-by-readl-write.patch"
git am "${DIR}/patches/arago-am33x/0051-usb-musb-ti81xx-add-support-for-save-and-restore.patch"
git am "${DIR}/patches/arago-am33x/0052-usb-musb-ti81xx-save-and-restore-DMA-registers.patch"
git am "${DIR}/patches/arago-am33x/0053-ARM-OMAP3-am33xx_hwmod-Correct-the-usb-clkdm_name.patch"
git am "${DIR}/patches/arago-am33x/0054-ARM-OMAP3-am33xx_clkdomain-Remove-usb-clkdomain-entr.patch"
git am "${DIR}/patches/arago-am33x/0055-usb-musb-cppi41dma-use-transparent-mode-for-g_mass_s.patch"
git am "${DIR}/patches/arago-am33x/0056-usb-musb-pm-turn-on-off-timers-during-suspend-resume.patch"
git am "${DIR}/patches/arago-am33x/0057-ARM-OMAP2-HSMMC-fix-the-platform-setup-for-am335x.patch"
git am "${DIR}/patches/arago-am33x/0058-ARM-OMAP2-I2C-hwmod-set-flag-to-restore-context.patch"
git am "${DIR}/patches/arago-am33x/0059-ARM-OMAP-AM33XX-CAN-d_can-Add-hwmod-data-for-am33xx-.patch"
git am "${DIR}/patches/arago-am33x/0060-ARM-OMAP-AM33XX-CAN-d_can-Platform-data-clean-up.patch"
git am "${DIR}/patches/arago-am33x/0061-ARM-OMAP-AM33XX-CAN-d_can-Add-pm-runtime-support.patch"
git am "${DIR}/patches/arago-am33x/0062-ARM-OMAP-AM33XX-CAN-d_can-fix-DCAN-raminit-issue.patch"
git am "${DIR}/patches/arago-am33x/0063-ARM-OMAP-AM33XX-CAN-d_can-Add-suspend-resume-support.patch"
}

bugs_trivial

#patches in git

#just a pure arago tree:
#am33x

#koens patchset for comparsion..
#am33x-meta-ti

#shipping:
am33x-cleanup

echo "patch.sh ran successful"

