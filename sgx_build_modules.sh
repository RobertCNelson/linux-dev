#!/bin/bash -e
#
# Copyright (c) 2012-2014 Robert Nelson <robertcnelson@gmail.com>
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

VERSION="v2014.02-1"

unset DIR

DIR=$PWD

SDK="5.01.01.01"
sdk_version="5_01_01_01"
SDK_DIR="5_01_01_01"
SGX_SHA="origin/${SDK}"
#SGX_SHA="origin/master"

http_ti="http://software-dl.ti.com/dsps/dsps_public_sw/gfxsdk/"
sgx_file="Graphics_SDK_setuplinux_hardfp_${sdk_version}.bin"
sgx_md5sum="94acdbd20152c905939c2448d5e80a72"

dl_sdk () {
	echo "md5sum mis-match: ${md5sum} (re-downloading)"
	wget -c --directory-prefix=${DIR}/dl ${http_ti}${sdk_version}/exports/${sgx_file}
	if [ ! -f ${DIR}/dl/${sgx_file} ] ; then
		echo "network failure"
		exit
	fi
}

dl_n_verify_sdk () {
	if [ -f "${DIR}/dl/${sgx_file}" ] ; then
		echo "Verifying: ${sgx_file}"
		md5sum=$(md5sum "${DIR}/dl/${sgx_file}" | awk '{print $1}')
		if [ "x${sgx_md5sum}" != "x${md5sum}" ] ; then
			echo "Debug: md5sum mismatch got: ${md5sum}"
			rm -f "${DIR}/dl/${sgx_file}" || true
			dl_sdk
		else
			echo "md5sum match: ${md5sum}"
		fi
	else
		dl_sdk
	fi
}

install_sgx () {
	if [ ! -f "${DIR}/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}/verify.${sgx_md5sum}" ] ; then
		echo "Installing: Graphics_SDK_setuplinux_${sdk_version}"
		if [ -d "${DIR}/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}" ] ; then
			rm -rf "${DIR}/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}" || true
		fi
		chmod +x "${DIR}"/dl/${sgx_file}
		"${DIR}"/dl/${sgx_file} --mode console --prefix "${DIR}"/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version} <<-__EOF__
		Y
		qy
	
		__EOF__
		touch "${DIR}"/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}/verify.${sgx_md5sum}
	else
		echo "Graphics_SDK_setuplinux_${sdk_version} is installed"
	fi
}

