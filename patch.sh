#!/bin/sh
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/version.sh
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

git="git am"
#git_patchset=""
#git_opts

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

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
}

#external_git
#local_patch

imx_next () {
	echo "dir: imx_next"
	#From: https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/shawnguo/linux.git for-next
}

omap_next () {
	echo "dir: omap_next"
	#from: https://git.kernel.org/cgit/linux/kernel/git/tmlind/linux-omap.git/
}

tegra_next () {
	echo "dir: tegra_next"
	#From: https://git.kernel.org/cgit/linux/kernel/git/tegra/linux.git/log/?h=for-next
	#git pull --no-edit git://git.kernel.org/pub/scm/linux/kernel/git/tegra/linux.git for-next
}

dts () {
	echo "dir: dts"
#start_cleanup
	${git} "${DIR}/patches/dts/0001-ARM-dts-omap3-beagle-add-i2c2.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0003-ARM-dts-beagle-xm-make-sure-dvi-is-enabled.patch"
	${git} "${DIR}/patches/dts/0004-ARM-DTS-omap3-beagle-xm-disable-powerdown-gpios.patch"
	${git} "${DIR}/patches/dts/0005-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/dts/0006-arm-dts-omap4-move-emif-so-panda-es-b3-now-boots.patch"
	${git} "${DIR}/patches/dts/0007-mach-imx51-disable-cpufreq-still-locks-up.patch"
	${git} "${DIR}/patches/dts/0008-omap3-beagle-xm-ehci-works-again.patch"
	${git} "${DIR}/patches/dts/0009-ARM-dts-omap3-beagle-ddc-i2c-bus-is-not-responding-d.patch"
	${git} "${DIR}/patches/dts/0010-imx-add-udoo.patch"
	${git} "${DIR}/patches/dts/0011-ARM-sun7i-Add-support-for-Olimex-A20-OLinuXino-LIME.patch"
#number=11
#cleanup
}

wand () {
	echo "dir: wand"
	${git} "${DIR}/patches/wand/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0003-Vivante-v4-driver.patch"
}

errata () {
	echo "dir: errata"
	${git} "${DIR}/patches/errata/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum-co.patch"
}

freescale () {
	echo "dir: freescale/ipu-v3"
	${git} "${DIR}/patches/freescale/ipu-v3/0001-gpu-ipu-v3-Add-ipu-cpmem-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0002-staging-imx-drm-Convert-to-new-ipu_cpmem-API.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0003-gpu-ipu-v3-Add-functions-to-set-CSI-IC-source-muxes.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0004-gpu-ipu-v3-Rename-and-add-IDMAC-channels.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0005-gpu-ipu-v3-Add-Camera-Sensor-Interface-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0006-gpu-ipu-v3-Add-Image-Converter-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0007-gpu-ipu-v3-smfc-Move-enable-disable-to-ipu-smfc.c.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0008-gpu-ipu-v3-smfc-Convert-to-per-channel.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0009-gpu-ipu-v3-smfc-Add-ipu_smfc_set_watermark.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0010-gpu-ipu-v3-Add-ipu_mbus_code_to_colorspace.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0011-gpu-ipu-v3-Add-rotation-mode-conversion-utilities.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0012-gpu-ipu-v3-Add-helper-function-checking-if-pixfmt-is.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0013-gpu-ipu-v3-Move-IDMAC-channel-names-to-imx-ipu-v3.h.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0014-gpu-ipu-v3-Add-ipu_idmac_buffer_is_ready.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0015-gpu-ipu-v3-Add-ipu_idmac_clear_buffer.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0016-gpu-ipu-v3-Add-__ipu_idmac_reset_current_buffer.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0017-gpu-ipu-v3-Add-ipu_stride_to_bytes.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0018-gpu-ipu-v3-Add-ipu_idmac_enable_watermark.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0019-gpu-ipu-v3-Add-ipu_idmac_lock_enable.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0020-gpu-ipu-cpmem-Add-ipu_cpmem_set_block_mode.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0021-gpu-ipu-cpmem-Add-ipu_cpmem_set_axi_id.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0022-gpu-ipu-cpmem-Add-ipu_cpmem_set_rotation.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0023-gpu-ipu-cpmem-Add-second-buffer-support-to-ipu_cpmem.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0024-gpu-ipu-v3-Add-more-planar-formats-support.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0025-gpu-ipu-cpmem-Add-ipu_cpmem_dump.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0026-gpu-ipu-v3-Add-ipu_dump.patch"
}

