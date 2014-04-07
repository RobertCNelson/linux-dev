#!/bin/sh
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
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

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

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
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

clock () {
	echo "dir: clock"
#	${git} "${DIR}/patches/clock/0001-clk-ti-am335x-remove-unecessary-cpu0-clk-node.patch"
#	${git} "${DIR}/patches/clock/0002-ARM-dts-OMAP3-add-clock-nodes-for-CPU.patch"

#	${git} "${DIR}/patches/clock/0003-ARM-dts-OMAP36xx-Add-device-node-for-ABB.patch"
#	${git} "${DIR}/patches/clock/0004-ARM-dts-OMAP4-Add-device-nodes-for-ABB.patch"
#	${git} "${DIR}/patches/clock/0005-ARM-dts-OMAP5-Add-device-nodes-for-ABB.patch"
#	${git} "${DIR}/patches/clock/0006-ARM-dts-DRA7-Add-device-nodes-for-ABB.patch"

	#wip:
	${git} "${DIR}/patches/clock/0007-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
}

usb () {
	echo "dir: usb"
	${git} "${DIR}/patches/usb/0001-mfd-omap-usb-host-Use-resource-managed-clk_get.patch"
	${git} "${DIR}/patches/usb/0002-mfd-omap-usb-host-Get-clocks-based-on-hardware-revis.patch"
	${git} "${DIR}/patches/usb/0003-mfd-omap-usb-host-Use-clock-names-as-per-function-fo.patch"
	${git} "${DIR}/patches/usb/0004-mfd-omap-usb-host-Update-DT-clock-binding-informatio.patch"
	${git} "${DIR}/patches/usb/0005-mfd-omap-usb-tll-Update-DT-clock-binding-information.patch"
	${git} "${DIR}/patches/usb/0006-ARM-dts-omap4-Update-omap-usb-host-node.patch"
	${git} "${DIR}/patches/usb/0007-ARM-dts-omap5-Update-omap-usb-host-node.patch"
	${git} "${DIR}/patches/usb/0008-ARM-dts-omap4-panda-Provide-USB-PHY-clock.patch"
	${git} "${DIR}/patches/usb/0009-ARM-dts-omap5-uevm-Provide-USB-PHY-clock.patch"
	${git} "${DIR}/patches/usb/0010-ARM-OMAP2-Remove-legacy_init_ehci_clk.patch"
	${git} "${DIR}/patches/usb/0011-ARM-dts-OMAP2-Get-rid-of-incompatible-ids-for-USB-ho.patch"
	${git} "${DIR}/patches/usb/0012-usb-omap-dts-Update-DT-binding-example-usage.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

	${git} "${DIR}/patches/dts/0005-ARM-dts-omap3-beagle-add-i2c2.patch"

	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0008-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0009-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0011-hack-wand-enable-hdmi.patch"
	${git} "${DIR}/patches/dts/0012-arm-dts-vf610-twr-Add-support-for-sdhc1.patch"
}

