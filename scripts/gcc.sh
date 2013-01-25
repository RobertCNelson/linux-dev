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

ARCH=$(uname -m)
DIR=$PWD

source ${DIR}/system.sh

ubuntu_arm_gcc_installed () {
	unset armel_pkg
	unset armhf_pkg
	if [ $(which lsb_release) ] ; then
		distro=$(lsb_release -is)
		if [ "x${distro}" == "xUbuntu" ] ; then
			distro_release=$(lsb_release -cs)

			case "${distro_release}" in
			oneiric|precise|quantal|raring)
				#http://packages.ubuntu.com/raring/gcc-arm-linux-gnueabi
				armel_pkg="gcc-arm-linux-gnueabi"
				;;
			esac

			case "${distro_release}" in
			oneiric|precise|quantal|raring)
				#http://packages.ubuntu.com/raring/gcc-arm-linux-gnueabihf
				armhf_pkg="gcc-arm-linux-gnueabihf"
				;;
			esac

			if [ "${armel_pkg}" ] || [ "${armhf_pkg}" ] ; then
				echo "fyi: ${distro} ${distro_release} has these ARM gcc cross compilers available in their repo:"
				if [ "${armel_pkg}" ] ; then
					echo "sudo apt-get install ${armel_pkg}"
				fi
				if [ "${armhf_pkg}" ] ; then
					echo "sudo apt-get install ${armhf_pkg}"
				fi
				echo "-----------------------------"
			fi
		fi
	fi

	if [ "${armel_pkg}" ] || [ "${armhf_pkg}" ] ; then
		if [ $(which arm-linux-gnueabi-gcc) ] ; then
			armel_gcc_test=$(LC_ALL=C arm-linux-gnueabi-gcc -v 2>&1 | grep "Target:" | grep arm || true)
		fi
		if [ $(which arm-linux-gnueabihf-gcc) ] ; then
			armhf_gcc_test=$(LC_ALL=C arm-linux-gnueabihf-gcc -v 2>&1 | grep "Target:" | grep arm || true)
		fi

		if [ "x${armel_gcc_test}" != "x" ] ; then
			CC="arm-linux-gnueabi-"
		fi
		if [ "x${armhf_gcc_test}" != "x" ] ; then
			CC="arm-linux-gnueabihf-"
		fi
	fi
}

armv7_toolchain () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	#https://launchpad.net/linaro-toolchain-binaries/+download
	#https://launchpad.net/linaro-toolchain-binaries/trunk/2012.12/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2012.12-20121214_linux.tar.bz2

	armv7hf_ver="2012.12"
	armv7hf_date="20121214"
	armv7hf_gcc="gcc-linaro-arm-linux-gnueabihf-4.7-${armv7hf_ver}-${armv7hf_date}_linux.tar.bz2"
	if [ ! -f ${DIR}/dl/${armv7hf_date} ] ; then
		echo "Installing gcc-arm toolchain"
		echo "-----------------------------"
		${WGET} https://launchpad.net/linaro-toolchain-binaries/trunk/${armv7hf_ver}/+download/${armv7hf_gcc}
		touch ${DIR}/dl/${armv7hf_date}
		if [ -d ${DIR}/dl/gcc-linaro-arm-linux-gnueabihf-4.7-${armv7hf_ver}-${armv7hf_date}_linux/ ] ; then
			rm -rf ${DIR}/dl/gcc-linaro-arm-linux-gnueabihf-4.7-${armv7hf_ver}-${armv7hf_date}_linux/ || true
		fi
		tar xjf ${DIR}/dl/${armv7hf_gcc} -C ${DIR}/dl/
	fi

	if [ "x${ARCH}" == "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${DIR}/dl/gcc-linaro-arm-linux-gnueabihf-4.7-${armv7hf_ver}-${armv7hf_date}_linux/bin/arm-linux-gnueabihf-"
	fi
}

if [ "x${CC}" == "x" ] && [ "x${ARCH}" != "xarmv7l" ] ; then
	ubuntu_arm_gcc_installed
	if [ "x${CC}" == "x" ] ; then
		armv7_toolchain
	fi
fi

GCC_TEST=$(LC_ALL=C ${CC}gcc -v 2>&1 | grep "Target:" | grep arm || true)

if [ "x${GCC_TEST}" == "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC ARM Cross Compiler you setup in system.sh (CC variable) is invalid."
	echo "-----------------------------"
	armv7_toolchain
fi

echo "-----------------------------"
echo "scripts/gcc: Debug Using: `LC_ALL=C ${CC}gcc --version`"
echo "-----------------------------"
echo "CC=${CC}" > ${DIR}/.CC