dtb_makefile_append () {
	sed -i -e 's:am335x-boneblack.dtb \\:am335x-boneblack.dtb \\\n\t'$device' \\:g' arch/arm/boot/dts/Makefile
}

dtsi_append () {
	wfile="arch/arm/boot/dts/${base_dts}-${cape}.dts"
	cp arch/arm/boot/dts/${base_dts}-base.dts ${wfile}
	echo "" >> ${wfile}
	echo "#include \"am335x-bone-${cape}.dtsi\"" >> ${wfile}
	git add ${wfile}
}

dtsi_append_custom () {
	wfile="arch/arm/boot/dts/${dtb_name}.dts"
	cp arch/arm/boot/dts/${base_dts}-base.dts ${wfile}
	echo "" >> ${wfile}
	echo "#include \"am335x-bone-${cape}.dtsi\"" >> ${wfile}
	git add ${wfile}
}

dtsi_append_hdmi_no_audio () {
	dtsi_append
	echo "#include \"am335x-boneblack-nxp-hdmi-no-audio.dtsi\"" >> ${wfile}
	git add ${wfile}
}

dtsi_drop_nxp_hdmi_audio () {
	sed -i -e 's:#include "am335x-boneblack-nxp-hdmi-no-audio.dtsi":/* #include "am335x-boneblack-nxp-hdmi-no-audio.dtsi" */:g' ${wfile}
	git add ${wfile}
}

dtsi_drop_emmc () {
	sed -i -e 's:#include "am335x-boneblack-emmc.dtsi":/* #include "am335x-boneblack-emmc.dtsi" */:g' ${wfile}
	git add ${wfile}
}

dts_drop_clkout2_pin () {
	sed -i -e 's:pinctrl-0 = <\&clkout2_pin>;:/* pinctrl-0 = <\&clkout2_pin>; */:g' ${wfile}
	git add ${wfile}
}

