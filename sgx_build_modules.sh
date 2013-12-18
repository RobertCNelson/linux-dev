#!/bin/bash -e
#
# Copyright (c) 2012-2013 Robert Nelson <robertcnelson@gmail.com>
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

VERSION="v2013.04-1"

unset DIR

DIR=$PWD

SDK="5.00.00.01"
sdk_version="5_00_00_01"
SDK_DIR="5_00_00_01"
SGX_SHA="origin/${SDK}"
#SGX_SHA="origin/master"

http_ti="http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/gfxsdk/"
sgx_file="Graphics_SDK_setuplinux_${sdk_version}_alpha_hardfp_minimal_demos.bin"


dl_sdk () {
	echo "md5sum mis-match: ${md5sum} (re-downloading)"
	wget -c --directory-prefix=${DIR}/dl ${http_ti}${sdk_version}/exports/${sgx_file}
	if [ ! -f ${DIR}/dl/${sgx_file} ] ; then
		echo "network failure"
		exit
	fi
}

dl_n_verify_sdk () {
	sgx_md5sum="ae6125d7f8a313ea5c02afded893052d"

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

#	es_version="es3.x"
#	copy_sgx_es

#	es_version="es5.x"
#	copy_sgx_es

#	es_version="es6.x"
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
	echo "make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" SUPPORT_XORG="$4" "$5""
	make ${GRAPHICS_PATH} ${KERNEL_PATH} HOME=${HOME} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" SUPPORT_XORG="$4" "$5"
	cd ${DIR}/
	echo "-----------------------------"
	echo "modinfo sanity check: vermagic:"
	/sbin/modinfo "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_es$2/"pvr* | grep vermagic || true
	echo "-----------------------------"
}

