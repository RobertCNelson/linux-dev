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

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

drivers () {
	echo "dir: drivers"
	${git} "${DIR}/patches/drivers/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_next () {
	echo "dir: imx_next"
	#From: https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=shortlog;h=refs/heads/for-next
	#git pull --no-edit git://git.linaro.org/people/shawnguo/linux-2.6.git for-next
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.13/dts
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git for_3.13/dts
}

omap_dt_dss () {
	echo "dir: omap_dt_dss"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tomba/linux.git/log/?h=work/dss-dt

#	${git} "${DIR}/patches/omap_dt_dss/0001-ARM-OMAP-remove-DSS-DT-hack.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0002-OMAPDSS-remove-DT-hacks-for-regulators.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0003-ARM-OMAP2-add-omapdss_init_of.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0004-OMAPDSS-if-dssdev-name-NULL-use-alias.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0005-OMAPDSS-get-dssdev-alias-from-DT-alias.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0006-OMAPFB-clean-up-default-display-search.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0007-OMAPFB-search-for-default-display-with-DT-alias.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0008-OMAPDSS-Add-DT-support-to-DSS-DISPC-DPI-HDMI-VENC.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0009-OMAPDSS-Add-DT-support-to-DSI.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0010-ARM-omap3.dtsi-add-omapdss-information.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0011-ARM-omap4.dtsi-add-omapdss-information.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0012-ARM-omap4-panda.dts-add-display-information.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0013-ARM-omap4-sdp.dts-add-display-information.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0014-ARM-omap3-tobi.dts-add-lcd-TEST.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0015-ARM-omap3-beagle.dts-add-display-information.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0016-OMAPDSS-panel-dsi-cm-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0017-OMAPDSS-encoder-tfp410-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0018-OMAPDSS-connector-dvi-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0019-OMAPDSS-encoder-tpd12s015-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0020-OMAPDSS-hdmi-connector-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0021-OMAPDSS-panel-dpi-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0022-OMAPDSS-connector-analog-tv-Add-DT-support.patch"
#	${git} "${DIR}/patches/omap_dt_dss/0023-test-ARM-omap3-beagle-xm.dts-add-display-information.patch"
}

imx () {
	echo "dir: imx"
}

omap_usb () {
	echo "dir: omap_usb"
	${git} "${DIR}/patches/omap_usb/0001-omap3-beagle-xm-enable-HubPower.patch"
}

omap_video () {
	echo "dir: omap_video"
	${git} "${DIR}/patches/omap_video/0001-dts-omap3-beagle-add-i2c2-i2c3.patch"
}

omap_clock () {
	echo "dir: omap_clock"
	#TI omap dts clock bindings driver
	${git} "${DIR}/patches/omap_clock/0001-Added-the-Texas-Instruments-OMAP-Clock-driver-origin.patch"

	#omap3: add device tree clock binding support
	${git} "${DIR}/patches/omap_clock/0002-Add-the-clock-bindings-to-omap3.dtsi-that-were-made-.patch"

	#omap: use cpu0-cpufreq SoC generic driver if performing dts boot, use old method if non dts
#	${git} "${DIR}/patches/omap_clock/0003-Use-cpu0-cpufreq-in-a-device-tree-supported-boot.-Th.patch"

	#beagleboard-xm: add abb bindings and OPP1G operating point for 1 GHz operation
	${git} "${DIR}/patches/omap_clock/0004-Now-this-one-is-mine-lol.-Reading-through-the-ti-abb.patch"
}

omap_board () {
	echo "dir: omap_board"
	#Note: the plan is to move to device tree, so these will be dropped at some point..
	#omap3430: lockup on reset fix...
	${git} "${DIR}/patches/omap_board/0001-omap2-twl-common-Add-default-power-configuration.patch"
	${git} "${DIR}/patches/omap_board/0002-ARM-OMAP-Beagle-use-TWL4030-generic-reset-script.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0005-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

imx_video_staging () {
	echo "dir: imx_video_staging"
	${git} "${DIR}/patches/imx_video_staging/0001-imx-drm-Add-mx6-hdmi-transmitter-support.patch"
#	${git} "${DIR}/patches/imx_video_staging/0002-imx-drm-ipuv3-crtc-Invert-IPU-DI0-clock-polarity.patch"
	${git} "${DIR}/patches/imx_video_staging/0003-ARM-dts-mx6qdl-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0004-ARM-dts-imx6qdl-wandboard-Add-HDMI-support.patch"
	${git} "${DIR}/patches/imx_video_staging/0005-imx-enable-hdmi-video-for-imx6q-sabrelite-imx6q-sabr.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-c.dts
	#cp arch/arm/boot/dts/omap3-beagle-xm.dts arch/arm/boot/dts/omap3-beagle-xm-ab.dts
	#gedit arch/arm/boot/dts/Makefile add ^
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-split-omap3-beagle-xm-to-ab-and-c-variant.patch"
	#xm-ab has active high usb host power on...
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab-usb-host-is-active-high-t.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
#	${git} "${DIR}/patches/fixes/0002-cpufreq-OMAP-Fix-compilation-error-r-ret-undeclared.patch"
}

saucy () {
	echo "dir: saucy"
	#need to be re-tested with v3.13-rcX
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

arm
drivers
imx_next
omap_next
omap_dt_dss
imx
omap_usb
omap_video
omap_clock
omap_board

dts
imx_video_staging
omap3_beagle_xm_rework
omap_sprz319_erratum
fixes

#saucy

echo "patch.sh ran successful"
