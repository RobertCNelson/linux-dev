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

	#v3.5: looks to be removed: (might want to revert it back in...)
	#http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commit;h=b6e695abe710ee1ae248463d325169efac487e17
	#git am "${DIR}/patches/beagle/0001-beagleboard-reinstate-usage-of-hi-speed-PLL-divider.patch"

	#Status: for meego guys..
	${git} "${DIR}/patches/beagle/0001-meego-modedb-add-Toshiba-LTA070B220F-800x480-support.patch"

	${git} "${DIR}/patches/beagle/0002-backlight-Add-TLC59108-backlight-control-driver.patch"
	${git} "${DIR}/patches/beagle/0003-tlc59108-adjust-for-beagleboard-uLCD7.patch"

	#Status: not for upstream
	${git} "${DIR}/patches/beagle/0004-zeroMAP-Open-your-eyes.patch"

	#cpufreq: only 800Mhz seems to cause hard lock... disable for now..
	${git} "${DIR}/patches/beagle/0005-TEMP-Beagle-xM-cpufreq-disable-800Mhz-opp.patch"
}

sprz319_erratum () {
	echo "sprz319 erratum 2.1"
	#Breaks: Beagle C4, hardlocks on bootup...
	#Status: no response from users:
	#https://groups.google.com/forum/#!topic/beagleboard/m7DLkYMKNkg
	${git} "${DIR}/patches/sprz319-erratum-2.1/0001-Fix-sprz319-erratum-2.1.patch"
}

panda () {
	echo "Board Patches for: PandaBoard"
	#Status: not for upstream: push device tree version upstream...
	${git} "${DIR}/patches/panda/0001-panda-fix-wl12xx-regulator.patch"
	#Status: unknown: cherry picked from linaro
	${git} "${DIR}/patches/panda/0002-ti-st-st-kim-fixing-firmware-path.patch"

	#Status: https://lkml.org/lkml/2012/9/11/303
	${git} "${DIR}/patches/panda/0003-staging-omap-thermal-Correct-checkpatch.pl-warnings.patch"
	${git} "${DIR}/patches/panda/0004-staging-omap-thermal-remove-checkpatch.pl-warnings-o.patch"
	${git} "${DIR}/patches/panda/0005-staging-omap-thermal-fix-polling-period-settings.patch"
	${git} "${DIR}/patches/panda/0006-staging-omap-thermal-improve-conf-data-handling-and-.patch"
}

omap_fixes () {
	echo "omap cherry pick fixes"
	#Status: unknown: only needed when forcing mpurate over 999 using bootargs...
	${git} "${DIR}/patches/omap_fixes/0001-omap3-Increase-limit-on-bootarg-mpurate.patch"
	#Status: unknown: seem to be dropped after v3.4-rc-fixes request
	${git} "${DIR}/patches/omap_fixes/0002-OMAP2-UART-enable-tx-wakeup-bit-for-wer-reg.patch"
	${git} "${DIR}/patches/omap_fixes/0003-OMAP2-UART-replace-omap34xx-omap4xx-cpu-checks-with-.patch"
}

sgx () {
	echo "patches needed for external sgx bins"
	#Status: TI 4.06.00.xx needs this
	${git} "${DIR}/patches/sgx/0001-Revert-drm-kill-drm_sman.patch"
}

mainline_fixes () {
	echo "mainline patches"
	#Status: v2 Review:
	#http://lists.infradead.org/pipermail/linux-arm-kernel/2012-August/112440.html
	${git} "${DIR}/patches/mainline-fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
	#Status:
	#http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=shortlog;h=refs/heads/devel-dt
	${git} "${DIR}/patches/mainline-fixes/0002-ARM-omap-add-dtb-targets.patch"
}

debug () {
	echo "debug: cpufreq"
	${git} "${DIR}/patches/debug/0001-beagle_xm-cpufreq-debug.patch"
}

