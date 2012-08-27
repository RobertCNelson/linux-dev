#!/bin/bash -e
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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

	git add .
	git commit --allow-empty -a -m "${KERNEL_TAG}-${BUILD} patchset"

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
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} zImage modules"
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
		echo "Error: make zImage modules failed"
		exit
	fi
	cd ${DIR}/
}

function make_uImage {
	cd ${DIR}/KERNEL/
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} uImage"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} uImage
	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	if [ -f ./arch/arm/boot/uImage ] ; then
		cp arch/arm/boot/uImage ${DIR}/deploy/${KERNEL_UTS}.uImage
	else
		echo "Error: make uImage failed"
		exit
	fi
	cd ${DIR}/
}

function make_modules_pkg {
  cd ${DIR}/KERNEL/

  echo ""
  echo "Building Module Archive"
  echo ""

  rm -rf ${DIR}/deploy/mod &> /dev/null || true
  mkdir -p ${DIR}/deploy/mod
  make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/mod
  echo "Building ${KERNEL_UTS}-modules.tar.gz"
  cd ${DIR}/deploy/mod
  tar czf ../${KERNEL_UTS}-modules.tar.gz *
  cd ${DIR}/
}

function make_dtbs_pkg {
	cd ${DIR}/KERNEL/

	echo ""
	echo "Building DTBS Archive"
	echo ""

	rm -rf ${DIR}/deploy/dtbs &> /dev/null || true
	mkdir -p ${DIR}/deploy/dtbs
	cp -v arch/arm/boot/*.dtb ${DIR}/deploy/dtbs
	cd ${DIR}/deploy/dtbs
	echo "Building ${KERNEL_UTS}-dtbs.tar.gz"
	tar czf ../${KERNEL_UTS}-dtbs.tar.gz *

	cd ${DIR}/
}

function make_headers_pkg {
  cd ${DIR}/KERNEL/

  echo ""
  echo "Building Header Archive"
  echo ""

  rm -rf ${DIR}/deploy/headers &> /dev/null || true
  mkdir -p ${DIR}/deploy/headers/usr
  make ARCH=arm CROSS_COMPILE=${CC} headers_install INSTALL_HDR_PATH=${DIR}/deploy/headers/usr
  cd ${DIR}/deploy/headers
  echo "Building ${KERNEL_UTS}-headers.tar.gz"
  tar czf ../${KERNEL_UTS}-headers.tar.gz *
  cd ${DIR}/
}

/bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ -e ${DIR}/system.sh ] ; then
	unset CC
	unset DEBUG_SECTION
	unset LATEST_GIT
	unset LINUX_GIT
	unset LOCAL_PATCH_DIR
	source ${DIR}/system.sh
	/bin/bash -e "${DIR}/scripts/gcc.sh" || { exit 1 ; }

	source ${DIR}/version.sh
	export LINUX_GIT
	export LATEST_GIT

	if [ "${LATEST_GIT}" ] ; then
		echo ""
		echo "Warning LATEST_GIT is enabled from system.sh I hope you know what your doing.."
		echo ""
	fi

	unset CONFIG_DEBUG_SECTION
	if [ "${DEBUG_SECTION}" ] ; then
		CONFIG_DEBUG_SECTION="CONFIG_DEBUG_SECTION_MISMATCH=y"
	fi

	/bin/bash -e "${DIR}/scripts/git.sh" || { exit 1 ; }
	patch_kernel
	copy_defconfig
	make_menuconfig
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)gcc:CROSS_COMPILE)'$GCC_OVERRIDE':g' ${DIR}/KERNEL/Makefile
	fi
	make_kernel
	if [ "${BUILD_UIMAGE}" ] ; then
		make_uImage
	else
		echo ""
		echo "NOTE: enable BUILD_UIMAGE variables in system.sh to build uImage's"
		echo ""
	fi
	make_modules_pkg
	if [ "x${DTBS}" != "x" ] ; then
		make_dtbs_pkg
	fi
	make_headers_pkg
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)'$GCC_OVERRIDE':CROSS_COMPILE)gcc:g' ${DIR}/KERNEL/Makefile
	fi
else
	echo ""
	echo "ERROR: Missing (your system) specific system.sh, please copy system.sh.sample to system.sh and edit as needed."
	echo ""
	echo "example: cp system.sh.sample system.sh"
	echo "example: gedit system.sh"
	echo ""
fi
