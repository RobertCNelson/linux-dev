#!/bin/bash
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
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

	#Status: v2 Review:
	#http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/112440.html
	${git} "${DIR}/patches/arm/0002-arm-add-definition-of-strstr-to-decompress.c.patch"
#	${git} "${DIR}/patches/arm/0003-Without-MACH_-option-Early-printk-DEBUG_LL.patch"
}

imx () {
	echo "imx patches"
	${git} "${DIR}/patches/imx/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/imx/0002-Add-IMX6Q-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0003-imx-Add-IMX53-AHCI-support.patch"
#	${git} "${DIR}/patches/imx/0004-cpufreq-add-imx6q-cpufreq-driver.patch"
	${git} "${DIR}/patches/imx/0005-SAUCE-imx6-enable-sata-clk-if-SATA_AHCI_PLATFORM.patch"
}

omap () {
	echo "dir: omap"
	#Fixes 800Mhz boot lockup: http://www.spinics.net/lists/linux-omap/msg83737.html
#	${git} "${DIR}/patches/omap/0001-regulator-core-if-voltage-scaling-fails-restore-orig.patch"
	${git} "${DIR}/patches/omap/0002-omap2-twl-common-Add-default-power-configuration.patch"

	echo "dir: omap/sakoman"
	${git} "${DIR}/patches/omap_sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	${git} "${DIR}/patches/omap_sakoman/0002-video-add-timings-for-hd720.patch"

	echo "dir: omap/beagle/expansion"
	${git} "${DIR}/patches/omap_beagle_expansion/0001-Beagle-expansion-add-buddy-param-for-expansionboard-.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0002-Beagle-expansion-add-zippy.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0003-Beagle-expansion-add-zippy2.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0004-Beagle-expansion-add-trainer.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0005-Beagle-expansion-add-CircuitCo-ulcd-Support.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0006-Beagle-expansion-add-wifi.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0007-Beagle-expansion-add-beaglefpga.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0008-Beagle-expansion-add-spidev.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0009-Beagle-expansion-add-Aptina-li5m03-camera.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0010-Beagle-expansion-add-LSR-COM6L-Adapter-Board.patch"
	${git} "${DIR}/patches/omap_beagle_expansion/0011-Beagle-expansion-LSR-COM6L-Adapter-Board-also-initia.patch"

	echo "dir: omap/beagle"
	#Status: for meego guys..
	${git} "${DIR}/patches/omap_beagle/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

	${git} "${DIR}/patches/omap_beagle/0002-backlight-Add-TLC59108-backlight-control-driver.patch"
	${git} "${DIR}/patches/omap_beagle/0003-tlc59108-adjust-for-beagleboard-uLCD7.patch"

	#Status: not for upstream
	${git} "${DIR}/patches/omap_beagle/0004-zeroMAP-Open-your-eyes.patch"

	${git} "${DIR}/patches/omap_beagle/0005-ARM-OMAP-Beagle-use-TWL4030-generic-reset-script.patch"

	echo "dir: omap/panda"
	#Status: not for upstream: push device tree version upstream...
	${git} "${DIR}/patches/omap_panda/0001-panda-fix-wl12xx-regulator.patch"
	#Status: unknown: cherry picked from linaro
	${git} "${DIR}/patches/omap_panda/0002-ti-st-st-kim-fixing-firmware-path.patch"
}

