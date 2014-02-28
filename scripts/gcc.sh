#!/bin/sh -e
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/system.sh

#For:
#toolchain
. ${DIR}/version.sh

dl_gcc_generic () {
	WGET="wget -c --directory-prefix=${DIR}/dl/"
	if [ ! -f ${DIR}/dl/${directory}/${datestamp} ] ; then
		echo "Installing: ${toolchain_name}"
		echo "-----------------------------"
		${WGET} ${site}/${version}/${filename}
		if [ -d ${DIR}/dl/${directory} ] ; then
			rm -rf ${DIR}/dl/${directory} || true
		fi
		tar -xf ${DIR}/dl/${filename} -C ${DIR}/dl/
		if [ -f ${DIR}/dl/${directory}/${binary}gcc ] ; then
			touch ${DIR}/dl/${directory}/${datestamp}
		fi
	fi

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${DIR}/dl/${directory}/${binary}"
	fi
}

gcc_toolchain () {
	case "${toolchain}" in
	arm9_gcc_4_7)
		#https://launchpad.net/gcc-arm-embedded/+download
		#https://launchpad.net/gcc-arm-embedded/4.7/4.7-2013-q3-update/+download/gcc-arm-none-eabi-4_7-2013q3-20130916-linux.tar.bz2

		toolchain_name="gcc-arm-none-eabi"
		site="https://launchpad.net/gcc-arm-embedded"
		version="4.7/4.7-2013-q3-update/+download"
		version_date="20130916"
		directory="${toolchain_name}-4_7-2013q3"
		filename="${directory}-${version_date}-linux.tar.bz2"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-none-eabi-"
		;;
	gcc_arm_embedded_4_8)
		#https://launchpad.net/gcc-arm-embedded/+download
		#https://launchpad.net/gcc-arm-embedded/4.8/4.8-2013-q4-major/+download/gcc-arm-none-eabi-4_8-2013q4-20131204-linux.tar.bz2

		toolchain_name="gcc-arm-none-eabi"
		site="https://launchpad.net/gcc-arm-embedded"
		version="4.8/4.8-2013-q4-major/+download"
		version_date="20131204"
		directory="${toolchain_name}-4_8-2013q4"
		filename="${directory}-${version_date}-linux.tar.bz2"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-none-eabi-"
		;;
	cortex_gcc_4_6)
		#https://launchpad.net/linaro-toolchain-binaries/+download
		#https://launchpad.net/linaro-toolchain-binaries/trunk/2012.03/+download/gcc-linaro-arm-linux-gnueabi-2012.03-20120326_linux.tar.bz2

		release="2012.03"
		toolchain_name="gcc-linaro-arm-linux-gnueabi"
		site="https://launchpad.net/linaro-toolchain-binaries"
		version="trunk/${release}/+download"
		version_date="20120326"
		directory="${toolchain_name}-${release}-${version_date}_linux"
		filename="${directory}.tar.bz2"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-linux-gnueabi-"
		;;
	cortex_gcc_4_7)
		#https://launchpad.net/linaro-toolchain-binaries/+download
		#https://launchpad.net/linaro-toolchain-binaries/trunk/2013.04/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz

		gcc_version="4.7"
		release="2013.04"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		site="https://launchpad.net/linaro-toolchain-binaries"
		version="trunk/${release}/+download"
		version_date="20130415"
		directory="${toolchain_name}-${gcc_version}-${release}-${version_date}_linux"
		filename="${directory}.tar.xz"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	cortex_gcc_4_8)
		#https://launchpad.net/linaro-toolchain-binaries/+download
		#https://launchpad.net/linaro-toolchain-binaries/trunk/2013.10/+download/gcc-linaro-arm-linux-gnueabihf-4.8-2013.10_linux.tar.xz

		gcc_version="4.8"
		release="2013.10"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		site="https://launchpad.net/linaro-toolchain-binaries"
		version="trunk/${release}/+download"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_8)
		#https://releases.linaro.org/14.02/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.8-2014.02_linux.tar.xz
		gcc_version="4.8"
		release="2014.02"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		site="https://releases.linaro.org"
		version="14.02/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	*)
		echo "bug: maintainer forgot to set:"
		echo "toolchain=\"xzy\" in version.sh"
		exit 1
		;;
	esac

	dl_gcc_generic
}

if [ "x${CC}" = "x" ] && [ "x${ARCH}" != "xarmv7l" ] ; then
	gcc_toolchain
fi

GCC_TEST=$(LC_ALL=C ${CC}gcc -v 2>&1 | grep "Target:" | grep arm || true)

if [ "x${GCC_TEST}" = "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC ARM Cross Compiler you setup in system.sh (CC variable) is invalid."
	echo "-----------------------------"
	gcc_toolchain
fi

echo "-----------------------------"
echo "scripts/gcc: Using: `LC_ALL=C ${CC}gcc --version`"
echo "-----------------------------"
echo "CC=${CC}" > ${DIR}/.CC
