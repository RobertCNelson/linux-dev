#!/bin/sh -e
#
# Copyright (c) 2009-2016 Robert Nelson <robertcnelson@gmail.com>
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

#merged_in_4_5="enable"
unset merged_in_4_5
#merged_in_4_6="enable"
unset merged_in_4_6

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		if [ "x${wdir}" = "x" ] ; then
			git format-patch -${number} -o ${DIR}/patches/
		else
			git format-patch -${number} -o ${DIR}/patches/${wdir}/
			unset wdir
		fi
	fi
	exit 2
}

cherrypick () {
	if [ ! -d ../patches/${cherrypick_dir} ] ; then
		mkdir -p ../patches/${cherrypick_dir}
	fi
	git format-patch -1 ${SHA} --start-number ${num} -o ../patches/${cherrypick_dir}
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
		echo "dir: aufs4"

		cd ../
		if [ ! -f ./aufs4-standalone ] ; then
			git clone https://github.com/sfjro/aufs4-standalone
			cd ./aufs4-standalone
			git checkout origin/aufs${KERNEL_REL} -b tmp
			cd ../
		fi
		cd ./KERNEL/

		cp -v ../aufs4-standalone/Documentation/ABI/testing/*aufs ./Documentation/ABI/testing/
		mkdir -p ./Documentation/filesystems/aufs/
		cp -rv ../aufs4-standalone/Documentation/filesystems/aufs/* ./Documentation/filesystems/aufs/
		mkdir -p ./fs/aufs/
		cp -v ../aufs4-standalone/fs/aufs/* ./fs/aufs/
		cp -v ../aufs4-standalone/include/uapi/linux/aufs_type.h ./include/uapi/linux/

		git add .
		git commit -a -m 'merge: aufs4' -s
		git format-patch -5 -o ../patches/aufs4/

		exit 2
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/aufs4/0005-merge-aufs4.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		git format-patch -5 -o ../patches/aufs4/
		exit 2
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

ti () {
	is_mainline="enable"
	if [ "x${is_mainline}" = "xenable" ] ; then
		echo "dir: ti/iodelay/"
		#regenerate="enable"
		if [ "x${regenerate}" = "xenable" ] ; then
			start_cleanup
		fi

		${git} "${DIR}/patches/ti/iodelay/0001-pinctrl-bindings-pinctrl-Add-support-for-TI-s-IODela.patch"
		${git} "${DIR}/patches/ti/iodelay/0002-pinctrl-Introduce-TI-IOdelay-configuration-driver.patch"
		${git} "${DIR}/patches/ti/iodelay/0003-ARM-dts-dra7-Add-iodelay-module.patch"

		if [ "x${regenerate}" = "xenable" ] ; then
			number=3
			cleanup
		fi
	fi
	unset is_mainline

	echo "dir: ti/dtbs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/ti/dtbs/0001-sync-with-ti-4.4.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

exynos () {
	echo "dir: exynos/"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/exynos/0001-clk-samsung-exynos3250-Add-UART2-clock.patch"
	${git} "${DIR}/patches/exynos/0002-clk-samsung-exynos3250-Add-MMC2-clock.patch"
	${git} "${DIR}/patches/exynos/0003-ARM-dts-Add-UART2-dt-node-for-Exynos3250-SoC.patch"
	${git} "${DIR}/patches/exynos/0004-ARM-dts-Add-MSHC2-dt-node-for-Exynos3250-SoC.patch"
	${git} "${DIR}/patches/exynos/0005-ARM-dts-Add-exynos3250-artik5-dtsi-file-for-ARTIK5-m.patch"
	${git} "${DIR}/patches/exynos/0006-ARM-dts-Add-MSHC0-dt-node-for-eMMC-device-for-exynos.patch"
	${git} "${DIR}/patches/exynos/0007-ARM-dts-Add-thermal-zone-and-cpufreq-node-for-exynos.patch"
	${git} "${DIR}/patches/exynos/0008-ARM-dts-Add-rtc-and-adc-dt-node-for-exynos3250-artik.patch"
	${git} "${DIR}/patches/exynos/0009-ARM-dts-Add-MSHC2-dt-node-for-SD-card-for-exynos3250.patch"
	${git} "${DIR}/patches/exynos/0010-ARM-dts-Add-PPMU-node-for-exynos3250-artik5-module.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=10
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
	${git} "${DIR}/patches/dts/0009-mcimx6ul-bb-and-ism43362-b81-evb.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="dts"
		number=9
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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

pru_rpmsg () {
	echo "dir: pru_rpmsg"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#${git} "${DIR}/patches/pru_rpmsg/0001-Fix-remoteproc-to-work-with-the-PRU-GNU-Binutils-por.patch"
#http://git.ti.com/gitweb/?p=ti-linux-kernel/ti-linux-kernel.git;a=commit;h=c2e6cfbcf2aafc77e9c7c8f1a3d45b062bd21876
#	${git} "${DIR}/patches/pru_rpmsg/0002-Add-rpmsg_pru-support.patch"
	${git} "${DIR}/patches/pru_rpmsg/0003-ARM-samples-seccomp-no-m32.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi
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
		git pull --no-edit https://github.com/RobertCNelson/dtc bb.org-4.1-dt-overlays5-dtc-b06e55c88b9b

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

		#4.6.0-rc: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=91feabc2e2240ee80dc8ac08103cb83f497e4d12
		${git} "${DIR}/patches/bbb_overlays/dtc/0001-scripts-dtc-Update-to-upstream-version-overlays.patch"

		if [ "x${regenerate}" = "xenable" ] ; then
			number=1
			cleanup
		fi
	fi

	echo "dir: bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/bbb_overlays/0001-OF-DT-Overlay-configfs-interface-v7.patch"
	${git} "${DIR}/patches/bbb_overlays/0002-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0003-add-PM-firmware.patch"
	${git} "${DIR}/patches/bbb_overlays/0004-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	#depends on: cf26f1137333251f3515dea31f95775b99df0fd5
	${git} "${DIR}/patches/bbb_overlays/0005-omap-Fix-crash-when-omap-device-is-disabled.patch"

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

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0029-of-changesets-Introduce-changeset-helper-methods.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0030-RFC-Device-overlay-manager-PCI-USB-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0031-boneblack-defconfig.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0032-of-remove-bogus-return-in-of_core_init.patch"
	${git} "${DIR}/patches/bbb_overlays/0033-of-Maintainer-fixes-for-dynamic.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0034-of-unittest-changeset-helpers.patch"

	${git} "${DIR}/patches/bbb_overlays/0035-of-rename-_node_sysfs-to-_node_post.patch"
	${git} "${DIR}/patches/bbb_overlays/0036-of-Support-hashtable-lookups-for-phandles.patch"
	${git} "${DIR}/patches/bbb_overlays/0037-of-overlay-Pick-up-label-symbols-from-overlays.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/bbb_overlays/0038-connector-wip.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="bbb_overlays"
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

	${git} "${DIR}/patches/beaglebone/dts/0001-dts-am335x-bone-common-fixup-leds-to-match-3.8.patch"
	${git} "${DIR}/patches/beaglebone/dts/0002-arm-dts-am335x-bone-common-add-collision-and-carrier.patch"
	${git} "${DIR}/patches/beaglebone/dts/0003-am335x-bone-common-disable-default-clkout2_pin.patch"
	${git} "${DIR}/patches/beaglebone/dts/0004-tps65217-Enable-KEY_POWER-press-on-AC-loss-PWR_BUT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="beaglebone/dts"
		number=4
		cleanup
	fi

	#echo "dir: beaglebone/tps65217"
	##regenerate="enable"
	#if [ "x${regenerate}" = "xenable" ] ; then
	#	start_cleanup
	#fi

	#${git} "${DIR}/patches/beaglebone/tps65217/0001-mfd-tps65217-Add-support-for-IRQs.patch"
	#${git} "${DIR}/patches/beaglebone/tps65217/0002-power_supply-tps65217-charger-Fix-NULL-deref-during-.patch"
	#${git} "${DIR}/patches/beaglebone/tps65217/0003-power_supply-tps65217-charger-Add-support-for-IRQs.patch"
	#${git} "${DIR}/patches/beaglebone/tps65217/0004-mfd-tps65217-Add-power-button-as-subdevice.patch"
	#${git} "${DIR}/patches/beaglebone/tps65217/0005-Input-Add-tps65217-power-button-driver.patch"
	#${git} "${DIR}/patches/beaglebone/tps65217/0006-rtc-omap-Support-ext_wakeup-configuration.patch"

	#if [ "x${regenerate}" = "xenable" ] ; then
	#	wdir="beaglebone/tps65217"
	#	number=6
	#	cleanup
	#fi

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
	${git} "${DIR}/patches/beaglebone/eqep/0003-tieqep-cleanup.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

	echo "dir: beaglebone/overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/overlays/0001-am335x-overlays.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	echo "dir: beaglebone/abbbi"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/abbbi/0001-gpu-drm-i2c-add-alternative-adv7511-driver-with-audi.patch"
	${git} "${DIR}/patches/beaglebone/abbbi/0002-gpu-drm-i2c-adihdmi-componentize-driver-and-huge-ref.patch"
	${git} "${DIR}/patches/beaglebone/abbbi/0003-ARM-dts-add-Arrow-BeagleBone-Black-Industrial-dts.patch"
	${git} "${DIR}/patches/beaglebone/abbbi/0004-drm-adihdmi-Drop-dummy-save-restore-hooks.patch"
	${git} "${DIR}/patches/beaglebone/abbbi/0005-drm-adihdmi-Pass-name-to-drm_encoder_init.patch"
	${git} "${DIR}/patches/beaglebone/abbbi/0006-adihdmi_drv-reg_default-reg_sequence.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=6
		cleanup
	fi

	echo "dir: beaglebone/am335x_olimex_som"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/am335x_olimex_som/0001-ARM-dts-Add-support-for-Olimex-AM3352-SOM.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	echo "dir: beaglebone/bbgw"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/bbgw/0001-add-beaglebone-green-wireless.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	echo "dir: beaglebone/sancloud"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/sancloud/0001-add-am335x-sancloud-bbe.patch"
	${git} "${DIR}/patches/beaglebone/sancloud/0002-am335x-sancloud-bbe-update-lps331ap-mpu6050-irq-pins.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
		cleanup
	fi

	echo "dir: beaglebone/tre"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/tre/0001-add-am335x-arduino-tre.dts.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	#echo "dir: beaglebone/CTAG"
	#regenerate="enable"
	#if [ "x${regenerate}" = "xenable" ] ; then
	#	start_cleanup
	#fi

	#${git} "${DIR}/patches/beaglebone/CTAG/0001-Added-driver-and-device-tree-for-CTAG-face2-4-Audio-.patch"
	#${git} "${DIR}/patches/beaglebone/CTAG/0002-Added-support-for-higher-sampling-rates-in-AD193X-dr.patch"
	#${git} "${DIR}/patches/beaglebone/CTAG/0003-Added-support-for-AD193X-and-CTAG-face2-4-Audio-Card.patch"
	#${git} "${DIR}/patches/beaglebone/CTAG/0004-Modified-ASOC-platform-driver-for-McASP-to-use-async.patch"
	#${git} "${DIR}/patches/beaglebone/CTAG/0005-Changed-descriptions-in-files-belonging-to-CTAG-face.patch"
	#${git} "${DIR}/patches/beaglebone/CTAG/0006-add-black-version-of-ctag-face-pass-uboot-cape-ctag-.patch"

	#if [ "x${regenerate}" = "xenable" ] ; then
	#	number=6
	#	cleanup
	#fi

	echo "dir: beaglebone/capes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/capes/0002-ARM-dts-am335x-boneblack-enable-wl1835mod-cape-suppo.patch"
	${git} "${DIR}/patches/beaglebone/capes/0003-add-am335x-boneblack-bbbmini.dts.patch"
	${git} "${DIR}/patches/beaglebone/capes/0004-add-lcd-am335x-boneblack-bbb-exp-c.dtb-am335x-bonebl.patch"
	${git} "${DIR}/patches/beaglebone/capes/0005-bb-audio-cape.patch"

	#Replicape use am335x-boneblack-overlay.dtb???

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
		cleanup
	fi

	echo "dir: beaglebone/mctrl_gpio"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi
		${git} "${DIR}/patches/beaglebone/mctrl_gpio/0001-tty-serial-8250-make-UART_MCR-register-access-consis.patch"
		${git} "${DIR}/patches/beaglebone/mctrl_gpio/0002-serial-mctrl_gpio-add-modem-control-read-routine.patch"
		${git} "${DIR}/patches/beaglebone/mctrl_gpio/0003-serial-mctrl_gpio-add-IRQ-locking.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="beaglebone/mctrl_gpio"
		number=3
		cleanup
	fi

	echo "dir: beaglebone/jtag"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/jtag/0001-add-jtag-clock-pinmux.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cherrypick_dir="beaglebone/tilcdc"
		#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=tilcdc

		#merged in 4.5.0-rc0

		#drm/tilcdc: rewrite pixel clock calculation
		SHA="3d19306a8240a163f6b02bb46213c277d6d44e08" ; num="1" ; cherrypick

		#drm/tilcdc: verify fb pitch
		SHA="6f206e9d2a965771e99bca4c22dbadac1b58a0e8" ; cherrypick

		#drm/tilcdc: adopt pinctrl support
		SHA="416a07fbe7b1f1a6f7e0595b43b5a85a1c877e05" ; cherrypick

		#drm/tilcdc: fix kernel panic on suspend when no hdmi monitor connected
		SHA="85fd27f80b3641c9af9f04cde1b712c8c20916d8" ; cherrypick

		#drm/tilcdc: make frame_done interrupt active at all times
		SHA="b62222fcaab994177f121d58acdab269f0f54897" ; cherrypick

		#drm/tilcdc: disable the lcd controller/dma engine when suspend invoked
		SHA="614b3cfeb8d22e2b0f49bcfeaf5b52900242a944" ; cherrypick

		#drm/tilcdc: Implement dma-buf support for tilcdc
		SHA="9c15390506d6888978fa98094f7578142d2e2f01" ; cherrypick

		#drm/tilcdc: fix build error when !CONFIG_CPU_FREQ
		SHA="7974dff4957f953f0f6fd71c30e02a7c25aea7f0" ; cherrypick

		#drm/tilcdc: Allocate register storage based on the actual number registers
		SHA="29ddd6e171abae990a881b9e221359f13c546369" ; cherrypick

		#drm/tilcdc: cleanup runtime PM handling
		SHA="65734a262350a746100dcfd85a81f7dc1b69dd10" ; cherrypick

		#drm/tilcdc: disable crtc on unload
		SHA="1aea1e79dbfd65a99da11868829c3e147b85cc32" ; cherrypick

		#drm/tilcdc: split reset to a separate function
		SHA="2efec4f3064d084bac1b2c1e1513a7452e8e245d" ; cherrypick

		#drm/tilcdc: remove broken error handling
		SHA="31ec5a2c7eed3a3e182a592591f4fb04304668a1" ; cherrypick

		#drm/tilcdc: cleanup irq handling
		SHA="317aae738b6402cd66fb9b52434b783f17ff5dd4" ; cherrypick

		#drm/tilcdc: Get rid of complex ping-pong mechanism
		SHA="2b2080d7e9ae2463b15a003629d2ea7d733759a0" ; cherrypick

		#drm/tilcdc: Do not update the next frame buffer close to vertical blank
		SHA="2b3a8cd71c2b830164df5de07e4ddebe0faa58f5" ; cherrypick

		#drm/tilcdc: Fix interrupt enable/disable code for version 2 tilcdc
		SHA="947df7e3f019bba902a55485635060e5970fb9a2" ; cherrypick

		#drm/tilcdc: Remove the duplicate LCDC_INT_ENABLE_SET_REG in registers[]
		SHA="f3a99946a95b3482eabec63b9f662963d7d2e3c8" ; cherrypick

		#drm/tilcdc: Add prints on sync lost and FIFO underrun interrupts
		SHA="c0c2baaab1b553df92a24e9175440f15e6ad3e2c" ; cherrypick

		#drm/tilcdc: Disable sync lost interrupt if it fires on every frame
		SHA="5895d08f6ff2175dabc373dada7d1bfa26123fc9" ; cherrypick

		#drm/tilcdc: Initialize crtc->port
		SHA="d66284fba15014daacef64cfc610a249553534c6" ; cherrypick

		#drm/tilcdc: Use devm_kzalloc() and devm_kcalloc() for private data
		SHA="d0ec32caef0baa490b419895ef61c8481d49f7cd" ; cherrypick

		exit 2
	fi

	if [ "x${merged_in_4_6}" = "xenable" ] ; then
		echo "dir: beaglebone/tilcdc"
		#merged in 4.6.0-rc0
		${git} "${DIR}/patches/beaglebone/tilcdc/0001-drm-tilcdc-rewrite-pixel-clock-calculation.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0002-drm-tilcdc-verify-fb-pitch.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0003-drm-tilcdc-adopt-pinctrl-support.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0004-drm-tilcdc-fix-kernel-panic-on-suspend-when-no-hdmi-.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0005-drm-tilcdc-make-frame_done-interrupt-active-at-all-t.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0006-drm-tilcdc-disable-the-lcd-controller-dma-engine-whe.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0007-drm-tilcdc-Implement-dma-buf-support-for-tilcdc.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0008-drm-tilcdc-fix-build-error-when-CONFIG_CPU_FREQ.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0009-drm-tilcdc-Allocate-register-storage-based-on-the-ac.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0010-drm-tilcdc-cleanup-runtime-PM-handling.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0011-drm-tilcdc-disable-crtc-on-unload.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0012-drm-tilcdc-split-reset-to-a-separate-function.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0013-drm-tilcdc-remove-broken-error-handling.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0014-drm-tilcdc-cleanup-irq-handling.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0015-drm-tilcdc-Get-rid-of-complex-ping-pong-mechanism.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0016-drm-tilcdc-Do-not-update-the-next-frame-buffer-close.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0017-drm-tilcdc-Fix-interrupt-enable-disable-code-for-ver.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0018-drm-tilcdc-Remove-the-duplicate-LCDC_INT_ENABLE_SET_.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0019-drm-tilcdc-Add-prints-on-sync-lost-and-FIFO-underrun.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0020-drm-tilcdc-Disable-sync-lost-interrupt-if-it-fires-o.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0021-drm-tilcdc-Initialize-crtc-port.patch"
		${git} "${DIR}/patches/beaglebone/tilcdc/0022-drm-tilcdc-Use-devm_kzalloc-and-devm_kcalloc-for-pri.patch"
	fi

	#[PATCH v2 0/3] Recover from sync lost error flood by resetting the LCDC
	${git} "${DIR}/patches/beaglebone/tilcdc/0023-drm-tilcdc-Write-to-LCDC_END_OF_INT_IND_REG-at-the-e.patch"
	${git} "${DIR}/patches/beaglebone/tilcdc/0024-drm-tilcdc-Move-waiting-of-LCDC_FRAME_DONE-IRQ-into-.patch"
	${git} "${DIR}/patches/beaglebone/tilcdc/0025-drm-tilcdc-Recover-from-sync-lost-error-flood-by-res.patch"

	#This has to be last...
	echo "dir: beaglebone/dtbs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		patch -p1 < "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"
		exit 2
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/dtbs/0001-sync-am335x-peripheral-pinmux.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi

	####
	#dtb makefile
	echo "dir: beaglebone/generated"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then

		device="am335x-boneblack-emmc-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-hdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-nhdmi-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblack-overlay.dtb" ; dtb_makefile_append
		device="am335x-bonegreen-overlay.dtb" ; dtb_makefile_append

		device="am335x-abbbi.dtb" ; dtb_makefile_append

		device="am335x-olimex-som.dtb" ; dtb_makefile_append

		device="am335x-bonegreen-wireless.dtb" ; dtb_makefile_append

		device="am335x-arduino-tre.dtb" ; dtb_makefile_append

		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbbmini.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-r.dtb" ; dtb_makefile_append
		device="am335x-boneblack-audio.dtb" ; dtb_makefile_append

		device="am335x-sancloud-bbe.dtb" ; dtb_makefile_append

		#device="am335x-boneblack-ctag-face.dtb" ; dtb_makefile_append
		#device="am335x-bonegreen-ctag-face.dtb" ; dtb_makefile_append

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
reverts
#fixes
ti
exynos
dts
wand
udoo
pru_uio
pru_rpmsg
bbb_overlays
beaglebone
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
