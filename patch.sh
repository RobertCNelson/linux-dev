#!/bin/bash
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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

# DIR=`pwd`

git="git am"
#git="git am --whitespace=fix"

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -1 -o ${DIR}/patches/
	exit
}

vaibhav () {
	echo "BeagleBone: vaibhav"
	${git} "${DIR}/patches/vaibhav/0001-ARM-OMAP2-hwmod-Hook-up-am33xx-support-in-omap_hwmod.patch"
	${git} "${DIR}/patches/vaibhav/0002-ARM-OMAP3-hwmod-Add-AM33XX-HWMOD-data.patch"
	${git} "${DIR}/patches/vaibhav/0003-ARM-OMAP2-irq-Increase-no-of-supported-interrupts-to.patch"
	${git} "${DIR}/patches/vaibhav/0004-ARM-OMAP2-gpmc-add-am33xx-support-in-gpmc.c.patch"
	${git} "${DIR}/patches/vaibhav/0005-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/vaibhav/0006-CUSTOM-Enable-APPENDED_DTB-ATAG_DTB_COMPAT-option-in.patch"
	${git} "${DIR}/patches/vaibhav/0007-ARM-OMAP2-am33xx-Fix-the-timer-fck-clock-naming-conv.patch"
	${git} "${DIR}/patches/vaibhav/0008-ARM-OMAP2-AM335x-hwmod-do-not-reset-GPIO0.patch"
	${git} "${DIR}/patches/vaibhav/0009-arm-dts-OMAP3-Set-the-default-status-of-module-to-di.patch"
	${git} "${DIR}/patches/vaibhav/0010-arm-dts-AM33XX-Set-the-default-status-of-module-to-d.patch"
	${git} "${DIR}/patches/vaibhav/0011-arm-OMAP3-am33xx-Add-new-clk-node-entry-for-d_can-mo.patch"
	${git} "${DIR}/patches/vaibhav/0012-ARM-AM33XX-board-generic-Add-of_dev_auxdata-to-fix-d.patch"
}

usb () {
	echo "BeagleBone: usb"
	${git} "${DIR}/patches/usb/0001-drivers-usb-otg-add-device-tree-support-to-otg-libra.patch"
	${git} "${DIR}/patches/usb/0002-usb-musb-kill-uses-of-is_host-peripheral_capable.patch"
	${git} "${DIR}/patches/usb/0003-arm-omap-hwmod-add-new-memory-resource-for-usb-phy-c.patch"
	${git} "${DIR}/patches/usb/0004-usb-musb-dsps-add-phy-control-logic-to-glue.patch"
	${git} "${DIR}/patches/usb/0005-usb-musb-dsps-enable-phy-control-for-am335x.patch"
	${git} "${DIR}/patches/usb/0006-usb-musb-add-musb_ida-for-multi-instance-support.patch"
	${git} "${DIR}/patches/usb/0007-usb-musb-kill-global-and-static-for-multi-instance.patch"
	${git} "${DIR}/patches/usb/0008-usb-musb-am335x-add-support-for-dual-instance.patch"
	${git} "${DIR}/patches/usb/0009-usb-otg-nop-add-support-for-multiple-tranceiver.patch"
	${git} "${DIR}/patches/usb/0010-usb-musb-dsps-add-dt-support.patch"
	${git} "${DIR}/patches/usb/0011-arm-dts-am33xx-Add-dt-data-for-usbss.patch"
	${git} "${DIR}/patches/usb/0012-usb-otg-nop-add-dt-support.patch"
	${git} "${DIR}/patches/usb/0013-arm-dts-am33xx-add-dt-data-for-usb-nop-phy.patch"
	${git} "${DIR}/patches/usb/0014-usb-musb-dsps-remove-explicit-NOP-device-creation.patch"
	${git} "${DIR}/patches/usb/0015-usb-musb-dsps-get-the-PHY-using-phandle-api.patch"
	${git} "${DIR}/patches/usb/0016-arm-dts-am33xx-add-phy-phandle-to-usbss.patch"
	${git} "${DIR}/patches/usb/0017-omap2plus_defconfig-enable-usb-support.patch"
}

regulator () {
	echo "BeagleBone: regulator"
	${git} "${DIR}/patches/regulator/0001-arm-dts-regulator-Add-tps65910-device-tree-data.patch"
	${git} "${DIR}/patches/regulator/0002-arm-dts-regulator-Add-tps65217-device-tree-data.patch"
	${git} "${DIR}/patches/regulator/0003-arm-dts-Add-tps65910-regulator-DT-data-to-am335x-evm.patch"
	${git} "${DIR}/patches/regulator/0004-arm-dts-Add-tps65217-regulator-DT-data-to-am335x-bon.patch"
}

