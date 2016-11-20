#!/bin/bash -e
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

shopt -s nullglob

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

dir () {
	wdir="$1"
	if [ -d "${DIR}/patches/$wdir" ]; then
		echo "dir: $wdir"

		if [ "x${regenerate}" = "xenable" ] ; then
			start_cleanup
		fi

		number=
		for p in "${DIR}/patches/$wdir/"*.patch; do
			${git} "$p"
			number=$(( $number + 1 ))
		done

		if [ "x${regenerate}" = "xenable" ] ; then
			cleanup
		fi
	fi
	unset wdir
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

	#https://github.com/torvalds/linux/commit/00f0ea70d2b82b7d7afeb1bdedc9169eb8ea6675
	#
	#Causes bone_capemgr to get stuck on slot 1 and just eventually exit "without" checking slot2/3/4...
	#
	#[    5.406775] bone_capemgr bone_capemgr: Baseboard: 'A335BNLT,00C0,2516BBBK2626'
	#[    5.414178] bone_capemgr bone_capemgr: compatible-baseboard=ti,beaglebone-black - #slots=4
	#[    5.422573] bone_capemgr bone_capemgr: Failed to add slot #1

	${git} "${DIR}/patches/reverts/0001-Revert-eeprom-at24-check-if-the-chip-is-functional-i.patch"

	#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/log/drivers/net/wireless/ti
	${git} "${DIR}/patches/reverts/0002-Revert-wlcore-sdio-drop-kfree-for-memory-allocated-w.patch"
	${git} "${DIR}/patches/reverts/0003-Revert-wlcore-wl18xx-Use-chip-specific-configuration.patch"
	${git} "${DIR}/patches/reverts/0004-Revert-wlcore-Fix-config-firmware-loading-issues.patch"
	${git} "${DIR}/patches/reverts/0005-Revert-wlcore-spi-Populate-config-firmware-data.patch"
	${git} "${DIR}/patches/reverts/0006-Revert-wlcore-sdio-Populate-config-firmware-data.patch"
	${git} "${DIR}/patches/reverts/0007-Revert-wlcore-Prepare-family-to-fix-nvs-file-handlin.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="reverts"
		number=7
		cleanup
	fi
}

drivers () {
	dir 'drivers/spi'
	dir 'drivers/pm_bus'

	echo "dir: drivers/pm_opp"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	${git} "${DIR}/patches/drivers/pm_opp/0001-PM-OPP-Reword-binding-supporting-multiple-regulators.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0002-PM-OPP-Don-t-use-OPP-structure-outside-of-rcu-protec.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0003-PM-OPP-Manage-supply-s-voltage-current-in-a-separate.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0004-PM-OPP-Pass-struct-dev_pm_opp_supply-to-_set_opp_vol.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0005-PM-OPP-Add-infrastructure-to-manage-multiple-regulat.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0006-PM-OPP-Separate-out-_generic_opp_set_rate.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0007-PM-OPP-Allow-platform-specific-custom-set_opp-callba.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0008-PM-OPP-Don-t-WARN-on-multiple-calls-to-dev_pm_opp_se.patch"
	${git} "${DIR}/patches/drivers/pm_opp/0009-PM-OPP-Don-t-assume-platform-doesn-t-have-regulators.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/pm_opp"
		number=9
		cleanup
	fi

	echo "dir: drivers/tps65218"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#Keerthy
	${git} "${DIR}/patches/drivers/tps65218/0001-mfd-tps65218-Remove-redundant-read-wrapper.patch"
	${git} "${DIR}/patches/drivers/tps65218/0002-Documentation-regulator-tps65218-Update-examples.patch"
	${git} "${DIR}/patches/drivers/tps65218/0003-input-tps65218-pwrbutton-Add-platform_device_id-tabl.patch"
	${git} "${DIR}/patches/drivers/tps65218/0004-mfd-tps65218-Use-mfd_add_devices-instead-of-of_platf.patch"
	${git} "${DIR}/patches/drivers/tps65218/0005-regulator-tps65218-Remove-all-the-compatibles.patch"

	#Milo Kim
	${git} "${DIR}/patches/drivers/tps65218/0006-ARM-dts-tps65217-Specify-the-interrupt-controller.patch"
	${git} "${DIR}/patches/drivers/tps65218/0007-ARM-dts-tps65217-Add-the-charger-device.patch"
	${git} "${DIR}/patches/drivers/tps65218/0008-ARM-dts-tps65217-Add-the-power-button-device.patch"
	${git} "${DIR}/patches/drivers/tps65218/0009-ARM-dts-am335x-Support-the-PMIC-interrupt.patch"
	${git} "${DIR}/patches/drivers/tps65218/0010-dt-bindings-mfd-Provide-human-readable-defines-for-T.patch"
	${git} "${DIR}/patches/drivers/tps65218/0011-ARM-dts-am335x-Add-the-charger-interrupt.patch"
	${git} "${DIR}/patches/drivers/tps65218/0012-ARM-dts-am335x-Add-the-power-button-interrupt.patch"
	${git} "${DIR}/patches/drivers/tps65218/0013-mfd-tps65217-Fix-mismatched-interrupt-number.patch"
	${git} "${DIR}/patches/drivers/tps65218/0014-HACK-tps65217_pwr_but.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/tps65218"
		number=14
		cleanup
	fi

	dir 'drivers/ti/iodelay'

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

	echo "dir: drivers/ti/firmware"
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

	${git} "${DIR}/patches/drivers/ti/firmware/0001-add-am33x-firmware.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="drivers/ti/firmware"
		number=1
		cleanup
	fi

	dir 'drivers/ti/cpsw'
	dir 'drivers/ti/etnaviv'
	dir 'drivers/ti/eqep'
	dir 'drivers/ti/mcasp'
	dir 'drivers/ti/mmc'
	dir 'drivers/ti/rpmsg'
	dir 'drivers/ti/rtc'
	dir 'drivers/ti/serial'
	dir 'drivers/ti/spi'
	dir 'drivers/ti/uio'

	dir 'drivers/ti/gpio'
}

