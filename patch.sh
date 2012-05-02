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
	git format-patch -7
	exit
}

distro () {
	echo "Distro Specific Patches"
	git am "${DIR}/patches/distro/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

micrel_zippy2 () {
	echo "Micrel KZ8851 patches for: zippy2"
	#originaly from:
	#ftp://www.micrel.com/ethernet/8851/beagle_zippy_patches.tar.gz 137 KB 04/10/2010 12:26:00 AM

	git am "${DIR}/patches/micrel_zippy2/0001-ks8851.h-it-helps-to-include-the-include-file.patch"
	git am "${DIR}/patches/micrel_zippy2/0002-ksz8851-move-to-header.patch"
	git am "${DIR}/patches/micrel_zippy2/0003-ksz8851-move-more-to-header.patch"
	git am "${DIR}/patches/micrel_zippy2/0004-ksz8851-share-ks8851_tx_hdr-union.patch"
	git am "${DIR}/patches/micrel_zippy2/0005-ksz8851-add-is_level_irq.patch"
	git am "${DIR}/patches/micrel_zippy2/0006-ksz8851-turn-off-hardware-interrupt-druing-receive-p.patch"
	git am "${DIR}/patches/micrel_zippy2/0007-ksz8851-add-ks8851_tx_check.patch"
}

sakoman () {
	echo "Patches from: Sakoman git tree"
	git am "${DIR}/patches/sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	git am "${DIR}/patches/sakoman/0002-video-add-timings-for-hd720.patch"
	git am "${DIR}/patches/sakoman/0003-omap-mmc-Adjust-dto-to-eliminate-timeout-errors.patch"
}


beagle () {
	echo "Board Patches for: BeagleBoard"

	git am "${DIR}/patches/beagle/expansion/0001-expansion-add-buddy-param-for-expansionboard-names.patch"
	git am "${DIR}/patches/beagle/expansion/0002-expansion-add-mmc-regulator-and-ds1307-rtc.patch"
	git am "${DIR}/patches/beagle/expansion/0003-expansion-add-zippy.patch"
	git am "${DIR}/patches/beagle/expansion/0004-expansion-add-zippy2.patch"
	git am "${DIR}/patches/beagle/expansion/0005-expansion-add-trainer.patch"
	git am "${DIR}/patches/beagle/expansion/0006-expansion-add-CircuitCo-ulcd-Support.patch"

#changes need to be ported to the 3.4-rc..
#	git am "${DIR}/patches/beagle/expansion/0007-expansion-add-wifi.patch"

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
	git am "${DIR}/patches/panda/0002-panda-enable-bluetooth.patch"
	git am "${DIR}/patches/panda/0003-ti-st-st-kim-fixing-firmware-path.patch"
}

omap_fixes () {
	echo "omap cherry pick fixes"
	git am "${DIR}/patches/omap_fixes/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
	git am "${DIR}/patches/omap_fixes/0002-OMAP2-UART-Remove-cpu-checks-for-populating-errata-f.patch"
	git am "${DIR}/patches/omap_fixes/0003-OMAP2-UART-enable-tx-wakeup-bit-for-wer-reg.patch"
	git am "${DIR}/patches/omap_fixes/0004-OMAP2-UART-replace-omap34xx-omap4xx-cpu-checks-with-.patch"
	git am "${DIR}/patches/omap_fixes/0005-mfd-cpu_is_omap3430-wasnt-defined.patch"

#breaks beagle c4, needs fix..
#	git am "${DIR}/patches/omap_fixes/0001-Fix-sprz319-erratum-2.1.patch"
}

omapdrm () {
	echo "omap testing omapdrm/kms"

	echo "Patches for 3.4-rc1-cma-v24"
	#git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git 3.4-rc1-cma-v24
	git am "${DIR}/patches/drm/cma/0001-mm-page_alloc-remove-trailing-whitespace.patch"
	git am "${DIR}/patches/drm/cma/0002-mm-compaction-introduce-isolate_migratepages_range.patch"
	git am "${DIR}/patches/drm/cma/0003-mm-compaction-introduce-map_pages.patch"
	git am "${DIR}/patches/drm/cma/0004-mm-compaction-introduce-isolate_freepages_range.patch"
	git am "${DIR}/patches/drm/cma/0005-mm-compaction-export-some-of-the-functions.patch"
	git am "${DIR}/patches/drm/cma/0006-mm-page_alloc-introduce-alloc_contig_range.patch"
	git am "${DIR}/patches/drm/cma/0007-mm-page_alloc-change-fallbacks-array-handling.patch"
	git am "${DIR}/patches/drm/cma/0008-mm-mmzone-MIGRATE_CMA-migration-type-added.patch"
	git am "${DIR}/patches/drm/cma/0009-mm-page_isolation-MIGRATE_CMA-isolation-functions-ad.patch"
	git am "${DIR}/patches/drm/cma/0010-mm-Serialize-access-to-min_free_kbytes.patch"
	git am "${DIR}/patches/drm/cma/0011-mm-extract-reclaim-code-from-__alloc_pages_direct_re.patch"
	git am "${DIR}/patches/drm/cma/0012-mm-trigger-page-reclaim-in-alloc_contig_range-to-sta.patch"
	git am "${DIR}/patches/drm/cma/0013-drivers-add-Contiguous-Memory-Allocator.patch"
	git am "${DIR}/patches/drm/cma/0014-X86-integrate-CMA-with-DMA-mapping-subsystem.patch"
	git am "${DIR}/patches/drm/cma/0015-ARM-integrate-CMA-with-DMA-mapping-subsystem.patch"

	#posted: 13 Mar 2012 for 3.4
	git am "${DIR}/patches/drm/0001-omap2-add-drm-device.patch"

	#might be merged in 3.4
	git am "${DIR}/patches/drm/0002-ARM-OMAP2-3-HWMOD-Add-missing-flags-for-dispc-class.patch"
	git am "${DIR}/patches/drm/0003-ARM-OMAP2-3-HWMOD-Add-missing-flag-for-rfbi-class.patch"
	git am "${DIR}/patches/drm/0004-ARM-OMAP3-HWMOD-Add-omap_hwmod_class_sysconfig-for-d.patch"
}

distro
micrel_zippy2
sakoman
beagle
devkit8000
panda
omap_fixes
omapdrm

echo "patch.sh ran successful"

