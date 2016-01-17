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

aufs_fail () {
	echo "aufs4 failed"
	exit 2
}

aufs4 () {
	echo "dir: aufs4"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-kbuild.patch
		patch -p1 < aufs4-kbuild.patch || aufs_fail
		rm -rf aufs4-kbuild.patch
		git add .
		git commit -a -m 'merge: aufs4-kbuild' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-base.patch
		patch -p1 < aufs4-base.patch || aufs_fail
		rm -rf aufs4-base.patch
		git add .
		git commit -a -m 'merge: aufs4-base' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-mmap.patch
		patch -p1 < aufs4-mmap.patch || aufs_fail
		rm -rf aufs4-mmap.patch
		git add .
		git commit -a -m 'merge: aufs4-mmap' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-standalone.patch
		patch -p1 < aufs4-standalone.patch || aufs_fail
		rm -rf aufs4-standalone.patch
		git add .
		git commit -a -m 'merge: aufs4-standalone' -s

		git format-patch -4 -o ../patches/aufs4/
		exit 2
	fi

	${git} "${DIR}/patches/aufs4/0001-merge-aufs4-kbuild.patch"
	${git} "${DIR}/patches/aufs4/0002-merge-aufs4-base.patch"
	${git} "${DIR}/patches/aufs4/0003-merge-aufs4-mmap.patch"
	${git} "${DIR}/patches/aufs4/0004-merge-aufs4-standalone.patch"

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#patch -p1 < "${DIR}/patches/aufs4/0005-aufs-why-this-isnt-a-patch.patch"
	#exit 2

	${git} "${DIR}/patches/aufs4/0005-aufs-why-this-isnt-a-patch.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
		cleanup
	fi
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
#aufs4
#rt
#local_patch

lts44_backports () {
	echo "dir: lts44_backports"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		#echo "dir: backports/mediatek"
		#directory="backports/mediatek"
		#SHA="c869f77d6abb5d5f9f2f1a661d5c53862a9cad34" ; num="1" ; mainline

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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
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

udoo () {
	echo "dir: udoo"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/udoo/0001-usb-hub-add-device-tree-support-for-populating-onboa.patch"
	${git} "${DIR}/patches/udoo/0002-doc-dt-binding-generic-onboard-USB-device.patch"
	${git} "${DIR}/patches/udoo/0003-usb-misc-generic_onboard_hub-add-generic-onboard-USB.patch"
	${git} "${DIR}/patches/udoo/0004-usb-chipidea-host-let-the-hcd-know-s-parent-device-n.patch"
	${git} "${DIR}/patches/udoo/0005-ARM-dts-imx6qdl-udoo.dtsi-fix-onboard-USB-HUB-proper.patch"
	${git} "${DIR}/patches/udoo/0006-udoo-sync-pincfgs-with-https-github.com-UDOOboard-li.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=6
		cleanup
	fi
}

pru_uio () {
	echo "dir: pru_uio"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/pru_uio/0001-Making-the-uio-pruss-driver-work.patch"
	${git} "${DIR}/patches/pru_uio/0002-Cleaned-up-error-reporting.patch"

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

	echo "dir: bbb_overlays/nvmem"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/nvmem/0001-nvmem-make-default-user-binary-file-root-access-only.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0002-nvmem-set-the-size-for-the-nvmem-binary-file.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0003-nvmem-add-permission-flags-in-nvmem_config.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0004-nvmem-fix-permissions-of-readonly-nvmem-binattr.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=4
		cleanup
	fi

	echo "dir: bbb_overlays/configfs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="bbb_overlays/configfs"
		#merged in 4.5.0-rc0
		SHA="03607ace807b414eab46323c794b6fb8fcc2d48c" ; num="1" ; mainline
		exit 2
	fi

	#(< 4.5.0-rc0)
#	${git} "${DIR}/patches/bbb_overlays/configfs/0001-configfs-implement-binary-attributes.patch"


	echo "dir: bbb_overlays/of"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="bbb_overlays/of"
		#merged in 4.5.0-rc0
		SHA="183223770ae8625df8966ed15811d1b3ee8720aa" ; num="1" ; mainline
		exit 2
	fi

	#(< 4.5.0-rc0)
#	${git} "${DIR}/patches/bbb_overlays/of/0001-drivers-of-Export-OF-changeset-functions.patch"

	echo "dir: bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/0001-OF-DT-Overlay-configfs-interface-v6.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0003-add-PM-firmware.patch"
	${git} "${DIR}/patches/bbb_overlays/0004-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0005-arm-omap-Proper-cleanups-for-omap_device.patch"
	${git} "${DIR}/patches/bbb_overlays/0006-serial-omap-Fix-port-line-number-without-aliases.patch"
	${git} "${DIR}/patches/bbb_overlays/0007-tty-omap-serial-Fix-up-platform-data-alloc.patch"
	${git} "${DIR}/patches/bbb_overlays/0008-ARM-DT-Enable-symbols-when-CONFIG_OF_OVERLAY-is-used.patch"

	#v4.5.0-rc0 merge...
	#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=33caf82acf4dc420bf0f0136b886f7b27ecf90c5
	${git} "${DIR}/patches/bbb_overlays/0009-of-Custom-printk-format-specifier-for-device-node.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0010-of-overlay-kobjectify-overlay-objects.patch"

	${git} "${DIR}/patches/bbb_overlays/0011-of-overlay-global-sysfs-enable-attribute.patch"
	${git} "${DIR}/patches/bbb_overlays/0012-Documentation-ABI-overlays-global-attributes.patch"
	${git} "${DIR}/patches/bbb_overlays/0013-Documentation-document-of_overlay_disable-parameter.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0014-of-overlay-add-per-overlay-sysfs-attributes.patch"

	${git} "${DIR}/patches/bbb_overlays/0015-Documentation-ABI-overlays-per-overlay-docs.patch"
	${git} "${DIR}/patches/bbb_overlays/0016-i2c-nvmem-at24-Provide-an-EEPROM-framework-interface.patch"
	${git} "${DIR}/patches/bbb_overlays/0017-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/bbb_overlays/0018-doc-misc-Beaglebone-capemanager-documentation.patch"
	${git} "${DIR}/patches/bbb_overlays/0019-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/bbb_overlays/0020-doc-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/bbb_overlays/0021-MAINTAINERS-Beaglebone-capemanager-maintainer.patch"
	${git} "${DIR}/patches/bbb_overlays/0022-arm-dts-Enable-beaglebone-cape-manager.patch"
	${git} "${DIR}/patches/bbb_overlays/0023-of-overlay-Implement-indirect-target-support.patch"
	${git} "${DIR}/patches/bbb_overlays/0024-of-unittest-Add-indirect-overlay-target-test.patch"
	${git} "${DIR}/patches/bbb_overlays/0025-doc-dt-Document-the-indirect-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0026-of-overlay-Introduce-target-root-capability.patch"
	${git} "${DIR}/patches/bbb_overlays/0027-of-unittest-Unit-tests-for-target-root-overlays.patch"
	${git} "${DIR}/patches/bbb_overlays/0028-doc-dt-Document-the-target-root-overlay-method.patch"
	${git} "${DIR}/patches/bbb_overlays/0029-of-dynamic-Add-__of_node_dupv.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0030-of-changesets-Introduce-changeset-helper-methods.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0031-RFC-Device-overlay-manager-PCI-USB-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0032-boneblack-defconfig.patch"
	${git} "${DIR}/patches/bbb_overlays/0033-connector-wip.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0034-of-remove-bogus-return-in-of_core_init.patch"
	${git} "${DIR}/patches/bbb_overlays/0035-of-Maintainer-fixes-for-dynamic.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0036-of-unittest-changeset-helpers.patch"

	${git} "${DIR}/patches/bbb_overlays/0037-of-rename-_node_sysfs-to-_node_post.patch"
	${git} "${DIR}/patches/bbb_overlays/0038-of-Support-hashtable-lookups-for-phandles.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=38
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
		device="am335x-abbbi.dtb" ; dtb_makefile_append

		device="am335x-arduino-tre.dtb" ; dtb_makefile_append

		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-r.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbbmini.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append

		device="am335x-boneblack-emmc-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-hdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-nhdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-overlay.dtb" ; dtb_makefile_append

		device="am335x-boneblack-replicape.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append

		device="am335x-bonegreen-overlay.dtb" ; dtb_makefile_append

		device="am335x-olimex-som.dtb" ; dtb_makefile_append

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

	echo "dir: etnaviv/mainline"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		directory="etnaviv/mainline"
		#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=etnaviv

		#merged in 4.5.0-rc0

		#drm/etnaviv: add devicetree bindings
		SHA="f04b205ac143413831b193f39fd9592665111d4b" ; num="1" ; mainline

		#drm/etnaviv: add initial etnaviv DRM driver
		SHA="a8c21a5451d831e67b7a6fb910f9ca8bc7b43554" ; num="2" ; mainline

		#MAINTAINERS: add maintainer and reviewers for the etnaviv DRM driver
		SHA="8bb0bce92ec9330b0ea931df90f719fb5c4a5224" ; num="3" ; mainline

		#drm/etnaviv: unlock on error in etnaviv_gem_get_iova()
		SHA="ed94add00e290e675c36cef6767d7d1f51a02f28" ; num="4" ; mainline

		#drm/etnaviv: fix workaround for GC500
		SHA="c33246d793b5bb9d8be7c67918136c310185c23d" ; num="5" ; mainline
		exit 2
	fi

	#merged in 4.5.0-rc0
#	${git} "${DIR}/patches/etnaviv/mainline/0001-drm-etnaviv-add-devicetree-bindings.patch"
#	${git} "${DIR}/patches/etnaviv/mainline/0002-drm-etnaviv-add-initial-etnaviv-DRM-driver.patch"
#	${git} "${DIR}/patches/etnaviv/mainline/0004-drm-etnaviv-unlock-on-error-in-etnaviv_gem_get_iova.patch"
#	${git} "${DIR}/patches/etnaviv/mainline/0003-MAINTAINERS-add-maintainer-and-reviewers-for-the-etn.patch"
#	${git} "${DIR}/patches/etnaviv/mainline/0005-drm-etnaviv-fix-workaround-for-GC500.patch"

	echo "dir: etnaviv"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/etnaviv/0001-ARM-dts-imx6-add-Vivante-GPU-nodes.patch"
	${git} "${DIR}/patches/etnaviv/0002-ARM-dts-dove-add-DT-GPU-support.patch"
	${git} "${DIR}/patches/etnaviv/0003-ARM-dts-enable-GPU-for-SolidRun-s-Cubox.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
}

quieter () {
	echo "dir: quieter"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#quiet some hide obvious things...
	${git} "${DIR}/patches/quieter/0001-quiet-8250_omap.c-use-pr_info-over-pr_err.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

###
lts44_backports
reverts
ti
dts
wand
udoo
pru_uio
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
