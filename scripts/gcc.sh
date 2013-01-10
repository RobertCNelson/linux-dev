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
source ${DIR}/version.sh

ubuntu_arm_gcc_installed () {
	unset armel_pkg
	unset armhf_pkg
	if [ $(which lsb_release) ] ; then
		distro=$(lsb_release -is)
		if [ "x${distro}" == "xUbuntu" ] ; then
			distro_release=$(lsb_release -cs)

			case "${distro_release}" in
			maverick|natty|oneiric|precise|quantal|raring)
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

arm_embedded () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	#wget https://launchpad.net/gcc-arm-embedded/4.6/4.6-2012-q4-update/+download/gcc-arm-none-eabi-4_6-2012q4-20121016.tar.bz2

	arm_embedded_dir="4.6/4.6-2012-q4-update"
	arm_embedded_ver="4_6-2012q4"
	arm_embedded_date="20121016"
	ARM_EMBEDDED_GCC="gcc-arm-none-eabi-${arm_embedded_ver}-${arm_embedded_date}.tar.bz2"
	if [ ! -f ${DIR}/dl/${arm_embedded_date} ] ; then
		echo "Installing gcc-arm-embedded toolchain"
		echo "-----------------------------"
		${WGET} https://launchpad.net/gcc-arm-embedded/${arm_embedded_dir}/+download/${ARM_EMBEDDED_GCC}
		touch ${DIR}/dl/${arm_embedded_date}
		if [ -d ${DIR}/dl/gcc-arm-none-eabi-${arm_embedded_ver}/ ] ; then
			rm -rf ${DIR}/dl/gcc-arm-none-eabi-${arm_embedded_ver}/ || true
		fi
		tar xjf ${DIR}/dl/${ARM_EMBEDDED_GCC} -C ${DIR}/dl/
	fi

	ARM_NONE_CC="${DIR}/dl/gcc-arm-none-eabi-${arm_embedded_ver}/bin/arm-none-eabi-"
}

armv7_toolchain () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	#https://launchpad.net/linaro-toolchain-binaries/+download
	#https://launchpad.net/linaro-toolchain-binaries/trunk/2012.04/+download/gcc-linaro-arm-linux-gnueabi-2012.04-20120426_linux.tar.bz2

	armv7_ver="2012.04"
	armv7_date="20120426"
	ARMV7_GCC="gcc-linaro-arm-linux-gnueabi-${armv7_ver}-${armv7_date}_linux.tar.bz2"
	if [ ! -f ${DIR}/dl/${armv7_date} ] ; then
		echo "Installing gcc-arm toolchain"
		echo "-----------------------------"
		${WGET} https://launchpad.net/linaro-toolchain-binaries/trunk/${armv7_ver}/+download/${ARMV7_GCC}
		touch ${DIR}/dl/${armv7_date}
		if [ -d ${DIR}/dl/gcc-linaro-arm-linux-gnueabi-${armv7_ver}-${armv7_date}_linux/ ] ; then
			rm -rf ${DIR}/dl/gcc-linaro-arm-linux-gnueabi-${armv7_ver}-${armv7_date}_linux/ || true
		fi
		tar xjf ${DIR}/dl/${ARMV7_GCC} -C ${DIR}/dl/
	fi

	if [ "x${ARCH}" == "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${DIR}/dl/gcc-linaro-arm-linux-gnueabi-${armv7_ver}-${armv7_date}_linux/bin/arm-linux-gnueabi-"
	fi
}

armv7hf_toolchain () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	#https://launchpad.net/linaro-toolchain-binaries/+download
	#https://launchpad.net/linaro-toolchain-binaries/trunk/2012.11/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2012.11-20121123_linux.tar.bz2

	armv7hf_ver="2012.11"
	armv7hf_date="20121123"
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
		if [ "x${DEBARCH}" == "xarmel" ] ; then
			armv7_toolchain
		fi
		if [ "x${DEBARCH}" == "xarmhf" ] ; then
			armv7hf_toolchain
		fi
	fi
fi

if [ "${IMX_BOOTLETS}" ] && [ "x${ARCH}" != "xarmv7l" ] ; then
	arm_embedded
fi

GCC="gcc"
if [ "x${GCC_OVERRIDE}" != "x" ] ; then
	GCC="${GCC_OVERRIDE}"
fi

GCC_TEST=$(LC_ALL=C ${CC}${GCC} -v 2>&1 | grep "Target:" | grep arm || true)
GCC_REPORT=$(LC_ALL=C ${CC}${GCC} -v 2>&1 || true)

if [ "x${GCC_TEST}" == "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC ARM Cross Compiler you setup in system.sh (CC variable)."
	echo "Doesn't seem to be valid for ARM, double check it's location, or that"
	echo "you chose the correct GCC Cross Compiler."
	echo ""
	echo "Output of: LC_ALL=C ${CC}${GCC} --version"
	echo "-----------------------------"
	echo "${GCC_REPORT}"
	echo "-----------------------------"
	exit 1
else
	echo "-----------------------------"
	echo "scripts/gcc: Debug Using: `LC_ALL=C ${CC}${GCC} --version`"
	if [ "${IMX_BOOTLETS}" ] ; then
		echo "-----------------------------"
		echo "scripts/gcc: imx-bootlets Using: `LC_ALL=C ${ARM_NONE_CC}${GCC} --version`"
	fi
	echo "-----------------------------"
	echo "CC=${CC}" > ${DIR}/.CC
	if [ "${IMX_BOOTLETS}" ] ; then
		echo "ARM_NONE_CC=${ARM_NONE_CC}" >> ${DIR}/.CC
	fi
fi
