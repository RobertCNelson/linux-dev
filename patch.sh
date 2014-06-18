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

	${git} "${DIR}/patches/omap_next/0001-ARM-OMAP2-hwmod-Change-hardreset-soc_ops-for-AM43XX.patch"
	${git} "${DIR}/patches/omap_next/0002-ARM-OMAP5-hwmod-Add-ocp2scp3-and-sata-hwmods.patch"
	${git} "${DIR}/patches/omap_next/0003-ARM-dts-Enable-twl4030-off-idle-configuration-for-se.patch"
	${git} "${DIR}/patches/omap_next/0004-ARM-DRA722-add-detection-of-SoC-information.patch"
	${git} "${DIR}/patches/omap_next/0005-ARM-dts-omap5-Update-CPU-OPP-table-as-per-final-prod.patch"
	${git} "${DIR}/patches/omap_next/0006-ARM-dts-am43x-epos-evm-Add-Missing-cpsw-phy-sel-for-.patch"
	${git} "${DIR}/patches/omap_next/0007-ARM-OMAP2-drop-unused-function.patch"
	${git} "${DIR}/patches/omap_next/0008-ARM-DTS-dra7-dra7xx-clocks-ATL-related-changes.patch"
	${git} "${DIR}/patches/omap_next/0009-ARM-OMAP2-Fix-parser-bug-in-platform-muxing-code.patch"
	${git} "${DIR}/patches/omap_next/0010-ARM-dts-dra7-evm-remove-interrupt-binding.patch"
}

tegra_next () {
	echo "dir: tegra_next"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tegra/linux.git/log/?h=for-next
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git for-next
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-ARM-dts-imx6qdl-wandboard-add-gpio-lines-to-wandboar.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-imx6qdl-wandboard-add-bluetooth-control-line.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

	${git} "${DIR}/patches/dts/0004-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0005-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0006-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0007-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"

	${git} "${DIR}/patches/dts/0008-ARM-dts-omap3-beagle-add-i2c2.patch"

	${git} "${DIR}/patches/dts/0009-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
	${git} "${DIR}/patches/dts/0010-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0011-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"

	${git} "${DIR}/patches/dts/0012-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
	${git} "${DIR}/patches/dts/0013-arm-dts-add-imx6dl-udoo.patch"
	${git} "${DIR}/patches/dts/0014-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/dts/0015-ARM-dts-imx6dl-udoo-Add-HDMI-support.patch"
	${git} "${DIR}/patches/dts/0016-ARM-dts-imx6q-udoo-Add-USB-Host-support.patch"
	${git} "${DIR}/patches/dts/0017-ARM-dts-imx6dl-udoo-Add-USB-Host-support.patch"
}

omap_sprz319_erratum () {
	echo "dir: omap_sprz319_erratum"
	${git} "${DIR}/patches/omap_sprz319_erratum_v2.1/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
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

	#v3.14.x+
	${git} "${DIR}/patches/vivante/0004-Fixed-vivante-driver-for-kernel-3.14.x.patch"
}

#revert
drivers
#imx_next
omap_next
#tegra_next

dts
omap_sprz319_erratum

fixes
vivante

echo "patch.sh ran successful"
