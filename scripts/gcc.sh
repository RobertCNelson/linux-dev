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
	site="https://releases.linaro.org"
	case "${toolchain}" in
	gcc_linaro_eabi_4_8)
		#https://releases.linaro.org/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
		gcc_version="4.8"
		release="2014.04"
		toolchain_name="gcc-linaro-arm-none-eabi"
		version="14.04/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-none-eabi-"
		;;
	gcc_linaro_eabi_4_9)
		#https://releases.linaro.org/14.05/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.9-2014.05_linux.tar.xz
		gcc_version="4.9"
		release="2014.05"
		toolchain_name="gcc-linaro-arm-none-eabi"
		version="14.05/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-none-eabi-"
		;;
	gcc_linaro_gnueabi_4_6)
		#https://releases.linaro.org/12.03/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabi-2012.03-20120326_linux.tar.bz2
		release="2012.03"
		toolchain_name="gcc-linaro-arm-linux-gnueabi"
		version="12.03/components/toolchain/binaries"
		version_date="20120326"
		directory="${toolchain_name}-${release}-${version_date}_linux"
		filename="${directory}.tar.bz2"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-linux-gnueabi-"
		;;
	gcc_linaro_gnueabihf_4_7)
		#https://releases.linaro.org/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz
		gcc_version="4.7"
		release="2013.04"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		version="13.04/components/toolchain/binaries"
		version_date="20130415"
		directory="${toolchain_name}-${gcc_version}-${release}-${version_date}_linux"
		filename="${directory}.tar.xz"
		datestamp="${version_date}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_8)
		#https://releases.linaro.org/14.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux.tar.xz
		gcc_version="4.8"
		release="2014.04"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		version="14.04/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_9)
		#https://releases.linaro.org/14.05/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.9-2014.05_linux.tar.xz
		gcc_version="4.9"
		release="2014.05"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		version="14.05/components/toolchain/binaries"
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