imx_drm () {
	echo "dir: imx_drm"

	${git} "${DIR}/patches/imx_drm/0001-imx-drm-imx-hdmi-convert-HDMI-clock-settings-to-tabu.patch"
	${git} "${DIR}/patches/imx_drm/0002-imx-drm-imx-hdmi-clean-up-setting-CSC-registers.patch"
	${git} "${DIR}/patches/imx_drm/0003-imx-drm-imx-hdmi-provide-register-modification-funct.patch"
	${git} "${DIR}/patches/imx_drm/0004-imx-drm-imx-hdmi-clean-up-setting-of-vp_conf.patch"
	${git} "${DIR}/patches/imx_drm/0005-imx-drm-imx-hdmi-fix-CTS-N-setup-at-init-time.patch"
	${git} "${DIR}/patches/imx_drm/0006-imx-drm-ipu-v3-more-inteligent-DI-clock-selection.patch"
	${git} "${DIR}/patches/imx_drm/0007-imx-drm-ipu-v3-don-t-use-clk_round_rate-before-clk_s.patch"
	${git} "${DIR}/patches/imx_drm/0008-imx-drm-ipu-v3-more-clocking-fixes.patch"
	${git} "${DIR}/patches/imx_drm/0009-imx-drm-add-imx6-DT-configuration-for-HDMI.patch"
	${git} "${DIR}/patches/imx_drm/0010-imx-drm-update-and-fix-imx6-DT-descriptions-for-v3-H.patch"
	${git} "${DIR}/patches/imx_drm/0011-imx-drm-imx-drm-core-sanitise-imx_drm_encoder_get_mu.patch"
	${git} "${DIR}/patches/imx_drm/0012-imx-drm-imx-drm-core-use-array-instead-of-list-for-C.patch"
	${git} "${DIR}/patches/imx_drm/0013-imx-drm-provide-common-connector-mode-validation-fun.patch"
	${git} "${DIR}/patches/imx_drm/0014-imx-drm-simplify-setup-of-panel-format.patch"
	${git} "${DIR}/patches/imx_drm/0015-imx-drm-convert-to-componentised-device-support.patch"
	${git} "${DIR}/patches/imx_drm/0016-imx-drm-delay-publishing-sysfs-connector-entries.patch"
	${git} "${DIR}/patches/imx_drm/0017-imx-drm-remove-separate-imx-fbdev.patch"
	${git} "${DIR}/patches/imx_drm/0018-imx-drm-remove-imx-fb.c.patch"
	${git} "${DIR}/patches/imx_drm/0019-imx-drm-use-supplied-drm_device-where-possible.patch"
	${git} "${DIR}/patches/imx_drm/0020-imx-drm-imx-drm-core-provide-helper-function-to-pars.patch"
	${git} "${DIR}/patches/imx_drm/0021-imx-drm-imx-drm-core-provide-common-connector-and-en.patch"
	${git} "${DIR}/patches/imx_drm/0022-imx-drm-initialise-drm-components-directly.patch"
	${git} "${DIR}/patches/imx_drm/0023-imx-drm-imx-drm-core-remove-imx_drm_connector-and-im.patch"
	${git} "${DIR}/patches/imx_drm/0024-imx-drm-imx-drm-core-get-rid-of-drm_mode_group_init_.patch"
	${git} "${DIR}/patches/imx_drm/0025-imx-drm-imx-drm-core-kill-off-mutex.patch"
	${git} "${DIR}/patches/imx_drm/0026-imx-drm-imx-drm-core-move-allocation-of-imxdrm-devic.patch"
	${git} "${DIR}/patches/imx_drm/0027-imx-drm-imx-drm-core-various-cleanups.patch"
	${git} "${DIR}/patches/imx_drm/0028-imx-drm-imx-drm-core-add-core-hotplug-connector-supp.patch"
	${git} "${DIR}/patches/imx_drm/0029-imx-drm-imx-hdmi-add-hotplug-support-to-HDMI-compone.patch"
}

imx_drm_dts () {
	echo "dir: imx_drm_dts"
	${git} "${DIR}/patches/imx_drm_dts/0001-ARM-dts-imx6qdl-sabresd-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_drm_dts/0002-arm-dts-wandboard-enable-hdmi-quad-has-to-force-edid.patch"
}

imx_video_staging () {
	echo "dir: imx_video_staging"
	${git} "${DIR}/patches/imx_video_staging/0001-ARM-dts-mx6qdl-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0002-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	#${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-arch-omap3-add-xm-ab-variant.patch"

	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-ab.dts
#	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab.dtb-copy-from-omap3-beagl.patch"
#	${git} "${DIR}/patches/omap3_beagle_xm_rework/0003-ARM-dts-omap3-beagle-xm-ab.dtb-build.patch"
#	${git} "${DIR}/patches/omap3_beagle_xm_rework/0004-ARM-dts-omap3-beagle-xm-ab.dtb-invert-usb-host.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
#	${git} "${DIR}/patches/fixes/0002-fix-compilation-of-imx-hdmi.patch"
#	${git} "${DIR}/patches/fixes/0003-Makefile-extra.patch"
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
}

next () {
	echo "dir: next"

	${git} "${DIR}/patches/next/0001-clk-sunxi-factors-automatic-reparenting-support.patch"
	${git} "${DIR}/patches/next/0002-clk-sunxi-Implement-MMC-phase-control.patch"
	${git} "${DIR}/patches/next/0003-ARM-sunxi-clk-export-clk_sunxi_mmc_phase_control.patch"
	${git} "${DIR}/patches/next/0004-ARM-sunxi-Add-driver-for-SD-MMC-hosts-found-on-Allwi.patch"
	${git} "${DIR}/patches/next/0005-ARM-dts-sun7i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0006-ARM-dts-sun4i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0007-ARM-dts-sun5i-Add-support-for-mmc.patch"
	${git} "${DIR}/patches/next/0008-ARM-sunxi-Add-documentation-for-driver-for-SD-MMC-ho.patch"
	${git} "${DIR}/patches/next/0009-arm-dts-sun4i-a10-olinuxino-lime-enable-mmc0.patch"
}

saucy () {
	echo "dir: saucy"
	#need to be re-tested with v3.14-rcX
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

#revert
drivers
#imx_next
#omap_next

clock
#usb

dts

#imx_drm
#imx_drm_dts
#imx_video_staging
omap_sprz319_erratum

omap3_beagle_xm_rework

fixes
vivante
next
#saucy

echo "patch.sh ran successful"
