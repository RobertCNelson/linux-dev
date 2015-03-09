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

overlay () {
	echo "dir: overlay"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/overlay/0001-of-Custom-printk-format-specifier-for-device-node.patch"
	${git} "${DIR}/patches/overlay/0002-arm-of-Add-a-DT-quirk-method-after-unflattening.patch"
	${git} "${DIR}/patches/overlay/0003-of-DT-quirks-infrastructure.patch"
	${git} "${DIR}/patches/overlay/0004-arm-am33xx-DT-quirks-for-am33xx-based-beaglebone-var.patch"
	${git} "${DIR}/patches/overlay/0005-arm-dts-Common-Black-White-Beaglebone-DTS-using-quir.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
		cleanup
	fi


}

dt () {
	echo "dir: dt/gpiohog"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/dt/gpiohog/0001-gpio-add-GPIO-hogging-mechanism.patch"
	${git} "${DIR}/patches/dt/gpiohog/0002-gpio-Document-GPIO-hogging-mechanism.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=8
		cleanup
	fi
}

wand () {
	echo "dir: wand"
	${git} "${DIR}/patches/wand/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

errata () {
	echo "dir: errata"
	${git} "${DIR}/patches/errata/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

	echo "dir: beaglebone/capes"
	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"

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
		device="am335x-bone-can0.dtb"
		dtb_makefile_append

		device="am335x-bone-can1.dtb"
		dtb_makefile_append

		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-bone-ttyO1.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO2.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO4.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO5.dtb"
		dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append

		device="am335x-boneblack-can0.dtb"
		dtb_makefile_append

		device="am335x-boneblack-can1.dtb"
		dtb_makefile_append

		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-ttyO1.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO2.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO4.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO5.dtb"
		dtb_makefile_append

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
	${git} "${DIR}/patches/beaglebone/phy/0003-cpsw-search-for-phy.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
}

etnaviv () {
	echo "dir: etnaviv"
	#https://github.com/austriancoder/linux

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
		patch -p1 < "${DIR}/patches/etnaviv/0001-staging-etnaviv-add-drm-driver.patch"
		exit 2

		#cd ~/linux-src
		#git checkout v4.0-rc2 -b tmp
		#git pull --no-edit https://github.com/austriancoder/linux master

		meld KERNEL/drivers/staging/etnaviv/ ~/linux-src/drivers/staging/etnaviv/
		meld KERNEL/include/uapi/drm/etnaviv_drm.h ~/linux-src/include/uapi/drm/etnaviv_drm.h
	fi

	${git} "${DIR}/patches/etnaviv/0001-staging-etnaviv-add-drm-driver.patch"
	${git} "${DIR}/patches/etnaviv/0002-ARM-add-etnaviv-devices.patch"
	${git} "${DIR}/patches/etnaviv/0004-temp-imx6qdl-disable-reserved-memory-locking-up-v3.1.patch"

#	echo "dir: etnaviv/fixes"
}

#overlay
dt
dts
wand
#errata
fixes

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
