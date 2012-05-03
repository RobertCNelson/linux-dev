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

VERSION="v2012.02-1"

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
 echo ""
 echo "Note: on the x86_64 platform, this script needs (ia32-libs)..."
 echo "--------------------------------------------------------------"
 echo ""
fi

cd ${DIR}
}

ti_DSP_binaries () {

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

file_DSP_startup () {

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

file_install_DSP () {

cat > ${DIR}/DSP/install-DSP.sh <<installDSP
#!/bin/bash

DIR=\$PWD

if [ \$(uname -m) == "armv7l" ] ; then

 if [ -e \${DIR}/dsp_libs.tar.gz ]; then

  echo "Extracting target files to rootfs"
  sudo tar xf dsp_libs.tar.gz -C /

  if which lsb_release >/dev/null 2>&1 && [ "\$(lsb_release -is)" = Ubuntu ]; then

    if [ \$(lsb_release -sc) == "jaunty" ]; then
      sudo cp /opt/dsp /etc/rcS.d/S61dsp.sh
      sudo chmod +x /etc/rcS.d/S61dsp.sh
    else
      #karmic/lucid/maverick/etc
      sudo update-rc.d -f dsp remove
      if [ -f /etc/init.d/dsp ] ; then
        sudo rm -f /etc/init.d/dsp || true
      fi
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

file_install_gst_dsp () {

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

if [ ! -f \${DIR}/git/gst-dsp/.git/config ] ; then
 cd \${DIR}/git/
 git clone git://github.com/felipec/gst-dsp.git
fi

cd \${DIR}/git/gst-dsp
make clean
git pull

echo ""
./configure

echo ""
echo "Building gst-dsp"
make CROSS_COMPILE= 
sudo make install

cd \${DIR}/

if [ ! -f \${DIR}/git/gst-omapfb/.git/config ] ; then
 cd \${DIR}/git/
 git clone git://github.com/felipec/gst-omapfb.git
fi

cd \${DIR}/git/gst-omapfb
make clean
git pull

echo ""
echo "Building gst-omapfb"
make CROSS_COMPILE= 
sudo make install

cd \${DIR}/

if [ ! -f \${DIR}/git/dsp-tools/.git/config ] ; then
 cd \${DIR}/git/
 git clone git://github.com/felipec/dsp-tools.git
fi

cd \${DIR}/git/dsp-tools
make clean
git checkout master -f
git pull

echo "fetching test.dll64P firmware"
git branch -D firmware-tmp || true
git checkout origin/firmware -b firmware-tmp
sudo cp -v firmware/test.dll64P /lib/dsp/
git checkout master -f
git branch -D firmware-tmp || true

echo ""
echo "Building dsp-tools"
make CROSS_COMPILE= 
sudo make install

cd \${DIR}/

else
 echo "This script is to be run on an armv7 platform"
 exit
fi

installgst

}

create_DSP_package () {
	cd ${DIR}
	sudo rm -rf ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/lib/dsp
	mkdir -p ${DIR}/DSP/opt/

 if [ -f ${DIR}/dl/TI_DSP_${TI_DSP_BIN}/binaries/baseimage.dof ] ; then
  sudo cp -v ${DIR}/dl/TI_DSP_${TI_DSP_BIN}/binaries/* ${DIR}/DSP/lib/dsp
 else
  echo "--------------------------------------------------------------"
  echo "Script, failure, DSP bin was not extracted, do you have i32-libs installed?"
  echo "--------------------------------------------------------------"
  echo ""
  exit
 fi

file_DSP_startup

	cd ${DIR}/DSP/
	tar czf ${DIR}/dsp_libs.tar.gz *
	cd ${DIR}

	sudo rm -rf ${DIR}/DSP/
	mkdir -p ${DIR}/DSP/

	mv ${DIR}/dsp_libs.tar.gz ${DIR}/DSP/

file_install_DSP
	chmod +x ./DSP/install-DSP.sh

file_install_gst_dsp
	chmod +x ./DSP/install-gst-dsp.sh

	cd ${DIR}/DSP
	tar cvzf ${DIR}/DSP_Install_libs.tar.gz *
	cd ${DIR}

	sudo rm -rf ${DIR}/DSP/
	cd ${DIR}
}


libstd_dependicy
ti_DSP_binaries

create_DSP_package

echo ""
echo "Script Version ${VERSION}"
echo "Email Bugs: bugs@rcn-ee.com"
echo "-----------------------------"
echo ""
echo "Script Complete: Copy DSP_Install_libs.tar.gz to target device."
echo ""

