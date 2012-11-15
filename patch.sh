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
}

omap () {
	echo "dir: omap/sakoman"
	${git} "${DIR}/patches/omap/sakoman/0001-OMAP-DSS2-add-bootarg-for-selecting-svideo.patch"
	${git} "${DIR}/patches/omap/sakoman/0002-video-add-timings-for-hd720.patch"

	echo "dir: omap/beagle/expansion"
	${git} "${DIR}/patches/omap/beagle/expansion/0001-Beagle-expansion-add-buddy-param-for-expansionboard-.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0002-Beagle-expansion-add-zippy.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0003-Beagle-expansion-add-zippy2.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0004-Beagle-expansion-add-trainer.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0005-Beagle-expansion-add-CircuitCo-ulcd-Support.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0006-Beagle-expansion-add-wifi.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0007-Beagle-expansion-add-beaglefpga.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0008-Enable-buddy-spidev.patch"
	${git} "${DIR}/patches/omap/beagle/expansion/0009-Beagle-Camera-add-MT9P031-Aptina-image-sensor-driver.patch"

	echo "dir: omap/beagle"
	#Status: for meego guys..
	${git} "${DIR}/patches/omap/beagle/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

	${git} "${DIR}/patches/omap/beagle/0002-backlight-Add-TLC59108-backlight-control-driver.patch"
	${git} "${DIR}/patches/omap/beagle/0003-tlc59108-adjust-for-beagleboard-uLCD7.patch"

	#Status: not for upstream
	${git} "${DIR}/patches/omap/beagle/0004-zeroMAP-Open-your-eyes.patch"

	#cpufreq: only 800Mhz seems to cause hard lock... disable for now..
	${git} "${DIR}/patches/omap/beagle/0005-TEMP-Beagle-xM-cpufreq-disable-800Mhz-opp.patch"

	#With this hack, ondemand no longer, locks up the Beagle C4 on software reset...
	#CONFIG_CPU_FREQ_GOV_ONDEMAND=m
	#${git} "${DIR}/patches/omap/beagle/0006-HACK-arm-omap-beagle-c4-fix-hardlock-on-software-res.patch"

	echo "dir: omap/panda"
	#Status: not for upstream: push device tree version upstream...
	${git} "${DIR}/patches/omap/panda/0001-panda-fix-wl12xx-regulator.patch"
	#Status: unknown: cherry picked from linaro
	${git} "${DIR}/patches/omap/panda/0002-ti-st-st-kim-fixing-firmware-path.patch"

	echo "dir: omap/sgx"
	#Status: TI 4.06.00.xx needs this, when building drm modues for Xorg.
	${git} "${DIR}/patches/omap/sgx/0001-Revert-drm-kill-drm_sman.patch"

	echo "dir: omap/fixes"
	#Status: unknown: only needed when forcing mpurate over 999 using bootargs...
	${git} "${DIR}/patches/omap/fixes/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"

	#Status: unknown:
	${git} "${DIR}/patches/omap/fixes/0002-OMAPDSS-DSI-fix-dsi_get_dsidev_from_id.patch"
	${git} "${DIR}/patches/omap/fixes/0003-omapdss-dss-Fix-clocks-on-OMAP363x.patch"
	${git} "${DIR}/patches/omap/fixes/0004-OMAPDSS-HDMI-fix-missing-unlock-on-error-in-hdmi_dum.patch"

	echo "dir: omap/thermal"
	#Status: https://lkml.org/lkml/2012/11/13/341
	${git} "${DIR}/patches/omap/thermal/0001-staging-omap-thermal-fix-compilation.patch"
	${git} "${DIR}/patches/omap/thermal/0002-staging-omap-thermal-remove-platform-data-nomenclatu.patch"
	${git} "${DIR}/patches/omap/thermal/0003-staging-omap-thermal-remove-freq_clip-table.patch"
	${git} "${DIR}/patches/omap/thermal/0004-staging-omap-thermal-add-IRQ-debugging-messaging.patch"
	${git} "${DIR}/patches/omap/thermal/0005-staging-omap-thermal-fix-context-restore-function.patch"
}

sprz319_erratum () {
	echo "sprz319 erratum 2.1"
	#Breaks: Beagle C4, hardlocks on bootup...
	#Status: no response from users:
	#https://groups.google.com/forum/#!topic/beagleboard/m7DLkYMKNkg
	${git} "${DIR}/patches/omap/sprz319-erratum-2.1/0001-Fix-sprz319-erratum-2.1.patch"
}

xm_cpufreq_debug () {
	echo "debug: cpufreq"
	${git} "${DIR}/patches/debug/0001-beagle_xm-cpufreq-debug.patch"

	patch -p1 -R < "${DIR}/patches/omap/beagle/0005-TEMP-Beagle-xM-cpufreq-disable-800Mhz-opp.patch"
}

arm
omap

#disabled as it breaks beagle c4...
#sprz319_erratum

#xm_cpufreq_debug

echo "patch.sh ran successful"
