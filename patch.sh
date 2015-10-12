#!/bin/sh
#
# Copyright (c) 2009-2015 Robert Nelson <robertcnelson@gmail.com>
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

#Debian 7 (Wheezy): git version 1.7.10.4 and later needs "--no-edit"
unset git_opts
git_no_edit=$(LC_ALL=C git help pull | grep -m 1 -e "--no-edit" || true)
if [ ! "x${git_no_edit}" = "x" ] ; then
	git_opts="--no-edit"
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
	exit 2
}

pick () {
	if [ ! -d ../patches/${pick_dir} ] ; then
		mkdir -p ../patches/${pick_dir}
	fi
	git format-patch -1 ${SHA} --start-number ${num} -o ../patches/${pick_dir}
	num=$(($num+1))
}

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

rt_cleanup () {
	echo "rt: needs fixup"
	exit 2
}

rt () {
	echo "dir: rt"
	rt_patch="${KERNEL_REL}${kernel_rt}"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		wget -c https://www.kernel.org/pub/linux/kernel/projects/rt/${KERNEL_REL}/patch-${rt_patch}.patch.xz
		xzcat patch-${rt_patch}.patch.xz | patch -p1 || rt_cleanup
		rm -f patch-${rt_patch}.patch.xz
		rm -f localversion-rt
		git add .
		git commit -a -m 'merge: CONFIG_PREEMPT_RT Patch Set' -s
		git format-patch -1 -o ../patches/rt/

		exit 2
	fi

	${git} "${DIR}/patches/rt/0001-merge-CONFIG_PREEMPT_RT-Patch-Set.patch"
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
}

#external_git
#rt
#local_patch

reverts () {
	echo "dir: reverts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/reverts/0001-Revert-spi-spidev-Warn-loudly-if-instantiated-from-D.patch"
	#udoo:
	${git} "${DIR}/patches/reverts/0002-Revert-usb-chipidea-usbmisc_imx-delete-clock-informa.patch"
	#am335x causing random reboots...
#	${git} "${DIR}/patches/reverts/0004-Revert-usb-musb-dsps-just-start-polling-already.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi
}

ti () {
	echo "dir: ti/cpu_freq/"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/ti/cpu_freq/0001-ARM-OMAP2-opp-Move-dt-check-from-omap_init_opp_table.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0002-ARM-OMAP2-opp-Add-helper-functions-for-variable-OPP-.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0003-ARM-OMAP2-AM33XX-Add-opp33xx_data-to-enable-higher-O.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0004-ARM-OMAP2-AM43XX-Add-opp43xx_data-to-enable-higher-O.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0005-ARM-OMAP2-DRA7XX-Add-opp7xx_data-to-enable-higher-OP.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0006-ARM-dts-am33xx-Drop-operating-points-table-from-cpu0.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0007-ARM-dts-am4372-Add-voltage-tolerance-to-cpu-node.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0008-ARM-dts-am43x-epos-evm-Hook-dcdc2-as-the-cpu0-supply.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0009-ARM-dts-am437x-gp-evm-Hook-dcdc2-as-the-cpu0-supply.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0010-ARM-dts-dra72x-add-clock-nodes-for-CPU.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0011-ARM-dts-dra72x-Add-basic-OPPs-for-MPU.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0012-ARM-dts-dra74x-Remove-non-common-cpu0-operating-poin.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0013-PM-Voltagedomain-Add-generic-clk-notifier-handler-fo.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0014-PM-Voltagedomain-introduce-voltage-domain-driver-sup.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0015-PM-Voltagedomain-introduce-basic-voltage-domain-supp.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0016-cpufreq-cpufreq-voltdm-Split-cpufreq-dt-to-use-clk-r.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0017-ARM-OMAP2-pm-Change-cpufreq-platform-device-to-cpufr.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0018-cpufreq-voltdm-use-the-right-device-node-for-resourc.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0019-cpufreq-voltdm-do-a-dummy-opp-setup-as-part-of-probe.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0020-ARM-dts-OMAP5-Add-voltage-domains.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0021-ARM-dts-omap5uevm-Add-vdd-regulators-for-voltage-dom.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0022-ARM-dts-dra7-add-voltage-domains.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0023-ARM-dts-dra7-evm-Add-vdd-regulators-for-voltage-doma.patch"
	${git} "${DIR}/patches/ti/cpu_freq/0024-ARM-dts-dra72-evm-Add-mapping-of-voltage-domains-to-.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=24
		cleanup
	fi

	echo "dir: ti/iodelay/"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/ti/iodelay/0001-ARM-dts-am57xx-beagle-x15-Map-regulators-to-voltage-.patch"
	${git} "${DIR}/patches/ti/iodelay/0002-pinctrl-bindings-pinctrl-Add-support-for-TI-s-IODela.patch"
	${git} "${DIR}/patches/ti/iodelay/0003-pinctrl-Introduce-TI-IOdelay-configuration-driver.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
}

