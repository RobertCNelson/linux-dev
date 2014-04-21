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

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-Add-support-for-i2c1.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0004-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
	${git} "${DIR}/patches/dts/0005-hack-wand-enable-hdmi.patch"

	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0008-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0009-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-add-i2c2.patch"

	${git} "${DIR}/patches/dts/0011-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
	${git} "${DIR}/patches/dts/0012-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0013-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
	${git} "${DIR}/patches/dts/0014-arch-omap3-add-xm-ab-variant.patch"

	${git} "${DIR}/patches/dts/0015-arm-dts-vf610-twr-Add-support-for-sdhc1.patch"
	${git} "${DIR}/patches/dts/0016-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-imx6q-work-around-fec-tx-queue-timeouts-when-SATA-SD.patch"
	${git} "${DIR}/patches/fixes/0002-arm-add-CLKSRC_OF.patch"
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

#revert
drivers
#imx_next
#omap_next

dts
omap_sprz319_erratum

fixes
vivante
next

echo "patch.sh ran successful"
