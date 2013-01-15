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
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} zImage modules"
	echo "-----------------------------"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} zImage modules

	unset DTBS
	cat ${DIR}/KERNEL/arch/arm/Makefile | grep "dtbs:" &> /dev/null && DTBS=1
	if [ "x${DTBS}" != "x" ] ; then
		echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} dtbs"
		time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} dtbs
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

function make_uImage {
	cd ${DIR}/KERNEL/
	echo "-----------------------------"
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} uImage"
	echo "-----------------------------"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} uImage
	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	if [ -f ./arch/arm/boot/uImage ] ; then
		cp arch/arm/boot/uImage ${DIR}/deploy/${KERNEL_UTS}.uImage
	else
		echo "-----------------------------"
		echo "Error: make uImage failed"
		exit
	fi
	cd ${DIR}/
}

function make_bootlets {
	cd ${DIR}/ignore/imx-bootlets/

	echo "-----------------------------"
	echo "Building IMX BOOTLETS"
	echo "-----------------------------"

	make CROSS_COMPILE=${ARM_NONE_CC} clean 2>/dev/null
	cat ${DIR}/KERNEL/arch/arm/boot/zImage ${DIR}/KERNEL/arch/arm/boot/${imx_bootlets_target}.dtb > ${DIR}/ignore/imx-bootlets/zImage
	make CROSS_COMPILE=${ARM_NONE_CC} 2>/dev/null

	if [ -f ${DIR}/ignore/imx-bootlets/sd_mmc_bootstream.raw ] ; then
		cp ${DIR}/ignore/imx-bootlets/sd_mmc_bootstream.raw ${DIR}/deploy/${KERNEL_UTS}.sd_mmc_bootstream.raw
	else
		echo "-----------------------------"
		echo "Error: make_bootlets failed"
		exit
	fi

	cd ${DIR}/
}

function make_modules_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Module Archive"
	echo "-----------------------------"

	rm -rf ${DIR}/deploy/mod &> /dev/null || true
	mkdir -p ${DIR}/deploy/mod
	make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/mod
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-modules.tar.gz"
	cd ${DIR}/deploy/mod
	tar czf ../${KERNEL_UTS}-modules.tar.gz *
	echo "-----------------------------"
	cd ${DIR}/
}

function make_firmware_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Firmware Archive"
	echo "-----------------------------"

	rm -rf ${DIR}/deploy/fir &> /dev/null || true
	mkdir -p ${DIR}/deploy/fir
	make ARCH=arm CROSS_COMPILE=${CC} firmware_install INSTALL_FW_PATH=${DIR}/deploy/fir
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-firmware.tar.gz"
	cd ${DIR}/deploy/fir
	tar czf ../${KERNEL_UTS}-firmware.tar.gz *
	echo "-----------------------------"
	cd ${DIR}/
}

function make_dtbs_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building DTBS Archive"
	echo "-----------------------------"

	rm -rf ${DIR}/deploy/dtbs &> /dev/null || true
	mkdir -p ${DIR}/deploy/dtbs
	find ./arch/arm/boot/ -iname "*.dtb" -exec cp -v '{}' ${DIR}/deploy/dtbs/ \;
	cd ${DIR}/deploy/dtbs
	echo "-----------------------------"
	echo "Building ${KERNEL_UTS}-dtbs.tar.gz"
	tar czf ../${KERNEL_UTS}-dtbs.tar.gz *
	echo "-----------------------------"
	cd ${DIR}/
}

function make_headers_pkg {
	cd ${DIR}/KERNEL/

	echo "-----------------------------"
	echo "Building Header Archive"
	echo "-----------------------------"

	rm -rf ${DIR}/deploy/headers &> /dev/null || true
	mkdir -p ${DIR}/deploy/headers/usr
	make ARCH=arm CROSS_COMPILE=${CC} headers_install INSTALL_HDR_PATH=${DIR}/deploy/headers/usr
	cd ${DIR}/deploy/headers
	echo "-----------------------------"	
	echo "Building ${KERNEL_UTS}-headers.tar.gz"
	tar czf ../${KERNEL_UTS}-headers.tar.gz *
	echo "-----------------------------"	
	cd ${DIR}/
}

/bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ ! -f ${DIR}/system.sh ] ; then
	cp ${DIR}/system.sh.sample ${DIR}/system.sh
fi

unset CC
unset DEBUG_SECTION
unset LATEST_GIT
unset LINUX_GIT
unset LOCAL_PATCH_DIR
source ${DIR}/system.sh
/bin/bash -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }
source ${DIR}/.CC
echo "debug: CC=${CC}"

source ${DIR}/version.sh
export LINUX_GIT
export LATEST_GIT

if [ "${LATEST_GIT}" ] ; then
	echo "-----------------------------"
	echo "Warning LATEST_GIT is enabled from system.sh I hope you know what your doing.."
	echo "-----------------------------"
fi

unset CONFIG_DEBUG_SECTION
if [ "${DEBUG_SECTION}" ] ; then
	CONFIG_DEBUG_SECTION="CONFIG_DEBUG_SECTION_MISMATCH=y"
fi

#unset FULL_REBUILD
FULL_REBUILD=1
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
if [ "x${GCC_OVERRIDE}" != "x" ] ; then
	sed -i -e 's:CROSS_COMPILE)gcc:CROSS_COMPILE)'$GCC_OVERRIDE':g' ${DIR}/KERNEL/Makefile
fi
make_kernel
if [ "${BUILD_UIMAGE}" ] ; then
	make_uImage
fi
if [ "${IMX_BOOTLETS}" ] ; then
	make_bootlets
fi
make_modules_pkg
make_firmware_pkg
if [ "x${DTBS}" != "x" ] ; then
	make_dtbs_pkg
fi
if [ "${FULL_REBUILD}" ] ; then
	make_headers_pkg
fi
if [ "x${GCC_OVERRIDE}" != "x" ] ; then
	sed -i -e 's:CROSS_COMPILE)'$GCC_OVERRIDE':CROSS_COMPILE)gcc:g' ${DIR}/KERNEL/Makefile
fi