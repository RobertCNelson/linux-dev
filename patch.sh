#!/bin/sh
#
# Copyright (c) 2009-2015 Robert Nelson <robertcnelson@gmail.com>
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

#Debian 7 (Wheezy): git version 1.7.10.4 and later needs "--no-edit"
unset git_opts
git_no_edit=$(LC_ALL=C git help pull | grep -m 1 -e "--no-edit" || true)
if [ ! "x${git_no_edit}" = "x" ] ; then
	git_opts="--no-edit"
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
	exit 2
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

#external_git
#local_patch

dt () {
	echo "dir: dt"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		number=0
		cleanup
	fi
}

dts () {
	echo "dir: dts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/dts/0001-ARM-dts-omap3-beagle-add-i2c2.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
	${git} "${DIR}/patches/dts/0004-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
	${git} "${DIR}/patches/dts/0005-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/dts/0006-arm-dts-omap4-move-emif-so-panda-es-b3-now-boots.patch"
	${git} "${DIR}/patches/dts/0007-omap3-beagle-xm-ehci-works-again.patch"
	${git} "${DIR}/patches/dts/0008-ARM-dts-omap3-beagle-ddc-i2c-bus-is-not-responding-d.patch"
	${git} "${DIR}/patches/dts/0009-first-pass-imx6q-ccimx6sbc.patch"
	${git} "${DIR}/patches/dts/0010-imx6-wl1835-base-boards.patch"
	${git} "${DIR}/patches/dts/0011-imx6q-sabresd-add-support-for-wilink8-wlan-and-bluet.patch"
	${git} "${DIR}/patches/dts/0012-imx6sl-evk-add-support-for-wilink8-wlan-and-bluetoot.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=12
		cleanup
	fi
}