omap_late () {
	echo "dir: omap_late"
	${git} "${DIR}/patches/omap_late/0001-ARM-OMAP3-clock-Back-propagate-rate-change-from-cam_.patch"
	${git} "${DIR}/patches/omap_late/0002-omap3isp-Set-cam_mclk-rate-directly.patch"
	${git} "${DIR}/patches/omap_late/0003-ARM-OMAP2-dpll-am335x-avoid-freqsel.patch"
	${git} "${DIR}/patches/omap_late/0004-ARM-OMAP2-clock-data-add-DEFINE_STRUCT_CLK_FLAGS-hel.patch"
	${git} "${DIR}/patches/omap_late/0005-ARM-OMAP-AM33XX-clock-data-SET_RATE_PARENT-in-lcd-pa.patch"
	${git} "${DIR}/patches/omap_late/0006-ARM-OMAP2-AM33xx-Add-SoC-specific-restart-hook.patch"
	${git} "${DIR}/patches/omap_late/0007-ARM-OMAP2-Get-rid-of-custom-OMAP_32K_TIMER_HZ.patch"
	${git} "${DIR}/patches/omap_late/0008-ARM-OMAP2-AM33XX-id-Add-support-for-AM335x-PG2.0.patch"
	${git} "${DIR}/patches/omap_late/0009-ARM-OMAP2xxx-PM-enter-WFI-via-inline-asm-if-CORE-sta.patch"
	${git} "${DIR}/patches/omap_late/0010-ARM-OMAP-AM3517-05-hwmod-data-block-WFI-when-EMAC-ac.patch"
	${git} "${DIR}/patches/omap_late/0011-ARM-OMAP4-PM-Warn-users-about-usage-of-older-bootloa.patch"
	${git} "${DIR}/patches/omap_late/0012-ARM-OMAP2-AM33XX-CM-Get-rid-of-unnecessary-header-in.patch"
	${git} "${DIR}/patches/omap_late/0013-ARM-OMAP2-AM33XX-CM-PRM-Use-__ASSEMBLER__-macros-in-.patch"
	${git} "${DIR}/patches/omap_late/0014-ARM-OMAP2-AM33XX-hwmod-Register-OCMC-RAM-hwmod.patch"
	${git} "${DIR}/patches/omap_late/0015-ARM-OMAP2-AM33XX-hwmod-Update-TPTC0-hwmod-with-the-r.patch"
	${git} "${DIR}/patches/omap_late/0016-ARM-OMAP2-AM33XX-hwmod-Fixup-cpgmac0-hwmod-entry.patch"
	${git} "${DIR}/patches/omap_late/0017-ARM-OMAP2-AM33XX-hwmod-Update-the-WKUP-M3-hwmod-with.patch"
	${git} "${DIR}/patches/omap_late/0018-ARM-OMAP2-AM33XX-Update-the-hardreset-API.patch"
	${git} "${DIR}/patches/omap_late/0019-ARM-DTS-AM33XX-Add-nodes-for-OCMC-RAM-and-WKUP-M3.patch"
	${git} "${DIR}/patches/omap_late/0020-ARM-OMAP-AM33xx-hwmod-Corrects-PWM-subsystem-HWMOD-e.patch"
	${git} "${DIR}/patches/omap_late/0021-ARM-OMAP-AM33xx-hwmod-Add-parent-child-relationship-.patch"
	${git} "${DIR}/patches/omap_late/0022-ARM-OMAP2-AM33xx-hwmod-add-missing-HWMOD_NO_IDLEST-f.patch"
	${git} "${DIR}/patches/omap_late/0023-ARM-OMAP2-am33xx-hwmod-Fix-register-offset-NULL-chec.patch"
	${git} "${DIR}/patches/omap_late/0024-ARM-OMAP2-PM-Fix-the-dt-return-condition-in-pm_late_.patch"
	${git} "${DIR}/patches/omap_late/0025-ARM-OMAP4-clock-data-Add-missing-clkdm-association-f.patch"
	${git} "${DIR}/patches/omap_late/0026-ARM-OMAP2-hwmod-add-enable_preprogram-hook.patch"
	${git} "${DIR}/patches/omap_late/0027-ASoC-TI-AESS-add-autogating-enable-function-callable.patch"
	${git} "${DIR}/patches/omap_late/0028-ARM-OMAP4-AESS-enable-internal-auto-gating-during-in.patch"
	${git} "${DIR}/patches/omap_late/0029-ARM-OMAP4-hwmod-data-Update-AESS-data-with-memory-ba.patch"
	${git} "${DIR}/patches/omap_late/0030-ARM-OMAP4-hwmod-data-Enable-AESS-hwmod-device.patch"
	${git} "${DIR}/patches/omap_late/0031-ARM-OMAP2-fix-some-omap_device_build-calls-that-aren.patch"
	${git} "${DIR}/patches/omap_late/0032-ARM-omap2-include-linux-errno.h-in-hwmod_reset.patch"
}

arm
imx
omap
omap_late

echo "patch.sh ran successful"
