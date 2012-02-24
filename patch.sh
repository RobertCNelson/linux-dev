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

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-Fix-link-to-headers-in-make-deb-pkg.patch"
}

function cpufreq {
echo "[git] omap-cpufreq"
#git pull git://github.com/RobertCNelson/linux.git omap_cpufreq_v3.2-rc4
}

function micrel {
echo "[git] Micrel KZ8851 patches for: zippy2"
#original from:
#ftp://www.micrel.com/ethernet/8851/beagle_zippy_patches.tar.gz 137 KB 04/10/2010 12:26:00 AM
git pull git://github.com/RobertCNelson/linux.git micrel_ks8851_v3.3-rc1
}

function beagle {
echo "[git] Board Patches for: BeagleBoard"
git pull git://github.com/RobertCNelson/linux.git omap_beagle_expansion_v3.3-rc1

patch -s -p1 < "${DIR}/patches/arago-project/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
patch -s -p1 < "${DIR}/patches/display/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

patch -s -p1 < "${DIR}/patches/beagle/0001-ASoC-omap-add-MODULE_ALIAS-to-mcbsp-and-pcm-drivers.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-ASoC-omap-convert-per-board-modules-to-platform-driv.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-beagleboard-reinstate-usage-of-hi-speed-PLL-divider.patch"

patch -s -p1 < "${DIR}/patches/beagle/ulcd/0001-ulcd-add-tlc59108-i2c-device.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-beagle-tsc2007-might-not-be-in-customer-config.patch"

patch -s -p1 < "${DIR}/patches/beagle/0001-ARM-OMAP3-clock-data-fill-in-some-missing-clockdomai.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-Turn-on-the-USB-regulator-on-Beagle-xM-explicitly-wh.patch"
patch -s -p1 < "${DIR}/patches/beagle/0001-ARM-OMAP3-USB-Fix-the-EHCI-ULPI-PHY-reset-issue.patch"
}

function dspbridge {
echo "[git] dspbridge"
git pull git://github.com/RobertCNelson/linux.git dspbridge_v3.2-rc3
}

function omapdrm {
echo "[git] testing omapdrm"
echo "[git] pulling cma driver"
git pull git://github.com/RobertCNelson/linux.git cma-v22_v3.3-rc4

echo "[git] pulling omapdrm driver"
git pull git://github.com/RobertCNelson/linux.git omapdrm_v3.3-rc4

#might be merged in 3.4
git am "${DIR}/patches/drm/0001-ARM-OMAP2-3-HWMOD-Add-missing-flags-for-dispc-class.patch"
git am "${DIR}/patches/drm/0002-ARM-OMAP2-3-HWMOD-Add-missing-flag-for-rfbi-class.patch"
git am "${DIR}/patches/drm/0003-ARM-OMAP3-HWMOD-Add-omap_hwmod_class_sysconfig-for-d.patch"

}

function sakoman {
echo "sakoman's patches"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0006-OMAP-DSS2-add-bootarg-for-selecting-svideo-or-compos.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0007-video-add-timings-for-hd720.patch"

patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0025-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
patch -s -p1 < "${DIR}/patches/sakoman/2.6.39/0026-OMAP-Overo-Add-support-for-spidev.patch"
}

function musb {
echo "musb patches"
patch -s -p1 < "${DIR}/patches/musb/0001-default-to-fifo-mode-5-for-old-musb-beagles.patch"
}

function devkit8000 {
echo "devkit8000"
patch -s -p1 < "${DIR}/patches/devkit8000/0001-arm-omap-devkit8000-for-lcd-use-samsung_lte_panel-2.6.37-git10.patch"
}

function touchbook {
echo "touchbook patches"
patch -s -p1 < "${DIR}/patches/touchbook/0001-omap3-touchbook-remove-mmc-gpio_wp.patch"
patch -s -p1 < "${DIR}/patches/touchbook/0002-omap3-touchbook-drop-u-boot-readonly.patch"
}

function omap4 {
echo "omap4 related patches"
patch -s -p1 < "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
patch -s -p1 < "${DIR}/patches/panda/0001-ARM-OMAP-enable-Bluetooth-on-the-PandaBoard.patch"
}

function fixes {
echo "generic fixes"

git am "${DIR}/patches/fixes/0001-OMAP-UART-Enable-tx-wakeup-bit-in-wer.patch"

}

bugs_trivial

#patches in git
#cpufreq
micrel
beagle
#dspbridge
omapdrm

#work in progress

#external tree's
sakoman
musb

#random board patches
devkit8000
touchbook

#omap4/dvfs still needs more testing..
omap4

fixes

echo "patch.sh ran successful"

