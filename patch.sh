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
git_bin=$(which git)
#git hard requirements:
#git: --no-edit

git="${git_bin} am"
#git_patchset=""
#git_opts

if [ "${RUN_BISECT}" ] ; then
	git="${git_bin} apply"
fi

echo "Starting patch.sh"

git_add () {
	${git_bin} add .
	${git_bin} commit -a -m 'testing patchset'
}

start_cleanup () {
	git="${git_bin} am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		if [ "x${wdir}" = "x" ] ; then
			${git_bin} format-patch -${number} -o ${DIR}/patches/
		else
			if [ ! -d ${DIR}/patches/${wdir}/ ] ; then
				mkdir -p ${DIR}/patches/${wdir}/
			fi
			${git_bin} format-patch -${number} -o ${DIR}/patches/${wdir}/
			unset wdir
		fi
	fi
	exit 2
}

cherrypick () {
	if [ ! -d ../patches/${cherrypick_dir} ] ; then
		mkdir -p ../patches/${cherrypick_dir}
	fi
	${git_bin} format-patch -1 ${SHA} --start-number ${num} -o ../patches/${cherrypick_dir}
	num=$(($num+1))
}

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	${git_bin} pull --no-edit ${git_patchset} ${git_tag}
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
		${git_bin} add .
		${git_bin} commit -a -m 'merge: aufs4-kbuild' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-base.patch
		patch -p1 < aufs4-base.patch || aufs_fail
		rm -rf aufs4-base.patch
		${git_bin} add .
		${git_bin} commit -a -m 'merge: aufs4-base' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-mmap.patch
		patch -p1 < aufs4-mmap.patch || aufs_fail
		rm -rf aufs4-mmap.patch
		${git_bin} add .
		${git_bin} commit -a -m 'merge: aufs4-mmap' -s

		wget https://raw.githubusercontent.com/sfjro/aufs4-standalone/aufs${KERNEL_REL}/aufs4-standalone.patch
		patch -p1 < aufs4-standalone.patch || aufs_fail
		rm -rf aufs4-standalone.patch
		${git_bin} add .
		${git_bin} commit -a -m 'merge: aufs4-standalone' -s

		${git_bin} format-patch -4 -o ../patches/aufs4/

		cd ../
		if [ ! -f ./aufs4-standalone ] ; then
			${git_bin} clone https://github.com/sfjro/aufs4-standalone
			cd ./aufs4-standalone
			${git_bin} checkout origin/aufs${KERNEL_REL} -b tmp
			cd ../
		else
			rm -rf ./aufs4-standalone || true
			${git_bin} clone https://github.com/sfjro/aufs4-standalone
			cd ./aufs4-standalone
			${git_bin} checkout origin/aufs${KERNEL_REL} -b tmp
			cd ../
		fi
		cd ./KERNEL/

		cp -v ../aufs4-standalone/Documentation/ABI/testing/*aufs ./Documentation/ABI/testing/
		mkdir -p ./Documentation/filesystems/aufs/
		cp -rv ../aufs4-standalone/Documentation/filesystems/aufs/* ./Documentation/filesystems/aufs/
		mkdir -p ./fs/aufs/
		cp -v ../aufs4-standalone/fs/aufs/* ./fs/aufs/
		cp -v ../aufs4-standalone/include/uapi/linux/aufs_type.h ./include/uapi/linux/

		${git_bin} add .
		${git_bin} commit -a -m 'merge: aufs4' -s
		${git_bin} format-patch -5 -o ../patches/aufs4/

		exit 2
	fi

	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/aufs4/0001-merge-aufs4-kbuild.patch"
	${git} "${DIR}/patches/aufs4/0002-merge-aufs4-base.patch"
	${git} "${DIR}/patches/aufs4/0003-merge-aufs4-mmap.patch"
	${git} "${DIR}/patches/aufs4/0004-merge-aufs4-standalone.patch"
	${git} "${DIR}/patches/aufs4/0005-merge-aufs4.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="aufs4"
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
		${git_bin} add .
		${git_bin} commit -a -m 'merge: CONFIG_PREEMPT_RT Patch Set' -s
		${git_bin} format-patch -1 -o ../patches/rt/

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

pre_backports () {
	echo "dir: backports/${subsystem}"

	cd ~/linux-src/
	${git_bin} pull --no-edit https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master
	${git_bin} pull --no-edit https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master --tags
	${git_bin} pull --no-edit https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master --tags
	if [ ! "x${backport_tag}" = "x" ] ; then
		${git_bin} checkout ${backport_tag} -b tmp
	fi
	cd -
}

post_backports () {
	if [ ! "x${backport_tag}" = "x" ] ; then
		cd ~/linux-src/
		${git_bin} checkout master -f ; ${git_bin} branch -D tmp
		cd -
	fi

	${git_bin} add .
	${git_bin} commit -a -m "backports: ${subsystem}: from: linux.git" -s
	if [ ! -d ../patches/backports/${subsystem}/ ] ; then
		mkdir -p ../patches/backports/${subsystem}/
	fi
	${git_bin} format-patch -1 -o ../patches/backports/${subsystem}/

	exit 2
}

patch_backports (){
	echo "dir: backports/${subsystem}"
	${git} "${DIR}/patches/backports/${subsystem}/0001-backports-${subsystem}-from-linux.git.patch"
}

backports () {
	backport_tag="v4.x-y"

	subsystem="xyz"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		pre_backports

		cp -v ~/linux-src/x/ ./x/

		post_backports
	fi
	patch_backports
}

reverts () {
	echo "dir: reverts"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

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

drivers () {
	echo "dir: drivers/spi"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/spi/0001-NFM-spi-spidev-allow-use-of-spidev-in-DT.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/spi"
		number=1
		cleanup
	fi

	echo "dir: drivers/ti/iodelay"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/ti/iodelay/0001-pinctrl-bindings-pinctrl-Add-support-for-TI-s-IODela.patch"
	${git} "${DIR}/patches/drivers/ti/iodelay/0002-pinctrl-Introduce-TI-IOdelay-configuration-driver.patch"
	${git} "${DIR}/patches/drivers/ti/iodelay/0003-ARM-dts-dra7-Add-iodelay-module.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/iodelay"
		number=3
		cleanup
	fi

	echo "dir: drivers/ti/uio"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/ti/uio/0001-Making-the-uio-pruss-driver-work.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/uio"
		number=1
		cleanup
	fi

	echo "dir: drivers/ti/rpmsg"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/ti/rpmsg/0001-ARM-samples-seccomp-no-m32.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/rpmsg"
		number=1
		cleanup
	fi

	#https://github.com/pantoniou/linux-beagle-track-mainline/tree/bbb-overlays
	echo "dir: drivers/ti/bbb_overlays"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0001-scripts-dtc-Update-to-upstream-version-1.4.1-Overlay.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0002-gitignore-Ignore-DTB-files.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0003-add-PM-firmware.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0004-ARM-CUSTOM-Build-a-uImage-with-dtb-already-appended.patch"
	fi

	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0005-omap-Fix-crash-when-omap-device-is-disabled.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0006-serial-omap-Fix-port-line-number-without-aliases.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0007-tty-omap-serial-Fix-up-platform-data-alloc.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0008-of-Custom-printk-format-specifier-for-device-node.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0009-of-overlay-kobjectify-overlay-objects.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0010-of-overlay-global-sysfs-enable-attribute.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0011-Documentation-ABI-overlays-global-attributes.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0012-Documentation-document-of_overlay_disable-parameter.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0013-of-overlay-add-per-overlay-sysfs-attributes.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0014-Documentation-ABI-overlays-per-overlay-docs.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0015-of-dynamic-Add-__of_node_dupv.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0016-of-changesets-Introduce-changeset-helper-methods.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0017-of-changeset-Add-of_changeset_node_move-method.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0018-of-unittest-changeset-helpers.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0019-OF-DT-Overlay-configfs-interface-v7.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0020-ARM-DT-Enable-symbols-when-CONFIG_OF_OVERLAY-is-used.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0021-misc-Beaglebone-capemanager.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0022-doc-misc-Beaglebone-capemanager-documentation.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0023-doc-dt-beaglebone-cape-manager-bindings.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0024-doc-ABI-bone_capemgr-sysfs-API.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0025-MAINTAINERS-Beaglebone-capemanager-maintainer.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0026-arm-dts-Enable-beaglebone-cape-manager.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0027-of-overlay-Implement-target-index-support.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0028-of-unittest-Add-indirect-overlay-target-test.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0029-doc-dt-Document-the-indirect-overlay-method.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0030-of-overlay-Introduce-target-root-capability.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0031-of-unittest-Unit-tests-for-target-root-overlays.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0032-doc-dt-Document-the-target-root-overlay-method.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0033-RFC-Device-overlay-manager-PCI-USB-DT.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0034-of-rename-_node_sysfs-to-_node_post.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0035-of-Support-hashtable-lookups-for-phandles.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0036-of-unittest-hashed-phandles-unitest.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0037-of-overlay-Pick-up-label-symbols-from-overlays.patch"


	if [ "x${regenerate}" = "xenable" ] ; then
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0038-of-Portable-Device-Tree-connector.patch"
	${git} "${DIR}/patches/drivers/ti/bbb_overlays/0039-boneblack-defconfig.patch"
	fi

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/bbb_overlays"
		number=39
		cleanup
	fi

	echo "dir: drivers/ti/cpsw"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/ti/cpsw/0001-cpsw-search-for-phy.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/cpsw"
		number=1
		cleanup
	fi
}

soc () {
	echo "dir: soc/exynos"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/exynos/0001-exynos5422-artik10.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/exynos"
		number=1
		cleanup
	fi

	echo "dir: soc/imx/udoo"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/imx/udoo/0001-binding-doc-power-pwrseq-generic-add-binding-doc-for.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0002-power-add-power-sequence-library.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0003-binding-doc-usb-usb-device-add-optional-properties-f.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0004-usb-core-add-power-sequence-handling-for-USB-devices.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0005-usb-chipidea-let-chipidea-core-device-of_node-equal-.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0006-ARM-dts-imx6qdl-Enable-usb-node-children-with-reg.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0007-ARM-dts-imx6qdl-udoo.dtsi-fix-onboard-USB-HUB-proper.patch"
	${git} "${DIR}/patches/soc/imx/udoo/0008-ARM-dts-imx6q-evi-Fix-onboard-hub-reset-line.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/imx/udoo"
		number=8
		cleanup
	fi

	echo "dir: soc/imx/wandboard"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/imx/wandboard/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	${git} "${DIR}/patches/soc/imx/wandboard/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/imx/wandboard"
		number=2
		cleanup
	fi

	echo "dir: soc/imx"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/imx/0001-first-pass-imx6q-ccimx6sbc.patch"
	${git} "${DIR}/patches/soc/imx/0005-mcimx6ul-bb-and-ism43362-b81-evb.patch"

	#need to be re-synced...
	#${git} "${DIR}/patches/soc/imx/0002-imx6-wl1835-base-boards.patch"
	#${git} "${DIR}/patches/soc/imx/0003-imx6q-sabresd-add-support-for-wilink8-wlan-and-bluet.patch"
	#${git} "${DIR}/patches/soc/imx/0004-imx6sl-evk-add-support-for-wilink8-wlan-and-bluetoot.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/imx"
		number=5
		cleanup
	fi

	echo "dir: soc/sunxi"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/sunxi/0001-ethernet-add-sun8i-emac-driver.patch"
	${git} "${DIR}/patches/soc/sunxi/0002-MAINTAINERS-Add-myself-as-maintainers-of-sun8i-emac.patch"
	${git} "${DIR}/patches/soc/sunxi/0003-ARM-sun8i-dt-Add-DT-bindings-documentation-for-Allwi.patch"
	${git} "${DIR}/patches/soc/sunxi/0004-ARM-dts-sun8i-h3-add-sun8i-emac-ethernet-driver.patch"
	${git} "${DIR}/patches/soc/sunxi/0005-ARM-dts-sun8i-Enable-sun8i-emac-on-the-Orange-PI-PC.patch"
	${git} "${DIR}/patches/soc/sunxi/0006-ARM-dts-sun8i-Enable-sun8i-emac-on-the-Orange-PI-One.patch"
	${git} "${DIR}/patches/soc/sunxi/0007-ARM-dts-sun8i-Add-ethernet0-alias-for-h3-emac.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/sunxi"
		number=7
		cleanup
	fi

	echo "dir: soc/ti"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/0001-sync-with-ti-4.4.patch"
	${git} "${DIR}/patches/soc/ti/0002-ARM-dts-omap3-beagle-add-i2c2.patch"
	${git} "${DIR}/patches/soc/ti/0003-ARM-dts-omap3-beagle-xm-spidev.patch"
	${git} "${DIR}/patches/soc/ti/0004-ARM-DTS-omap3-beagle.dts-enable-twl4030-power-reset.patch"
	${git} "${DIR}/patches/soc/ti/0005-arm-dts-omap4-move-emif-so-panda-es-b3-now-boots.patch"
	${git} "${DIR}/patches/soc/ti/0006-omap3-beagle-fixes.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti"
		number=6
		cleanup
	fi

	echo "dir: soc/ti/bone_common"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/bone_common/0001-ARM-dts-am335x-bone-common-update-leds-to-match-3.8..patch"
	${git} "${DIR}/patches/soc/ti/bone_common/0002-ARM-dts-am335x-bone-common-add-collision-and-carrier.patch"
	${git} "${DIR}/patches/soc/ti/bone_common/0003-ARM-dts-am335x-bone-common-disable-running-JTAG.patch"
	${git} "${DIR}/patches/soc/ti/bone_common/0004-ARM-dts-am335x-bone-common-overlays.patch"
	#FIXME: still broken...
	${git} "${DIR}/patches/soc/ti/bone_common/0005-HACK-am335x-bone-common.dtsi-pwr-button.patch"
	${git} "${DIR}/patches/soc/ti/bone_common/0006-ARM-dts-am335x-bone-common-rtc-defined-in-common.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/bone_common"
		number=6
		cleanup
	fi

	echo "dir: soc/ti/bbg"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/bbg/0001-NFM-ARM-dts-am335x-bonegreen.dts-disable-usart-for-o.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/bbg"
		number=1
		cleanup
	fi

	echo "dir: soc/ti/bbgw"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/bbgw/0001-ARM-dts-add-am335x-bonegreen-wireless.dtb.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/bbgw"
		number=1
		cleanup
	fi

	echo "dir: soc/ti/bbbw"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/bbbw/0001-ARM-dts-add-am335x-boneblack-wireless.dtb.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/bbbw"
		number=1
		cleanup
	fi

	echo "dir: soc/ti/blue"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/blue/0001-ARM-dts-add-am335x-boneblue.dtb.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/blue"
		number=1
		cleanup
	fi

	echo "dir: soc/ti/sancloud"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/sancloud/0001-add-am335x-sancloud-bbe.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/sancloud"
		number=1
		cleanup
	fi

	echo "dir: soc/ti/tre"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/soc/ti/tre/0001-add-am335x-arduino-tre.dts.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/tre"
		number=1
		cleanup
	fi

}

dtb_makefile_append () {
	sed -i -e 's:am335x-boneblack.dtb \\:am335x-boneblack.dtb \\\n\t'$device' \\:g' arch/arm/boot/dts/Makefile
}

beaglebone () {
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
		wdir="beaglebone/pinmux-helper"
		number=14
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

		device="am335x-bone-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-cape-bone-argus.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wl1835mod.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbbmini.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-c.dtb" ; dtb_makefile_append
		device="am335x-boneblack-bbb-exp-r.dtb" ; dtb_makefile_append
		device="am335x-boneblack-audio.dtb" ; dtb_makefile_append

		device="am335x-bonegreen-wireless.dtb" ; dtb_makefile_append
		device="am335x-bonegreen-wireless-led-hack.dtb" ; dtb_makefile_append

		device="am335x-boneblack-wireless.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wireless-emmc-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblue.dtb" ; dtb_makefile_append

		device="am335x-sancloud-bbe.dtb" ; dtb_makefile_append

		device="am335x-arduino-tre.dtb" ; dtb_makefile_append

		git commit -a -m 'auto generated: capes: add dtbs to makefile' -s
		git format-patch -1 -o ../patches/beaglebone/generated/
		exit 2
	else
		${git} "${DIR}/patches/beaglebone/generated/0001-auto-generated-capes-add-dtbs-to-makefile.patch"
	fi

	echo "dir: beaglebone/firmware"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#http://git.ti.com/gitweb/?p=processor-firmware/ti-amx3-cm3-pm-firmware.git;a=summary
	#git clone git://git.ti.com/processor-firmware/ti-amx3-cm3-pm-firmware.git

	#cd ti-amx3-cm3-pm-firmware/
	#git checkout origin/ti-v4.1.y-next -b tmp

	#commit ee4acf427055d7e87d9d1d82296cbd05e388642e
	#Author: Dave Gerlach <d-gerlach@ti.com>
	#Date:   Tue Sep 6 14:33:11 2016 -0500
	#
	#    CM3: Firmware release 0x192
	#    
	#    This version, 0x192, includes the following changes:
	#         - Fix DDR IO CTRL handling during suspend so both am335x and am437x
	#           use optimal low power state and restore the exact previous
	#           configuration.
	#        - Explicitly configure PER state in standby, even though it is
	#           configured to ON state to ensure proper state.
	#         - Add new 'halt' flag in IPC_REG4 bit 11 to allow HLOS to configure
	#           the suspend path to wait immediately before suspending the system
	#           entirely to allow JTAG visiblity for debug.
	#         - Fix board voltage scaling binaries i2c speed configuration in
	#           order to properly configure 100khz operation.
	#    
	#    Signed-off-by: Dave Gerlach <d-gerlach@ti.com>

	#cp -v bin/am* /opt/github/bb.org/ti-4.4/normal/KERNEL/firmware/

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

more_fixes () {
	echo "dir: more_fixes"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/more_fixes/0001-slab-gcc5-fixes.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		number=1
		cleanup
	fi
}

###
#backports
#reverts
#fixes
drivers
soc
beaglebone
quieter
more_fixes

packaging () {
	echo "dir: packaging"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
		${git_bin} commit -a -m 'packaging: sync builddeb changes' -s
		${git_bin} format-patch -1 -o "${DIR}/patches/packaging"
		exit 2
	else
		${git} "${DIR}/patches/packaging/0001-packaging-sync-builddeb-changes.patch"
	fi
}

packaging
echo "patch.sh ran successfully"
