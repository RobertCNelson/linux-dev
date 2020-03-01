#!/bin/sh -e
#
# Copyright (c) 2009-2020 Robert Nelson <robertcnelson@gmail.com>
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
git_bin=$(which git)

mkdir -p "${DIR}/deploy/"

patch_kernel () {
	cd "${DIR}/KERNEL" || exit

	export DIR
	/bin/bash -e "${DIR}/patch.sh" || { ${git_bin} add . ; exit 1 ; }

	if [ ! -f "${DIR}/.yakbuild" ] ; then
		if [ ! "${RUN_BISECT}" ] ; then
			${git_bin} add --all
			${git_bin} commit --allow-empty -a -m "${KERNEL_TAG}${BUILD} patchset"
		fi
	fi

	cd "${DIR}/" || exit
}

copy_defconfig () {
	cd "${DIR}/KERNEL" || exit
	make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" distclean
	if [ ! -f "${DIR}/.yakbuild" ] ; then
		make ARCH=${KERNEL_ARCH} CROSS_COMPILE="${CC}" "${config}"
		cp -v .config "${DIR}/patches/ref_${config}"
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

make_deb () {
	cd "${DIR}/KERNEL" || exit

	deb_distro=$(lsb_release -cs | sed 's/\//_/g')
	if [ "x${deb_distro}" = "xn_a" ] ; then
		deb_distro="unstable"
	fi

	build_opts="-j${CORES}"
	build_opts="${build_opts} ARCH=${KERNEL_ARCH}"
	build_opts="${build_opts} KBUILD_DEBARCH=${DEBARCH}"
	build_opts="${build_opts} LOCALVERSION=${BUILD}"
	build_opts="${build_opts} KDEB_CHANGELOG_DIST=${deb_distro}"
	build_opts="${build_opts} KDEB_PKGVERSION=1${DISTRO}"
	#Just use "linux-upstream"...
	#https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/scripts/package/builddeb?id=3716001bcb7f5822382ac1f2f54226b87312cc6b
	build_opts="${build_opts} KDEB_SOURCENAME=linux-upstream"

	echo "-----------------------------"
	if grep -q bindeb-pkg "${DIR}/KERNEL/scripts/package/Makefile"; then
		echo "make ${build_opts} CROSS_COMPILE="${CC}" bindeb-pkg"
		echo "-----------------------------"
		make ${build_opts} CROSS_COMPILE="${CC}" bindeb-pkg
	else
		echo "make ${build_opts} CROSS_COMPILE="${CC}" deb-pkg"
		echo "-----------------------------"
		make ${build_opts} CROSS_COMPILE="${CC}" deb-pkg
	fi

	#old
	mv "${DIR}"/*.debian.tar.gz "${DIR}/deploy/" || true
	mv "${DIR}"/*.dsc "${DIR}/deploy/" || true
	mv "${DIR}"/*.orig.tar.gz "${DIR}/deploy/" || true

	#current
	mv "${DIR}"/*.buildinfo "${DIR}/deploy/" || true
	mv "${DIR}"/*.changes "${DIR}/deploy/" || true
	mv "${DIR}"/*.deb "${DIR}/deploy/" || true

	KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )

	cd "${DIR}/" || exit
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

if [ ! "${CORES}" ] ; then
	CORES=$(getconf _NPROCESSORS_ONLN)
fi

unset FULL_REBUILD
#FULL_REBUILD=1
if [ "${FULL_REBUILD}" ] ; then
	/bin/sh -e "${DIR}/scripts/git.sh" || { exit 1 ; }

	if [ "${RUN_BISECT}" ] ; then
		/bin/sh -e "${DIR}/scripts/bisect.sh" || { exit 1 ; }
	fi

	patch_kernel
	copy_defconfig
fi
if [ ! "${AUTO_BUILD}" ] ; then
	make_menuconfig
fi
if [  -f "${DIR}/.yakbuild" ] ; then
	BUILD=$(echo ${kernel_tag} | sed 's/[^-]*//'|| true)
fi
make_deb
echo "-----------------------------"
echo "Script Complete"
echo "${KERNEL_UTS}" > kernel_version
echo "-----------------------------"
