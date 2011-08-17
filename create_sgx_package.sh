#!/bin/bash -e
#SGX Modules

unset DIR

DIR=$PWD

if [ $(uname -m) == "armv7l" ] ; then
  echo "ERROR: This script can only be run on an x86 system. (TI *.bin is an x86 executable)"
  exit
fi

# Check if the host is X86_64
PLATFORM=$(uname -m 2>/dev/null)
if [ "$PLATFORM" == "x86_64" ]; then
  IA32=$(file /usr/share/lintian/overrides/ia32-libs | grep -v ERROR 2> /dev/null)
  if test "-$IA32-" = "--"
  then
    echo "Missing ia32-libs"
    sudo apt-get -y install ia32-libs
  fi
fi

SGX_VERSION=4_04_00_02
SGX_BIN_NAME="Graphics_SDK_setuplinux"

SGX_BIN=${SGX_BIN_NAME}_${SGX_VERSION}.bin

sudo rm -rf ${DIR}/SDK/ || true
mkdir -p ${DIR}/SDK/
mkdir -p ${DIR}/SDK_BIN/

function sgx_setup {
if [ -e ${DIR}/${SGX_BIN} ]; then
  echo "${SGX_BIN} found"
  if [ -e  ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/Makefile ]; then
    echo "Extracted ${SGX_BIN} found"
    echo ""
  else
    echo "${SGX_BIN} needs to be executable"
    echo ""
    sudo chmod +x ${DIR}/${SGX_BIN}
    echo "running ${SGX_BIN}"
    echo ""
    ${DIR}/${SGX_BIN} --mode console --prefix ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION} <<setupSDK
Y
 qY
setupSDK
    cd ${DIR}
  fi
else
	wget -c --directory-prefix=${DIR} --no-check-certificate http://software-dl.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/gfxsdk/${SGX_VERSION}//exports/${SGX_BIN_NAME}_${SGX_VERSION}.bin

	if [ -e ${DIR}/${SGX_BIN} ]; then
	  echo "${SGX_BIN} found"
	else
	  echo "${SGX_BIN} still missing, wget error?"
	  exit
	fi

	sgx_setup
fi
}