dts () {
	echo "dir: dts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/dts/0001-ARM-dts-omap3-beagle-add-i2c2.patch"
	${git} "${DIR}/patches/dts/0002-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/dts/0003-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/dts/0004-arm-dts-omap4-move-emif-so-panda-es-b3-now-boots.patch"
	${git} "${DIR}/patches/dts/0005-first-pass-imx6q-ccimx6sbc.patch"
	${git} "${DIR}/patches/dts/0006-imx6-wl1835-base-boards.patch"
	${git} "${DIR}/patches/dts/0007-imx6q-sabresd-add-support-for-wilink8-wlan-and-bluet.patch"
	${git} "${DIR}/patches/dts/0008-imx6sl-evk-add-support-for-wilink8-wlan-and-bluetoot.patch"
	${git} "${DIR}/patches/dts/0009-dts-am57xx-beagle-x15-make-sure-vdd_sd-is-on-fixex-v.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=9
		cleanup
	fi
}

wand () {
	echo "dir: wand"
	${git} "${DIR}/patches/wand/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
}

errata () {
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi
	echo "dir: errata"

	${git} "${DIR}/patches/errata/0001-hack-omap-clockk-dpll5-apply-sprz319e-2.1-erratum.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

fixes () {
	echo "dir: fixes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

pru () {
	echo "dir: pru"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/pru/0001-Making-the-uio-pruss-driver-work.patch"
	${git} "${DIR}/patches/pru/0002-Cleaned-up-error-reporting.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi
}

mainline () {
	git format-patch -1 ${SHA} --start-number ${num} -o ../patches/${directory}/
}

bbb_overlays () {
	echo "dir: bbb_overlays/dtc"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then

		cd ../
		if [ -d dtc ] ; then
			rm -rf dtc
		fi
		git clone https://git.kernel.org/pub/scm/utils/dtc/dtc.git
		cd dtc
		git pull --no-edit https://github.com/pantoniou/dtc dt-overlays5

		cd ../KERNEL/
		sed -i -e 's:git commit:#git commit:g' ./scripts/dtc/update-dtc-source.sh
		./scripts/dtc/update-dtc-source.sh
		sed -i -e 's:#git commit:git commit:g' ./scripts/dtc/update-dtc-source.sh
		git commit -a -m "scripts/dtc: Update to upstream version overlays" -s
		git format-patch -1 -o ../patches/bbb_overlays/dtc/
		exit 2
	else
		#regenerate="enable"
		if [ "x${regenerate}" = "xenable" ] ; then
			start_cleanup
		fi

		${git} "${DIR}/patches/bbb_overlays/dtc/0001-scripts-dtc-Update-to-upstream-version-overlays.patch"

		if [ "x${regenerate}" = "xenable" ] ; then
			number=1
			cleanup
		fi
	fi

	echo "dir: bbb_overlays/mainline"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="bbb_overlays/mainline"
		SHA="668abc729fcb9d034eccadf63166d2c76cd645d1" ; num="1" ; mainline
		SHA="a2f776cbb8271d7149784207da0b0c51e8b1847c" ; num="2" ; mainline
		SHA="5d1a2961adf906f965b00eb8059fd2e0585e0e09" ; num="3" ; mainline
		SHA="4f001fd30145a6a8f72f9544c982cfd3dcb7c6df" ; num="4" ; mainline
		exit 2
	fi

	echo "dir: bbb_overlays/nvmem"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="bbb_overlays/nvmem"
		SHA="eace75cfdcf7d9937d8c1fb226780123c64d72c4" ; num="1" ; mainline
		SHA="69aba7948cbe53f2f1827e84e9dd0ae470a5072e" ; num="2" ; mainline
		SHA="e2a5402ec7c6d0442cca370a0097e75750f81398" ; num="3" ; mainline
		SHA="2af38ab572b031a4111f01153cc020b1038b427b" ; num="4" ; mainline
		SHA="354ebb541dfa37a83395e5a9b7d68c34f80fffc0" ; num="5" ; mainline
		SHA="4ab11996b489ad65092216315484824ed32018f8" ; num="6" ; mainline
		SHA="b470d6d7a5dfe41112d55c39eac67ddc5afac80d" ; num="7" ; mainline
		SHA="3d0b16a66c8a9d10294572c6f79df4f15a27825d" ; num="8" ; mainline
		SHA="7c806883e143dc60439e6bdb3589700ebed1efaa" ; num="9" ; mainline
		SHA="cbf854ab36870b931aeba4edd954015b7c3005a2" ; num="10" ; mainline
		SHA="ace22170655f61d82fff95e57d673bf847a32a03" ; num="11" ; mainline
		SHA="fb727077b04f768d0c79d9aa29e958262a9e3d9e" ; num="12" ; mainline
		exit 2
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

#linux-next:

	${git} "${DIR}/patches/bbb_overlays/nvmem/0013-nvmem-Add-Vybrid-OCOTP-support.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0014-nvmem-imx-ocotp-Add-i.MX6-OCOTP-driver.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0015-nvmem-add-driver-for-ocotp-in-i.MX23-and-i.MX28.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0016-nvmem-Adding-bindings-for-rockchip-efuse.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0017-nvmem-rockchip_efuse_regmap_config-can-be-static.patch"

#email...

	${git} "${DIR}/patches/bbb_overlays/nvmem/0018-nvmem-make-default-user-binary-file-root-access-only.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0019-nvmem-set-the-size-for-the-nvmem-binary-file.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0020-nvmem-add-permission-flags-in-nvmem_config.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0021-nvmem-fix-permissions-of-readonly-nvmem-binattr.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=21
		cleanup
	fi

	echo "dir: bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/0001-configfs-Implement-binary-attributes-v4.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-OF-DT-Overlay-configfs-interface-v5.patch"
	${git} "${DIR}/patches/bbb_overlays/0003-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0004-add-PM-firmware.patch"
	${git} "${DIR}/patches/bbb_overlays/0005-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0006-arm-omap-Proper-cleanups-for-omap_device.patch"
	${git} "${DIR}/patches/bbb_overlays/0007-serial-omap-Fix-port-line-number-without-aliases.patch"
	${git} "${DIR}/patches/bbb_overlays/0008-tty-omap-serial-Fix-up-platform-data-alloc.patch"
	${git} "${DIR}/patches/bbb_overlays/0009-ARM-DT-Enable-symbols-when-CONFIG_OF_OVERLAY-is-used.patch"
	${git} "${DIR}/patches/bbb_overlays/0010-of-Custom-printk-format-specifier-for-device-node.patch"
	${git} "${DIR}/patches/bbb_overlays/0011-of-overlay-kobjectify-overlay-objects.patch"
	${git} "${DIR}/patches/bbb_overlays/0012-of-overlay-global-sysfs-enable-attribute.patch"
	${git} "${DIR}/patches/bbb_overlays/0013-of-overlay-add-per-overlay-sysfs-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0014-Documentation-ABI-sys-firmware-devicetree-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0015-i2c-nvmem-at24-Provide-an-EEPROM-framework-interface.patch"
	${git} "${DIR}/patches/bbb_overlays/0016-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/bbb_overlays/0017-doc-misc-Beaglebone-capemanager-documentation.patch"
	${git} "${DIR}/patches/bbb_overlays/0018-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/bbb_overlays/0019-doc-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/bbb_overlays/0020-MAINTAINERS-Beaglebone-capemanager-maintainer.patch"
	${git} "${DIR}/patches/bbb_overlays/0021-arm-dts-Enable-beaglebone-cape-manager.patch"
	${git} "${DIR}/patches/bbb_overlays/0022-of-overlay-Implement-indirect-target-support.patch"
	${git} "${DIR}/patches/bbb_overlays/0023-of-unittest-Add-indirect-overlay-target-test.patch"
	${git} "${DIR}/patches/bbb_overlays/0024-doc-dt-Document-the-indirect-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0025-of-overlay-Introduce-target-root-capability.patch"
	${git} "${DIR}/patches/bbb_overlays/0026-of-unittest-Unit-tests-for-target-root-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0027-doc-dt-Document-the-target-root-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0028-of-dynamic-Add-__of_node_dupv.patch"
	${git} "${DIR}/patches/bbb_overlays/0029-of-changesets-Introduce-changeset-helper-methods.patch"
	${git} "${DIR}/patches/bbb_overlays/0030-RFC-Device-overlay-manager-PCI-USB-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0031-boneblack-defconfig.patch"
	${git} "${DIR}/patches/bbb_overlays/0032-connector-wip.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		number=32
		cleanup
	fi
}

dtb_makefile_append () {
	sed -i -e 's:am335x-boneblack.dtb \\:am335x-boneblack.dtb \\\n\t'$device' \\:g' arch/arm/boot/dts/Makefile
}

beaglebone () {
	echo "dir: beaglebone/dts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#${git} "${DIR}/patches/beaglebone/dts/0001-am335x-boneblack-add-cpu0-opp-points.patch"
	${git} "${DIR}/patches/beaglebone/dts/0001-hack-bbb-enable-1ghz-operation.patch"
	${git} "${DIR}/patches/beaglebone/dts/0002-dts-am335x-bone-common-fixup-leds-to-match-3.8.patch"
	${git} "${DIR}/patches/beaglebone/dts/0003-arm-dts-am335x-bone-common-add-collision-and-carrier.patch"
	${git} "${DIR}/patches/beaglebone/dts/0004-add-am335x-bonegreen.patch"
	${git} "${DIR}/patches/beaglebone/dts/0005-add-overlay-dtb.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
		cleanup
	fi

	echo "dir: beaglebone/capes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/capes/0002-Added-support-for-Replicape.patch"
	${git} "${DIR}/patches/beaglebone/capes/0003-ARM-dts-am335x-boneblack-enable-wl1835mod-cape-suppo.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

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
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0010-pinmux-helper-hdmi.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0011-pinmux-helper-can1.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0012-Remove-CONFIG_EXPERIMENTAL-dependency-on-CONFIG_GPIO.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0013-pinmux-helper-add-P9_19_pinmux-P9_20_pinmux.patch"
	${git} "${DIR}/patches/beaglebone/pinmux-helper/0014-gpio-of-helper-idr_alloc.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=14
		cleanup
	fi

	echo "dir: beaglebone/eqep"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/eqep/0001-Provides-a-sysfs-interface-to-the-eQEP-hardware-on-t.patch"
	${git} "${DIR}/patches/beaglebone/eqep/0002-tieqep.c-devres-remove-devm_request_and_ioremap.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi

	#This has to be last...
	echo "dir: beaglebone/dtbs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		patch -p1 < "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"
		exit 2
	fi
	${git} "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"

	####
	#dtb makefile
	echo "dir: beaglebone/generated"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then

		device="am335x-arduino-tre.dtb" ; dtb_makefile_append

		device="am335x-bone-can0.dtb" ; dtb_makefile_append
		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-r.dtb" ; dtb_makefile_append
		device="am335x-boneblack-can0.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-emmc-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-hdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-nhdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-replicape.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append
		device="am335x-boneblack-universal.dtb" ; dtb_makefile_append

		device="am335x-bonegreen.dtb" ; dtb_makefile_append

		git commit -a -m 'auto generated: capes: add dtbs to makefile' -s
		git format-patch -1 -o ../patches/beaglebone/generated/
		exit 2
	else
		${git} "${DIR}/patches/beaglebone/generated/0001-auto-generated-capes-add-dtbs-to-makefile.patch"
	fi

	echo "dir: beaglebone/phy"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/phy/0001-cpsw-search-for-phy.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	echo "dir: beaglebone/firmware"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#http://git.ti.com/gitweb/?p=ti-cm3-pm-firmware/amx3-cm3.git;a=summary
	#git clone git://git.ti.com/ti-cm3-pm-firmware/amx3-cm3.git
	#cd amx3-cm3/
	#git checkout origin/ti-v4.1.y -b tmp

	#commit 730f0695ca2dda65abcff5763e8f108517bc0d43
	#Author: Dave Gerlach <d-gerlach@ti.com>
	#Date:   Wed Mar 4 21:34:54 2015 -0600
	#
	#    CM3: Bump firmware release to 0x191
	#    
	#    This version, 0x191, includes the following changes:
	#         - Add trace output on boot for kernel remoteproc driver
	#         - Fix resouce table as RSC_INTMEM is no longer used in kernel
	#         - Add header dependency checking
	#    
	#    Signed-off-by: Dave Gerlach <d-gerlach@ti.com>

	#cp -v bin/am* /opt/github/linux-dev/KERNEL/firmware/

	#git add -f ./firmware/am*

	${git} "${DIR}/patches/beaglebone/firmware/0001-add-am33x-firmware.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

etnaviv () {
	echo "dir: etnaviv"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/etnaviv/0001-of-Add-vendor-prefix-for-Vivante-Corporation.patch"
	${git} "${DIR}/patches/etnaviv/0002-staging-etnaviv-add-devicetree-bindings.patch"
	${git} "${DIR}/patches/etnaviv/0003-staging-etnaviv-add-drm-driver.patch"
	${git} "${DIR}/patches/etnaviv/0004-staging-etnaviv-respect-the-submission-command-offse.patch"
	${git} "${DIR}/patches/etnaviv/0005-staging-etnaviv-add-an-offset-for-buffer-dumping.patch"
	${git} "${DIR}/patches/etnaviv/0006-staging-etnaviv-quieten-down-submission-debugging.patch"
	${git} "${DIR}/patches/etnaviv/0007-staging-etnaviv-fix-multiple-command-buffer-submissi.patch"
	${git} "${DIR}/patches/etnaviv/0008-staging-etnaviv-package-up-events-into-etnaviv_event.patch"
	${git} "${DIR}/patches/etnaviv/0009-staging-etnaviv-track-the-last-known-GPU-position.patch"
	${git} "${DIR}/patches/etnaviv/0010-staging-etnaviv-ensure-that-ring-buffer-wraps.patch"
	${git} "${DIR}/patches/etnaviv/0011-staging-etnaviv-fix-checkpatch-errors.patch"
	${git} "${DIR}/patches/etnaviv/0012-staging-etnaviv-fix-checkpatch-warnings.patch"
	${git} "${DIR}/patches/etnaviv/0013-staging-etnaviv-fix-get_pages-failure-path.patch"
	${git} "${DIR}/patches/etnaviv/0014-staging-etnaviv-add-gem-operations-structure-to-etna.patch"
	${git} "${DIR}/patches/etnaviv/0015-staging-etnaviv-convert-prime-import-to-use-etnaviv_.patch"
	${git} "${DIR}/patches/etnaviv/0016-staging-etnaviv-convert-shmem-release-to-use-etnaviv.patch"
	${git} "${DIR}/patches/etnaviv/0017-staging-etnaviv-convert-cmdbuf-release-to-use-etnavi.patch"
	${git} "${DIR}/patches/etnaviv/0018-staging-etnaviv-move-drm_gem_object_release.patch"
	${git} "${DIR}/patches/etnaviv/0019-staging-etnaviv-ensure-cleanup-of-reservation-object.patch"
	${git} "${DIR}/patches/etnaviv/0020-staging-etnaviv-clean-up-etnaviv_gem_free_object.patch"
	${git} "${DIR}/patches/etnaviv/0021-staging-etnaviv-provide-etnaviv_gem_new_private.patch"
	${git} "${DIR}/patches/etnaviv/0022-staging-etnaviv-move-msm_gem_import-etc-to-etnaviv_g.patch"
	${git} "${DIR}/patches/etnaviv/0023-staging-etnaviv-clean-up-prime-import.patch"
	${git} "${DIR}/patches/etnaviv/0024-staging-etnaviv-convert-get_pages-put_pages-to-take-.patch"
	${git} "${DIR}/patches/etnaviv/0025-staging-etnaviv-clean-up-etnaviv_gem_-get-put-_pages.patch"
	${git} "${DIR}/patches/etnaviv/0026-staging-etnaviv-add-gem-get_pages-method.patch"
	${git} "${DIR}/patches/etnaviv/0027-staging-etnaviv-fix-DMA-API-usage.patch"
	${git} "${DIR}/patches/etnaviv/0028-staging-etnaviv-add-support-to-insert-a-MMU-flush-in.patch"
	${git} "${DIR}/patches/etnaviv/0029-staging-etnaviv-move-GPU-memory-management-into-MMU.patch"
	${git} "${DIR}/patches/etnaviv/0030-staging-etnaviv-publish-and-use-mmu-geometry.patch"
	${git} "${DIR}/patches/etnaviv/0031-staging-etnaviv-mmuv1-ensure-we-unmap-all-entries.patch"
	${git} "${DIR}/patches/etnaviv/0032-staging-etnaviv-move-MMU-setup-and-teardown-code-to-.patch"
	${git} "${DIR}/patches/etnaviv/0033-staging-etnaviv-hack-bypass-iommu-with-contiguous-bu.patch"
	${git} "${DIR}/patches/etnaviv/0034-staging-etnaviv-implement-round-robin-GPU-MMU-alloca.patch"
	${git} "${DIR}/patches/etnaviv/0035-staging-etnaviv-fix-etnaviv_iommu_map_gem-return-pat.patch"
	${git} "${DIR}/patches/etnaviv/0036-staging-etnaviv-implement-MMU-reaping.patch"
	${git} "${DIR}/patches/etnaviv/0037-staging-etnaviv-move-scatterlist-creation-to-etnaviv.patch"
	${git} "${DIR}/patches/etnaviv/0038-staging-etnaviv-add-userptr-mapping-support.patch"
	${git} "${DIR}/patches/etnaviv/0039-staging-etnaviv-call-the-DRM-device-drm.patch"
	${git} "${DIR}/patches/etnaviv/0040-staging-etnaviv-clean-up-printk-s-etc.patch"
	${git} "${DIR}/patches/etnaviv/0041-staging-etnaviv-safely-take-down-hangcheck.patch"
	${git} "${DIR}/patches/etnaviv/0042-staging-etnaviv-move-hangcheck-disable-to-separate-f.patch"
	${git} "${DIR}/patches/etnaviv/0043-staging-etnaviv-stop-the-hangcheck-timer-mis-firing.patch"
	${git} "${DIR}/patches/etnaviv/0044-staging-etnaviv-ensure-that-we-retire-all-pending-ev.patch"
	${git} "${DIR}/patches/etnaviv/0045-staging-etnaviv-ensure-GPU-reset-times-out.patch"
	${git} "${DIR}/patches/etnaviv/0046-staging-etnaviv-add-workarounds-for-GC320-on-iMX6.patch"
	${git} "${DIR}/patches/etnaviv/0047-staging-etnaviv-increase-iommu-page-table-size-to-51.patch"
	${git} "${DIR}/patches/etnaviv/0048-staging-etnaviv-allow-non-DT-use.patch"
	${git} "${DIR}/patches/etnaviv/0049-staging-etnaviv-dump-mmu-allocations.patch"
	${git} "${DIR}/patches/etnaviv/0050-staging-etnaviv-use-definitions-for-constants.patch"
	${git} "${DIR}/patches/etnaviv/0051-staging-etnaviv-fix-fence-wrapping-for-gem-objects.patch"
	${git} "${DIR}/patches/etnaviv/0052-staging-etnaviv-move-scatterlist-map-unmap.patch"
	${git} "${DIR}/patches/etnaviv/0053-staging-etnaviv-remove-presumption-of-BO-addresses.patch"
	${git} "${DIR}/patches/etnaviv/0054-staging-etnaviv-remove-shifting-and-bitwise-or-ing-o.patch"
	${git} "${DIR}/patches/etnaviv/0055-staging-etnaviv-clean-up-etnaviv-mmu-scatterlist-cod.patch"
	${git} "${DIR}/patches/etnaviv/0056-staging-etnaviv-better-DMA-API-usage.patch"
	${git} "${DIR}/patches/etnaviv/0057-staging-etnaviv-iommu-add-a-poisoned-bad-page.patch"
	${git} "${DIR}/patches/etnaviv/0058-staging-etnaviv-validate-user-supplied-command-strea.patch"
	${git} "${DIR}/patches/etnaviv/0059-staging-etnaviv-allow-get_param-without-auth.patch"
	${git} "${DIR}/patches/etnaviv/0060-staging-etnaviv-fix-busy-reporting.patch"
	${git} "${DIR}/patches/etnaviv/0061-staging-etnaviv-fix-event-allocation-failure-path.patch"
	${git} "${DIR}/patches/etnaviv/0062-staging-etnaviv-remove-powerrail-support.patch"
	${git} "${DIR}/patches/etnaviv/0063-staging-etnaviv-NULL-out-stale-pointers-at-unbind-ti.patch"
	${git} "${DIR}/patches/etnaviv/0064-staging-etnaviv-move-mutex-around-component_-un-bind.patch"
	${git} "${DIR}/patches/etnaviv/0065-staging-etnaviv-move-PM-calls-into-bind-unbind-callb.patch"
	${git} "${DIR}/patches/etnaviv/0066-staging-etnaviv-separate-out-etnaviv-gpu-hardware-in.patch"
	${git} "${DIR}/patches/etnaviv/0067-staging-etnaviv-add-support-to-shutdown-and-restore-.patch"
	${git} "${DIR}/patches/etnaviv/0068-staging-etnaviv-runtime-PM-add-initial-support.patch"
	${git} "${DIR}/patches/etnaviv/0069-staging-etnaviv-add-support-for-offset-physical-memo.patch"
	${git} "${DIR}/patches/etnaviv/0070-staging-etnaviv-remove-add-child-kernel-message.patch"
	${git} "${DIR}/patches/etnaviv/0071-staging-etnaviv-quiten-down-some-further-debugging-m.patch"
	${git} "${DIR}/patches/etnaviv/0072-staging-etnaviv-avoid-holding-struct_mutex-over-dma_.patch"
	${git} "${DIR}/patches/etnaviv/0073-staging-etnaviv-restructure-iommu-handling.patch"
	${git} "${DIR}/patches/etnaviv/0074-staging-etnaviv-import-new-headers.patch"
	${git} "${DIR}/patches/etnaviv/0075-staging-etnaviv-allow-to-draw-up-to-256-rectangles-i.patch"
	${git} "${DIR}/patches/etnaviv/0076-staging-etnaviv-correct-instruction-count-for-GC2000.patch"
	${git} "${DIR}/patches/etnaviv/0077-staging-etnaviv-reconfigure-bus-mapping-on-GC2000.patch"
	${git} "${DIR}/patches/etnaviv/0078-staging-etnaviv-properly-flush-all-TLBs-on-MMUv1.patch"
	${git} "${DIR}/patches/etnaviv/0079-staging-etnaviv-convert-to_etnaviv_bo-to-real-functi.patch"
	${git} "${DIR}/patches/etnaviv/0080-staging-etnaviv-plug-in-fence-waiting-in-cpu_prepare.patch"
	${git} "${DIR}/patches/etnaviv/0081-staging-etnaviv-allow-to-map-buffer-object-into-mult.patch"
	${git} "${DIR}/patches/etnaviv/0082-staging-etnaviv-don-t-pretend-to-have-a-single-MMU.patch"
	${git} "${DIR}/patches/etnaviv/0083-staging-etnaviv-use-GPU-device-to-construct-MMU.patch"
	${git} "${DIR}/patches/etnaviv/0084-staging-etnaviv-flush-MMU-when-switching-context.patch"
	${git} "${DIR}/patches/etnaviv/0085-staging-etnaviv-add-flag-to-force-buffer-through-MMU.patch"
	${git} "${DIR}/patches/etnaviv/0086-staging-etnaviv-use-more-natural-devicetree-abstract.patch"
	${git} "${DIR}/patches/etnaviv/0087-staging-etnaviv-don-t-override-platform-provided-IRQ.patch"
	${git} "${DIR}/patches/etnaviv/0088-staging-etnaviv-separate-GPU-pipes-from-execution-st.patch"
	${git} "${DIR}/patches/etnaviv/0089-staging-etnaviv-clean-up-public-API.patch"
	${git} "${DIR}/patches/etnaviv/0090-staging-etnaviv-clean-up-public-API-part-2.patch"
	${git} "${DIR}/patches/etnaviv/0091-staging-etnaviv-rename-last-remaining-msm_-symbols.patch"
	${git} "${DIR}/patches/etnaviv/0092-staging-etnaviv-rename-last-remaining-bits-from-msm-.patch"
	${git} "${DIR}/patches/etnaviv/0093-staging-etnaviv-quiten-down-kernel-log-output.patch"
	${git} "${DIR}/patches/etnaviv/0094-staging-etnaviv-add-proper-license-header-to-all-fil.patch"
	${git} "${DIR}/patches/etnaviv/0095-staging-etnaviv-add-Dove-GPU-subsystem-compatible.patch"
	${git} "${DIR}/patches/etnaviv/0096-staging-etnaviv-fix-missing-error-cleanups-in-etnavi.patch"
	${git} "${DIR}/patches/etnaviv/0097-staging-etnaviv-fix-off-by-one-for-iommu-aperture-en.patch"
	${git} "${DIR}/patches/etnaviv/0098-staging-etnaviv-avoid-lockdep-circular-dependency-wa.patch"
	${git} "${DIR}/patches/etnaviv/0099-staging-etnaviv-fix-gpu-debugfs-show-implementation.patch"
	${git} "${DIR}/patches/etnaviv/0100-staging-etnaviv-use-vm_insert_page-rather-than-vm_in.patch"
	${git} "${DIR}/patches/etnaviv/0101-staging-etnaviv-etnaviv_gem_fault-reduce-struct_mute.patch"
	${git} "${DIR}/patches/etnaviv/0102-staging-etnaviv-give-etnaviv_gem_mmap_offset-a-sane-.patch"
	${git} "${DIR}/patches/etnaviv/0103-staging-etnaviv-allow-etnaviv_ioctl_gem_info-locking.patch"
	${git} "${DIR}/patches/etnaviv/0104-staging-etnaviv-make-context-a-per-GPU-thing.patch"
	${git} "${DIR}/patches/etnaviv/0105-staging-etnaviv-switch-to-per-GPU-fence-completion-i.patch"
	${git} "${DIR}/patches/etnaviv/0106-staging-etnaviv-provide-etnaviv_queue_work.patch"
	${git} "${DIR}/patches/etnaviv/0107-staging-etnaviv-use-standard-kernel-types-rather-tha.patch"
	${git} "${DIR}/patches/etnaviv/0108-staging-etnaviv-no-need-to-initialise-a-list_head.patch"
	${git} "${DIR}/patches/etnaviv/0109-staging-etnaviv-fix-oops-caused-by-scanning-for-free.patch"
	${git} "${DIR}/patches/etnaviv/0110-staging-etnaviv-clean-up-etnaviv_iommu_unmap_gem-sig.patch"
	${git} "${DIR}/patches/etnaviv/0111-staging-etnaviv-increase-page-table-size-to-maximum.patch"
	${git} "${DIR}/patches/etnaviv/0112-staging-etnaviv-fix-BUG_ON-when-removing-module.patch"
	${git} "${DIR}/patches/etnaviv/0113-staging-etnaviv-fix-oops-on-removing-module.patch"
	${git} "${DIR}/patches/etnaviv/0114-staging-etnaviv-provide-a-helper-to-load-the-GPU-clo.patch"
	${git} "${DIR}/patches/etnaviv/0115-staging-etnaviv-rename-GPU-clock-functions.patch"
	${git} "${DIR}/patches/etnaviv/0116-staging-etnaviv-fix-runtime-resume.patch"
	${git} "${DIR}/patches/etnaviv/0117-staging-etnaviv-drop-event-ring-buffer-tracking.patch"
	${git} "${DIR}/patches/etnaviv/0118-staging-etnaviv-improve-efficiency-of-command-parser.patch"
	${git} "${DIR}/patches/etnaviv/0119-staging-etnaviv-no-point-looking-up-the-mapping-for-.patch"
	${git} "${DIR}/patches/etnaviv/0120-staging-etnaviv-copy-submit-command-and-bos-in-one-g.patch"
	${git} "${DIR}/patches/etnaviv/0121-staging-etnaviv-remove-cmd-buffer-offset-validation-.patch"
	${git} "${DIR}/patches/etnaviv/0122-staging-etnaviv-move-mapping-teardown-into-etnaviv_g.patch"
	${git} "${DIR}/patches/etnaviv/0123-staging-etnaviv-add-support-for-GEM_WAIT-ioctl.patch"
	${git} "${DIR}/patches/etnaviv/0124-staging-etnaviv-avoid-pinning-pages-in-CMA.patch"
	${git} "${DIR}/patches/etnaviv/0125-staging-etnaviv-fix-ret-may-be-used-uninitialized-in.patch"
	${git} "${DIR}/patches/etnaviv/0126-staging-etnaviv-fix-error-etnaviv_gpu_hw_resume-defi.patch"
	${git} "${DIR}/patches/etnaviv/0127-staging-etnaviv-debugfs-add-possibility-to-dump-kern.patch"
	${git} "${DIR}/patches/etnaviv/0128-staging-etnaviv-change-etnaviv_buffer_init-to-return.patch"
	${git} "${DIR}/patches/etnaviv/0129-staging-etnaviv-prune-dumb-buffer-support.patch"
	${git} "${DIR}/patches/etnaviv/0130-staging-etnaviv-implement-simple-hang-recovery.patch"
	${git} "${DIR}/patches/etnaviv/0131-staging-etnaviv-map-all-buffers-to-the-GPU.patch"
	${git} "${DIR}/patches/etnaviv/0132-staging-etnaviv-implement-cache-maintenance-on-cpu_-.patch"
	${git} "${DIR}/patches/etnaviv/0133-staging-etnaviv-remove-submit-type.patch"
	${git} "${DIR}/patches/etnaviv/0134-staging-etnaviv-rewrite-submit-interface-to-use-copy.patch"
	${git} "${DIR}/patches/etnaviv/0135-staging-etnaviv-don-t-use-GEM-buffer-for-internal-ri.patch"
	${git} "${DIR}/patches/etnaviv/0136-staging-etnaviv-remove-CMDSTREAM-GEM-allocation-from.patch"
	${git} "${DIR}/patches/etnaviv/0137-staging-etnaviv-some-final-trivial-changes-to-the-mo.patch"
	${git} "${DIR}/patches/etnaviv/0138-staging-etnaviv-remove-compat-MMU-code.patch"
	${git} "${DIR}/patches/etnaviv/0139-ARM-imx6-add-Vivante-GPU-nodes.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=139
		cleanup
	fi
}

quieter () {
	echo "dir: quieter"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/quieter/0001-quiet-8250_omap.c-use-pr_info-over-pr_err.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

###
reverts
ti
dts
wand
#errata
#fixes
pru
bbb_overlays
beaglebone
etnaviv
quieter

packaging () {
	echo "dir: packaging"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
		git commit -a -m 'packaging: sync builddeb changes' -s
		git format-patch -1 -o "${DIR}/patches/packaging"
		exit 2
	else
		${git} "${DIR}/patches/packaging/0001-packaging-sync-builddeb-changes.patch"
	fi
}

packaging
echo "patch.sh ran successfully"