wand () {
	echo "dir: wand"
	${git} "${DIR}/patches/wand/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

errata () {
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi
	echo "dir: errata"

	${git} "${DIR}/patches/errata/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

fixes () {
	echo "dir: fixes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/fixes/0001-trusty-gcc-4.8-4.8.2-19ubuntu1-has-fix.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

pru () {
	echo "dir: pru"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/pru/0001-Making-the-uio-pruss-driver-work.patch"
	${git} "${DIR}/patches/pru/0002-Cleaned-up-error-reporting.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi
}

bbb_overlays () {
	echo "dir: bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/0001-configfs-Implement-binary-attributes-v4.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-OF-DT-Overlay-configfs-interface-v4.patch"
	${git} "${DIR}/patches/bbb_overlays/0003-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0004-add-PM-firmware.patch"
	${git} "${DIR}/patches/bbb_overlays/0005-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0006-omap-Properly-handle-resources-for-omap_devices.patch"
	${git} "${DIR}/patches/bbb_overlays/0007-pdev-Fix-platform-device-resource-linking.patch"
	${git} "${DIR}/patches/bbb_overlays/0008-arm-omap-Proper-cleanups-for-omap_device.patch"
	${git} "${DIR}/patches/bbb_overlays/0009-serial-omap-Fix-port-line-number-without-aliases.patch"
	${git} "${DIR}/patches/bbb_overlays/0010-tty-omap-serial-Fix-up-platform-data-alloc.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0011-boneblack-defconfig.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0012-scripts-dtc-Update-to-upstream-version-with-overlay-.patch"
	${git} "${DIR}/patches/bbb_overlays/0013-ARM-DT-Enable-symbols-when-CONFIG_OF_OVERLAY-is-used.patch"
	${git} "${DIR}/patches/bbb_overlays/0014-of-Custom-printk-format-specifier-for-device-node.patch"
	${git} "${DIR}/patches/bbb_overlays/0015-i2c-Mark-instantiated-device-nodes-with-OF_POPULATE.patch"
	${git} "${DIR}/patches/bbb_overlays/0016-of-overlay-kobjectify-overlay-objects.patch"
	${git} "${DIR}/patches/bbb_overlays/0017-of-overlay-global-sysfs-enable-attribute.patch"
	${git} "${DIR}/patches/bbb_overlays/0018-of-overlay-add-per-overlay-sysfs-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0019-Documentation-ABI-sys-firmware-devicetree-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0020-of-Move-OF-flags-to-be-visible-even-when-CONFIG_OF.patch"
	${git} "${DIR}/patches/bbb_overlays/0021-i2c-EEPROM-In-kernel-memory-accessor-interface.patch"
	${git} "${DIR}/patches/bbb_overlays/0022-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/bbb_overlays/0023-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/bbb_overlays/0024-documentation-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/bbb_overlays/0025-arm-dts-Beaglebone-i2c-definitions.patch"
	${git} "${DIR}/patches/bbb_overlays/0026-arm-dts-Enable-beaglebone-cape-manager.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=26
		cleanup
	fi
}

dtb_makefile_append () {
	sed -i -e 's:am335x-boneblack.dtb \\:am335x-boneblack.dtb \\\n\t'$device' \\:g' arch/arm/boot/dts/Makefile
}

beaglebone () {
	echo "dir: beaglebone/dts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/dts/0001-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/beaglebone/dts/0002-dts-am335x-bone-common-fixup-leds-to-match-3.8.patch"
	${git} "${DIR}/patches/beaglebone/dts/0003-arm-dts-am335x-bone-common-add-collision-and-carrier.patch"
	${git} "${DIR}/patches/beaglebone/dts/0004-add-am335x-bonegreen.patch"
	${git} "${DIR}/patches/beaglebone/dts/0005-add-overlay-dtb.patch"
	${git} "${DIR}/patches/beaglebone/dts/0006-ARM-dts-AM33XX-Set-pmic-shutdown-controller-for-Beag.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=6
		cleanup
	fi

	echo "dir: beaglebone/capes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/capes/0002-Added-support-for-Replicape.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi

	#This has to be last...
	echo "dir: beaglebone/dtbs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		patch -p1 < "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"
		exit 2
	fi
	${git} "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"

	####
	#dtb makefile
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then

		device="am335x-bone-can0.dtb" ; dtb_makefile_append
		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-can0.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-replicape.dtb" ; dtb_makefile_append

		git commit -a -m 'auto generated: capes: add dtbs to makefile' -s
		git format-patch -1 -o ../patches/beaglebone/generated/
		exit 2
	else
		${git} "${DIR}/patches/beaglebone/generated/0001-auto-generated-capes-add-dtbs-to-makefile.patch"
	fi

	echo "dir: beaglebone/phy"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/phy/0001-cpsw-Add-support-for-byte-queue-limits.patch"
	${git} "${DIR}/patches/beaglebone/phy/0002-cpsw-napi-polling-of-64-is-good-for-gigE-less-good-f.patch"
	#${git} "${DIR}/patches/beaglebone/phy/0003-cpsw-search-for-phy.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
}

etnaviv () {
	echo "dir: etnaviv"

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
		patch -p1 < "${DIR}/patches/etnaviv/0001-staging-etnaviv-add-drm-driver.patch"
		exit 2

	cd ~/linux-src
	git checkout v4.0-rc6 -b tmp
	git pull --no-edit git://git.pengutronix.de/git/lst/linux.git etnaviv-for-upstream

meld KERNEL/Documentation/devicetree/bindings/drm/etnaviv/etnaviv-drm.txt ~/linux-src/Documentation/devicetree/bindings/drm/etnaviv/etnaviv-drm.txt

meld KERNEL/Documentation/devicetree/bindings/vendor-prefixes.txt ~/linux-src/Documentation/devicetree/bindings/vendor-prefixes.txt

meld KERNEL/arch/arm/boot/dts/imx6dl.dtsi ~/linux-src/arch/arm/boot/dts/imx6dl.dtsi
meld KERNEL/arch/arm/boot/dts/imx6q.dtsi ~/linux-src/arch/arm/boot/dts/imx6q.dtsi
meld KERNEL/arch/arm/boot/dts/imx6qdl.dtsi ~/linux-src/arch/arm/boot/dts/imx6qdl.dtsi

meld KERNEL/drivers/staging/Kconfig ~/linux-src/drivers/staging/Kconfig
meld KERNEL/drivers/staging/Makefile ~/linux-src/drivers/staging/Makefile
meld KERNEL/drivers/staging/etnaviv/ ~/linux-src/drivers/staging/etnaviv/

meld KERNEL/include/uapi/drm/etnaviv_drm.h ~/linux-src/include/uapi/drm/etnaviv_drm.h

	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/etnaviv/0001-staging-etnaviv-add-drm-driver.patch"
	${git} "${DIR}/patches/etnaviv/0002-etnaviv-wheezy-build-fix.patch"
	${git} "${DIR}/patches/etnaviv/0003-Revert-iommu-Remove-domain_init-and-domain_free-iomm.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

#	echo "dir: etnaviv/fixes"
}

dt
dts
wand
errata
fixes
pru
bbb_overlays
beaglebone
etnaviv

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
	exit 2
}

packaging () {
	echo "dir: packaging"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
	#${git} "${DIR}/patches/packaging/0003-deb-pkg-no-dtbs_install.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
}

#packaging_setup
packaging
echo "patch.sh ran successfully"
