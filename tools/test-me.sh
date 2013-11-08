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

fileserver="http://rcn-ee.homeip.net:81/dl/jenkins/beagleboard.org"

if ! id | grep -q root; then
	echo "must be run as root"
	exit
fi

network_failure () {
	echo "Error: is network setup?"
	exit
}

dl_latest () {
	wget --directory-prefix="${tempdir}/dl/" ${fileserver}/latest
	if [ -f "${tempdir}/dl/latest" ] ; then
		. "${tempdir}/dl/latest"
		echo "ABI:${abi}"
		echo "Kernel:${kernel}"
	else
		network_failure
	fi

	current_kernel=`uname -r`
	if [ "x${current_kernel}" = "x${kernel}" ] ; then
		echo "You are already running the latest: [${current_kernel}]"
		echo -n "Do you wish to reinstall [${current_kernel}] anyways (y/n)? "
		read response
		if [ ! "x${response}" = "xy" ] ; then
			exit
		fi
	fi
}

validate_abi () {
	#aab: add ubuntu/debian support...
	#aac: check that its run as root...
	if [ ! "x${abi}" = "xaac" ] ; then
		echo "abi mismatch, please redownload test-me.sh from:"
		echo "http://rcn-ee.homeip.net:81/dl/jenkins/beagleboard.org/"
		echo "-----------------------------"
		echo "rm -rf ./test-me.sh"
		echo "wget http://rcn-ee.homeip.net:81/dl/jenkins/beagleboard.org/test-me.sh"
		echo "chmod +x ./test-me.sh"
		echo "-----------------------------"
		exit
	fi
}

file_download () {
	if [ -f /boot/zImage ] || [ -f /boot/uboot/zImage ]; then
		echo "Downloading: zImage"
		wget --directory-prefix="${tempdir}/dl/" ${fileserver}/${kernel}/${kernel}.zImage.xz
		if [ ! -f "${tempdir}/dl/${kernel}.zImage.xz" ] ; then
			network_failure
		fi
	fi
	if [ -f /boot/uImage ] || [ -f /boot/uboot/uImage ]; then
		echo "Downloading: uImage"
		wget --directory-prefix="${tempdir}/dl/" ${fileserver}/${kernel}/${kernel}.uImage.xz
		if [ ! -f "${tempdir}/dl/${kernel}.uImage.xz" ] ; then
			network_failure
		fi
	fi
	echo "Downloading: dtbs"
	wget --directory-prefix="${tempdir}/dl/" ${fileserver}/${kernel}/${kernel}-dtbs.tar.xz
	if [ ! -f "${tempdir}/dl/${kernel}-dtbs.tar.xz" ] ; then
		network_failure
	fi
	echo "Downloading: firmware"
	wget --directory-prefix="${tempdir}/dl/" ${fileserver}/${kernel}/${kernel}-firmware.tar.xz
	if [ ! -f "${tempdir}/dl/${kernel}-firmware.tar.xz" ] ; then
		network_failure
	fi
	echo "Downloading: modules"
	wget --directory-prefix="${tempdir}/dl/" ${fileserver}/${kernel}/${kernel}-modules.tar.xz
	if [ ! -f "${tempdir}/dl/${kernel}-modules.tar.xz" ] ; then
		network_failure
	fi
}

file_backup () {
	echo "Backing up files..."
	if [ -d "/boot/`uname -r`/" ] ; then
		rm -rf "/boot/`uname -r`/" || true
	fi
	mkdir -p /boot/`uname -r`.bak/firmware || true
	mkdir -p /boot/`uname -r`.bak/modules || true

	if [ -f /boot/zImage ] ; then
		echo "[Backing up: zImage]"
		cp -v /boot/zImage /boot/`uname -r`.bak/zImage
	fi
	if [ -f /boot/uboot/zImage ] ; then
		echo "[Backing up: zImage]"
		cp -v /boot/uboot/zImage /boot/`uname -r`.bak/zImage
	fi

	if [ -f /boot/uImage ] ; then
		echo "[Backing up: uImage]"
		cp -v /boot/uImage /boot/`uname -r`.bak/uImage
	fi
	if [ -f /boot/uboot/uImage ] ; then
		echo "[Backing up: uImage]"
		cp -v /boot/uboot/uImage /boot/`uname -r`.bak/uImage
	fi

	if [ -d /boot/uboot/dtbs/ ] ; then
		echo "[Backing up: *.dtb]"
		cp /boot/uboot/dtbs/*.dtb /boot/`uname -r`.bak/  || true
	else
		echo "[Backing up: *.dtb]"
		cp /boot/*.dtb /boot/`uname -r`.bak/  || true
	fi

	echo "[Backing up: firmware: *.dtbo]"
	cp -u /lib/firmware/*dtbo /boot/`uname -r`.bak/firmware || true
	echo "[Backing up: firmware: *.dts]"
	cp -u /lib/firmware/*dts /boot/`uname -r`.bak/firmware || true
	echo "[Backing up: modules]"
	cp -ru /lib/modules/`uname -r`/* /boot/`uname -r`.bak/modules || true
	sync
}

install_files () {
	echo "Installing files..."
	if [ -f /boot/zImage ] ; then
		echo "[Installing: zImage]"
		unxz ${tempdir}/dl/${kernel}.zImage.xz
		rm -rf /boot/zImage || true
		mv ${tempdir}/dl/${kernel}.zImage /boot/zImage
	fi
	if [ -f /boot/uboot/zImage ] ; then
		echo "[Installing: zImage]"
		unxz ${tempdir}/dl/${kernel}.zImage.xz
		rm -rf /boot/uboot/zImage || true
		mv ${tempdir}/dl/${kernel}.zImage /boot/uboot/zImage
	fi
	sync

	if [ -f /boot/uImage ] ; then
		echo "[Installing: uImage]"
		unxz ${tempdir}/dl/${kernel}.uImage.xz
		rm -rf /boot/uImage || true
		mv ${tempdir}/dl/${kernel}.uImage /boot/uImage
	fi
	if [ -f /boot/uboot/uImage ] ; then
		echo "[Installing: uImage]"
		unxz ${tempdir}/dl/${kernel}.uImage.xz
		rm -rf /boot/uImage || true
		mv ${tempdir}/dl/${kernel}.uImage /boot/uboot/uImage
	fi
	sync

	if [ -d /boot/uboot/dtbs/ ] ; then
		echo "[Installing: dtbs]"
		#This can be fat16 so add '-o' for no-same-owner
		tar xfmo ${tempdir}/dl/${kernel}-dtbs.tar.xz -C /boot/uboot/dtbs/
	else
		echo "[Installing: dtbs]"
		tar xfm ${tempdir}/dl/${kernel}-dtbs.tar.xz -C /boot/
	fi
	sync

	echo "[Installing: modules]"
	tar xfm ${tempdir}/dl/${kernel}-modules.tar.xz -C /
	sync
	echo "[Installing: firmware]"
	tar xfm ${tempdir}/dl/${kernel}-firmware.tar.xz -C ${tempdir}/dl/extract
	sync
	cp ${tempdir}/dl/extract/*.dtbo /lib/firmware/ 2>/dev/null || true
	cp ${tempdir}/dl/extract/*.dts /lib/firmware/ 2>/dev/null || true
	sync
	echo "Please reboot..."
}

workingdir="$PWD"
tempdir=$(mktemp -d)
mkdir -p ${tempdir}/dl/extract || true

dl_latest
validate_abi
file_download
file_backup
install_files

