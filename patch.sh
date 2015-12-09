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

backports () {
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		echo "dir: backports/mediatek"
		directory="backports/mediatek"
		SHA="c869f77d6abb5d5f9f2f1a661d5c53862a9cad34" ; num="1" ; mainline
		SHA="69647fab13a5cbc305b50305fdd7dd4114c0e8db" ; num="2" ; mainline
		SHA="2af6d21fce9990630d2adfda5a329706aa9e3571" ; num="3" ; mainline
		SHA="9a15b57e9a2c591a812d979fa3f4f1a763533636" ; num="4" ; mainline
		SHA="2dea58f62964f80883c8de80c0b5df8dbce0b278" ; num="5" ; mainline
		SHA="8d0123748af0248750b123f9bfb8040d74691a77" ; num="6" ; mainline

		exit 2
	fi
}

reverts () {
	echo "dir: reverts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/reverts/0001-Revert-spi-spidev-Warn-loudly-if-instantiated-from-D.patch"
	#udoo:
#	${git} "${DIR}/patches/reverts/0002-Revert-usb-chipidea-usbmisc_imx-delete-clock-informa.patch"

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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=8
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
		SHA="6230699469523337d65bb5e2f47279dfcf3eea17" ; num="9" ; mainline
		SHA="22dbdb7cbf7214befd3a449ba7959c8cf4038e6c" ; num="10" ; mainline
		SHA="5380a9a6acd990833f76c52c1327a289d09d88aa" ; num="11" ; mainline
		SHA="3edba6b47e4265948db3a77a0137157c033d69e2" ; num="12" ; mainline
		SHA="fb86de91c2a48e320bfa3767802d9a1fb204a230" ; num="13" ; mainline
		SHA="c01e9a11ab6f3096a54574c3224d8732a374f135" ; num="14" ; mainline
		SHA="faf25a9089fc9bdc277b30dbdef8ea7ad7c9083b" ; num="15" ; mainline
		SHA="03a69568e07e1150e1cfdb862892798f88dafd17" ; num="16" ; mainline
		SHA="7e532f7925f1758369c7963297baceac3cbaefc1" ; num="17" ; mainline
		SHA="7c806883e143dc60439e6bdb3589700ebed1efaa" ; num="18" ; mainline
		SHA="cbf854ab36870b931aeba4edd954015b7c3005a2" ; num="19" ; mainline
		SHA="ace22170655f61d82fff95e57d673bf847a32a03" ; num="20" ; mainline
		SHA="fb727077b04f768d0c79d9aa29e958262a9e3d9e" ; num="21" ; mainline
		exit 2
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#email...
	${git} "${DIR}/patches/bbb_overlays/nvmem/0022-nvmem-make-default-user-binary-file-root-access-only.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0023-nvmem-set-the-size-for-the-nvmem-binary-file.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0024-nvmem-add-permission-flags-in-nvmem_config.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0025-nvmem-fix-permissions-of-readonly-nvmem-binattr.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=25
		cleanup
	fi

	echo "dir: bbb_overlays/configfs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="bbb_overlays/configfs"
		SHA="870823e629ea194e6cf8e82a9694ac62cad49512" ; num="1" ; mainline
		SHA="45b6a73f62ebcf3ff067895fb8030e67f4c7b67f" ; num="2" ; mainline
		SHA="76e0da34c7cec5a7dc94667326a948de2e9c8c8d" ; num="3" ; mainline
		SHA="da4e527cd8850712bb705f4c41f0839705ab7c98" ; num="4" ; mainline
		SHA="ea6bd6b14ec67eb22e3eb8b2a2b979b5ea800a3a" ; num="5" ; mainline
		SHA="f9a63da33d3f86acadc14c5cb66e9ad06860892f" ; num="6" ; mainline
		SHA="75ab2256a7d05128f8aa088cdde961d8029bcd55" ; num="7" ; mainline
		SHA="3755a273db8f523f8be6c18df9e1506faa93c664" ; num="8" ; mainline
		SHA="aa48a415270f7cf16ec0ef825d19b4f8bd1a875e" ; num="9" ; mainline
		SHA="208e61ac7c0a2c3e4b23e74a66ddc2ea471d251e" ; num="10" ; mainline
		SHA="4a90cb203836e4989cc50121b13ff0fb7f671fcb" ; num="11" ; mainline
		SHA="c6f89f1cca1cfd81cc27307595ebddee29cc84d3" ; num="12" ; mainline
		SHA="495702bcc12fb2c51997088befe37145a34e5e3a" ; num="13" ; mainline
		SHA="3da5e4c10cbacf5f3da043498299ae631a6dfc9c" ; num="14" ; mainline
		SHA="0736390bea65cac63bed9671a957031c068a60e7" ; num="15" ; mainline
		SHA="0b4be4fa878780a15a953577499eb69839942956" ; num="16" ; mainline
		SHA="9ae0f367df5d0d7be09fad1e2e5b080f6a45ca6b" ; num="17" ; mainline
		SHA="2eafd72939fda6118e27d3ee859684987f43921b" ; num="18" ; mainline
		SHA="517982229f78b2aebf00a8a337e84e8eeea70b8e" ; num="19" ; mainline
		exit 2
	fi

	echo "dir: bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/0001-configfs-Implement-binary-attributes-v5.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-OF-DT-Overlay-configfs-interface-v6.patch"
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
	${git} "${DIR}/patches/bbb_overlays/0013-Documentation-ABI-overlays-global-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0014-Documentation-document-of_overlay_disable-parameter.patch"
	${git} "${DIR}/patches/bbb_overlays/0015-of-overlay-add-per-overlay-sysfs-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0016-Documentation-ABI-overlays-per-overlay-docs.patch"
	${git} "${DIR}/patches/bbb_overlays/0017-i2c-nvmem-at24-Provide-an-EEPROM-framework-interface.patch"
	${git} "${DIR}/patches/bbb_overlays/0018-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/bbb_overlays/0019-doc-misc-Beaglebone-capemanager-documentation.patch"
	${git} "${DIR}/patches/bbb_overlays/0020-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/bbb_overlays/0021-doc-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/bbb_overlays/0022-MAINTAINERS-Beaglebone-capemanager-maintainer.patch"
	${git} "${DIR}/patches/bbb_overlays/0023-arm-dts-Enable-beaglebone-cape-manager.patch"
	${git} "${DIR}/patches/bbb_overlays/0024-of-overlay-Implement-indirect-target-support.patch"
	${git} "${DIR}/patches/bbb_overlays/0025-of-unittest-Add-indirect-overlay-target-test.patch"
	${git} "${DIR}/patches/bbb_overlays/0026-doc-dt-Document-the-indirect-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0027-of-overlay-Introduce-target-root-capability.patch"
	${git} "${DIR}/patches/bbb_overlays/0028-of-unittest-Unit-tests-for-target-root-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0029-doc-dt-Document-the-target-root-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0030-of-dynamic-Add-__of_node_dupv.patch"
	${git} "${DIR}/patches/bbb_overlays/0031-of-changesets-Introduce-changeset-helper-methods.patch"
	${git} "${DIR}/patches/bbb_overlays/0032-RFC-Device-overlay-manager-PCI-USB-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0033-boneblack-defconfig.patch"
	${git} "${DIR}/patches/bbb_overlays/0034-connector-wip.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0035-of-remove-bogus-return-in-of_core_init.patch"
	${git} "${DIR}/patches/bbb_overlays/0036-of-Maintainer-fixes-for-dynamic.patch"
	${git} "${DIR}/patches/bbb_overlays/0037-of-unittest-changeset-helpers.patch"
	${git} "${DIR}/patches/bbb_overlays/0038-of-rename-_node_sysfs-to-_node_post.patch"
	${git} "${DIR}/patches/bbb_overlays/0039-of-Support-hashtable-lookups-for-phandles.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=39
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
	${git} "${DIR}/patches/beaglebone/dts/0004-add-overlay-dtb.patch"
	${git} "${DIR}/patches/beaglebone/dts/0005-tps65217-Enable-KEY_POWER-press-on-AC-loss-PWR_BUT.patch"
	${git} "${DIR}/patches/beaglebone/dts/0006-spi-omap2-mcspi-ti-pio-mode.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=6
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
		device="am335x-boneblack-spi0.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append
		device="am335x-boneblack-universal.dtb" ; dtb_makefile_append

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

	${git} "${DIR}/patches/etnaviv/0001-devicetree-add-vendor-prefix-for-Vivante-Corporation.patch"
	${git} "${DIR}/patches/etnaviv/0002-drm-etnaviv-add-devicetree-bindings.patch"
	${git} "${DIR}/patches/etnaviv/0003-drm-etnaviv-add-etnaviv-UAPI-header.patch"
	${git} "${DIR}/patches/etnaviv/0004-drm-etnaviv-add-generated-hardware-description-heade.patch"
	${git} "${DIR}/patches/etnaviv/0005-drm-etnaviv-add-GPU-core-driver.patch"
	${git} "${DIR}/patches/etnaviv/0006-drm-etnaviv-add-GEM-core-functionality.patch"
	${git} "${DIR}/patches/etnaviv/0007-drm-etnaviv-add-GEM-submit-and-cmdstream-validation-.patch"
	${git} "${DIR}/patches/etnaviv/0008-drm-etnaviv-add-GPU-MMU-handling-functionality.patch"
	${git} "${DIR}/patches/etnaviv/0009-drm-etnaviv-add-GPU-core-dump-functionality.patch"
	${git} "${DIR}/patches/etnaviv/0010-drm-etnaviv-add-master-driver-and-hook-up-in-Kconfig.patch"
	${git} "${DIR}/patches/etnaviv/0011-MAINTAINERS-add-maintainer-and-reviewers-for-the-etn.patch"
	${git} "${DIR}/patches/etnaviv/0012-ARM-dts-imx6-add-Vivante-GPU-nodes.patch"
	${git} "${DIR}/patches/etnaviv/0013-ARM-dts-dove-add-DT-GPU-support.patch"
	${git} "${DIR}/patches/etnaviv/0014-ARM-dts-enable-GPU-for-SolidRun-s-Cubox.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=14
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
backports
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