pm () {
	echo "omap: pm patches"
	#git pull git://gitorious.org/~kristo/omap-pm/omap-pm-work.git mainline-3.6-rc5-omap-auto-ret-v7

	${git} "${DIR}/patches/pm/0001-ARM-OMAP4-hwmod-flag-hwmods-modules-not-supporting-m.patch"
	${git} "${DIR}/patches/pm/0002-ARM-OMAP-hwmod-Add-support-for-per-hwmod-module-cont.patch"
	${git} "${DIR}/patches/pm/0003-ARM-OMAP4-powerdomain-add-support-for-reading-prev-l.patch"

	#in 3.6-rc7
	#${git} "${DIR}/patches/pm/0004-ARM-OMAP4-hwmod-data-temporarily-comment-out-data-fo.patch"

	${git} "${DIR}/patches/pm/0005-ARM-OMAP4-HWMOD-add-support-for-lostcontext_mask.patch"
	${git} "${DIR}/patches/pm/0006-ARM-OMAP2-PM-introduce-power-domains-functional-stat.patch"
	${git} "${DIR}/patches/pm/0007-ARM-OMAP2-PM-add-a-lock-to-protect-the-powerdomains-.patch"
	${git} "${DIR}/patches/pm/0008-ARM-OMAP2-PM-use-the-functional-power-states-API.patch"
	${git} "${DIR}/patches/pm/0009-ARM-OMAP2-PM-use-power-domain-functional-state-in-st.patch"
	${git} "${DIR}/patches/pm/0010-ARM-OMAP2-PM-debug-trace-the-functional-power-domain.patch"
	${git} "${DIR}/patches/pm/0011-ARM-OMAP2-powerdomain-add-error-logs.patch"
	${git} "${DIR}/patches/pm/0012-ARM-OMAP2-PM-reorganize-the-powerdomain-API-in-publi.patch"
	${git} "${DIR}/patches/pm/0013-ARM-OMAP-PM-update-target-fpwrst-to-what-pwrdm-can-r.patch"
	${git} "${DIR}/patches/pm/0014-ARM-OMAP4-PM-add-errata-support.patch"
	${git} "${DIR}/patches/pm/0015-ARM-OMAP4460-Workaround-for-ROM-bug-because-of-CA9-r.patch"
	${git} "${DIR}/patches/pm/0016-ARM-OMAP4-suspend-Program-all-domains-to-retention.patch"
	${git} "${DIR}/patches/pm/0017-ARM-OMAP4-PM-put-all-domains-to-OSWR-during-suspend.patch"
	${git} "${DIR}/patches/pm/0018-ARM-OMAP4-retrigger-localtimers-after-re-enabling-gi.patch"
	${git} "${DIR}/patches/pm/0019-ARM-OMAP-clockdomain-Fix-locking-on-_clkdm_clk_hwmod.patch"
	${git} "${DIR}/patches/pm/0020-ARM-OMAP3-voltage-pwrdm-clkdm-clock-add-recursive-us.patch"
	${git} "${DIR}/patches/pm/0021-ARM-OMAP3-voltage-add-support-for-voltagedomain-usec.patch"
	${git} "${DIR}/patches/pm/0022-ARM-OMAP3-add-manual-control-for-mpu-core-pwrdm-usec.patch"
	${git} "${DIR}/patches/pm/0023-ARM-OMAP3-set-autoidle-flag-for-sdrc_ick.patch"
	${git} "${DIR}/patches/pm/0024-ARM-OMAP-clockdomain-add-support-for-preventing-auto.patch"
	${git} "${DIR}/patches/pm/0025-ARM-OMAP3-do-not-delete-per_clkdm-autodeps-during-id.patch"
	${git} "${DIR}/patches/pm/0026-ARM-OMAP4-clock-data-set-autoidle-flag-for-dss_fck.patch"
	${git} "${DIR}/patches/pm/0027-ARM-OMAP4-hwmod-add-support-for-hwmod-autoidle-flag.patch"
	${git} "${DIR}/patches/pm/0028-ARM-OMAP4-hwmod-data-set-mpu-hwmod-modulemode-to-hwa.patch"
	${git} "${DIR}/patches/pm/0029-ARM-OMAP4-clock-data-flag-hw-controlled-clocks-as-au.patch"
	${git} "${DIR}/patches/pm/0030-ARM-OMAP3-PM-VP-use-uV-for-max-and-min-voltage-limit.patch"
	${git} "${DIR}/patches/pm/0031-ARM-OMAP-voltage-renamed-vp_vddmin-and-vp_vddmax-fie.patch"
	${git} "${DIR}/patches/pm/0032-ARM-OMAP3-voltage-introduce-omap-vc-vp-params-for-vo.patch"
	${git} "${DIR}/patches/pm/0033-ARM-OMAP3-VC-calculate-ramp-times.patch"
	${git} "${DIR}/patches/pm/0034-ARM-OMAP4-voltage-add-support-for-VOLTSETUP_x_OFF-re.patch"
	${git} "${DIR}/patches/pm/0035-ARM-OMAP4-VC-calculate-ramp-times.patch"
	${git} "${DIR}/patches/pm/0036-ARM-OMAP-add-support-for-oscillator-setup.patch"
	${git} "${DIR}/patches/pm/0037-ARM-OMAP3-vp-use-new-vp_params-for-calculating-vddmi.patch"
	${git} "${DIR}/patches/pm/0038-ARM-OMAP3-voltage-use-oscillator-data-to-calculate-s.patch"
	${git} "${DIR}/patches/pm/0039-ARM-OMAP-TWL-change-the-vddmin-vddmax-voltages-to-sp.patch"
	${git} "${DIR}/patches/pm/0040-TEMP-ARM-OMAP3-beagle-rev-c4-enable-OPP6.patch"
	${git} "${DIR}/patches/pm/0041-ARM-OMAP-beagle-set-oscillator-startup-time-to-10ms-.patch"
	${git} "${DIR}/patches/pm/0042-ARM-OMAP3-vc-auto_ret-auto_off-support.patch"
	${git} "${DIR}/patches/pm/0043-ARM-OMAP3-voltage-remove-unused-volt_setup_time-para.patch"
	${git} "${DIR}/patches/pm/0044-ARM-OMAP4-vc-fix-channel-configuration.patch"
	${git} "${DIR}/patches/pm/0045-ARM-OMAP4-VC-setup-I2C-parameters-based-on-board-dat.patch"
	${git} "${DIR}/patches/pm/0046-ARM-OMAP4-TWL-enable-high-speed-mode-for-PMIC-commun.patch"
	${git} "${DIR}/patches/pm/0047-ARM-OMAP4-OPP-add-OMAP4460-definitions.patch"
	${git} "${DIR}/patches/pm/0048-ARM-OMAP3-PM-introduce-a-central-pmic-control.patch"
	${git} "${DIR}/patches/pm/0049-ARM-OMAP2-PM-Add-support-for-TPS62361.patch"
	${git} "${DIR}/patches/pm/0050-ARM-OMAP4-vc-auto-retention-support.patch"
}

distro
sakoman
beagle

#disabled as it breaks beagle c4...
#sprz319_erratum

panda
omap_fixes
sgx
mainline_fixes
#debug
#pm

echo "patch.sh ran successful"

