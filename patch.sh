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

devel_dt () {
	echo "Patches from: devel-dt"
	${git} "${DIR}/patches/devel-dt/0001-arm-dts-omap5-Add-mmc-controller-nodes-and-board-dat.patch"
	${git} "${DIR}/patches/devel-dt/0002-arm-dts-AM33XX-Set-the-default-status-of-module-to-d.patch"
	${git} "${DIR}/patches/devel-dt/0003-ARM-omap-add-dtb-targets.patch"
	${git} "${DIR}/patches/devel-dt/0004-arm-dts-Cleanup-regulator-naming-and-remove-0-1.patch"
	${git} "${DIR}/patches/devel-dt/0005-arm-dts-regulator-Add-tps65910-device-tree-data.patch"
	${git} "${DIR}/patches/devel-dt/0006-arm-dts-regulator-Add-tps65217-device-tree-data.patch"
	${git} "${DIR}/patches/devel-dt/0007-arm-dts-Add-tps65910-regulator-DT-data-to-am335x-evm.patch"
	${git} "${DIR}/patches/devel-dt/0008-arm-dts-Add-tps65217-regulator-DT-data-to-am335x-bon.patch"
	${git} "${DIR}/patches/devel-dt/0009-ARM-OMAP-omap_device-Fix-up-resource-names-when-boot.patch"
	${git} "${DIR}/patches/devel-dt/0010-ARM-OMAP-omap_device-Do-not-overwrite-resources-allo.patch"
	${git} "${DIR}/patches/devel-dt/0011-ARM-dts-omap5-evm-Add-I2C-support.patch"
	${git} "${DIR}/patches/devel-dt/0012-ARM-dts-omap5-evm-Add-tmp102-sensor-support.patch"
	${git} "${DIR}/patches/devel-dt/0013-ARM-dts-omap5-evm-Add-keypad-data.patch"
	${git} "${DIR}/patches/devel-dt/0014-ARM-dts-omap5-evm-Add-bmp085-sensor-support.patch"
	${git} "${DIR}/patches/devel-dt/0015-ARM-dts-omap4-sdp-Add-keypad-data.patch"
	${git} "${DIR}/patches/devel-dt/0016-Documentation-dt-i2c-trivial-devices-Update-for-tmp1.patch"
	${git} "${DIR}/patches/devel-dt/0017-Documentation-dt-device-tree-bindings-for-LPDDR2-mem.patch"
	${git} "${DIR}/patches/devel-dt/0018-Documentation-dt-emif-device-tree-bindings-for-TI-s-.patch"
	${git} "${DIR}/patches/devel-dt/0019-ARM-dts-EMIF-and-LPDDR2-device-tree-data-for-OMAP4-b.patch"
	${git} "${DIR}/patches/devel-dt/0020-ARM-OMAP4-Add-L2-Cache-Controller-in-Device-Tree.patch"
	${git} "${DIR}/patches/devel-dt/0021-ARM-OMAP4-Add-local-timer-support-for-Device-Tree.patch"
	${git} "${DIR}/patches/devel-dt/0022-ARM-dts-OMAP4-Cleanup-and-move-GIC-outside-of-the-OC.patch"
	${git} "${DIR}/patches/devel-dt/0023-gpio-twl4030-get-platform-data-from-device-tree.patch"
	${git} "${DIR}/patches/devel-dt/0024-ARM-dts-omap3-Add-gpio-twl4030-properties-for-Beagle.patch"
	${git} "${DIR}/patches/devel-dt/0025-ARM-dts-omap3-beagle-Add-heartbeat-and-mmc-LEDs-supp.patch"
	${git} "${DIR}/patches/devel-dt/0026-ARM-dts-omap2-Add-McBSP-entries-for-OMAP2420-and-OMA.patch"
	${git} "${DIR}/patches/devel-dt/0027-ARM-dts-omap2420-h4-Include-omap2420.dtsi-file-inste.patch"
	${git} "${DIR}/patches/devel-dt/0028-ARM-dts-omap3-Add-McBSP-entries.patch"
	${git} "${DIR}/patches/devel-dt/0029-ARM-dts-omap4-Add-McBSP-entries.patch"
	${git} "${DIR}/patches/devel-dt/0030-ARM-dts-omap4-Add-reg-names-for-McPDM-and-DMIC.patch"
	${git} "${DIR}/patches/devel-dt/0031-ARM-dts-omap5-Add-McBSP-entries.patch"
	${git} "${DIR}/patches/devel-dt/0032-ARM-dts-omap5-Add-McPDM-and-DMIC-section-to-the-dtsi.patch"
	${git} "${DIR}/patches/devel-dt/0033-ARM-dts-omap3-beagle-Enable-audio-support.patch"
	${git} "${DIR}/patches/devel-dt/0034-ARM-dts-AM33XX-Convert-all-hex-numbers-to-lower-case.patch"
	${git} "${DIR}/patches/devel-dt/0035-ARM-dts-AM33XX-Specify-reg-and-interrupt-property-fo.patch"
	${git} "${DIR}/patches/devel-dt/0036-ARM-dts-OMAP4-Add-reg-and-interrupts-for-every-nodes.patch"
	${git} "${DIR}/patches/devel-dt/0037-ARM-dts-OMAP3-Add-support-for-Gumstix-Overo-with-Tob.patch"
	${git} "${DIR}/patches/devel-dt/0038-Documentation-dt-Update-the-OMAP-documentation-with-.patch"
	${git} "${DIR}/patches/devel-dt/0039-ARM-dts-omap3-overo-Add-support-for-the-blue-LED.patch"
	${git} "${DIR}/patches/devel-dt/0040-arm-dts-Add-omap36xx.dtsi-file-and-rename-omap3-beag.patch"
	${git} "${DIR}/patches/devel-dt/0041-arm-dts-Add-pinctrl-driver-entries-for-omap2-3-4.patch"
	${git} "${DIR}/patches/devel-dt/0042-ARM-OMAP2-select-PINCTRL-in-Kconfig.patch"
	${git} "${DIR}/patches/devel-dt/0043-arm-dts-Mux-uart-pins-for-omap4-sdp.patch"
}