beaglebone () {
	echo "dir: beaglebone/hdmi_audio"
	#[PATCH v2 0/8] Beaglebone-Black HDMI audio
	${git} "${DIR}/patches/beaglebone/hdmi_audio/0001-clk-ti-add-gpio-controlled-clock.patch"
	${git} "${DIR}/patches/beaglebone/hdmi_audio/0002-drm-tilcdc-Add-I2S-HDMI-audio-config-for-tda998x.patch"
	${git} "${DIR}/patches/beaglebone/hdmi_audio/0003-ASoC-davinci-evm-HDMI-audio-support-for-TDA998x-trou.patch"
	${git} "${DIR}/patches/beaglebone/hdmi_audio/0004-ASoC-davinci-HDMI-audio-build-for-AM33XX-and-TDA998x.patch"
	${git} "${DIR}/patches/beaglebone/hdmi_audio/0005-ARM-dts-am33xx-Add-external-clock-provider.patch"

	echo "dir: beaglebone/pinmux-helper"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0001-BeagleBone-pinmux-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0002-pinmux-helper-Add-runtime-configuration-capability.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0003-pinmux-helper-Switch-to-using-kmalloc.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0004-gpio-Introduce-GPIO-OF-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0005-Add-dir-changeable-property-to-gpio-of-helper.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0006-am33xx.dtsi-add-ocp-label.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0007-beaglebone-added-expansion-header-to-dtb.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0008-bone-pinmux-helper-Add-support-for-mode-device-tree-.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0009-pinmux-helper-add-P8_37_pinmux-P8_38_pinmux.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=9
		cleanup
	fi

	echo "dir: beaglebone/pinmux"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi
	# gedit arch/arm/boot/dts/am335x-bone-common.dtsi arch/arm/boot/dts/am335x-bone-common-pinmux.dtsi
	# gedit arch/arm/boot/dts/am335x-boneblack.dts arch/arm/boot/dts/am335x-bone.dts &
	# git commit -a -m 'am335x-bone-common: split out am33xx_pinmux' -s

	${git} "${DIR}/patches/beaglebone/pinmux/0001-am335x-bone-common-split-out-am33xx_pinmux.patch"

	# gedit arch/arm/boot/dts/am335x-bone-common-pinmux.dtsi arch/arm/boot/dts/am335x-boneblack.dts
	# git commit -a -m 'am335x-boneblack: split out am33xx_pinmux' -s

	${git} "${DIR}/patches/beaglebone/pinmux/0002-am335x-boneblack-split-out-am33xx_pinmux.patch"

	# cp arch/arm/boot/dts/am335x-boneblack.dts arch/arm/boot/dts/am335x-boneblack-emmc.dtsi
	# gedit arch/arm/boot/dts/am335x-boneblack.dts arch/arm/boot/dts/am335x-boneblack-emmc.dtsi &
	# git add arch/arm/boot/dts/am335x-boneblack-emmc.dtsi
	# git commit -a -m 'am335x-boneblack: split out emmc' -s

	${git} "${DIR}/patches/beaglebone/pinmux/0003-am335x-boneblack-split-out-emmc.patch"

	# cp arch/arm/boot/dts/am335x-boneblack.dts arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-audio.dtsi
	# gedit arch/arm/boot/dts/am335x-boneblack.dts arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-audio.dtsi &
	# git add arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-audio.dtsi
	# git commit -a -m 'am335x-boneblack: split out nxp hdmi audio' -s

	#${git} "${DIR}/patches/beaglebone/pinmux/0004-am335x-boneblack-split-out-nxp-hdmi-audio.patch"

	# cp arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-audio.dtsi arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-no-audio.dtsi
	# gedit arch/arm/boot/dts/am335x-boneblack.dts  arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-no-audio.dtsi &
	# git add arch/arm/boot/dts/am335x-boneblack-nxp-hdmi-no-audio.dtsi
	# git commit -a -m 'am335x-bone: nxp hdmi no audio' -s

	${git} "${DIR}/patches/beaglebone/pinmux/0005-am335x-bone-nxp-hdmi-no-audio.patch"

	${git} "${DIR}/patches/beaglebone/pinmux/0006-pinmux-bone-black-disable-pins-for-hdmi-audio-clkout.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0007-pinmux-i2c.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0008-pinmux-uart.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0009-pinmux-spi.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0010-node-4-wire-touchscreen.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0011-node-led-gpio.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0012-node-backlight-gpio.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0013-node-keymap.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0014-node-panel.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0015-cape-audio-revb.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0016-cape-audio-reva.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0017-cape-crypto-00a0.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0018-cape-rtc-01-00a1.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0019-cape-lcd.patch"
	${git} "${DIR}/patches/beaglebone/pinmux/0020-cape-basic-proto.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=20
		cleanup
	fi

	echo "dir: beaglebone/dts"
	${git} "${DIR}/patches/beaglebone/dts/0001-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/beaglebone/dts/0002-dts-am335x-bone-common-fixup-leds-to-match-3.8.patch"
	${git} "${DIR}/patches/beaglebone/dts/0003-ARM-dts-am335x-bone-Fix-model-name-and-update-compat.patch"
	${git} "${DIR}/patches/beaglebone/dts/0004-ARM-dts-am335x-boneblack-dcdc1-set-to-1.35v-for-ddr3.patch"

	#echo "patch -p1 < \"${DIR}/patches/beaglebone/dts/0005-add-base-files.patch\""
	#exit
	${git} "${DIR}/patches/beaglebone/dts/0005-add-base-files.patch"

	echo "dir: beaglebone/capes"
	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"

	#regenerate="enable"
	echo "dir: beaglebone/generated"
	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="ttyO1"
		dtsi_append

		cape="ttyO2"
		dtsi_append

		cape="ttyO4"
		dtsi_append

		cape="ttyO5"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="ttyO1"
		dtsi_append

		cape="ttyO2"
		dtsi_append

		cape="ttyO4"
		dtsi_append

		cape="ttyO5"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: uarts' -s
		git format-patch -1 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0001-auto-generated-cape-uarts.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="audio-reva"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="audio-reva"
		dtsi_append
#		dtsi_append_hdmi_no_audio
#		dtsi_drop_nxp_hdmi_audio

		base_dts="am335x-bone"
		cape="audio-revb"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="audio-revb"
		dtsi_append
#		dtsi_append_hdmi_no_audio
#		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: audio' -s
		git format-patch -2 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0002-auto-generated-cape-audio.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="lcd3-01-00a2"
		dtsi_append

		cape="lcd4-01-00a1"
		dtsi_append

		cape="lcd7-01-00a2"
		dtsi_append

		cape="lcd7-01-00a3"
		dtsi_append

		base_dts="am335x-boneblack"
		#lcd3 a2+
		cape="lcd3-01-00a2"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		#lcd4 a1+
		cape="lcd4-01-00a1"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		#drop emmc:
		cape="lcd7-01-00a2"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio
		dtsi_drop_emmc

		#lcd4 a3+
		cape="lcd7-01-00a3"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: lcd' -s
		git format-patch -3 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0003-auto-generated-cape-lcd.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		cape="argus"

		base_dts="am335x-bone"
		dtb_name="${base_dts}-cape-bone-${cape}"
		dtsi_append_custom
		dts_drop_clkout2_pin

		base_dts="am335x-boneblack"
		dtb_name="${base_dts}-cape-bone-${cape}"
		dtsi_append_custom
		dts_drop_clkout2_pin

		git commit -a -m 'auto generated: cape: argus' -s
		git format-patch -4 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0004-auto-generated-cape-argus.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="rtc-01-00a1"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="rtc-01-00a1"
		dtsi_append

		git commit -a -m 'auto generated: cape: rtc-01-00a1' -s
		git format-patch -5 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0005-auto-generated-cape-rtc-01-00a1.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="crypto-00a0"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="crypto-00a0"
		dtsi_append

		git commit -a -m 'auto generated: cape: crypto-00a0' -s
		git format-patch -6 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0006-auto-generated-cape-crypto-00a0.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="4dcape-43"
		dtsi_append

		cape="4dcape-43t"
		dtsi_append

		cape="4dcape-70"
		dtsi_append

		cape="4dcape-70t"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="4dcape-43"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		base_dts="am335x-boneblack"
		cape="4dcape-43t"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		base_dts="am335x-boneblack"
		cape="4dcape-70"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		base_dts="am335x-boneblack"
		cape="4dcape-70t"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: 4dcape' -s
		git format-patch -7 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0007-auto-generated-cape-4dcape.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="bbb-exp-c"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="bbb-exp-c"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: bbb-exp-c' -s
		git format-patch -8 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0008-auto-generated-cape-bbb-exp-c.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		base_dts="am335x-bone"
		cape="bb-view-43"
		dtsi_append

		base_dts="am335x-boneblack"
		cape="bb-view-43"
		dtsi_append
		dtsi_drop_nxp_hdmi_audio

		git commit -a -m 'auto generated: cape: bb-view-43' -s
		git format-patch -9 -o ../patches/beaglebone/generated/
	else
		${git} "${DIR}/patches/beaglebone/generated/0009-auto-generated-cape-bb-view-43.patch"
	fi

	####
	#dtb makefile
	if [ "x${regenerate}" = "xenable" ] ; then
		device="am335x-bone-audio-reva.dtb"
		dtb_makefile_append

		device="am335x-bone-audio-revb.dtb"
		dtb_makefile_append

		device="am335x-bone-bb-view-43.dtb"
		dtb_makefile_append

		device="am335x-bone-cape-bone-argus.dtb"
		dtb_makefile_append

		device="am335x-bone-crypto-00a0.dtb"
		dtb_makefile_append

		device="am335x-bone-4dcape-43.dtb"
		dtb_makefile_append

		device="am335x-bone-4dcape-43t.dtb"
		dtb_makefile_append

		device="am335x-bone-4dcape-70.dtb"
		dtb_makefile_append

		device="am335x-bone-4dcape-70t.dtb"
		dtb_makefile_append

		device="am335x-bone-bbb-exp-c.dtb"
		dtb_makefile_append

		device="am335x-bone-lcd3-01-00a2.dtb"
		dtb_makefile_append

		device="am335x-bone-lcd4-01-00a1.dtb"
		dtb_makefile_append

		device="am335x-bone-lcd7-01-00a2.dtb"
		dtb_makefile_append

		device="am335x-bone-lcd7-01-00a3.dtb"
		dtb_makefile_append

		device="am335x-bone-rtc-01-00a1.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO1.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO2.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO4.dtb"
		dtb_makefile_append

		device="am335x-bone-ttyO5.dtb"
		dtb_makefile_append

		device="am335x-boneblack-audio-reva.dtb"
		dtb_makefile_append

		device="am335x-boneblack-audio-revb.dtb"
		dtb_makefile_append

		device="am335x-boneblack-bb-view-43.dtb"
		dtb_makefile_append

		device="am335x-boneblack-cape-bone-argus.dtb"
		dtb_makefile_append

		device="am335x-boneblack-crypto-00a0.dtb"
		dtb_makefile_append

		device="am335x-boneblack-4dcape-43.dtb"
		dtb_makefile_append

		device="am335x-boneblack-4dcape-43t.dtb"
		dtb_makefile_append

		device="am335x-boneblack-4dcape-70.dtb"
		dtb_makefile_append

		device="am335x-boneblack-4dcape-70t.dtb"
		dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb"
		dtb_makefile_append

		device="am335x-boneblack-lcd3-01-00a2.dtb"
		dtb_makefile_append

		device="am335x-boneblack-lcd4-01-00a1.dtb"
		dtb_makefile_append

		device="am335x-boneblack-lcd7-01-00a2.dtb"
		dtb_makefile_append

		device="am335x-boneblack-lcd7-01-00a3.dtb"
		dtb_makefile_append

		device="am335x-boneblack-rtc-01-00a1.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO1.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO2.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO4.dtb"
		dtb_makefile_append

		device="am335x-boneblack-ttyO5.dtb"
		dtb_makefile_append

		git commit -a -m 'auto generated: capes: add dtbs to makefile' -s
		git format-patch -1 -o ../patches/beaglebone/generated/last/
		exit
	else
		${git} "${DIR}/patches/beaglebone/generated/last/0001-auto-generated-capes-add-dtbs-to-makefile.patch"
	fi

	echo "dir: beaglebone/power"
	${git} "${DIR}/patches/beaglebone/power/0001-tps65217-Enable-KEY_POWER-press-on-AC-loss-PWR_BUT.patch"
	${git} "${DIR}/patches/beaglebone/power/0002-am335x-bone-common-enable-ti-pmic-shutdown-controlle.patch"
	${git} "${DIR}/patches/beaglebone/power/0003-dt-bone-common-Add-interrupt-for-PMIC.patch"

	echo "dir: beaglebone/phy"
	${git} "${DIR}/patches/beaglebone/phy/0001-cpsw-Add-support-for-byte-queue-limits.patch"
	${git} "${DIR}/patches/beaglebone/phy/0002-cpsw-napi-polling-of-64-is-good-for-gigE-less-good-f.patch"
	${git} "${DIR}/patches/beaglebone/phy/0003-cpsw-search-for-phy.patch"

	echo "dir: beaglebone/mac"
	#[PATCH v6 0/7] net: cpsw: Support for am335x chip MACIDs
	${git} "${DIR}/patches/beaglebone/mac/0001-DT-doc-net-cpsw-mac-address-is-optional.patch"
	${git} "${DIR}/patches/beaglebone/mac/0002-net-cpsw-Add-missing-return-value.patch"
	${git} "${DIR}/patches/beaglebone/mac/0003-net-cpsw-header-Add-missing-include.patch"
	${git} "${DIR}/patches/beaglebone/mac/0004-net-cpsw-Replace-pr_err-by-dev_err.patch"
	${git} "${DIR}/patches/beaglebone/mac/0005-net-cpsw-Add-am33xx-MACID-readout.patch"
	${git} "${DIR}/patches/beaglebone/mac/0006-am33xx-define-syscon-control-module-device-node.patch"
	${git} "${DIR}/patches/beaglebone/mac/0007-arm-dts-am33xx-Add-syscon-phandle-to-cpsw-node.patch"
}

#imx_next
#omap_next
#tegra_next

dts
wand
errata
freescale

beaglebone

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
}

packaging () {
	echo "dir: packaging"
	#${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
	#${git} "${DIR}/patches/packaging/0003-deb-pkg-no-dtbs_install.patch"
}

#packaging_setup
packaging
echo "patch.sh ran successfully"
