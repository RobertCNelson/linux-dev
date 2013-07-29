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

make_kernel () {
	cd ${DIR}/KERNEL/
	echo "-----------------------------"
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CC}\" zImage modules"
	echo "-----------------------------"
	make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" zImage modules

	unset DTBS
	cat ${DIR}/KERNEL/arch/arm/Makefile | grep "dtbs:" >/dev/null 2>&1 && DTBS=1
	if [ "x${DTBS}" != "x" ] ; then
		echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CC}\" dtbs"
		make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" dtbs
		ls arch/arm/boot/* | grep dtb >/dev/null 2>&1 || unset DTBS
	fi

	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )

	deployfile=".zImage"
	if [ -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}${deployfile}" || true
		rm -rf "${DIR}/deploy/${KERNEL_UTS}.config" || true
	fi

	if [ -f ./arch/arm/boot/zImage ] ; then
		echo "-----------------------------"
		cp -v arch/arm/boot/zImage "${DIR}/deploy/${KERNEL_UTS}.zImage"
		cp -v .config "${DIR}/deploy/${KERNEL_UTS}.config"
	fi

	cd ${DIR}/

	if [ ! -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		export ERROR_MSG="File Generation Failure: [${KERNEL_UTS}${deployfile}]"
		/bin/sh -e "${DIR}/scripts/error.sh" && { exit 1 ; }
	else
		ls -lh "${DIR}/deploy/${KERNEL_UTS}${deployfile}"
	fi
}

make_pkg () {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building ${pkg} Archive"
	echo "-----------------------------"

	deployfile="-${pkg}.tar.gz"
	if [ -f "${DIR}/deploy/${KERNEL_UTS}${deployfile}" ] ; then
		rm -rf "${DIR}/deploy/${KERNEL_UTS}${deployfile}" || true
	fi

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	case "${pkg}" in
	modules)
		make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/tmp
		;;
	firmware)
		make ARCH=arm CROSS_COMPILE=${CC} firmware_install INSTALL_FW_PATH=${DIR}/deploy/tmp
		;;
	dtbs)
		find ./arch/arm/boot/ -iname "*.dtb" -exec cp -v '{}' ${DIR}/deploy/tmp/ \;
		;;
	esac

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

/bin/sh -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ ! -f ${DIR}/system.sh ] ; then
	cp ${DIR}/system.sh.sample ${DIR}/system.sh
else
	#fixes for bash -> sh conversion...
	sed -i 's/bash/sh/g' ${DIR}/system.sh
	sed -i 's/==/=/g' ${DIR}/system.sh
fi

unset CC
unset LINUX_GIT
. ${DIR}/system.sh
/bin/sh -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }
. ${DIR}/.CC
echo "debug: CC=${CC}"

. ${DIR}/version.sh
export LINUX_GIT

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
if [ ! ${AUTO_BUILD} ] ; then
	make_menuconfig
fi
make_kernel
make_modules_pkg
make_firmware_pkg
if [ "x${DTBS}" != "x" ] ; then
	make_dtbs_pkg
fi
echo "-----------------------------"
echo "Script Complete"
echo "eewiki.net: [user@localhost:~$ export kernel_version=${KERNEL_UTS}]"
echo "-----------------------------"
