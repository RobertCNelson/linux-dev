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

DIR=$PWD
CORES=$(getconf _NPROCESSORS_ONLN)
git_bin=$(which git)

mkdir -p "${DIR}/deploy/"

patch_kernel () {
	cd "${DIR}/KERNEL" || exit

	export DIR
	/bin/sh -e "${DIR}/patch.sh" || { ${git_bin} add . ; exit 1 ; }

	if [ ! "${RUN_BISECT}" ] ; then
		${git_bin} add --all
		${git_bin} commit --allow-empty -a -m "${KERNEL_TAG}${BUILD} patchset"
	fi

	cd "${DIR}/" || exit
}

config_reference () {
	echo "Updating reference config: ${ref_config}"
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" ${ref_config}
	cp -v .config "${DIR}/patches/example_${ref_config}"
}

config_comparsion () {
	cd "${DIR}/KERNEL" || exit
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" distclean
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" "${config}"
	cp -v .config "${DIR}/patches/ref_${config}"

	ref_config="imx_v6_v7_defconfig"
	config_reference

	ref_config="omap2plus_defconfig"
	config_reference

	ref_config="sunxi_defconfig"
	config_reference

	ref_config="tegra_defconfig"
	config_reference

	clear
	echo "Updating: defconfig-lpae"
	echo "-----------------------------"
	cp "${DIR}/patches/defconfig-lpae" .config
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" oldconfig
	cp .config "${DIR}/patches/defconfig-lpae"

	clear
	echo "Updating: defconfig-bone"
	echo "-----------------------------"
	cp "${DIR}/patches/defconfig-bone" .config
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" oldconfig
	cp .config "${DIR}/patches/defconfig-bone"

	clear
	echo "Updating: defconfig"
	echo "-----------------------------"
	cp "${DIR}/patches/defconfig" .config
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" oldconfig
	cp .config "${DIR}/patches/defconfig"
	cd "${DIR}/" || exit
}