pinctrl () {
	echo "BeagleBone: pinctrl"
	${git} "${DIR}/patches/pinctrl/0001-arm-dts-Add-AM33XX-basic-pinctrl-support.patch"
	${git} "${DIR}/patches/pinctrl/0002-arm-dts-Configure-pinmuxs-for-user-leds-control-on-B.patch"
}

rtc () {
	echo "BeagleBone: rtc"
	${git} "${DIR}/patches/rtc/0001-arm-dts-am33xx-wdt-node.patch"
	${git} "${DIR}/patches/rtc/0002-rtc-omap-kicker-mechanism-support.patch"
	${git} "${DIR}/patches/rtc/0003-ARM-davinci-remove-rtc-kicker-release.patch"
	${git} "${DIR}/patches/rtc/0004-rtc-omap-dt-support.patch"
	${git} "${DIR}/patches/rtc/0005-rtc-omap-depend-on-am33xx.patch"
	${git} "${DIR}/patches/rtc/0006-rtc-omap-Add-runtime-pm-support.patch"
	${git} "${DIR}/patches/rtc/0007-arm-dts-am33xx-rtc-node.patch"
}

beaglebone () {
	echo "BeagleBone: beaglebone"
	${git} "${DIR}/patches/beaglebone/0001-beaglebone-add-usr0-and-usr1-LEDS-to-devicetree.patch"
	${git} "${DIR}/patches/beaglebone/0002-beaglebone-add-mcspi1-and-mcspi2.patch"
	${git} "${DIR}/patches/beaglebone/0003-beaglebone-enable-WLED-backlight-LCD3-LCD4.patch"
}

cpsw () {
	echo "BeagleBone: cpsw"
	${git} "${DIR}/patches/cpsw/0001-drivers-net-ethernet-cpsw-Add-SOC-dependency-support.patch"
	${git} "${DIR}/patches/cpsw/0002-drivers-net-ethernet-cpsw-Add-device-tree-support-to.patch"
	${git} "${DIR}/patches/cpsw/0003-beaglebone-add-broken-cpsw-DT.patch"
	${git} "${DIR}/patches/cpsw/0004-net-davinci_mdio-enable-and-disable-clock.patch"
	${git} "${DIR}/patches/cpsw/0005-net-davinci_mdio-add-DT-bindings.patch"
	${git} "${DIR}/patches/cpsw/0006-ARM-omap2-am33xx-add-hwmod-for-davinci_mdio.patch"
	${git} "${DIR}/patches/cpsw/0007-beaglebone-fix-mdio-DT.patch"
}

dma () {
	echo "BeagleBone: dma"
	${git} "${DIR}/patches/dma/0001-mmc-davinci_mmc-convert-to-DMA-engine-API.patch"
	${git} "${DIR}/patches/dma/0002-spi-spi-davinci-convert-to-DMA-engine-API.patch"
	${git} "${DIR}/patches/dma/0003-ARM-configs-modified-da8xx-defconfig-used-for-testin.patch"
	${git} "${DIR}/patches/dma/0004-spi-omap2-mcspi-In-case-of-dma-errors-fall-back-to-p.patch"
}

mmc () {
	echo "BeagleBone: mmc"
	${git} "${DIR}/patches/mmc/0001-am33xx.dtsi-add-mmc.patch"
}

da8xx_fb () {
	echo "BeagleBone: da8xx-fb"
	${git} "${DIR}/patches/da8xx-fb/0001-da8xx-fb-allow-frame-to-complete-after-disabling-LCD.patch"
}