file_pvr_startup () {
	cat > "${DIR}/ignore/ti-sdk-pvr/pkg/pvr_startup" <<-__EOF__
	#!/bin/sh -e
	### BEGIN INIT INFO
	# Provides:          pvr_startup
	# Required-Start:    \$local_fs
	# Required-Stop:     \$local_fs
	# Default-Start:     2 3 4 5
	# Default-Stop:      0 1 6
	# Short-Description: Start daemon at boot time
	# Description:       Enable service provided by daemon.
	### END INIT INFO

	touch /etc/powervr-esrev
	SAVED_ESREVISION="\$(cat /etc/powervr-esrev)"

	case "\$1" in
	start)
	        echo "sgx: Starting PVR"
	        modprobe drm
	        modprobe bufferclass_ti

	        pvr_maj=\$(grep "pvrsrvkm$" /proc/devices | cut -b1,2,3)
	        bc_maj=\$(grep "bc" /proc/devices | cut -b1,2,3)

	        if [ -e /dev/pvrsrvkm ] ; then
	                rm -f /dev/pvrsrvkm
	        fi

	        mknod /dev/pvrsrvkm c \$pvr_maj 0
	        chmod 666 /dev/pvrsrvkm

	        #devmem2 0x48004B48 w 0x2 > /dev/null
	        #devmem2 0x48004B10 w 0x1 > /dev/null
	        #devmem2 0x48004B00 w 0x2 > /dev/null

	        #ES_REVISION="\$(devmem2 0x50000014 | sed -e s:0x10205:5: -e s:0x10201:3: | tail -n1 | awk -F': ' '{print \$2}')"
	        ES_REVISION="8"

	        if [ "x\${ES_REVISION}" != "x\${SAVED_ESREVISION}" ] ; then
	                echo -n "sgx: Starting SGX fixup for"
	                echo " ES\${ES_REVISION}.x"
	                cp -a /usr/lib/es\${ES_REVISION}.0/* /usr/lib
	                cp -a /usr/bin/es\${ES_REVISION}.0/* /usr/bin
	                echo "\${ES_REVISION}" > /etc/powervr-esrev
	        fi

	        /usr/bin/pvrsrvctl --start --no-module
	        ;;
	reload|force-reload|restart)
	        echo "sgx: Restarting PVR"
	        rmmod bufferclass_ti 2>/dev/null || true
	        rmmod drm 2>/dev/null || true
	        rmmod pvrsrvkm 2>/dev/null || true

	        echo "sgx: Starting PVR"
	        modprobe drm
	        modprobe bufferclass_ti

	        pvr_maj=\$(grep "pvrsrvkm$" /proc/devices | cut -b1,2,3)
	        bc_maj=\$(grep "bc" /proc/devices | cut -b1,2,3)

	        if [ -e /dev/pvrsrvkm ] ; then
	                rm -f /dev/pvrsrvkm
	        fi

	        mknod /dev/pvrsrvkm c \$pvr_maj 0
	        chmod 666 /dev/pvrsrvkm

	        #devmem2 0x48004B48 w 0x2 > /dev/null
	        #devmem2 0x48004B10 w 0x1 > /dev/null
	        #devmem2 0x48004B00 w 0x2 > /dev/null

	        #ES_REVISION="\$(devmem2 0x50000014 | sed -e s:0x10205:5: -e s:0x10201:3: | tail -n1 | awk -F': ' '{print \$2}')"
	        ES_REVISION="8"

	        if [ "x\${ES_REVISION}" != "x\${SAVED_ESREVISION}" ] ; then
	                echo -n "sgx: Starting SGX fixup for"
	                echo " ES\${ES_REVISION}.x"
	                cp -a /usr/lib/es\${ES_REVISION}.0/* /usr/lib
	                cp -a /usr/bin/es\${ES_REVISION}.0/* /usr/bin
	                echo "\${ES_REVISION}" > /etc/powervr-esrev
	        fi

	        /usr/bin/pvrsrvctl --start --no-module
	        ;;
	stop)
	        echo "sgx: Stopping PVR"
	        rmmod bufferclass_ti 2>/dev/null || true
	        rmmod drm 2>/dev/null || true
	        rmmod pvrsrvkm 2>/dev/null || true
	        ;;
	*)
	        echo "Usage: /etc/init.d/pvr_startup {start|stop|reload|restart|force-reload}"
	        exit 1
	        ;;
	esac

	exit 0

	__EOF__
}

file_install_sgx () {
	cat > "${DIR}/ignore/ti-sdk-pvr/pkg/install-sgx.sh" <<-__EOF__
	#!/bin/sh

	if ! id | grep -q root; then
	        echo "must be run as root"
	        exit
	fi

	DIR=\$PWD

	#ln -sf /usr/lib/libXdmcp.so.6.0.0 /usr/lib/libXdmcp.so.0
	#ln -sf /usr/lib/libXau.so.6.0.0 /usr/lib/libXau.so.0

	sudo rm -rf /opt/sgx_modules/ || true
	sudo rm -rf /opt/sgx_other/ || true
	sudo rm -rf /opt/sgx_xorg/ || true

	if [ -f ./gfx_rel_es3_armhf.tar.gz ] ; then
	        echo "Extracting gfx_rel_es3_armhf.tar.gz"
	        tar xf ./gfx_rel_es3_armhf.tar.gz -C /
	fi

	if [ -f ./gfx_rel_es5_armhf.tar.gz ] ; then
	        echo "Extracting gfx_rel_es5_armhf.tar.gz"
	        tar xf ./gfx_rel_es5_armhf.tar.gz -C /
	fi

	if [ -f ./gfx_rel_es6_armhf.tar.gz ] ; then
	        echo "Extracting gfx_rel_es6_armhf.tar.gz"
	        tar xf ./gfx_rel_es6_armhf.tar.gz -C /
	fi

	if [ -f ./gfx_rel_es8_armhf.tar.gz ] ; then
	        echo "Extracting gfx_rel_es8_armhf.tar.gz"
	        tar xf ./gfx_rel_es8_armhf.tar.gz -C /
	        cp -v /opt/sgx_xorg/es8.0/pvr_drv.so /usr/lib/xorg/modules/drivers/
	fi

	if [ -f ./gfx_rel_es9_armhf.tar.gz ] ; then
	        echo "Extracting gfx_rel_es9_armhf.tar.gz"
	        tar xf ./gfx_rel_es9_armhf.tar.gz -C /
	fi

	if [ -f /etc/powervr-esrev ] ; then
	        rm -f /etc/powervr-esrev || true
	fi

	echo "[default]" > /etc/powervr.ini
	echo "WindowSystem=libpvrPVR2D_FRONTWSEGL.so" >> /etc/powervr.ini

	touch /etc/powervr-esrev

	SAVED_ESREVISION="\$(cat /etc/powervr-esrev)"

	#devmem2 0x48004B48 w 0x2 > /dev/null
	#devmem2 0x48004B10 w 0x1 > /dev/null
	#devmem2 0x48004B00 w 0x2 > /dev/null

	#ES_REVISION="\$(devmem2 0x50000014 | sed -e s:0x10205:5: -e s:0x10201:3: | tail -n1 | awk -F': ' '{print \$2}')"
	ES_REVISION="8"

	if [ "x\${ES_REVISION}" != "x\${SAVED_ESREVISION}" ] ; then
	        echo -n "sgx: Starting SGX fixup for"
	        echo " ES\${ES_REVISION}.x"
	        cp -a /usr/lib/es\${ES_REVISION}.0/* /usr/lib
	        cp -a /usr/bin/es\${ES_REVISION}.0/* /usr/bin
	        echo "\${ES_REVISION}" > /etc/powervr-esrev
	fi

	if [ -d /lib/modules/\$(uname -r)/extra/ ] ; then
	        rm -rf /lib/modules/\$(uname -r)/extra/ || true
	fi

	#FIXME: is there a better way? A way that doesn't look like a hack...
	mkdir -p /lib/modules/\$(uname -r)/extra/
	cp -v /opt/sgx_modules/es\${ES_REVISION}.0/*.ko /lib/modules/\$(uname -r)/extra/

	grep -v -e "extra/pvrsrvkm.ko" /lib/modules/\$(uname -r)/modules.dep >/tmp/modules.tmp
	echo "/lib/modules/\$(uname -r)/extra/pvrsrvkm.ko:" >>/tmp/modules.tmp
	cp /tmp/modules.tmp /lib/modules/\$(uname -r)/modules.dep

	grep -v -e "extra/drm.ko" /lib/modules/\$(uname -r)/modules.dep >/tmp/modules.tmp
	echo "/lib/modules/\$(uname -r)/extra/drm.ko: /lib/modules/\$(uname -r)/extra/pvrsrvkm.ko" >>/tmp/modules.tmp
	cp /tmp/modules.tmp /lib/modules/\$(uname -r)/modules.dep

	#grep -v -e "extra/bufferclass_ti.ko" /lib/modules/\$(uname -r)/modules.dep >/tmp/modules.tmp
	#echo "/lib/modules/\$(uname -r)/extra/bufferclass_ti.ko: /lib/modules/\$(uname -r)/extra/pvrsrvkm.ko" >>/tmp/modules.tmp
	#cp /tmp/modules.tmp /lib/modules/\$(uname -r)/modules.dep

	depmod -a

	update-rc.d -f pvr_init remove
	if [ -f /etc/init.d/pvr_init ] ; then
	        rm -f /etc/init.d/pvr_init || true
	fi

	cp ./pvr_startup /etc/init.d/pvr_init
	chmod +x /etc/init.d/pvr_init
	update-rc.d pvr_init defaults

	echo "Done: Please reboot system"

	__EOF__

	chmod +x "${DIR}/ignore/ti-sdk-pvr/pkg/install-sgx.sh"
}

file_run_sgx () {
	cat > "${DIR}/ignore/ti-sdk-pvr/pkg/run-sgx.sh" <<-__EOF__
	#!/bin/sh

	if ! id | grep -q root; then
	        echo "must be run as root"
	        exit
	fi

	DIR=\$PWD

	if [ -f /etc/powervr-esrev ] ; then
	        rm /etc/powervr-esrev || true
	fi

	depmod -a omaplfb

	/etc/init.d/pvr_init restart

	__EOF__

	chmod +x "${DIR}/ignore/ti-sdk-pvr/pkg/run-sgx.sh"
}

mv_modules_libs_bins () {
	echo "packaging: ${CORE}.x: ${ARCH} Kernel Modules:"
	mkdir -p ./opt/sgx_modules/${CORE}.0/
	cp -v "${DIR}"/ignore/ti-sdk-pvr/Graphics_SDK/gfx_rel_${CORE}.x/*.ko ./opt/sgx_modules/${CORE}.0/ || true
	echo "-----------------------------"

	#armhf has extra pre-built kernel modules, remove...(built against v3.4.4-x1 so not usable..)
	rm -rf *.ko || true 

	mkdir -p ./opt/sgx_xorg/${CORE}.0/
	mv ./pvr_drv* ./opt/sgx_xorg/${CORE}.0/ || true
	mv ./xorg.conf ./opt/sgx_xorg/${CORE}.0/ || true

	mkdir -p ./opt/sgx_other/${CORE}.0/
	mv ./*.sh ./opt/sgx_other/${CORE}.0/ || true
	mv ./*.pvr ./opt/sgx_other/${CORE}.0/ || true

	mkdir -p ./usr/lib/${CORE}.0/
	mv ./*.so* ./usr/lib/${CORE}.0/ || true
	mv ./*.a ./usr/lib/${CORE}.0/ || true
	mv ./*.dbg ./usr/lib/${CORE}.0/ || true

	mkdir -p ./usr/bin/${CORE}.0/
	mv ./*_test ./usr/bin/${CORE}.0/ || true
	mv ./*gl* ./usr/bin/${CORE}.0/ || true
	mv ./p[dv]* ./usr/bin/${CORE}.0/ || true
}

gfx_rel_x () {
	if [ -d "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/${ARCH}/gfx_rel_${CORE}.x" ] ; then
		cd "${DIR}/ignore/ti-sdk-pvr/Graphics_SDK/${ARCH}/gfx_rel_${CORE}.x"
		mv_modules_libs_bins
		tar czf "${DIR}/ignore/ti-sdk-pvr/pkg"/gfx_rel_${CORE}_${ARCH}.tar.gz *
	else
		echo "SGX: missing gfx_rel_${CORE}.x dir, did you get the FULL release"
	fi
}

pkg_modules () {
	if [ -d "${DIR}/ignore/ti-sdk-pvr/pkg/" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/pkg" || true
	fi
	mkdir "${DIR}/ignore/ti-sdk-pvr/pkg"

	ARCH="armhf"
	CORE="es3"
	gfx_rel_x

	CORE="es5"
	gfx_rel_x

	CORE="es6"
	gfx_rel_x

	CORE="es8"
	gfx_rel_x

	CORE="es9"
	gfx_rel_x

	rm -rf gfx_* || true
	rm -rf README || true
	rm -rf *.pdf || true
}

pkg_install_script () {
	cd "${DIR}/ignore/ti-sdk-pvr/pkg"
	file_pvr_startup
	file_install_sgx
	file_run_sgx
	cd ${DIR}/
}

pkg_up () {
	cd "${DIR}/ignore/ti-sdk-pvr/pkg"
	tar czf ${DIR}/deploy/GFX_${SDK}_libs.tar.gz *
	cd ${DIR}/
}


pkg_up_examples () {
	BASE_DIR=""${DIR}"/ignore/SDK_BIN/Graphics_SDK_setuplinux_${sdk_version}"
	OGLES="GFX_Linux_SDK/OGLES/SDKPackage"
	OGLES2="GFX_Linux_SDK/OGLES2/SDKPackage"

	if [ -d "${DIR}/ignore/ti-sdk-pvr/examples/" ] ; then
		rm -rf "${DIR}/ignore/ti-sdk-pvr/examples" || true
	fi
	mkdir "${DIR}/ignore/ti-sdk-pvr/examples"


	if [ -d "${BASE_DIR}"/GFX_Linux_SDK ] ; then
		echo "Copying SDK example appications..."

		if [ -d "${BASE_DIR}"/${OGLES}/Binaries/ ] ; then
			mkdir -p "${DIR}/ignore/ti-sdk-pvr/examples/${OGLES}/Binaries/"
			cp -r "${BASE_DIR}"/${OGLES}/Binaries/ "${DIR}/ignore/ti-sdk-pvr/examples/${OGLES}/"
		fi

		if [ -d "${BASE_DIR}"/${OGLES2}/Binaries/ ] ; then
			mkdir -p "${DIR}/ignore/ti-sdk-pvr/examples/${OGLES2}/Binaries/"
			cp -r "${BASE_DIR}"/${OGLES2}/Binaries/ "${DIR}/ignore/ti-sdk-pvr/examples/${OGLES2}/"
		fi

		if [ -d "${BASE_DIR}"/GFX_Linux_SDK/ti-components/ ] ; then
			mkdir -p "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK/ti-components/"
			cp -r "${BASE_DIR}"/GFX_Linux_SDK/ti-components/ "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK/"
		fi

		echo "taring SDK example files for use on the OMAP board"

		echo "removing windows binaries"
		find "${DIR}/ignore/ti-sdk-pvr/examples" -name "*.exe" -exec rm -rf {} \;
		find "${DIR}/ignore/ti-sdk-pvr/examples" -name "*.dll" -exec rm -rf {} \;

		cd "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK"
		tar czf "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK"/OGLES.tar.gz ./OGLES
		rm -rf "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK/OGLES" || true
		tar czf "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK"/OGLES2.tar.gz ./OGLES2
		rm -rf "${DIR}/ignore/ti-sdk-pvr/examples/GFX_Linux_SDK/OGLES2" || true

		cd "${DIR}/ignore/ti-sdk-pvr/examples/"
		tar czfv ${DIR}/deploy/GFX_Linux_${SDK}_examples.tar.gz ./GFX_Linux_SDK
		echo "SGX examples are in: deploy/GFX_Linux_${SDK}_examples.tar.gz"
		cd ${DIR}

	else
		echo "SGX: missing GFX_Linux_SDK dir, did you get the FULL release"
	fi
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

#	clean_sgx_modules
#	build_sgx_modules release 3.x yes 0 all

#	clean_sgx_modules
#	build_sgx_modules release 5.x yes 0 all

#	clean_sgx_modules
#	build_sgx_modules release 6.x yes 0 all

	clean_sgx_modules
	build_sgx_modules release 8.x yes 1 all

#	clean_sgx_modules
#	build_sgx_modules release 9.x yes 0 all

	pkg_modules

	pkg_install_script

	pkg_up
	pkg_up_examples

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

