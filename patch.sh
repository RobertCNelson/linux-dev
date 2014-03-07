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

deassert_hard_reset () {
	echo "dir: deassert-hard-reset"
	${git} "${DIR}/patches/deassert-hard-reset/0001-ARM-omap-add-DT-support-for-deasserting-hardware-res.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0002-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/dts/0003-arm-dts-am335x-bone-common-enable-and-use-i2c2.patch"
	${git} "${DIR}/patches/dts/0004-arm-dts-am335x-bone-common-setup-default-pinmux-http.patch"
}

fixes () {
	echo "dir: fixes"
	${git} "${DIR}/patches/fixes/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
}

usb  () {
	echo "dir: usb"
	${git} "${DIR}/patches/usb/0001-usb-musb-musb_host-Enable-ISOCH-IN-handling-for-AM33.patch"
	${git} "${DIR}/patches/usb/0002-usb-musb-musb_cppi41-Make-CPPI-aware-of-high-bandwid.patch"
	${git} "${DIR}/patches/usb/0003-usb-musb-musb_cppi41-Handle-ISOCH-differently-and-no.patch"
}

audio () {
	echo "dir: audio"
	${git} "${DIR}/patches/audio/0001-clk-add-gpio-controlled-clock.patch"
	${git} "${DIR}/patches/audio/0002-ASoC-davinci-evm-Add-named-clock-reference-to-DT-bin.patch"
	${git} "${DIR}/patches/audio/0003-ASoC-davinci-evm-HDMI-audio-support-for-TDA998x-trou.patch"
	${git} "${DIR}/patches/audio/0004-ASoC-hdmi-codec-Add-devicetree-binding-with-document.patch"
	${git} "${DIR}/patches/audio/0005-ASoC-davinci-HDMI-audio-build-for-AM33XX-and-TDA998x.patch"
	${git} "${DIR}/patches/audio/0006-drm-tilcdc-Add-I2C-HDMI-audio-config-for-tda998x.patch"
}

overlay () {
	echo "dir: merge-of-kobj-min-new-20131227"
	#git checkout f41bfc9423aac4e589d2b3bedf26b3c249c61146 -b tmp
	#git pull --no-edit https://github.com/pantoniou/linux-beagle-track-mainline.git merge-of-kobj-min-new-20131227
	#git rebase f41bfc9423aac4e589d2b3bedf26b3c249c61146
	#git format-patch -27 | grep auxvec.h-account-for-AT_HWCAP2-in-AT_VECTOR_SIZE_BAS.patch ; rm -rf *.patch
	#git format-patch -26 -o /opt/github/linux-dev/patches/merge-of-kobj-min-new-20131227
	#git checkout master -f ; git branch -D tmp

	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0001-Fix-util_is_printable_string.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0002-fdtdump-properly-handle-multi-string-properties.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0003-dtc-Dynamic-symbols-fixup-support.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0004-dtc-Dynamic-symbols-fixup-support-shipped.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0005-OF-Compile-Device-Tree-sources-with-resolve-option.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0006-pdev-Fix-platform-device-resource-linking.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0007-of-Link-platform-device-resources-properly.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0008-omap-Properly-handle-resources-for-omap_devices.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0009-arm-omap-Proper-cleanups-for-omap_device.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0010-staging-Platform-device-tester-Allow-removal.patch"
#	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0011-add-PM-firmware.patch"
#	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0012-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
#	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0013-defconfig-add-for-mainline-on-the-beaglebone.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0014-gitignore-Add-.dtbo.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0015-tty-omap-serial-Fix-up-platform-data-alloc.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0016-of-Make-device-nodes-kobjects-so-they-show-up-in-sys.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0017-of-selftest-Add-self-tests-for-manipulation-of-prope.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0018-of-remove-proc-device-tree.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0019-OF-kobj-node-lifecycle-fixes.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0020-of-i2c-Export-single-device-registration-method.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0021-OF-Introduce-device-tree-node-flag-helpers.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0022-OF-Clear-detach-flag-on-attach.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0023-OF-Introduce-utility-helper-functions.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0024-OF-Introduce-Device-Tree-resolve-support.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0025-OF-Introduce-DT-overlay-support.patch"
	${git} "${DIR}/patches/merge-of-kobj-min-new-20131227/0026-OF-DT-Overlay-configfs-interface.patch"
}

capemgr () {
	echo "dir: capemgr"
	${git} "${DIR}/patches/capemgr/0001-wip-add-capemgr-from-3.8.patch"
}

pru () {
	echo "dir: pru"
	${git} "${DIR}/patches/pru/0001-Rebased-the-PRUSS-patch-from-3.12-commit-2c2a6c5.patch"
}

sgx () {
	echo "dir: sgx"
	${git} "${DIR}/patches/sgx/0001-reset-Add-driver-for-gpio-controlled-reset-pins.patch"
	${git} "${DIR}/patches/sgx/0002-prcm-port-from-ti-linux-3.12.y.patch"
	${git} "${DIR}/patches/sgx/0003-ARM-DTS-AM335x-Add-SGX-DT-node.patch"
	${git} "${DIR}/patches/sgx/0004-arm-Export-cache-flush-management-symbols-when-MULTI.patch"
	${git} "${DIR}/patches/sgx/0005-hack-port-da8xx-changes-from-ti-3.12-repo.patch"
	${git} "${DIR}/patches/sgx/0006-Revert-drm-remove-procfs-code-take-2.patch"
	${git} "${DIR}/patches/sgx/0007-Changes-according-to-TI-for-SGX-support.patch"
}

static_capes () {
	echo "dir: static-capes"

	#MAKE SURE TO ALWAYS ADD PINMUXS TO PATCH 1:
	${git} "${DIR}/patches/static-capes/0001-dts-am335x-boneblack-default.patch"

	#Serial capes
	${git} "${DIR}/patches/static-capes/0002-dts-boneblack-ttyO1-ttyO2-ttyO4.patch"

	#Argus UPS Cape
	${git} "${DIR}/patches/static-capes/0003-Added-Argus-UPS-cape-support.patch"

	#Update Makefile Last
	${git} "${DIR}/patches/static-capes/0004-build-capes-one-layer.patch"
}

boards () {
	echo "dir: boards"
	${git} "${DIR}/patches/boards/0001-add-work-in-progress-am335x-som-board.patch"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

###
arm
deassert_hard_reset
dts
fixes
usb
#audio
#overlay
#capemgr
pru
sgx
static_capes
boards
saucy

echo "patch.sh ran successful"
