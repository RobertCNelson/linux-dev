#!/bin/bash -e
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

function patch_kernel {
	cd ${DIR}/KERNEL

	export DIR GIT_OPTS
	/bin/bash -e ${DIR}/patch.sh || { git add . ; exit 1 ; }

	if [ ! "${RUN_BISECT}" ] ; then
		git add .
		git commit --allow-empty -a -m "${KERNEL_TAG}-${BUILD} patchset"
	fi

#Test Patches:
#exit

	if [ "${LOCAL_PATCH_DIR}" ] ; then
		for i in ${LOCAL_PATCH_DIR}/*.patch ; do patch  -s -p1 < $i ; done
		BUILD+='+'
	fi

	cd ${DIR}/
}

function copy_defconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} distclean
	make ARCH=arm CROSS_COMPILE=${CC} ${config}
	cp -v .config ${DIR}/patches/ref_${config}
	cp -v ${DIR}/patches/defconfig .config
	cd ${DIR}/
}

function make_menuconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} menuconfig
	cp -v .config ${DIR}/patches/defconfig
	cd ${DIR}/
}

function make_kernel {
	cd ${DIR}/KERNEL/
	echo "-----------------------------"
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CC}\" ${CONFIG_DEBUG_SECTION} zImage modules"
	echo "-----------------------------"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" ${CONFIG_DEBUG_SECTION} zImage modules

	unset DTBS
	cat ${DIR}/KERNEL/arch/arm/Makefile | grep "dtbs:" &> /dev/null && DTBS=1
	if [ "x${DTBS}" != "x" ] ; then
		echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CC}\" ${CONFIG_DEBUG_SECTION} dtbs"
		time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CC}" ${CONFIG_DEBUG_SECTION} dtbs
		ls arch/arm/boot/* | grep dtb || unset DTBS
	fi

	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	if [ -f ./arch/arm/boot/zImage ] ; then
		cp arch/arm/boot/zImage ${DIR}/deploy/${KERNEL_UTS}.zImage
		cp .config ${DIR}/deploy/${KERNEL_UTS}.config
	else
		echo "-----------------------------"
		echo "Error: make zImage modules failed"
		exit
	fi
	cd ${DIR}/
}

function make_modules_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Module Archive"
	echo "-----------------------------"

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/tmp

	cd ${DIR}/deploy/tmp
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-modules.tar.gz"
	tar czf ../${KERNEL_UTS}-modules.tar.gz *
	echo "-----------------------------"

	cd ${DIR}/
	rm -rf ${DIR}/deploy/tmp || true
}

function make_firmware_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Firmware Archive"
	echo "-----------------------------"

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	make ARCH=arm CROSS_COMPILE=${CC} firmware_install INSTALL_FW_PATH=${DIR}/deploy/tmp

	cd ${DIR}/deploy/tmp
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-firmware.tar.gz"
	tar czf ../${KERNEL_UTS}-firmware.tar.gz *
	echo "-----------------------------"

	cd ${DIR}/
	rm -rf ${DIR}/deploy/tmp || true
}

function make_dtbs_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building DTBS Archive"
	echo "-----------------------------"

	if [ -d ${DIR}/deploy/tmp ] ; then
		rm -rf ${DIR}/deploy/tmp || true
	fi
	mkdir -p ${DIR}/deploy/tmp

	find ./arch/arm/boot/ -iname "*.dtb" -exec cp -v '{}' ${DIR}/deploy/tmp/ \;

	cd ${DIR}/deploy/tmp
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-dtbs.tar.gz"
	tar czf ../${KERNEL_UTS}-dtbs.tar.gz *
	echo "-----------------------------"

	cd ${DIR}/
	rm -rf ${DIR}/deploy/tmp || true
}

/bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ ! -f ${DIR}/system.sh ] ; then
	cp ${DIR}/system.sh.sample ${DIR}/system.sh
fi

unset CC
unset DEBUG_SECTION
unset LINUX_GIT
unset LOCAL_PATCH_DIR
source ${DIR}/system.sh
/bin/bash -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }
source ${DIR}/.CC
echo "debug: CC=${CC}"

source ${DIR}/version.sh
export LINUX_GIT

unset CONFIG_DEBUG_SECTION
if [ "${DEBUG_SECTION}" ] ; then
	CONFIG_DEBUG_SECTION="CONFIG_DEBUG_SECTION_MISMATCH=y"
fi

unset FULL_REBUILD
#FULL_REBUILD=1
if [ "${FULL_REBUILD}" ] ; then
	/bin/bash -e "${DIR}/scripts/git.sh" || { exit 1 ; }

	if [ "${RUN_BISECT}" ] ; then
		/bin/bash -e "${DIR}/scripts/bisect.sh" || { exit 1 ; }
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