vaibhav () {
	echo "Patches from: vaibhav"
	${git} "${DIR}/patches/vaibhav/0001-ARM-OMAP2-hwmod-Hook-up-am33xx-support-in-omap_hwmod.patch"
	${git} "${DIR}/patches/vaibhav/0002-ARM-OMAP3-hwmod-Add-AM33XX-HWMOD-data.patch"
	${git} "${DIR}/patches/vaibhav/0003-ARM-OMAP2-dpll-Add-missing-soc_is_am33xx-check-for-c.patch"
	${git} "${DIR}/patches/vaibhav/0004-ARM-AM33XX-clock-Add-dcan-clock-aliases-for-device-t.patch"
	${git} "${DIR}/patches/vaibhav/0005-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	${git} "${DIR}/patches/vaibhav/0006-CUSTOM-Enable-APPENDED_DTB-ATAG_DTB_COMPAT-option-in.patch"
	${git} "${DIR}/patches/vaibhav/0007-ARM-OMAP2-irq-Increase-no-of-supported-interrupts-to.patch"
	${git} "${DIR}/patches/vaibhav/0008-ARM-OMAP2-AM335x-hwmod-do-not-reset-GPIO0.patch"
}

net_next_am335x () {
	echo "Patches from: net-next-am335x"
	${git} "${DIR}/patches/net-next-am335x/0001-drivers-net-ethernet-cpsw-Add-SOC-dependency-support.patch"
	${git} "${DIR}/patches/net-next-am335x/0002-drivers-net-ethernet-cpsw-Add-device-tree-support-to.patch"
	${git} "${DIR}/patches/net-next-am335x/0003-drivers-net-ethernet-davince_mdio-device-tree-implem.patch"
	${git} "${DIR}/patches/net-next-am335x/0004-documentation-dt-bindings-cpsw-fixing-the-examples-f.patch"
}

cpsw () {
	echo "Patches from: cpsw"
	${git} "${DIR}/patches/cpsw/0001-ARM-OMAP3-hwmod-Add-AM33XX-HWMOD-data-for-davinci_md.patch"
	${git} "${DIR}/patches/cpsw/0002-net-davinci_mdio-Fix-type-mistake-in-calling-runtime.patch"
	${git} "${DIR}/patches/cpsw/0003-net-cpsw-Add-parent-child-relation-support-between-c.patch"
	${git} "${DIR}/patches/cpsw/0004-arm-dts-am33xx-Add-cpsw-and-mdio-module-nodes-for-AM.patch"
}

