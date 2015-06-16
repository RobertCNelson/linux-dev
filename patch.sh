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

reverts () {
	echo "dir: reverts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#my major screw up...
	${git} "${DIR}/patches/reverts/0001-Revert-ARM-dts-am335x-boneblack-disable-RTC-only-sle.patch"

	${git} "${DIR}/patches/reverts/0002-Revert-spi-spidev-Warn-loudly-if-instantiated-from-D.patch"

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

	${git} "${DIR}/patches/bbb_overlays/0001-regmap-Introduce-regmap_get_max_register.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-regmap-Introduce-regmap_get_reg_stride.patch"
	${git} "${DIR}/patches/bbb_overlays/0003-nvmem-Add-a-simple-NVMEM-framework-for-nvmem-provide.patch"
	${git} "${DIR}/patches/bbb_overlays/0004-nvmem-Add-a-simple-NVMEM-framework-for-consumers.patch"
	${git} "${DIR}/patches/bbb_overlays/0005-nvmem-Add-nvmem_device-based-consumer-apis.patch"
	${git} "${DIR}/patches/bbb_overlays/0006-nvmem-Add-bindings-for-simple-nvmem-framework.patch"
	${git} "${DIR}/patches/bbb_overlays/0007-nvmem-Add-simple-nvmem-mmio-consumer-helper-function.patch"
	${git} "${DIR}/patches/bbb_overlays/0008-nvmem-qfprom-Add-Qualcomm-QFPROM-support.patch"
	${git} "${DIR}/patches/bbb_overlays/0009-nvmem-qfprom-Add-bindings-for-qfprom.patch"
	${git} "${DIR}/patches/bbb_overlays/0010-nvmem-sunxi-Move-the-SID-driver-to-the-nvmem-framewo.patch"
	${git} "${DIR}/patches/bbb_overlays/0011-configfs-Implement-binary-attributes-v4.patch"
	${git} "${DIR}/patches/bbb_overlays/0012-OF-DT-Overlay-configfs-interface-v5.patch"
	${git} "${DIR}/patches/bbb_overlays/0013-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0014-add-PM-firmware.patch"
	${git} "${DIR}/patches/bbb_overlays/0015-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0016-arm-omap-Proper-cleanups-for-omap_device.patch"
	${git} "${DIR}/patches/bbb_overlays/0017-serial-omap-Fix-port-line-number-without-aliases.patch"
	${git} "${DIR}/patches/bbb_overlays/0018-tty-omap-serial-Fix-up-platform-data-alloc.patch"
	${git} "${DIR}/patches/bbb_overlays/0019-scripts-dtc-Update-to-upstream-version-with-overlay-.patch"
	${git} "${DIR}/patches/bbb_overlays/0020-ARM-DT-Enable-symbols-when-CONFIG_OF_OVERLAY-is-used.patch"
	${git} "${DIR}/patches/bbb_overlays/0021-of-Custom-printk-format-specifier-for-device-node.patch"
	${git} "${DIR}/patches/bbb_overlays/0022-i2c-Mark-instantiated-device-nodes-with-OF_POPULATE.patch"
	${git} "${DIR}/patches/bbb_overlays/0023-of-overlay-kobjectify-overlay-objects.patch"
	${git} "${DIR}/patches/bbb_overlays/0024-of-overlay-global-sysfs-enable-attribute.patch"
	${git} "${DIR}/patches/bbb_overlays/0025-of-overlay-add-per-overlay-sysfs-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0026-Documentation-ABI-sys-firmware-devicetree-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0027-of-Move-OF-flags-to-be-visible-even-when-CONFIG_OF.patch"
	${git} "${DIR}/patches/bbb_overlays/0028-i2c-nvmem-at24-Provide-an-EEPROM-framework-interface.patch"
	${git} "${DIR}/patches/bbb_overlays/0029-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/bbb_overlays/0030-doc-misc-Beaglebone-capemanager-documentation.patch"
	${git} "${DIR}/patches/bbb_overlays/0031-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/bbb_overlays/0032-doc-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/bbb_overlays/0033-MAINTAINERS-Beaglebone-capemanager-maintainer.patch"
	${git} "${DIR}/patches/bbb_overlays/0034-arm-dts-Beaglebone-i2c-definitions.patch"
	${git} "${DIR}/patches/bbb_overlays/0035-arm-dts-Enable-beaglebone-cape-manager.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0036-boneblack-defconfig.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0037-gcl-Fix-resource-linking.patch"
	${git} "${DIR}/patches/bbb_overlays/0038-of-overlay-Implement-indirect-target-support.patch"
	${git} "${DIR}/patches/bbb_overlays/0039-of-unittest-Add-indirect-overlay-target-test.patch"
	${git} "${DIR}/patches/bbb_overlays/0040-doc-dt-Document-the-indirect-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0041-of-overlay-Introduce-target-root-capability.patch"
	${git} "${DIR}/patches/bbb_overlays/0042-of-unittest-Unit-tests-for-target-root-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0043-doc-dt-Document-the-target-root-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0044-of-dynamic-Add-__of_node_dupv.patch"
	${git} "${DIR}/patches/bbb_overlays/0045-of-changesets-Introduce-changeset-helper-methods.patch"
	${git} "${DIR}/patches/bbb_overlays/0046-RFC-Device-overlay-manager-PCI-USB-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=46
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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
		cleanup
	fi

	echo "dir: beaglebone/capes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/capes/0002-Added-support-for-Replicape.patch"
	${git} "${DIR}/patches/beaglebone/capes/0003-ARM-dts-am335x-boneblack-enable-wl1835mod-cape-suppo.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

	echo "dir: beaglebone/pinmux-helper"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/pinmux-helper/0001-BeagleBone-pinmux-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0002-pinmux-helper-Add-runtime-configuration-capability.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0003-pinmux-helper-Switch-to-using-kmalloc.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0004-gpio-Introduce-GPIO-OF-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0005-Add-dir-changeable-property-to-gpio-of-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0006-am33xx.dtsi-add-ocp-label.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0007-beaglebone-added-expansion-header-to-dtb.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0008-bone-pinmux-helper-Add-support-for-mode-device-tree-.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0009-pinmux-helper-add-P8_37_pinmux-P8_38_pinmux.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0010-pinmux-helper-hdmi.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0011-pinmux-helper-can1.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0012-Remove-CONFIG_EXPERIMENTAL-dependency-on-CONFIG_GPIO.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0013-pinmux-helper-add-P9_19_pinmux-P9_20_pinmux.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0014-gpio-of-helper-idr_alloc.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=14
		cleanup
	fi

	echo "dir: beaglebone/eqep"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/eqep/0001-Provides-a-sysfs-interface-to-the-eQEP-hardware-on-t.patch"
	${git} "${DIR}/patches/beaglebone/eqep/0002-tieqep.c-devres-remove-devm_request_and_ioremap.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi

#	echo "dir: beaglebone/hdmi-audio"
#	#regenerate="enable"
#	if [ "x${regenerate}" = "xenable" ] ; then
#		start_cleanup
#	fi

#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0001-ASoC-davinci-mcasp-Calculate-BCLK-using-TDM-slots-an.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0002-ASoC-davinci-mcasp-Channel-count-constraints-for-mul.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0003-ASoC-davinci-macsp-Optimize-implicit-BLCK-sample-rat.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0004-drm-tilcdc-Fix-module-unloading.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0005-drm-tilcdc-Remove-tilcdc-slave-support-for-tda998x-d.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0006-drm-tilcdc-Add-support-for-external-tda998x-encoder.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0007-drm-tilcdc-Add-DRM_TILCDC_SLAVE_COMPAT-for-ti-tilcdc.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0008-drm-tilcdc-Force-building-of-DRM_TILCDC_SLAVE_COMPAT.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0009-ARM-dts-am335x-boneblack-Use-new-binding-for-HDMI.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0010-ARM-dts-am335x-boneblack-Add-HDMI-audio-support-HACK.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0011-ASoC-hdmi-codec-lib-Add-hdmi-codec-lib-for-external-.patch"
#	${git} "${DIR}/patches/beaglebone/hdmi-audio/0012-drm-i2c-tda998x-HACK-Implement-primitive-HDMI-audio-.patch"

#	if [ "x${regenerate}" = "xenable" ] ; then
#		number=12
#		cleanup
#	fi

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

		device="am335x-arduino-tre.dtb" ; dtb_makefile_append

		device="am335x-bone-can0.dtb" ; dtb_makefile_append
		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-r.dtb" ; dtb_makefile_append
		device="am335x-boneblack-can0.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-replicape.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append
		device="am335x-boneblack-universal.dtb" ; dtb_makefile_append

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

reverts
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