soc () {
	dir 'soc/exynos'
	dir 'soc/imx/udoo'
	dir 'soc/imx/wandboard'
	dir 'soc/imx'
	dir 'soc/sunxi'
	dir 'soc/ti'
	dir 'soc/ti/bone_common'
	dir 'soc/ti/bbg'
	dir 'soc/ti/bbgw'
	dir 'soc/ti/bbbw'
	dir 'soc/ti/blue'
	dir 'soc/ti/sancloud'
	dir 'soc/ti/abbbi'
	dir 'soc/ti/am335x_olimex_som'

	echo "dir: soc/ti/opp"
	#regenerate="enable"
	if [ "x${regenerate}" = "xenable" ] ; then
		start_cleanup
	fi

	#https://github.com/dgerlach/linux-pm/commits/upstream/v4.9/ti-cpufreq-driver-v3
	${git} "${DIR}/patches/soc/ti/opp/0001-PM-OPP-Expose-_of_get_opp_desc_node-as-dev_pm_opp-AP.patch"
	${git} "${DIR}/patches/soc/ti/opp/0002-Documentation-dt-add-bindings-for-ti-cpufreq.patch"
	${git} "${DIR}/patches/soc/ti/opp/0003-cpufreq-ti-Add-cpufreq-driver-to-determine-available.patch"
	${git} "${DIR}/patches/soc/ti/opp/0004-cpufreq-dt-Don-t-use-generic-platdev-driver-for-ti-c.patch"
	${git} "${DIR}/patches/soc/ti/opp/0005-ARM-dts-am33xx-Add-updated-operating-points-v2-table.patch"
	${git} "${DIR}/patches/soc/ti/opp/0006-ARM-dts-am335x-boneblack-Enable-1GHz-OPP-for-cpu.patch"
	${git} "${DIR}/patches/soc/ti/opp/0007-ARM-dts-am4372-Update-operating-points-v2-table-for-.patch"
	${git} "${DIR}/patches/soc/ti/opp/0008-ARM-dts-dra7-Add-updated-operating-points-v2-table-f.patch"

	if [ "x${regenerate}" = "xenable" ] ; then
		wdir="soc/ti/opp"
		number=8
		cleanup
	fi

	dir 'soc/ti/beaglebone_capes'
}

dtb_makefile_append () {
	sed -i -e 's:am335x-boneblack.dtb \\:am335x-boneblack.dtb \\\n\t'$device' \\:g' arch/arm/boot/dts/Makefile
}

beaglebone () {
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

		device="am335x-boneblack-wireless.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wireless-emmc-overlay.dtb" ; dtb_makefile_append
		device="am335x-boneblue.dtb" ; dtb_makefile_append
		device="am335x-boneblack-roboticscape.dtb" ; dtb_makefile_append
		device="am335x-boneblack-wireless-roboticscape.dtb" ; dtb_makefile_append

		device="am335x-sancloud-bbe.dtb" ; dtb_makefile_append

		git commit -a -m 'auto generated: capes: add dtbs to makefile' -s
		git format-patch -1 -o ../patches/beaglebone/generated/
		exit 2
	else
		${git} "${DIR}/patches/beaglebone/generated/0001-auto-generated-capes-add-dtbs-to-makefile.patch"
	fi
}

###
#backports
reverts
drivers
soc
beaglebone
dir 'build/gcc'

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