usb () {
	echo "Patches from: usb"
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

pinctrl () {
	echo "Patches from: pinctrl"
	${git} "${DIR}/patches/pinctrl/0001-leds-leds-gpio-adopt-pinctrl-support.patch"
	${git} "${DIR}/patches/pinctrl/0002-arm-dts-AM33XX-Add-basic-pinctrl-device-tree-data.patch"
	${git} "${DIR}/patches/pinctrl/0003-arm-dts-AM33XX-Configure-pinmuxs-for-user-leds-contr.patch"
	${git} "${DIR}/patches/pinctrl/0004-beaglebone-DT-set-default-triggers-for-LEDS.patch"
	${git} "${DIR}/patches/pinctrl/0005-pinctrl-pinctrl-single-add-debugfs-pin-h-w-state-inf.patch"
}

rtc () {
	echo "Patches from: rtc"
	${git} "${DIR}/patches/rtc/0001-arm-dts-am33xx-wdt-node.patch"
	${git} "${DIR}/patches/rtc/0002-rtc-omap-kicker-mechanism-support.patch"
	${git} "${DIR}/patches/rtc/0003-ARM-davinci-remove-rtc-kicker-release.patch"
	${git} "${DIR}/patches/rtc/0004-rtc-omap-dt-support.patch"
	${git} "${DIR}/patches/rtc/0005-rtc-omap-depend-on-am33xx.patch"
	${git} "${DIR}/patches/rtc/0006-rtc-omap-Add-runtime-pm-support.patch"
	${git} "${DIR}/patches/rtc/0007-arm-dts-am33xx-rtc-node.patch"
}

mmc () {
	echo "Patches from: mmc"
	${git} "${DIR}/patches/mmc/0001-am33xx.dtsi-add-mmc.patch"
}

da8xx_fb () {
	echo "Patches from: da8xx_fb"
	${git} "${DIR}/patches/da8xx-fb/0001-da8xx-fb-allow-frame-to-complete-after-disabling-LCD.patch"
	${git} "${DIR}/patches/da8xx-fb/0002-da8xx-fb-enable-LCDC-if-FB-is-unblanked.patch"
	${git} "${DIR}/patches/da8xx-fb/0003-da8xx-fb-add-pm_runtime-support.patch"
}

fixes () {
	echo "Patches from: fixes"
	${git} "${DIR}/patches/fixes/0001-am33xx.dtsi-remove-duplicate-wdt-node-merge-error.patch"
	${git} "${DIR}/patches/fixes/0002-regulator-core-Try-using-the-parent-device-for-the-d.patch"
	${git} "${DIR}/patches/fixes/0003-ARM-dts-AM33XX-fix-gpio-node-numbering-to-match-hard.patch"
	${git} "${DIR}/patches/fixes/0004-ARM-dts-AM33XX-adjust-leds-to-use-the-corrected-gpio.patch"
}

cpufreq () {
	echo "Patches from: cpufreq"
	${git} "${DIR}/patches/cpufreq/0001-regulator-add-a-new-API-regulator_set_voltage_tol.patch"
	${git} "${DIR}/patches/cpufreq/0002-ARM-add-cpufreq-transiton-notifier-to-adjust-loops_p.patch"
	${git} "${DIR}/patches/cpufreq/0003-PM-OPP-Initialize-OPP-table-from-device-tree.patch"
	${git} "${DIR}/patches/cpufreq/0004-cpufreq-Add-a-generic-cpufreq-cpu0-driver.patch"
	${git} "${DIR}/patches/cpufreq/0005-ARM-OMAP2-AM33XX-Add-clock-entries-to-omap_clk-data.patch"
	${git} "${DIR}/patches/cpufreq/0006-arm-dts-AM33XX-Add-device-tree-OPP-table.patch"
}

spi () {
	echo "Patches from: spi"
	${git} "${DIR}/patches/spi/0001-arm-dts-AM33XX-Add-SPI-device-tree-data.patch"
}

adc () {
	echo "Patches from: adc"
	${git} "${DIR}/patches/adc/0001-input-TSC-ti_tscadc-Correct-register-usage.patch"
	${git} "${DIR}/patches/adc/0002-input-TSC-ti_tscadc-Add-Step-configuration-as-platfo.patch"
	${git} "${DIR}/patches/adc/0003-input-TSC-ti_tscadc-set-FIFO0-threshold-Interrupt.patch"
	${git} "${DIR}/patches/adc/0004-input-TSC-ti_tscadc-Remove-definition-of-End-Of-Inte.patch"
	${git} "${DIR}/patches/adc/0005-input-TSC-ti_tscadc-Rename-the-existing-touchscreen-.patch"
	${git} "${DIR}/patches/adc/0006-MFD-ti_tscadc-Add-support-for-TI-s-TSC-ADC-MFDevice.patch"
	${git} "${DIR}/patches/adc/0007-input-TSC-ti_tsc-Convert-TSC-into-a-MFDevice.patch"
	${git} "${DIR}/patches/adc/0008-IIO-ADC-tiadc-Add-support-of-TI-s-ADC-driver.patch"
	${git} "${DIR}/patches/adc/0009-MFD-ti_tscadc-add-suspend-resume-functionality.patch"
	${git} "${DIR}/patches/adc/0010-MFD-TI-tsadc-adjust-to-new-mfd-API.patch"
}

dma () {
	echo "Patches from: dma"
	${git} "${DIR}/patches/dma/0001-dmaengine-add-TI-EDMA-DMA-engine-driver.patch"
	${git} "${DIR}/patches/dma/0002-ARM-davinci-move-private-EDMA-API-to-arm-common.patch"
	${git} "${DIR}/patches/dma/0003-ARM-edma-remove-unused-transfer-controller-handlers.patch"
	${git} "${DIR}/patches/dma/0004-ARM-edma-add-support-for-AM335x.patch"
	${git} "${DIR}/patches/dma/0005-dmaengine-edma-enable-build-for-AM335x.patch"
	${git} "${DIR}/patches/dma/0006-ARM-omap-hwmod-prevent-the-am33xx-edma-from-idling.patch"
	${git} "${DIR}/patches/dma/0007-ARM-omap-add-hsmmc-am33xx-specific-init.patch"
	${git} "${DIR}/patches/dma/0008-mmc-omap_hsmmc-hack-in-edma-dmaengine-filter-and-lim.patch"
	${git} "${DIR}/patches/dma/0009-spi-omap2_mcspi-hack-in-edma-edmaengine-filter.patch"
	${git} "${DIR}/patches/dma/0010-ARM-dts-minimal-updates-to-support-spi-mmc-on-am335x.patch"
	${git} "${DIR}/patches/dma/0011-spi-mcspi-add-hack-to-work-around-a-bug-in-the-edma-.patch"
}

pwm () {
	echo "Patches from: pwm"
	${git} "${DIR}/patches/pwm/0001-Revert-pwm-pwm-tiehrpwm-Fix-conflicting-channel-peri.patch"
	${git} "${DIR}/patches/pwm/0002-ARM-OMAP3-hwmod-Corrects-resource-data-for-PWM-devic.patch"
	${git} "${DIR}/patches/pwm/0003-pwm-Add-support-for-configuring-the-PWM-polarity.patch"
	${git} "${DIR}/patches/pwm/0004-pwm_backlight-Add-device-tree-support-for-Low-Thresh.patch"
	${git} "${DIR}/patches/pwm/0005-pwm-pwm-tiecap-Add-support-for-configuring-polarity-.patch"
	${git} "${DIR}/patches/pwm/0006-pwm-pwm-tiehrpwm-Add-support-for-configuring-polarit.patch"
	${git} "${DIR}/patches/pwm/0007-pwm-pwm-tiecap-Add-device-tree-binding-support-in-AP.patch"
	${git} "${DIR}/patches/pwm/0008-pwm-pwm-tiehrpwm-Add-device-tree-binding-support-EHR.patch"
	${git} "${DIR}/patches/pwm/0009-ARM-OMAP2-HWMOD-AM33xx-Fixes-the-naming-convention-f.patch"
	${git} "${DIR}/patches/pwm/0010-Control-module-EHRPWM-clk-enabling.patch"
	${git} "${DIR}/patches/pwm/0011-pwm-pwm-tiecap-Enable-clock-gating.patch"
	${git} "${DIR}/patches/pwm/0012-pwm-pwm-tiehrpwm-Enable-clock-gating.patch"
	${git} "${DIR}/patches/pwm/0013-arm-dts-DT-support-for-EHRPWM-and-ECAP-device.patch"
	${git} "${DIR}/patches/pwm/0014-dts-support-for-config-space.patch"
	${git} "${DIR}/patches/pwm/0015-pwm-pwm-tiehrpwm-Fix-conflicting-channel-period-sett.patch"
	${git} "${DIR}/patches/pwm/0016-PWM-ti-ehrpwm-fix-up-merge-conflict.patch"
	${git} "${DIR}/patches/pwm/0017-pwm-pwm_test-Driver-support-for-PWM-module-testing.patch"
}

st7735 () {
	echo "Patches from: st7735"
	${git} "${DIR}/patches/st7735/0001-video-st7735fb-add-st7735-framebuffer-driver.patch"
	${git} "${DIR}/patches/st7735/0002-of-Add-Adafruit-and-Sitronix-vendor-prefixes.patch"
	${git} "${DIR}/patches/st7735/0003-ARM-dts-AM33XX-Add-support-for-the-Adafruit-1.8-LCD-.patch"
	${git} "${DIR}/patches/st7735/0004-spi-omap2-mcspi-add-pinctrl-support.patch"
	${git} "${DIR}/patches/st7735/0005-ARM-OMAP2-Enable-pinctrl-dummy-states.patch"
	${git} "${DIR}/patches/st7735/0006-video-st7735fb-defer-all-in-kernel-updates-and-fix-l.patch"
	${git} "${DIR}/patches/st7735/0007-video-st7735fb-remove-FOREIGN_ENDIAN-flag.patch"
	${git} "${DIR}/patches/st7735/0008-video-st7735fb-fix-fbcon-color-problem.patch"
	${git} "${DIR}/patches/st7735/0009-beaglebone-3.6-enable-EHRPWM1A-backlight-for-st7735f.patch"
	${git} "${DIR}/patches/st7735/0010-video-st7735fb-add-pinctrl-support.patch"
}

i2c () {
	echo "Patches from: i2c"
	${git} "${DIR}/patches/i2c/0001-pinctrl-pinctrl-single-must-be-initialized-early.patch"
	${git} "${DIR}/patches/i2c/0002-i2c-pinctrl-ify-i2c-omap.c.patch"
	${git} "${DIR}/patches/i2c/0003-Bone-DTS-working-i2c2-i2c3-in-the-tree.patch"
	${git} "${DIR}/patches/i2c/0004-am33xx-Convert-I2C-from-omap-to-am33xx-names.patch"
	${git} "${DIR}/patches/i2c/0005-beaglebone-fix-backlight-entry-in-DT.patch"
}

w1 () {
	echo "Patches from: w1"
	${git} "${DIR}/patches/w1/0001-onewire-w1-gpio-add-ext_pullup_enable-pin-in-platfor.patch"
	${git} "${DIR}/patches/w1/0002-onewire-w1-gpio-add-DT-bindings.patch"
}

pruss () {
	echo "Patches from: pruss"
	${git} "${DIR}/patches/pruss/0001-uio-uio_pruss-port-to-AM33xx.patch"
	${git} "${DIR}/patches/pruss/0002-ARM-omap-add-DT-support-for-deasserting-hardware-res.patch"
	${git} "${DIR}/patches/pruss/0003-ARM-dts-AM33xx-PRUSS-support.patch"
}

beaglebone () {
	echo "Patches from: beaglebone"
	${git} "${DIR}/patches/beaglebone/0001-ARM-OMAP-Makefile.boot-add-am335x-hardware.patch"
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
#	${git} "${DIR}/patches/mainline-fixes/0002-ARM-omap-add-dtb-targets.patch"

	#From: https://github.com/RobertCNelson/linux-dev/issues/7
	#DisplayLink fb driver (udlfb.ko)
	#Status: https://patchwork.kernel.org/patch/1361471/
	${git} "${DIR}/patches/mainline-fixes/0003-ARM-export-read_current_timer.patch"
}

debug () {
	echo "debug: cpufreq"
	${git} "${DIR}/patches/debug/0001-beagle_xm-cpufreq-debug.patch"
}

devel_dt
vaibhav
net_next_am335x
cpsw
usb
pinctrl
rtc
mmc
da8xx_fb
fixes
cpufreq
spi
adc
dma
pwm
st7735
i2c
w1
pruss

beaglebone

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

echo "patch.sh ran successful"

