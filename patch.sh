#!/bin/sh
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/version.sh
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

git="git am"
#git_patchset=""
#git_opts

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

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
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
	#from: https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/

	${git} "${DIR}/patches/omap_next/0001-irqchip-crossbar-Dont-use-0-to-mark-reserved-interru.patch"
	${git} "${DIR}/patches/omap_next/0002-irqchip-crossbar-Check-for-premapped-crossbar-before.patch"
	${git} "${DIR}/patches/omap_next/0003-irqchip-crossbar-Introduce-ti-irqs-skip-to-skip-irqs.patch"
	${git} "${DIR}/patches/omap_next/0004-irqchip-crossbar-Initialise-the-crossbar-with-a-safe.patch"
	${git} "${DIR}/patches/omap_next/0005-irqchip-crossbar-Change-allocation-logic-by-reversin.patch"
	${git} "${DIR}/patches/omap_next/0006-irqchip-crossbar-Remove-IS_ERR_VALUE-check.patch"
	${git} "${DIR}/patches/omap_next/0007-irqchip-crossbar-Fix-sparse-and-checkpatch-warnings.patch"
	${git} "${DIR}/patches/omap_next/0008-irqchip-crossbar-Fix-kerneldoc-warning.patch"
	${git} "${DIR}/patches/omap_next/0009-irqchip-crossbar-Return-proper-error-value.patch"
	${git} "${DIR}/patches/omap_next/0010-irqchip-crossbar-Change-the-goto-naming.patch"
	${git} "${DIR}/patches/omap_next/0011-irqchip-crossbar-Set-cb-pointer-to-null-in-case-of-e.patch"
	${git} "${DIR}/patches/omap_next/0012-irqchip-crossbar-Add-kerneldoc-for-crossbar_domain_u.patch"
	${git} "${DIR}/patches/omap_next/0013-irqchip-crossbar-Introduce-ti-max-crossbar-sources-t.patch"
	${git} "${DIR}/patches/omap_next/0014-irqchip-crossbar-Introduce-centralized-check-for-cro.patch"
	${git} "${DIR}/patches/omap_next/0015-documentation-dt-omap-crossbar-Add-description-for-i.patch"
	${git} "${DIR}/patches/omap_next/0016-irqchip-crossbar-Allow-for-quirky-hardware-with-dire.patch"
	${git} "${DIR}/patches/omap_next/0017-ARM-dts-am4372-let-boards-access-all-nodes-through-l.patch"
	${git} "${DIR}/patches/omap_next/0018-ARM-dts-add-support-for-AM437x-StarterKit.patch"
	${git} "${DIR}/patches/omap_next/0019-ARM-OMAP2-convert-sys_ck-and-osc_ck-to-standard-cloc.patch"
	${git} "${DIR}/patches/omap_next/0020-ARM-dts-am335x-evmsk-enable-display-and-lcd-panel-su.patch"
	${git} "${DIR}/patches/omap_next/0021-ARM-OMAP2420-clock-get-rid-of-fixed-div-property-use.patch"
	${git} "${DIR}/patches/omap_next/0022-ARM-OMAP2-PRM-add-support-for-OMAP2-specific-clock-p.patch"
	${git} "${DIR}/patches/omap_next/0023-ARM-OMAP2-clock-use-DT-clock-boot-if-available.patch"
	${git} "${DIR}/patches/omap_next/0024-ARM-OMAP24xx-clock-remove-legacy-clock-data.patch"
	${git} "${DIR}/patches/omap_next/0025-ARM-dts-dra7-add-routable-irqs-property-for-gic-node.patch"
	${git} "${DIR}/patches/omap_next/0026-ARM-dts-dra7-add-crossbar-device-binding.patch"
	${git} "${DIR}/patches/omap_next/0027-ARM-dts-Add-devicetree-for-Gumstix-Pepper-board.patch"
	${git} "${DIR}/patches/omap_next/0028-ARM-dts-AM43x-Add-TPS65218-device-tree-nodes.patch"
	${git} "${DIR}/patches/omap_next/0029-ARM-dts-AM437x-Fix-i2c-nodes-indentation.patch"
	${git} "${DIR}/patches/omap_next/0030-ARM-dts-AM437x-Add-TPS65218-device-tree-nodes.patch"
	${git} "${DIR}/patches/omap_next/0031-ARM-omap2plus_defconfig-enable-TPS65218-configs.patch"
	${git} "${DIR}/patches/omap_next/0032-ARM-dts-dra7-evm-Add-regulator-information-to-USB2-P.patch"
	${git} "${DIR}/patches/omap_next/0033-ARM-dts-dra7xx-clocks-Add-divider-table-to-optfclk_p.patch"
	${git} "${DIR}/patches/omap_next/0034-ARM-dts-dra7xx-clocks-Change-the-parent-of-apll_pcie.patch"
	${git} "${DIR}/patches/omap_next/0035-ARM-dts-dra7xx-clocks-Add-missing-32KHz-clocks-used-.patch"
	${git} "${DIR}/patches/omap_next/0036-ARM-dts-dra7xx-clocks-rename-pcie-clocks-to-accommod.patch"
	${git} "${DIR}/patches/omap_next/0037-ARM-dts-dra7xx-clocks-Add-missing-clocks-for-second-.patch"
	${git} "${DIR}/patches/omap_next/0038-ARM-dts-dra7-Add-dt-data-for-PCIe-PHY-control-module.patch"
	${git} "${DIR}/patches/omap_next/0039-ARM-dts-dra7-Add-dt-data-for-PCIe-PHY.patch"
	${git} "${DIR}/patches/omap_next/0040-ARM-dts-dra7-Add-dt-data-for-PCIe-controller.patch"
	${git} "${DIR}/patches/omap_next/0041-ARM-DTS-omap5-uevm-Enable-palmas-clk32kgaudio-clock.patch"
	${git} "${DIR}/patches/omap_next/0042-ARM-DTS-omap5-uevm-Add-node-for-twl6040-audio-codec.patch"
	${git} "${DIR}/patches/omap_next/0043-ARM-DTS-omap5-uevm-Enable-basic-audio-McPDM-twl6040.patch"
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

#	${git} "${DIR}/patches/dts/0009-beagle-xm-use-ti-abb-for-1Ghz-operation.patch"
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

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
}

packaging () {
	echo "dir: packaging"
	#${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
}

#packaging_setup
packaging
echo "patch.sh ran successful"
