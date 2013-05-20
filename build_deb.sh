#!/bin/sh -e
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
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

mkdir -p ${DIR}/deploy/

patch_kernel () {
	cd ${DIR}/KERNEL

	export DIR GIT_OPTS
	/bin/sh -e ${DIR}/patch.sh || { git add . ; exit 1 ; }

	if [ ! "${RUN_BISECT}" ] ; then
		git add .
		git commit --allow-empty -a -m "${KERNEL_TAG}-${BUILD} patchset"
	fi

#Test Patches:
#exit

	if [ "${LOCAL_PATCH_DIR}" ] ; then
		for i in ${LOCAL_PATCH_DIR}/*.patch ; do patch  -s -p1 < $i ; done
		BUILD="${BUILD}+"
	fi

	cd ${DIR}/
}

copy_defconfig () {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} distclean
	make ARCH=arm CROSS_COMPILE=${CC} ${config}
	cp -v .config ${DIR}/patches/ref_${config}
	cp -v ${DIR}/patches/defconfig .config
	cd ${DIR}/
}

make_menuconfig () {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} menuconfig
	cp -v .config ${DIR}/patches/defconfig
	cd ${DIR}/
}

make_deb () {
	cd ${DIR}/KERNEL/
	echo "-----------------------------"
	echo "make -j${CORES} ARCH=arm KBUILD_DEBARCH=${DEBARCH} LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" KDEB_PKGVERSION=${BUILDREV}${DISTRO} ${CONFIG_DEBUG_SECTION} deb-pkg"
	echo "-----------------------------"
	fakeroot make -j${CORES} ARCH=arm KBUILD_DEBARCH=${DEBARCH} LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" KDEB_PKGVERSION=${BUILDREV}${DISTRO} ${CONFIG_DEBUG_SECTION} deb-pkg
	mv ${DIR}/*.deb ${DIR}/deploy/

	unset DTBS
	cat ${DIR}/KERNEL/arch/arm/Makefile | grep "dtbs:" >/dev/null 2>&1 && DTBS=1
	if [ "x${DTBS}" != "x" ] ; then
		echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CC}\" ${CONFIG_DEBUG_SECTION} dtbs"
		make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" ${CONFIG_DEBUG_SECTION} dtbs
		ls arch/arm/boot/* | grep dtb >/dev/null 2>&1 || unset DTBS
	fi

	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )

	cd ${DIR}/
}

make_firmware_pkg () {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Firmware Archive"
	echo "-----------------------------"

	deployfile="-firmware.tar.gz"
	if [ -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}${deployfile}" || true
	fi

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	make ARCH=arm CROSS_COMPILE=${CC} firmware_install INSTALL_FW_PATH=${DIR}/deploy/tmp

	cd ${DIR}/deploy/tmp
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}${deployfile}"
	tar czf ../${KERNEL_UTS}${deployfile} *
	echo "-----------------------------"

	cd ${DIR}/
	rm -rf ${DIR}/deploy/tmp || true

	if [ ! -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		export ERROR_MSG="File Generation Failure: [${KERNEL_UTS}${deployfile}]"
		/bin/sh -e "${DIR}/scripts/error.sh" && { exit 1 ; }
	else
		ls -lh "${DIR}/deploy/${KERNEL_UTS}${deployfile}"
	fi
}

make_dtbs_pkg () {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building DTBS Archive"
	echo "-----------------------------"

	deployfile="-dtbs.tar.gz"
	if [ -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}${deployfile}" || true
	fi

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	find ./arch/arm/boot/ -iname "*.dtb" -exec cp -v '{}' ${DIR}/deploy/tmp/ \;

	cd ${DIR}/deploy/tmp
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}${deployfile}"
	tar czf ../${KERNEL_UTS}${deployfile} *
	echo "-----------------------------"

	cd ${DIR}/
	rm -rf ${DIR}/deploy/tmp || true

	if [ ! -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		export ERROR_MSG="File Generation Failure: [${KERNEL_UTS}${deployfile}]"
		/bin/sh -e "${DIR}/scripts/error.sh" && { exit 1 ; }
	else
		ls -lh "${DIR}/deploy/${KERNEL_UTS}${deployfile}"
	fi
}

/bin/sh -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ ! -f ${DIR}/system.sh ] ; then
	cp ${DIR}/system.sh.sample ${DIR}/system.sh
else
	#fixes for bash -> sh conversion...
	sed -i 's/bash/sh/g' ${DIR}/system.sh
	sed -i 's/==/=/g' ${DIR}/system.sh
fi

if [ -f "${DIR}/branches.list" ] ; then
	echo "-----------------------------"
	echo "Please checkout one of the active branches:"
	echo "-----------------------------"
	cat ${DIR}/branches.list | grep -v INACTIVE
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
unset DEBUG_SECTION
unset LINUX_GIT
unset LOCAL_PATCH_DIR
. ${DIR}/system.sh
/bin/sh -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }
. ${DIR}/.CC
echo "debug: CC=${CC}"

. ${DIR}/version.sh
export LINUX_GIT

unset CONFIG_DEBUG_SECTION
if [ "${DEBUG_SECTION}" ] ; then
	CONFIG_DEBUG_SECTION="CONFIG_DEBUG_SECTION_MISMATCH=y"
fi

#unset FULL_REBUILD
FULL_REBUILD=1
if [ "${FULL_REBUILD}" ] ; then
	/bin/sh -e "${DIR}/scripts/git.sh" || { exit 1 ; }

	if [ "${RUN_BISECT}" ] ; then
		/bin/sh -e "${DIR}/scripts/bisect.sh" || { exit 1 ; }
	fi

	patch_kernel
	copy_defconfig
fi
if [ ! ${AUTO_BUILD} ] ; then
	make_menuconfig
fi
make_deb
make_firmware_pkg
if [ "x${DTBS}" != "x" ] ; then
	make_dtbs_pkg
fi