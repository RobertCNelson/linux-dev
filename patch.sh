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

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -8 -o ${DIR}/patches/
	exit
}

distro () {
	echo "Distro Specific Patches"
	git am "${DIR}/patches/distro/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

sakoman () {
	echo "Patches from: Sakoman git tree"
	git am "${DIR}/patches/sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	git am "${DIR}/patches/sakoman/0002-video-add-timings-for-hd720.patch"
}


beagle () {
	echo "Board Patches for: BeagleBoard"

	git am "${DIR}/patches/beagle/expansion/0001-Beagle-expansion-add-buddy-param-for-expansionboard-.patch"
	git am "${DIR}/patches/beagle/expansion/0002-Beagle-expansion-add-zippy.patch"
	git am "${DIR}/patches/beagle/expansion/0003-Beagle-expansion-add-zippy2.patch"
	git am "${DIR}/patches/beagle/expansion/0004-Beagle-expansion-add-trainer.patch"
	git am "${DIR}/patches/beagle/expansion/0005-Beagle-expansion-add-CircuitCo-ulcd-Support.patch"
	git am "${DIR}/patches/beagle/expansion/0006-Beagle-expansion-add-wifi.patch"
	git am "${DIR}/patches/beagle/expansion/0007-Beagle-expansion-add-beaglefpga.patch"
	git am "${DIR}/patches/beagle/expansion/0008-Enable-buddy-spidev.patch"

	git am "${DIR}/patches/beagle/0001-beagleboard-reinstate-usage-of-hi-speed-PLL-divider.patch"
	git am "${DIR}/patches/beagle/0002-Turn-on-the-USB-regulator-on-Beagle-xM-explicitly.patch"
	git am "${DIR}/patches/beagle/0003-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"
	git am "${DIR}/patches/beagle/0004-default-to-fifo-mode-5-for-old-musb-beagles.patch"
	git am "${DIR}/patches/beagle/0005-omap3_beagle-init-uart2-for-beagle-rev-AX-BX-only.patch"

	git am "${DIR}/patches/beagle/0006-backlight-Add-TLC59108-backlight-control-driver.patch"
	git am "${DIR}/patches/beagle/0007-tlc59108-adjust-for-beagleboard-uLCD7.patch"
}

devkit8000 () {
	echo "Board Patches for: devkit8000"
	git am "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel-2.6.37-git10.patch"
}

panda () {
	echo "Board Patches for: PandaBoard"
	git am "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
	git am "${DIR}/patches/panda/0003-ti-st-st-kim-fixing-firmware-path.patch"
}

omap_fixes () {
	echo "omap cherry pick fixes"
	git am "${DIR}/patches/omap_fixes/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
	git am "${DIR}/patches/omap_fixes/0002-OMAP2-UART-enable-tx-wakeup-bit-for-wer-reg.patch"
	git am "${DIR}/patches/omap_fixes/0003-OMAP2-UART-replace-omap34xx-omap4xx-cpu-checks-with-.patch"
	git am "${DIR}/patches/omap_fixes/0004-Unconditional-call-to-smp_cross_call-on-UP-crashes.patch"
#	git am "${DIR}/patches/omap_fixes/0005-OMAPDSS-fix-build-when-DEBUG_FS-or-DSS_DEBUG_SUPPORT.patch"
#	git am "${DIR}/patches/omap_fixes/0006-OMAPDSS-Taal-fix-compilation-warning.patch"
#	git am "${DIR}/patches/omap_fixes/0007-OMAPDSS-fix-bogus-WARN_ON-in-dss_runtime_put.patch"
#	git am "${DIR}/patches/omap_fixes/0008-OMAPDSS-DSI-Fix-bug-when-calculating-LP-command-inte.patch"
#	git am "${DIR}/patches/omap_fixes/0009-OMAPDSS-fix-registration-of-DPI-and-SDI-devices.patch"

#breaks beagle c4, needs fix..
#	git am "${DIR}/patches/omap_fixes/0001-Fix-sprz319-erratum-2.1.patch"
}

omapdrm () {
	echo "omap testing omapdrm/kms"

	#posted: 13 Mar 2012 for 3.4
	git am "${DIR}/patches/drm/0001-omap2-add-drm-device.patch"

	#might be merged in 3.4
	git am "${DIR}/patches/drm/0002-ARM-OMAP2-3-HWMOD-Add-missing-flags-for-dispc-class.patch"
	git am "${DIR}/patches/drm/0003-ARM-OMAP2-3-HWMOD-Add-missing-flag-for-rfbi-class.patch"
	git am "${DIR}/patches/drm/0004-ARM-OMAP3-HWMOD-Add-omap_hwmod_class_sysconfig-for-d.patch"
}

dsp () {
	echo "dsp patches"
	git am "${DIR}/patches/dsp/0001-dsp-add-memblock-include.patch"
}

sgx_mainline () {
	echo "patches needed for external sgx bins"
	git am "${DIR}/patches/sgx/0001-Revert-drm-kill-drm_sman.patch"
}

mainline_fixes () {
	echo "mainline patches"
	git am "${DIR}/patches/mainline-fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
}

distro
sakoman
beagle
devkit8000
panda
omap_fixes
omapdrm
dsp
sgx_mainline
mainline_fixes

echo "patch.sh ran successful"

