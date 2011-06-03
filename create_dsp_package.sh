#!/bin/bash -e
#Based on: http://omappedia.org/wiki/DSPBridge_Project#Build_Userspace_Files
unset BUILD
unset CC
DIR=$PWD

if [ $(uname -m) == "armv7l" ] ; then
  echo "ERROR: This script can only be run on an x86 system. (TI *.bin is an x86 executable)"
  exit
fi

TI_DSP_BIN=TI_DSPbinaries_RLS23.i3.8-3.12
TI_DSP_DIR=352/3680

DL_DIR=${DIR}/dl

mkdir -p ${DL_DIR}

function libstd_dependicy {
DIST=$(lsb_release -sc)

if [ $(uname -m) == "x86_64" ] ; then
	LIBSTD=$(file /usr/lib32/libstdc++.so.5 | grep -v ERROR | awk '{print $1}')
	if [ "-$LIBSTD-" = "--" ] ; then
		sudo apt-get install -y ia32-libs
	fi
else
	LIBSTD=$(file /usr/lib/libstdc++.so.5 | grep -v ERROR | awk '{print $1}')
	if [ "-$LIBSTD-" = "--" ] ; then
		sudo apt-get install libstdc++5
	fi
fi
cd ${DIR}
}

function ti_DSP_binaries {

if [ -e ${DIR}/dl/${TI_DSP_BIN}-Linux-x86-Install ]; then
  echo "DSPbinaries-${TI_DSP_BIN}-Linux-x86-Install found..."
  if [ -e  ${DIR}/dl/TI_DSP_${TI_DSP_BIN}/Binaries/baseimage.dof ]; then
    echo "Installed ${TI_DSP_BIN}-Linux-x86-Install found..."
  else
    cd ${DIR}/dl/
    echo "Setting permissions ${TI_DSP_BIN}-Linux-x86-Install needs to be executable..."
    sudo chmod +x ${DIR}/dl/${TI_DSP_BIN}-Linux-x86-Install
    ${DIR}/dl/${TI_DSP_BIN}-Linux-x86-Install --mode console --prefix ${DIR}/dl/TI_DSP_${TI_DSP_BIN}/ <<setupDSP
Y
setupDSP

    cd ${DIR}
  fi
else
  wget -c --directory-prefix=${DL_DIR} --no-check-certificate https://gforge.ti.com/gf/download/frsrelease/${TI_DSP_DIR}/${TI_DSP_BIN}-Linux-x86-Install
  ti_DSP_binaries
fi

}

function file-DSP-startup {

cat > ${DIR}/DSP/opt/dsp <<dspscript
#!/bin/sh

case "\$1" in
	start)
		modprobe mailbox_mach
		modprobe bridgedriver base_img=/lib/dsp/baseimage.dof
		;;
esac

dspscript

}

function file-install-DSP {

cat > ${DIR}/DSP/install-DSP.sh <<installDSP
#!/bin/bash

DIR=\$PWD

if [ \$(uname -m) == "armv7l" ] ; then

 if [ -e  \${DIR}/dsp_libs.tar.gz ]; then

  echo "Extracting target files to rootfs"
  sudo tar xf dsp_libs.tar.gz -C /

  if which lsb_release >/dev/null 2>&1 && [ "\$(lsb_release -is)" = Ubuntu ]; then

    if [ \$(lsb_release -sc) == "jaunty" ]; then
      sudo cp /opt/dsp /etc/rcS.d/S61dsp.sh
      sudo chmod +x /etc/rcS.d/S61dsp.sh
    else
      #karmic/lucid/maverick/etc
      sudo cp /opt/dsp /etc/init.d/dsp
      sudo chmod +x /etc/init.d/dsp
      sudo update-rc.d dsp defaults
    fi

  else

    sudo cp /opt/dsp /etc/init.d/dsp
    sudo chmod +x /etc/init.d/dsp
    sudo update-rc.d dsp defaults

  fi

 else
  echo "dsp_libs.tar.gz is missing"
  exit
 fi

else
 echo "This script is to be run on an armv7 platform"
 exit
fi

installDSP

}

function file-install-gst-dsp {

cat > ${DIR}/DSP/install-gst-dsp.sh <<installgst
#!/bin/bash

DIR=\$PWD

function no_connection {

echo "setup internet connection before running.."
exit

}

if [ \$(uname -m) == "armv7l" ] ; then

ping -c 1 -w 100 www.google.com  | grep "ttl=" || no_connection

sudo apt-get -y install git-core pkg-config build-essential gstreamer-tools libgstreamer0.10-dev

mkdir -p \${DIR}/git/

if ! ls \${DIR}/git/gst-dsp >/dev/null 2>&1;then
cd \${DIR}/git/
git clone git://github.com/felipec/gst-dsp.git
fi

cd \${DIR}/git/gst-dsp
make clean
git pull
make CROSS_COMPILE= 
sudo make install
cd \${DIR}/

if ! ls \${DIR}/git/gst-omapfb >/dev/null 2>&1;then
cd \${DIR}/git/
git clone git://github.com/felipec/gst-omapfb.git
fi

cd \${DIR}/git/gst-omapfb
make clean
git pull
make CROSS_COMPILE= 
sudo make install
cd \${DIR}/

if ! ls \${DIR}/git/dsp-tools >/dev/null 2>&1;then
cd \${DIR}/git/
git clone git://github.com/felipec/dsp-tools.git
fi

cd \${DIR}/git/dsp-tools
make clean
git checkout master -f
git pull
git branch -D firmware-tmp || true
git checkout origin/firmware -b firmware-tmp
sudo cp -v firmware/test.dll64P /lib/dsp/
git checkout master -f
git branch -D firmware-tmp || true
make CROSS_COMPILE= 
sudo make install
cd \${DIR}/

else
 echo "This script is to be run on an armv7 platform"
 exit
fi

installgst

}

function create_DSP_package {
	cd ${DIR}
	sudo rm -rfd ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/lib/dsp
	mkdir -p ${DIR}/DSP/opt/

	sudo cp -v ${DIR}/dl/TI_DSP_${TI_DSP_BIN}/binaries/* ${DIR}/DSP/lib/dsp

file-DSP-startup

	cd ${DIR}/DSP/
	tar czf ${DIR}/dsp_libs.tar.gz *
	cd ${DIR}

	sudo rm -rfd ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/

	mv ${DIR}/dsp_libs.tar.gz ${DIR}/DSP/

file-install-DSP
	chmod +x ./DSP/install-DSP.sh

file-install-gst-dsp
	chmod +x ./DSP/install-gst-dsp.sh

	cd ${DIR}/DSP
	tar czf ${DIR}/DSP_Install_libs.tar.gz *
	cd ${DIR}

	sudo rm -rfd ${DIR}/DSP/
	cd ${DIR}
}


libstd_dependicy
ti_DSP_binaries

create_DSP_package