set_sgx_make_vars () {
	source ${DIR}/.CC
	GRAPHICS_PATH="GRAPHICS_INSTALL_DIR="${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/""
	KERNEL_PATH="KERNEL_INSTALL_DIR="${DIR}/KERNEL""
	USER_VAR="HOME=/home/${USER}"
	CSTOOL_PREFIX=${CC##*/}

	#Will probally have to revist this one later...
	CSTOOL_DIR=$(echo ${CC} | awk -F "/bin/${CSTOOL_PREFIX}" '{print $1}')

	if [ "x${CSTOOL_PREFIX}" == "x${CSTOOL_DIR}" ] ; then
		CSTOOL_DIR="/usr"
	fi

	CROSS="CSTOOL_PREFIX=${CSTOOL_PREFIX} CSTOOL_DIR=${CSTOOL_DIR}"
}

git_sgx_modules () {
	if [ ! -f "${DIR}/ignore/ti-sdk-pvr/.git/config" ] ; then
		git clone git://github.com/RobertCNelson/ti-sdk-pvr.git "${DIR}/ignore/ti-sdk-pvr/"
		cd "${DIR}/ignore/ti-sdk-pvr/"
		git checkout ${SGX_SHA} -b tmp-build
		cd ${DIR}/
	else
		cd "${DIR}/ignore/ti-sdk-pvr/"
		git add .
		git commit --allow-empty -a -m 'empty cleanup commit'
		git checkout origin/master -b tmp-scratch
		git branch -D tmp-build &>/dev/null || true
		git fetch
		git checkout ${SGX_SHA} -b tmp-build
		git branch -D tmp-scratch &>/dev/null || true
		cd ${DIR}/
	fi
}

copy_sgx_es () {
	echo "Copying: ${es_version} to build dir"
	mkdir -p "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/armhf/gfx_rel_${es_version}" || true
	cp -r "${DIR}"/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}/gfx_rel_${es_version}/* "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/armhf/gfx_rel_${es_version}/"
}

copy_sgx_binaries () {
	if [ -d "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/armhf" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/armhf" || true
		mkdir -p "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/armhf" || true
	fi

	echo "Starting: copying files from the SDK"
	if [  -d "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/targetfs" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/targetfs" || true
	fi
	mkdir -p "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/targetfs" || true

	if [ -d "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/tools" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/tools" || true
	fi
	mkdir -p "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/tools" || true

	cp -r "${DIR}"/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}/tools "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/"

#	es_version="es5.x"
#	copy_sgx_es

	es_version="es8.x"
	copy_sgx_es

#	es_version="es9.x"
#	copy_sgx_es
}

clean_sgx_modules () {
	echo "-----------------------------"
	echo "make clean"
	echo "-----------------------------"
	cd "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/"
	pwd
	echo "make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} clean"
	make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} clean &> /dev/null
	cd ${DIR}/
	echo "-----------------------------"
}

build_sgx_modules () {
	echo "-----------------------------"
	echo "Building es$2 modules"
	echo "-----------------------------"
	cd "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/"

	if [ -d "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es$2/" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es$2/" || true
	fi
	mkdir -p "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es$2/" || true

	pwd
	echo "make BUILD={debug | release} OMAPES={5.x | 8.x | 9.x} FBDEV={yes | no} all"
	echo "make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" "$4""
	make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" "$4"
	cd ${DIR}/
	echo "-----------------------------"
	echo "modinfo sanity check: vermagic:"
	/sbin/modinfo "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es$2/"pvr* | grep vermagic || true
	echo "-----------------------------"
}

installing_sgx_modules () {
	echo "-----------------------------"
	echo "Installing es$2 modules"
	echo "-----------------------------"
	cd "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/"

	DESTDIR="${DIR}/deploy/$2"
	if [ -d ${DESTDIR} ] ; then
		rm -rf ${DESTDIR} || true
	fi
	mkdir -p ${DESTDIR} || true
	mkdir -p ${DESTDIR}/etc/init.d/ || true
	mkdir -p ${DESTDIR}/opt/ || true

	INSTALL_HOME="${DIR}/ignore/SDK_BIN/"
	GRAPHICS_INSTALL_DIR="${INSTALL_HOME}Graphics_SDK_setuplinux_${sdk_version}"

	pwd
	echo "make BUILD=(debug | release} OMAPES={5.x | 8.x | 9.x} install"
	echo "make DESTDIR=${DESTDIR} HOME=${INSTALL_HOME} GRAPHICS_INSTALL_DIR=${GRAPHICS_INSTALL_DIR} BUILD="$1" OMAPES="$2" "$3""
	make DESTDIR=${DESTDIR} HOME=${INSTALL_HOME} GRAPHICS_INSTALL_DIR=${GRAPHICS_INSTALL_DIR} BUILD="$1" OMAPES="$2" "$3"

	OMAPES="$2"
	mkdir -p ${DESTDIR}/opt/gfxmodules/gfx_rel_es${OMAPES} || true
	cp -v "${DIR}"/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es${OMAPES}/*.ko ${DESTDIR}/opt/gfxmodules/gfx_rel_es${OMAPES} || true

	#remove devmem2:
	find "${DESTDIR}/" -name "devmem2" -exec rm -rf {} \;
	rm -rf ${DESTDIR}/etc/init.d/335x-demo || true
	rm -rf ${DESTDIR}/etc/init.d/rc.pvr || true

	mkdir -p ${DESTDIR}/opt/gfxinstall/scripts/ || true
	cp -v "${DIR}"/3rdparty/sgx-startup-debian.sh ${DESTDIR}/opt/gfxinstall/scripts/
	cp -v "${DIR}"/3rdparty/sgx-startup-ubuntu.conf ${DESTDIR}/opt/gfxinstall/scripts/
	cp -v "${DIR}"/3rdparty/sgx-install.sh ${DESTDIR}/opt/gfxinstall/
	chmod +x ${DESTDIR}/opt/gfxinstall/sgx-install.sh

	cd ${DESTDIR}/
	tar czf ${DIR}/deploy/GFX_${SDK}.tar.gz *
	cd "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/"
}

if [ -e ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
	source ${DIR}/version.sh

	if [ ! -d "${DIR}/ignore/" ] ; then
		mkdir "${DIR}/ignore/"
	fi

	dl_n_verify_sdk
	install_sgx

	set_sgx_make_vars

	git_sgx_modules
	copy_sgx_binaries

	#No reason to rebuild the sdk...
	sed -i -e 's:all_km all_sdk:all_km:g' "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/Makefile"
	sed -i -e 's:install_km install_sdk:install_km:g' "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/Makefile"

	#Disable building of devmem2, as it breaks with hardfp based cross compilers, and we use the distro package anyways...
	sed -i -e 's:prepare_km buildkernel builddevmem2:prepare_km buildkernel:g' "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/Makefile.KM"

	if [ ! -f "${DIR}/KERNEL/Makefile" ] ; then
		echo ""
		echo "ERROR: Run: ./build_kernel.sh first"
		echo ""
		exit
	fi

	#Build:
	#make BUILD={debug | release} OMAPES={5.x | 8.x | 9.x} FBDEV={yes | no} all
	#Install:
	#make BUILD=(debug | release} OMAPES={5.x | 8.x | 9.x} install

#	clean_sgx_modules
#	build_sgx_modules release 5.x yes all

	clean_sgx_modules
	build_sgx_modules release 8.x no all
	installing_sgx_modules release 8.x install

#	clean_sgx_modules
#	build_sgx_modules release 9.x yes all

	#Disable when debugging...
	if [ -d "${DIR}/ignore/ti-sdk-pvr/pkg/" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/pkg" || true
	fi
	if [ -d "${DIR}/ignore/ti-sdk-pvr/examples/" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/examples" || true
	fi

else
	echo ""
	echo "ERROR: Missing (your system) specific system.sh, please copy system.sh.sample to system.sh and edit as needed."
	echo ""
	echo "example: cp system.sh.sample system.sh"
	echo "example: gedit system.sh"
	echo ""
fi