flash_kernel_db () {
	cat ./KERNEL/arch/${KERNEL_ARCH}/boot/dts/*.dts | grep 'model =' | grep -v ',model' | grep -v 'audio' | grep -v 'sgtl5000' | grep -v 'n-board' | awk -F'"' '{print $2}' | sort -u > /tmp/pre.db
	sed -i -e 's/^/Machine: /' /tmp/pre.db
	awk '{print $0 "\nMethod: generic\nBootloader-sets-root: yes\n"}' /tmp/pre.db > patches/all.db
}

copy_defconfig () {
	cd "${DIR}/KERNEL" || exit
	if [ ! -f "${DIR}/.yakbuild" ] ; then
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" "${config}"
		cp -v "${DIR}/patches/defconfig" .config
	else
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" rcn-ee_defconfig
	fi
	cd "${DIR}/" || exit
}

make_menuconfig () {
	cd "${DIR}/KERNEL" || exit
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" menuconfig
	if [ ! -f "${DIR}/.yakbuild" ] ; then
		cp -v .config "${DIR}/patches/defconfig"
	fi
	cd "${DIR}/" || exit
}

make_kernel () {
	if [ "x${KERNEL_ARCH}" = "xarm" ] ; then
		image="zImage"
	else
		image="Image"
	fi

	unset address

	##uImage, if you really really want a uImage, zreladdr needs to be defined on the build line going forward...
	##make sure to install your distro's version of mkimage
	#image="uImage"
	#address="LOADADDR=${ZRELADDR}"

	cd "${DIR}/KERNEL" || exit
	echo "-----------------------------"
	echo "make -j${CORES} ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE=\"${CC}\" ${address} ${image} modules"
	echo "-----------------------------"
	make -j${CORES} ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE="${CC}" ${address} ${image} modules
	echo "-----------------------------"

	if grep -q dtbs "${DIR}/KERNEL/arch/${KERNEL_ARCH}/Makefile"; then
		echo "make -j${CORES} ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE=\"${CC}\" dtbs"
		echo "-----------------------------"
		make -j${CORES} ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE="${CC}" dtbs
		echo "-----------------------------"
	fi

	KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )

	if [ -f "${DIR}/deploy/${KERNEL_UTS}.${image}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}.${image}" || true
		rm -rf "${DIR}/deploy/config-${KERNEL_UTS}" || true
	fi

	if [ -f ./arch/${KERNEL_ARCH}/boot/${image} ] ; then
		cp -v arch/${KERNEL_ARCH}/boot/${image} "${DIR}/deploy/${KERNEL_UTS}.${image}"
		cp -v .config "${DIR}/deploy/config-${KERNEL_UTS}"
	fi

	cd "${DIR}/" || exit

	if [ ! -f "${DIR}/deploy/${KERNEL_UTS}.${image}" ] ; then
		export ERROR_MSG="File Generation Failure: [${KERNEL_UTS}.${image}]"
		/bin/sh -e "${DIR}/scripts/error.sh" && { exit 1 ; }
	else
		ls -lh "${DIR}/deploy/${KERNEL_UTS}.${image}"
	fi
}

make_pkg () {
	cd "${DIR}/KERNEL" || exit

	deployfile="-${pkg}.tar.gz"
	tar_options="--create --gzip --file"

	if [ -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}${deployfile}" || true
	fi

	if [ -d "${DIR}/deploy/tmp" ] ; then
		rm -rf "${DIR}/deploy/tmp" || true
	fi
	mkdir -p "${DIR}/deploy/tmp"

	echo "-----------------------------"
	echo "Building ${pkg} archive..."

	case "${pkg}" in
	modules)
		make -s ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE="${CC}" modules_install INSTALL_MOD_PATH="${DIR}/deploy/tmp"
		;;
	firmware)
		make -s ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE="${CC}" firmware_install INSTALL_FW_PATH="${DIR}/deploy/tmp"
		;;
	dtbs)
		if grep -q dtbs_install "${DIR}/KERNEL/arch/${KERNEL_ARCH}/Makefile"; then
			make -s ARCH=${KERNEL_ARCH} LOCALVERSION=${BUILD} CROSS_COMPILE="${CC}" dtbs_install INSTALL_DTBS_PATH="${DIR}/deploy/tmp"
		else
			find ./arch/${KERNEL_ARCH}/boot/ -iname "*.dtb" -exec cp -v '{}' "${DIR}/deploy/tmp/" \;
		fi
		;;
	esac

	echo "Compressing ${KERNEL_UTS}${deployfile}..."
	cd "${DIR}/deploy/tmp" || true
	tar ${tar_options} "../${KERNEL_UTS}${deployfile}" ./*

	cd "${DIR}/" || exit
	rm -rf "${DIR}/deploy/tmp" || true

	if [ ! -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		export ERROR_MSG="File Generation Failure: [${KERNEL_UTS}${deployfile}]"
		/bin/sh -e "${DIR}/scripts/error.sh" && { exit 1 ; }
	else
		ls -lh "${DIR}/deploy/${KERNEL_UTS}${deployfile}"
	fi
}

make_modules_pkg () {
	pkg="modules"
	make_pkg
}

make_firmware_pkg () {
	pkg="firmware"
	make_pkg
}

make_dtbs_pkg () {
	pkg="dtbs"
	make_pkg
}

if [  -f "${DIR}/.yakbuild" ] ; then
	if [ -f "${DIR}/recipe.sh.sample" ] ; then
		if [ ! -f "${DIR}/recipe.sh" ] ; then
			cp -v "${DIR}/recipe.sh.sample" "${DIR}/recipe.sh"
		fi
	fi
fi

/bin/sh -e "${DIR}/tools/host_det.sh" || { exit 1 ; }

if [ ! -f "${DIR}/system.sh" ] ; then
	cp -v "${DIR}/system.sh.sample" "${DIR}/system.sh"
fi

if [ -f "${DIR}/branches.list" ] ; then
	echo "-----------------------------"
	echo "Please checkout one of the active branches:"
	echo "-----------------------------"
	cat "${DIR}/branches.list" | grep -v INACTIVE
	echo "-----------------------------"
	exit
fi

if [ -f "${DIR}/branch.expired" ] ; then
	echo "-----------------------------"
	echo "Support for this branch has expired."
	unset response
	echo -n "Do you wish to bypass this warning and support your self: (y/n)? "
	read response
	if [ "x${response}" != "xy" ] ; then
		exit
	fi
	echo "-----------------------------"
fi

unset CC
unset LINUX_GIT
. "${DIR}/system.sh"
if [  -f "${DIR}/.yakbuild" ] ; then
	. "${DIR}/recipe.sh"
fi
/bin/sh -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }
. "${DIR}/.CC"
echo "CROSS_COMPILE=${CC}"
if [ -f /usr/bin/ccache ] ; then
	echo "ccache [enabled]"
	CC="ccache ${CC}"
fi

. "${DIR}/version.sh"
export LINUX_GIT

#unset FULL_REBUILD
FULL_REBUILD=1
if [ "${FULL_REBUILD}" ] ; then
	/bin/sh -e "${DIR}/scripts/git.sh" || { exit 1 ; }
	cp -v "${DIR}/KERNEL/scripts/package/builddeb" "${DIR}/3rdparty/packaging/"
	patch -p1 < "${DIR}/patches/pre-packaging/builddeb-make-dtbs_install.diff"

	if [ "${RUN_BISECT}" ] ; then
		/bin/sh -e "${DIR}/scripts/bisect.sh" || { exit 1 ; }
	fi

	if [ ! -f "${DIR}/.yakbuild" ] ; then
		patch_kernel
	fi
	if [ ! "${AUTO_BUILD}" ] ; then
		config_comparsion
		flash_kernel_db
	fi
	copy_defconfig
fi
if [ ! "${AUTO_BUILD}" ] ; then
	make_menuconfig
fi
if [  -f "${DIR}/.yakbuild" ] ; then
	BUILD=$(echo ${kernel_tag} | sed 's/[^-]*//'|| true)
fi
make_kernel
make_modules_pkg
make_firmware_pkg
if grep -q dtbs "${DIR}/KERNEL/arch/${KERNEL_ARCH}/Makefile"; then
	make_dtbs_pkg
fi
echo "-----------------------------"
echo "Script Complete"
echo "${KERNEL_UTS}" > kernel_version
echo "eewiki.net: [user@localhost:~$ export kernel_version=${KERNEL_UTS}]"
echo "-----------------------------"
