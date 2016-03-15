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
		echo "dir: lts44_backports/fixes"
		cherrypick_dir="lts44_backports/fixes"
		SHA="d20313b2c407a90fb60eca99d73c47a75bb42e08" ; num="1" ; cherrypick

		echo "dir: lts44_backports/dmtimer"
		cherrypick_dir="lts44_backports/dmtimer"
		SHA="6604c6556db9e41c85f2839f66bd9d617bcf9f87" ; num="1" ; cherrypick
		SHA="074726402b82f14ca377da0b4a4767674c3d1ff8" ; cherrypick
		SHA="20437f79f6627a31752f422688a6047c25cefcf1" ; cherrypick

		exit 2
	fi

	#is_44="enable"
	if [ "x${is_44}" = "xenable" ] ; then
		echo "dir: lts44_backports/fixes"
		#4.5.0-rc0
		${git} "${DIR}/patches/lts44_backports/fixes/0001-dmaengine-edma-Fix-paRAM-slot-allocation-for-entry-c.patch"

		echo "dir: lts44_backports/dmtimer"
		#4.5.0-rc0
		${git} "${DIR}/patches/lts44_backports/dmtimer/0001-pwm-Add-PWM-driver-for-OMAP-using-dual-mode-timers.patch"
		${git} "${DIR}/patches/lts44_backports/dmtimer/0002-pwm-omap-dmtimer-Potential-NULL-dereference-on-error.patch"
		${git} "${DIR}/patches/lts44_backports/dmtimer/0003-ARM-OMAP-Add-PWM-dmtimer-platform-data-quirks.patch"
	fi
	unset is_44
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
	echo "dir: ti/iodelay/"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/ti/iodelay/0001-pinctrl-bindings-pinctrl-Add-support-for-TI-s-IODela.patch"
	${git} "${DIR}/patches/ti/iodelay/0002-pinctrl-Introduce-TI-IOdelay-configuration-driver.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=2
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

	#[PATCHv6 0/7] Convert exiting EEPROM drivers to NVMEM
	${git} "${DIR}/patches/bbb_overlays/nvmem/0001-nvmem-Add-flag-to-export-NVMEM-to-root-only.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0002-nvmem-Add-backwards-compatibility-support-for-older-.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0003-eeprom-at24-extend-driver-to-plug-into-the-NVMEM-fra.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0004-eeprom-at25-Remove-in-kernel-API-for-accessing-the-E.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0005-eeprom-at25-extend-driver-to-plug-into-the-NVMEM-fra.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0006-eeprom-93xx46-extend-driver-to-plug-into-the-NVMEM-f.patch"
	${git} "${DIR}/patches/bbb_overlays/nvmem/0007-misc-at24-replace-memory_accessor-with-nvmem_device_.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=7
		cleanup
	fi

	echo "dir: bbb_overlays/configfs"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cherrypick_dir="bbb_overlays/configfs"
		#merged in 4.5.0-rc0
		SHA="03607ace807b414eab46323c794b6fb8fcc2d48c" ; num="1" ; cherrypick
		exit 2
	fi

	#is_44="enable"
	if [ "x${is_44}" = "xenable" ] ; then
		#(< 4.5.0-rc0)
		${git} "${DIR}/patches/bbb_overlays/configfs/0001-configfs-implement-binary-attributes.patch"
	fi
	unset is_44


	echo "dir: bbb_overlays/of"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cherrypick_dir="bbb_overlays/of"
		#merged in 4.5.0-rc0
		SHA="183223770ae8625df8966ed15811d1b3ee8720aa" ; num="1" ; cherrypick
		exit 2
	fi

	#is_44="enable"
	if [ "x${is_44}" = "xenable" ] ; then
		#(< 4.5.0-rc0)
		${git} "${DIR}/patches/bbb_overlays/of/0001-drivers-of-Export-OF-changeset-functions.patch"
	fi
	unset is_44

	echo "dir: bbb_overlays/omap"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cherrypick_dir="bbb_overlays/omap"
		#merged in 4.5.0-rc6?
		SHA="cf26f1137333251f3515dea31f95775b99df0fd5" ; num="1" ; cherrypick
		exit 2
	fi

	#is_44="enable"
	if [ "x${is_44}" = "xenable" ] ; then
		#merged in 4.5.0-rc6?
		${git} "${DIR}/patches/bbb_overlays/omap/0001-ARM-OMAP2-Fix-omap_device-for-module-reload-on-PM-ru.patch"
	fi
	unset is_44

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
	${git} "${DIR}/patches/bbb_overlays/0032-connector-wip.patch"
	fi

	${git} "${DIR}/patches/bbb_overlays/0033-of-remove-bogus-return-in-of_core_init.patch"
	${git} "${DIR}/patches/bbb_overlays/0034-of-Maintainer-fixes-for-dynamic.patch"

	#v4.5.0-rc0 (api change):183223770ae8625df8966ed15811d1b3ee8720aa
	${git} "${DIR}/patches/bbb_overlays/0035-of-unittest-changeset-helpers.patch"

	${git} "${DIR}/patches/bbb_overlays/0036-of-rename-_node_sysfs-to-_node_post.patch"
	${git} "${DIR}/patches/bbb_overlays/0037-of-Support-hashtable-lookups-for-phandles.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=37
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
	${git} "${DIR}/patches/beaglebone/dts/0003-tps65217-Enable-KEY_POWER-press-on-AC-loss-PWR_BUT.patch"
	${git} "${DIR}/patches/beaglebone/dts/0004-am335x-bone-common-disable-default-clkout2_pin.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=4
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

	is_45="enable"
	if [ "x${is_45}" = "xenable" ] ; then
		${git} "${DIR}/patches/beaglebone/abbbi/0003-drm-adihdmi-Drop-dummy-save-restore-hooks.patch"
		${git} "${DIR}/patches/beaglebone/abbbi/0004-drm-adihdmi-Pass-name-to-drm_encoder_init.patch"
	fi
	unset is_45

	${git} "${DIR}/patches/beaglebone/abbbi/0005-ARM-dts-add-Arrow-BeagleBone-Black-Industrial-dts.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=5
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

	${git} "${DIR}/patches/beaglebone/sancloud/0001-add-sancloud-beaglebone-enhanced.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
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

	echo "dir: beaglebone/capes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/beaglebone/capes/0001-cape-Argus-UPS-cape-support.patch"
	${git} "${DIR}/patches/beaglebone/capes/0002-ARM-dts-am335x-boneblack-enable-wl1835mod-cape-suppo.patch"
	${git} "${DIR}/patches/beaglebone/capes/0003-add-am335x-boneblack-bbbmini.dts.patch"
	${git} "${DIR}/patches/beaglebone/capes/0004-add-lcd-am335x-boneblack-bbb-exp-c.dtb-am335x-bonebl.patch"

	#Replicape use am335x-boneblack-overlay.dtb???

	if [ "x${regenerate}" = "xenable" ] ; then
		number=4
		cleanup
	fi

	echo "dir: beaglebone/rs485"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#[PATCH v8 0/3] tty: Introduce software RS485 direction control support
	${git} "${DIR}/patches/beaglebone/rs485/0001-tty-Move-serial8250_stop_rx-in-front-of-serial8250_s.patch"
	${git} "${DIR}/patches/beaglebone/rs485/0002-tty-Add-software-emulated-RS485-support-for-8250.patch"
	${git} "${DIR}/patches/beaglebone/rs485/0003-tty-8250_omap-Use-software-emulated-RS485-direction-.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=3
		cleanup
	fi

	echo "dir: beaglebone/tilcdc"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

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

	if [ "x${regenerate}" = "xenable" ] ; then
		number=22
		cleanup
	fi

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

		device="am335x-sancloud-bbe.dtb" ; dtb_makefile_append

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
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cherrypick_dir="etnaviv/mainline"
		#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/?qt=grep&q=etnaviv

		#merged in 4.5.0-rc0

		#drm/etnaviv: add devicetree bindings
		SHA="f04b205ac143413831b193f39fd9592665111d4b" ; num="1" ; cherrypick

		#drm/etnaviv: add initial etnaviv DRM driver
		SHA="a8c21a5451d831e67b7a6fb910f9ca8bc7b43554" ; cherrypick

		#MAINTAINERS: add maintainer and reviewers for the etnaviv DRM driver
		SHA="8bb0bce92ec9330b0ea931df90f719fb5c4a5224" ; cherrypick

		#drm/etnaviv: unlock on error in etnaviv_gem_get_iova()
		SHA="ed94add00e290e675c36cef6767d7d1f51a02f28" ; cherrypick

		#drm/etnaviv: fix workaround for GC500
		SHA="c33246d793b5bb9d8be7c67918136c310185c23d" ; cherrypick

		#ARM: dts: imx6: add Vivante GPU nodes
		SHA="419e202b260ba5913affd7cb3c36f129c036e8f7" ; cherrypick

		#merged in 4.5.0-rc1

		#drm/etnaviv: remove owner assignment from platform_driver
		SHA="23a9d5dcb6ae114733fac4757b0b154571c21129" ; cherrypick

		#drm/etnaviv: hold object lock while getting pages for coredump
		SHA="339073ef77e45e87ec4cc8671b2d2328dcfd31f0" ; cherrypick

		#drm/etnaviv: fix failure path if model is zero
		SHA="f6427760a29ba3fd968e27ea567b1ebdd500740b" ; cherrypick

		#drm/etnaviv: ignore VG GPUs with FE2.0
		SHA="b98c66887ee1aec661dcb88fe17399d5d112ed98" ; cherrypick

		#drm/etnaviv: update common and state_hi xml.h files
		SHA="e2a2e263e06a0c153234b3e93fb85612d1c454d3" ; cherrypick

		#drm/etnaviv: use defined constants for the chip model
		SHA="507f899137f9e4f1405820b946063a6db78b2295" ; cherrypick

		#drm/etnaviv: add helper to extract bitfields
		SHA="52f36ba1d6134f5c1c45deb0da53442a5971358e" ; cherrypick

		#drm/etnaviv: add helper for comparing model/revision IDs
		SHA="472f79dcf21d34f4d667910002482efe3ca4ba34" ; cherrypick

		#drm/etnaviv: add further minor features and varyings count
		SHA="602eb48966d7b7f7e64dca8d9ea2842d83bfae73" ; cherrypick

		#drm/etnaviv: fix memory leak in IOMMU init path
		SHA="45d16a6d94580cd3c6baed69b5fe441ece599fc4" ; cherrypick

		#drm/etnaviv: fix get pages error path in etnaviv_gem_vaddr
		SHA="9f07bb0d4ada68f05b2e51c10720d4688e6adea4" ; cherrypick

		#drm/etnaviv: rename etnaviv_gem_vaddr to etnaviv_gem_vmap
		SHA="ce3088fdb51eda7b9ef3d119e7c302c08428f274" ; cherrypick

		#drm/etnaviv: call correct function when trying to vmap a DMABUF
		SHA="a0a5ab3e99b8e617221caabf074dcabd1659b9d8" ; cherrypick

		exit 2
	fi

	#is_44="enable"
	if [ "x${is_44}" = "xenable" ] ; then
		echo "dir: etnaviv/mainline"
		#merged in 4.5.0-rc0
		${git} "${DIR}/patches/etnaviv/mainline/0001-drm-etnaviv-add-devicetree-bindings.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0002-drm-etnaviv-add-initial-etnaviv-DRM-driver.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0004-drm-etnaviv-unlock-on-error-in-etnaviv_gem_get_iova.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0003-MAINTAINERS-add-maintainer-and-reviewers-for-the-etn.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0005-drm-etnaviv-fix-workaround-for-GC500.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0006-ARM-dts-imx6-add-Vivante-GPU-nodes.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0007-drm-etnaviv-remove-owner-assignment-from-platform_dr.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0008-drm-etnaviv-hold-object-lock-while-getting-pages-for.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0009-drm-etnaviv-fix-failure-path-if-model-is-zero.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0010-drm-etnaviv-ignore-VG-GPUs-with-FE2.0.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0011-drm-etnaviv-update-common-and-state_hi-xml.h-files.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0012-drm-etnaviv-use-defined-constants-for-the-chip-model.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0013-drm-etnaviv-add-helper-to-extract-bitfields.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0014-drm-etnaviv-add-helper-for-comparing-model-revision-.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0015-drm-etnaviv-add-further-minor-features-and-varyings-.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0016-drm-etnaviv-fix-memory-leak-in-IOMMU-init-path.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0017-drm-etnaviv-fix-get-pages-error-path-in-etnaviv_gem_.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0018-drm-etnaviv-rename-etnaviv_gem_vaddr-to-etnaviv_gem_.patch"
		${git} "${DIR}/patches/etnaviv/mainline/0019-drm-etnaviv-call-correct-function-when-trying-to-vma.patch"
	fi
	unset is_44

	#echo "dir: etnaviv/drm-etnaviv-fixes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#http://git.pengutronix.de/?p=lst/linux.git;a=shortlog;h=refs/heads/drm-etnaviv-fixes
	#cd ~/linux-src
	#git checkout v4.5-rc1 -b tmp
	#git pull --no-edit git://git.pengutronix.de/git/lst/linux.git drm-etnaviv-fixes
	#git rebase v4.5-rc1
	#git format-patch -14 | grep rc1 ; rm *.patch

	#git format-patch -13 -o /opt/github/linux-dev/patches/etnaviv/drm-etnaviv-fixes
	#git checkout master -f ; git branch -D tmp

	if [ "x${regenerate}" = "xenable" ] ; then
		number=13
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