function file-pvr-startup {

cat > ${DIR}/SDK/libs/opt/pvr <<pvrscript
#!/bin/sh

if [ "\$1" = "" ]; then
	echo PVR-INIT: Please use start, stop, or restart.
	exit 1
fi

if [ "\$1" = "stop" -o  "\$1" = "restart" ]; then
	echo Stopping PVR
	rmmod bufferclass_ti 2>/dev/null
	rmmod omaplfb 2>/dev/null
	rmmod pvrsrvkm 2>/dev/null
fi

if [ "\$1" = "stop" ]; then
	exit 0
fi

echo Starting PVR
modprobe omaplfb
modprobe bufferclass_ti

pvr_maj=\$(grep "pvrsrvkm$" /proc/devices | cut -b1,2,3)
bc_maj=\$(grep "bc" /proc/devices | cut -b1,2,3)

if [ -e /dev/pvrsrvkm ] ; then
	rm -f /dev/pvrsrvkm
fi

mknod /dev/pvrsrvkm c \$pvr_maj 0
chmod 666 /dev/pvrsrvkm

touch /etc/powervr-esrev

SAVED_ESREVISION="\$(cat /etc/powervr-esrev)"

devmem2 0x48004B48 w 0x2 > /dev/null
devmem2 0x48004B10 w 0x1 > /dev/null
devmem2 0x48004B00 w 0x2 > /dev/null

ES_REVISION="\$(devmem2 0x50000014 | sed -e s:0x10205:5: -e s:0x10201:3: -e s:0x10003:2: | tail -n1 | awk -F': ' '{print \$2}')"

if [ "\${ES_REVISION}" != "\${SAVED_ESREVISION}" ] ; then

	echo -n "Starting SGX fixup for"
	echo " ES\${ES_REVISION}.x"
	cp -a /usr/lib/ES\${ES_REVISION}.0/* /usr/lib
	cp -a /usr/bin/ES\${ES_REVISION}.0/* /usr/bin
	echo "\${ES_REVISION}" > /etc/powervr-esrev
fi

/usr/bin/pvrsrvinit

pvrscript

}

function file-install-SGX {

cat > ${DIR}/SDK/install-SGX.sh <<installSGX
#!/bin/bash

DIR=\$PWD

if [ \$(uname -m) == "armv7l" ] ; then

 if [ -e  \${DIR}/target_libs.tar.gz ]; then

  sudo ln -sf /usr/lib/libXdmcp.so.6.0.0 /usr/lib/libXdmcp.so.0
  sudo ln -sf /usr/lib/libXau.so.6.0.0 /usr/lib/libXau.so.0

  echo "Extracting target files to rootfs"
  sudo tar xf target_libs.tar.gz -C /

  if which lsb_release >/dev/null 2>&1 && [ "\$(lsb_release -is)" = Ubuntu ]; then

    if [ ! \$(which devmem2) ];then
        if ls /devmem2*_armel.deb >/dev/null 2>&1;then
          sudo dpkg -i /devmem2*_armel.deb
        fi
    fi

    if ls /devmem2*_armel.deb >/dev/null 2>&1;then
        sudo rm -f /devmem2*_armel.deb
    fi

    if [ \$(lsb_release -sc) == "jaunty" ]; then
      sudo cp /opt/pvr /etc/rcS.d/S60pvr.sh
      sudo chmod +x /etc/rcS.d/S60pvr.sh
    else
      #karmic/lucid/maverick/natty etc
      sudo cp /opt/pvr /etc/init.d/pvr
      sudo chmod +x /etc/init.d/pvr
      sudo update-rc.d pvr defaults
    fi

  else

    sudo cp /opt/pvr /etc/init.d/pvr
    sudo chmod +x /etc/init.d/pvr
    sudo update-rc.d pvr defaults

  fi

 else
  echo "target_libs.tar.gz is missing"
  exit
 fi

else
 echo "This script is to be run on an armv7 platform"
 exit
fi

installSGX

}

function file-run-SGX {

cat > ${DIR}/SDK/run-SGX.sh <<runSGX
#!/bin/bash

DIR=\$PWD

if [ \$(uname -m) == "armv7l" ] ; then

 sudo rm /etc/powervr-esrev
 sudo depmod -a omaplfb

 if which lsb_release >/dev/null 2>&1 && [ "\$(lsb_release -is)" = Ubuntu ]; then
  if [ \$(lsb_release -sc) == "jaunty" ]; then
   sudo /etc/rcS.d/S60pvr.sh restart
  else
   sudo /etc/init.d/pvr restart
  fi
 else
  sudo /etc/init.d/pvr restart
 fi

else
 echo "This script is to be run on an armv7 platform"
 exit
fi

runSGX

}

function copy_sgx_system_files {
	sudo rm -rf ${DIR}/SDK/
	mkdir -p ${DIR}/SDK/libs/usr/lib/ES2.0
	mkdir -p ${DIR}/SDK/libs/usr/bin/ES2.0
	mkdir -p ${DIR}/SDK/libs/usr/lib/ES3.0
	mkdir -p ${DIR}/SDK/libs/usr/bin/ES3.0
	mkdir -p ${DIR}/SDK/libs/usr/lib/ES5.0
	mkdir -p ${DIR}/SDK/libs/usr/bin/ES5.0
	mkdir -p ${DIR}/SDK/libs/usr/lib/ES6.0
	mkdir -p ${DIR}/SDK/libs/usr/bin/ES6.0

	mkdir -p ${DIR}/SDK/libs/usr/lib/ES7.0
	mkdir -p ${DIR}/SDK/libs/usr/bin/ES7.0

	mkdir -p ${DIR}/SDK/libs/opt/

	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es2.x/lib* ${DIR}/SDK/libs/usr/lib/ES2.0
	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es2.x/p[dv]* ${DIR}/SDK/libs/usr/bin/ES2.0

	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es3.x/lib* ${DIR}/SDK/libs/usr/lib/ES3.0
	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es3.x/p[dv]* ${DIR}/SDK/libs/usr/bin/ES3.0

	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es5.x/lib* ${DIR}/SDK/libs/usr/lib/ES5.0
	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es5.x/p[dv]* ${DIR}/SDK/libs/usr/bin/ES5.0

	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es6.x/lib* ${DIR}/SDK/libs/usr/lib/ES6.0
	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es6.x/p[dv]* ${DIR}/SDK/libs/usr/bin/ES6.0

	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es7.x/lib* ${DIR}/SDK/libs/usr/lib/ES7.0
	sudo cp ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/gfx_rel_es7.x/p[dv]* ${DIR}/SDK/libs/usr/bin/ES7.0

file-pvr-startup

	cd ${DIR}/SDK/libs

	#download devmem2
	rm -f /tmp/index.html || true
	wget --directory-prefix=/tmp http://ports.ubuntu.com/pool/universe/d/devmem2/
	DEVMEM2=$(cat /tmp/index.html | grep _armel.deb | head -1 | awk -F"\"" '{print $8}')
	wget -c http://ports.ubuntu.com/pool/universe/d/devmem2/${DEVMEM2}

	tar czf ${DIR}/SDK/target_libs.tar.gz *
	cd ${DIR}
	sudo rm -rf ${DIR}/SDK/libs || true

file-install-SGX
	chmod +x ./SDK/install-SGX.sh
file-run-SGX
	chmod +x ./SDK/run-SGX.sh

	cd ${DIR}/SDK
	tar czf ${DIR}/GFX_${SGX_VERSION}_libs.tar.gz *
	cd ${DIR}

	sudo rm -rf ${DIR}/SDK/ || true
	echo "SGX libs are in: GFX_${SGX_VERSION}_libs.tar.gz"
}

function tar_up_examples {
	cd ${DIR}
	mkdir -p ${DIR}/SDK/
	cp -r ${DIR}/SDK_BIN/${SGX_BIN_NAME}_${SGX_VERSION}/GFX_Linux_SDK ${DIR}/SDK/
	echo ""
	echo "taring SDK example files for use on the OMAP board"

	echo "removing windows binaries"
	find ${DIR}/SDK/ -name "*.exe" -exec rm -rf {} \;
	find ${DIR}/SDK/ -name "*.dll" -exec rm -rf {} \;
	find ${DIR}/SDK/ -type d -name "Win32" | xargs rm -r
	find ${DIR}/SDK/ -type d -name "MacOS" | xargs rm -r

	cd ${DIR}/SDK/GFX_Linux_SDK
	tar czf ${DIR}/SDK/GFX_Linux_SDK/OGLES.tar.gz ./OGLES
	rm -rf ${DIR}/SDK/GFX_Linux_SDK/OGLES
	tar czf ${DIR}/SDK/GFX_Linux_SDK/OGLES2.tar.gz ./OGLES2
	rm -rf ${DIR}/SDK/GFX_Linux_SDK/OGLES2
	tar czf ${DIR}/SDK/GFX_Linux_SDK/OVG.tar.gz ./OVG
	rm -rf ${DIR}/SDK/GFX_Linux_SDK/OVG

	cd ${DIR}/SDK
	tar czfv ${DIR}/GFX_Linux_SDK.tar.gz ./GFX_Linux_SDK
	echo "SGX examples are in: GFX_Linux_SDK.tar.gz"
	cd ${DIR}
}

 sgx_setup
 copy_sgx_system_files
 tar_up_examples

