#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"

#Bisected from 2.6.35 -> 2.6.36 to find this..
#This commit breaks some lcd monitors..
#rcn-ee Feb 26, 2011...
#Still needs more work for 2.6.38, causes:
#[   14.962829] omapdss DISPC error: GFX_FIFO_UNDERFLOW, disabling GFX
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-OMAP-DSS2-OMAPFB-swap-front-and-back-porches-.patch"

patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"

#should fix gcc-4.6 ehci problems..
patch -s -p1 < "${DIR}/patches/trivial/0001-USB-ehci-use-packed-aligned-4-instead-of-removing-th.patch"

#3.1-rc3, serial broken, probally will be revert later..
#fixed with 3.1-rc4
#patch -s -p1 < "${DIR}/patches/trivial/0001-Revert-irq-Always-set-IRQF_ONESHOT-if-no-primary-han.patch"

#3.1-merge-to-v3.2-rc0

#patch -s -p1 < "${DIR}/patches/trivial/0001-ARM-OMAP-fix-omap2plus_defconfig-with-OMAP2-disabled.patch"
#patch -s -p1 < "${DIR}/patches/trivial/0001-trivial-drivers-mmc-omap-add-missing.patch"

}

function cpufreq {
echo "[git] omap-cpufreq"
git pull git://github.com/RobertCNelson/linux.git omap_cpufreq_v3.2-rc3
}

function micrel {
echo "[git] Micrel KZ8851 patches for: zippy2"
#original from:
#ftp://www.micrel.com/ethernet/8851/beagle_zippy_patches.tar.gz 137 KB 04/10/2010 12:26:00 AM
git pull git://github.com/RobertCNelson/linux.git micrel_ks8851_v3.2-rc3
}

function beagle {
echo "[git] Board Patches for: BeagleBoard"
git pull git://github.com/RobertCNelson/linux.git omap_beagle_expansion_v3.2-rc3

patch -s -p1 < "${DIR}/patches/arago-project/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
patch -s -p1 < "${DIR}/patches/display/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"
}

function dspbridge {
echo "[git] dspbridge"
git pull git://github.com/RobertCNelson/linux.git dspbridge_v3.2-rc3
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
#patch -s -p1 < "${DIR}/patches/touchbook/0001-touchbook-add-madc.patch"
#patch -s -p1 < "${DIR}/patches/touchbook/0002-touchbook-add-twl4030-bci-battery.patch"
}

function dspbridge {
echo "dspbridge fixes"
#broken in 3.0-git5
#drivers/staging/tidspbridge/core/dsp-clock.c: In function ‘dsp_clk_enable’:
#drivers/staging/tidspbridge/core/dsp-clock.c:212:3: error: implicit declaration of function ‘omap_mcbsp_set_io_type’
#drivers/staging/tidspbridge/core/dsp-clock.c:212:42: error: ‘OMAP_MCBSP_POLL_IO’ undeclared (first use in this function)
#drivers/staging/tidspbridge/core/dsp-clock.c:212:42: note: each undeclared identifier is reported only once for each function it appears in
#make[3]: *** [drivers/staging/tidspbridge/core/dsp-clock.o] Error 1
#make[2]: *** [drivers/staging/tidspbridge] Error 2
#patch -s -p1 < "${DIR}/patches/dspbridge/0001-Revert-omap-mcbsp-Remove-port-number-enums.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0002-Revert-omap-mcbsp-Remove-rx_-tx_word_length-variable.patch"
#patch -s -p1 < "${DIR}/patches/dspbridge/0003-Revert-omap-mcbsp-Drop-in-driver-transfer-support.patch"
#fixed with 3.1-rc4
}

function omap4 {
echo "omap4 related patches"
#drop with 3.0-git16
#patch -s -p1 < "${DIR}/patches/panda/0001-OMAP4-DSS2-add-dss_dss_clk.patch"
patch -s -p1 < "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
}

bugs_trivial

#patches in git
cpufreq
micrel
beagle
dspbridge

#work in progress

#external tree's
sakoman
musb

#random board patches
devkit8000
touchbook
dspbridge

#omap4/dvfs still needs more testing..
omap4

echo "patch.sh ran successful"

