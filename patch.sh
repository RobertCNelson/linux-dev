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
	${git} "${DIR}/patches/arm/0001-builddeb-just-use-armhf-at-this-point.patch"
}

drivers () {
	echo "dir: drivers"
	${git} "${DIR}/patches/drivers/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
}

imx_next () {
	echo "dir: imx_next"
	#With all the imx6*.dtsi changes, its eaiser to just pull the for-next then try to manually rebase
	#https://git.linaro.org/gitweb?p=people/shawnguo/linux-2.6.git;a=shortlog;h=refs/heads/for-next
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.12/dts
	${git} "${DIR}/patches/omap_next/0001-ARM-dts-omap3-beagle-xm-fix-string-error-in-compatib.patch"
	${git} "${DIR}/patches/omap_next/0002-ARM-dts-N900-Add-device-tree.patch"
	${git} "${DIR}/patches/omap_next/0003-ARM-dts-omap3-igep-add-pinmux-node-for-GPIO-LED-conf.patch"
	${git} "${DIR}/patches/omap_next/0004-ARM-dts-omap3-igep0020-add-mux-conf-for-GPIO-LEDs.patch"
	${git} "${DIR}/patches/omap_next/0005-ARM-dts-omap3-igep0030-add-mux-conf-for-GPIO-LED.patch"
	${git} "${DIR}/patches/omap_next/0006-ARM-dts-AM33XX-Add-PMU-support.patch"
	${git} "${DIR}/patches/omap_next/0007-ARM-dts-AM33xx-Correct-gpio-interrupt-cells-property.patch"
	${git} "${DIR}/patches/omap_next/0008-ARM-dts-omap5-uevm-Split-SMPS10-in-two-nodes.patch"
	${git} "${DIR}/patches/omap_next/0009-ARM-dts-Remove-0x-s-from-OMAP2420-H4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0010-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0020-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0011-ARM-dts-Remove-0x-s-from-OMAP3-IGEP0030-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0012-ARM-dts-Remove-0x-s-from-OMAP3-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0013-ARM-dts-Remove-0x-s-from-OMAP3430-SDP-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0014-ARM-dts-Remove-0x-s-from-OMAP4-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0015-ARM-dts-Remove-0x-s-from-OMAP5-DTS-file.patch"
	${git} "${DIR}/patches/omap_next/0016-ARM-dts-twl6030-Move-common-configuration-for-OMAP4-.patch"
	${git} "${DIR}/patches/omap_next/0017-ARM-dts-omap4-var-som-configure-connection-to-PMIC-o.patch"
}

imx () {
	echo "dir: imx"
}

omap_usb () {
	echo "dir: omap_usb"
	${git} "${DIR}/patches/omap_usb/0001-usb-phy-generic-Add-gpio_reset-to-platform-data.patch"
	${git} "${DIR}/patches/omap_usb/0002-usb-phy-generic-Don-t-use-regulator-framework-for-RE.patch"
	${git} "${DIR}/patches/omap_usb/0003-ARM-OMAP2-omap-usb-host-Get-rid-of-platform_data-fro.patch"
	${git} "${DIR}/patches/omap_usb/0004-ARM-OMAP2-usb-host-Adapt-to-USB-phy-nop-RESET-line-c.patch"
	${git} "${DIR}/patches/omap_usb/0005-ARM-dts-omap3-beagle-Use-reset-gpios-for-hsusb2_rese.patch"
	${git} "${DIR}/patches/omap_usb/0006-ARM-dts-omap4-panda-Use-reset-gpios-for-hsusb1_reset.patch"
	${git} "${DIR}/patches/omap_usb/0007-ARM-dts-omap5-uevm-Use-reset-gpios-for-hsusb2_reset.patch"
	${git} "${DIR}/patches/omap_usb/0008-ARM-dts-omap3-beagle-Make-USB-host-pin-naming-consis.patch"
	${git} "${DIR}/patches/omap_usb/0009-ARM-dts-omap3-beagle-xm-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/omap_usb/0010-ARM-dts-omap3-beagle-Add-USB-OTG-PHY-details.patch"
	${git} "${DIR}/patches/omap_usb/0011-hack-beagle-xm-NOP_USB_XCEIV-still-has-to-be-a-modul.patch"
}

omap_video () {
	echo "dir: omap_video"
	${git} "${DIR}/patches/omap_video/0001-dts-omap3-beagle-add-i2c2-i2c3.patch"
	${git} "${DIR}/patches/omap_video/0002-hack-beagle_xm-like-omap4-use-the-dss-common-transit.patch"
}

omap_clock () {
	echo "dir: omap_clock"
	#TI omap dts clock bindings driver
	${git} "${DIR}/patches/omap_clock/0001-Added-the-Texas-Instruments-OMAP-Clock-driver-origin.patch"

	#omap3: add device tree clock binding support
	${git} "${DIR}/patches/omap_clock/0002-Add-the-clock-bindings-to-omap3.dtsi-that-were-made-.patch"

	#omap: use cpu0-cpufreq SoC generic driver if performing dts boot, use old method if non dts
	${git} "${DIR}/patches/omap_clock/0003-Use-cpu0-cpufreq-in-a-device-tree-supported-boot.-Th.patch"

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
	${git} "${DIR}/patches/dts/0004-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c3.patch"
	${git} "${DIR}/patches/dts/0005-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0006-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

imx_video () {
	echo "dir: imx_video"
	#total wip...
	${git} "${DIR}/patches/imx_video/0001-imx-video-staging-Add-HDMI-support-to-imx-drm-driver.patch"
	${git} "${DIR}/patches/imx_video/0002-imx-enable-hdmi-video-for-imx6q-sabrelite-imx6q-sabr.patch"
}

imx_audio () {
	echo "dir: imx_audio"
	${git} "${DIR}/patches/imx_audio/0001-ARM-imx6qdl-wandboard-Add-spdif-support.patch"
}

omap3_beagle_xm_rework () {
	echo "dir: omap3_beagle_xm_rework"
	#Still needs: CONFIG_NOP_USB_XCEIV=m but ehci works
	#cp omap3-beagle-xm.dts omap3-beagle-xm-c.dts
	#cp omap3-beagle-xm.dts omap3-beagle-xm-ab.dts
	#edit Makefile add ^
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0001-ARM-dts-split-omap3-beagle-xm-to-ab-and-c-variant.patch"
	#xm-ab has active high usb host power on...
	${git} "${DIR}/patches/omap3_beagle_xm_rework/0002-ARM-dts-omap3-beagle-xm-ab-usb-host-is-active-high-t.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	# Apply the modified sprz319 erratum for the v3.11-rc2 kernel
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
}

arm
drivers
imx_next
omap_next
imx
omap_usb
omap_video
omap_clock
omap_board

dts
imx_video
imx_audio
omap3_beagle_xm_rework
omap_sprz319_erratum

saucy

echo "patch.sh ran successful"