distro () {
	echo "Distro Specific Patches"
	${git} "${DIR}/patches/distro/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

sakoman () {
	echo "Patches from: Sakoman git tree"
	${git} "${DIR}/patches/sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	${git} "${DIR}/patches/sakoman/0002-video-add-timings-for-hd720.patch"
}

beagle () {
	echo "Board Patches for: BeagleBoard"

	${git} "${DIR}/patches/beagle/expansion/0001-Beagle-expansion-add-buddy-param-for-expansionboard-.patch"
	${git} "${DIR}/patches/beagle/expansion/0002-Beagle-expansion-add-zippy.patch"
	${git} "${DIR}/patches/beagle/expansion/0003-Beagle-expansion-add-zippy2.patch"
	${git} "${DIR}/patches/beagle/expansion/0004-Beagle-expansion-add-trainer.patch"
	${git} "${DIR}/patches/beagle/expansion/0005-Beagle-expansion-add-CircuitCo-ulcd-Support.patch"
	${git} "${DIR}/patches/beagle/expansion/0006-Beagle-expansion-add-wifi.patch"
	${git} "${DIR}/patches/beagle/expansion/0007-Beagle-expansion-add-beaglefpga.patch"
	${git} "${DIR}/patches/beagle/expansion/0008-Enable-buddy-spidev.patch"

	#v3.5: looks to be removed:
	#http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=b6e695abe710ee1ae248463d325169efac487e17
	#git am "${DIR}/patches/beagle/0001-beagleboard-reinstate-usage-of-hi-speed-PLL-divider.patch"

	${git} "${DIR}/patches/beagle/0002-Turn-on-the-USB-regulator-on-Beagle-xM-explicitly.patch"
	${git} "${DIR}/patches/beagle/0003-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

#	just use boot args...
#	${git} "${DIR}/patches/beagle/0004-default-to-fifo-mode-5-for-old-musb-beagles.patch"

	${git} "${DIR}/patches/beagle/0005-omap3_beagle-init-uart2-for-beagle-rev-AX-BX-only.patch"
	${git} "${DIR}/patches/beagle/0006-backlight-Add-TLC59108-backlight-control-driver.patch"
	${git} "${DIR}/patches/beagle/0007-tlc59108-adjust-for-beagleboard-uLCD7.patch"
	${git} "${DIR}/patches/beagle/0008-zeroMAP-Open-your-eyes.patch"
}

sprz319_erratum () {
	echo "sprz319 erratum 2.1"
	${git} "${DIR}/patches/sprz319-erratum-2.1/0001-Fix-sprz319-erratum-2.1.patch"
}

devkit8000 () {
	echo "Board Patches for: devkit8000"
	${git} "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel.patch"
}

panda () {
	echo "Board Patches for: PandaBoard"
	${git} "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
	${git} "${DIR}/patches/panda/0002-ti-st-st-kim-fixing-firmware-path.patch"
#	in 3.6-rc1
#	${git} "${DIR}/patches/panda/0003-staging-OMAP4-thermal-introduce-bandgap-temperature-.patch"
#	${git} "${DIR}/patches/panda/0004-staging-omap-thermal-common-code-to-expose-driver-to.patch"
#	${git} "${DIR}/patches/panda/0005-staging-omap-thermal-add-OMAP4-data-structures.patch"
}

omap_fixes () {
	echo "omap cherry pick fixes"
	${git} "${DIR}/patches/omap_fixes/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
	${git} "${DIR}/patches/omap_fixes/0002-OMAP2-UART-enable-tx-wakeup-bit-for-wer-reg.patch"
	${git} "${DIR}/patches/omap_fixes/0003-OMAP2-UART-replace-omap34xx-omap4xx-cpu-checks-with-.patch"
#	in 3.6-rc1
#	${git} "${DIR}/patches/omap_fixes/0004-only-call-smp_send_stop-on-SMP.patch"
}

omapdrm () {
	echo "omap testing omapdrm/kms"

	#posted: 13 Mar 2012 for 3.4
#	in 3.6-rc1
#	${git} "${DIR}/patches/drm/0001-omap2-add-drm-device.patch"

	#might be merged in 3.4
	${git} "${DIR}/patches/drm/0002-ARM-OMAP2-3-HWMOD-Add-missing-flags-for-dispc-class.patch"
	${git} "${DIR}/patches/drm/0003-ARM-OMAP2-3-HWMOD-Add-missing-flag-for-rfbi-class.patch"
	${git} "${DIR}/patches/drm/0004-ARM-OMAP3-HWMOD-Add-omap_hwmod_class_sysconfig-for-d.patch"
}

dsp () {
	echo "dsp patches"
	${git} "${DIR}/patches/dsp/0001-dsp-add-memblock-include.patch"
}

sgx_mainline () {
	echo "patches needed for external sgx bins"
	${git} "${DIR}/patches/sgx/0001-Revert-drm-kill-drm_sman.patch"
}

mainline_fixes () {
	echo "mainline patches"
	${git} "${DIR}/patches/mainline-fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
	${git} "${DIR}/patches/mainline-fixes/0002-ARM-omap-add-dtb-targets.patch"
}

vaibhav
usb
regulator
pinctrl
rtc
beaglebone
cpsw
dma
mmc
da8xx_fb

distro
sakoman
beagle

#disabled as it breaks beagle c4...
#sprz319_erratum

devkit8000
panda
omap_fixes
omapdrm
dsp
sgx_mainline
mainline_fixes

echo "patch.sh ran successful"

