#!/bin/sh -e
#
# Copyright (c) 2009-2019 Robert Nelson <robertcnelson@gmail.com>
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

. "${DIR}/system.sh"

#For:
#toolchain
. "${DIR}/version.sh"

if [  -f "${DIR}/.yakbuild" ] ; then
	. "${DIR}/recipe.sh"
fi

if [ -d $HOME/dl/gcc/ ] ; then
	gcc_dir="$HOME/dl/gcc"
else
	gcc_dir="${DIR}/dl"
fi

dl_gcc_generic () {
	WGET="wget -c --directory-prefix=${gcc_dir}/"
	if [ ! -f "${gcc_dir}/${directory}/${datestamp}" ] ; then
		echo "Installing: ${toolchain_name}"
		echo "-----------------------------"
		${WGET} "${site}/${version}${subdir}/${filename}" || ${WGET} "${archive_site}/${version}${subdir}/${filename}"
		if [ -d "${gcc_dir}/${directory}" ] ; then
			rm -rf "${gcc_dir}/${directory}" || true
		fi
		tar -xf "${gcc_dir}/${filename}" -C "${gcc_dir}/"
		if [ -f "${gcc_dir}/${directory}/${binary}gcc" ] ; then
			touch "${gcc_dir}/${directory}/${datestamp}"
		fi
	fi

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${gcc_dir}/${directory}/${binary}"
	fi
}

gcc_toolchain () {
	subdir=""
	site="https://releases.linaro.org"
	archive_site="https://releases.linaro.org/archive"
	case "${toolchain}" in
	gcc_linaro_eabi_4_8)
		#
		#https://releases.linaro.org/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
		#
		gcc_version="4.8"
		release="2014.04"
		toolchain_name="gcc-linaro-arm-none-eabi"
		version="14.04/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-none-eabi-"
		;;
	gcc_linaro_eabi_4_9_i686)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-eabi/gcc-linaro-4.9.4-2017.01-i686_arm-eabi.tar.xz
		#

		gcc_version="4.9"
		gcc_minor=".4"
		release="17.01"
		target="arm-eabi"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-i686_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-i686_${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_eabi_4_9)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-eabi/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi.tar.xz
		#

		gcc_version="4.9"
		gcc_minor=".4"
		release="17.01"
		target="arm-eabi"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_eabi_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-eabi/gcc-linaro-5.4.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-eabi/gcc-linaro-5.5.0-2017.10-x86_64_arm-eabi.tar.xz
		#

		gcc_version="5.5"
		gcc_minor=".0"
		release="17.10"
		target="arm-eabi"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_eabi_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/arm-eabi/gcc-linaro-6.3.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/arm-eabi/gcc-linaro-6.4.1-2017.08-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/arm-eabi/gcc-linaro-6.4.1-2017.11-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/arm-eabi/gcc-linaro-6.4.1-2018.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-eabi/gcc-linaro-6.5.0-2018.12-x86_64_arm-eabi.tar.xz
		#

		gcc_version="6.5"
		gcc_minor=".0"
		release="18.12"
		target="arm-eabi"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_eabi_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/arm-eabi/gcc-linaro-7.1.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-eabi/gcc-linaro-7.1.1-2017.08-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-eabi/gcc-linaro-7.2.1-2017.11-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-eabi/gcc-linaro-7.3.1-2018.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-eabi/gcc-linaro-7.4.1-2019.02-x86_64_arm-eabi.tar.xz
		#
		#site="https://snapshots.linaro.org"

		gcc_version="7.4"
		gcc_minor=".1"
		release="19.02"
		target="arm-eabi"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_gnueabi_4_6)
		#
		#https://releases.linaro.org/12.03/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabi-2012.03-20120326_linux.tar.bz2
		#https://releases.linaro.org/archive/12.03/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabi-2012.03-20120326_linux.tar.bz2
		#

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
		#
		#https://releases.linaro.org/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz
		#https://releases.linaro.org/archive/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz
		#

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
		#
		#https://releases.linaro.org/14.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux.tar.xz
		#

		gcc_version="4.8"
		release="2014.04"
		toolchain_name="gcc-linaro-arm-linux-gnueabihf"
		version="14.04/components/toolchain/binaries"
		directory="${toolchain_name}-${gcc_version}-${release}_linux"
		filename="${directory}.tar.xz"
		datestamp="${release}-${toolchain_name}"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_9_i686)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-i686_arm-linux-gnueabihf.tar.xz
		#

		gcc_version="4.9"
		gcc_minor=".4"
		release="17.01"
		target="arm-linux-gnueabihf"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-i686_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-i686_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_gnueabihf_4_9)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_version="4.9"
		gcc_minor=".4"
		release="17.01"
		target="arm-linux-gnueabihf"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_gnueabihf_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-linux-gnueabihf/gcc-linaro-5.5.0-2017.10-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_version="5.5"
		gcc_minor=".0"
		release="17.10"
		target="arm-linux-gnueabihf"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_gnueabihf_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/arm-linux-gnueabihf/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/arm-linux-gnueabihf/gcc-linaro-6.4.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/arm-linux-gnueabihf/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/arm-linux-gnueabihf/gcc-linaro-6.4.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-linux-gnueabihf/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_version="6.5"
		gcc_minor=".0"
		release="18.12"
		target="arm-linux-gnueabihf"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_gnueabihf_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-linux-gnueabihf/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
		#
		#site="https://snapshots.linaro.org"

		gcc_version="7.4"
		gcc_minor=".1"
		release="19.02"
		target="arm-linux-gnueabihf"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_arm_gnueabihf_8)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/gcc-arm-8.2-2018.08-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.11/gcc-arm-8.2-2018.11-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2019.01/gcc-arm-8.2-2019.01-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz
		#
		site="https://developer.arm.com/-/media/Files/downloads/gnu-a"
		archive_site="https://developer.arm.com/-/media/Files/downloads/gnu-a"

		gcc_version="8.3"
		gcc_minor=""
		release="19.03"
		target="arm-linux-gnueabihf"

		version="${gcc_version}-20${release}"
		filename="gcc-arm-${gcc_version}${gcc_minor}-20${release}-x86_64-${target}.tar.xz"
		directory="gcc-arm-${gcc_version}${gcc_minor}-20${release}-x86_64-${target}"
		subdir="/binrel"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_aarch64_gnu_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/aarch64-linux-gnu/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu.tar.xz
		#

		gcc_version="5.5"
		gcc_minor=".0"
		release="17.10"
		target="aarch64-linux-gnu"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_aarch64_gnu_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/aarch64-linux-gnu/gcc-linaro-6.4.1-2017.08-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/aarch64-linux-gnu/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/aarch64-linux-gnu/gcc-linaro-6.4.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz
		#

		gcc_version="6.5"
		gcc_minor=".0"
		release="18.12"
		target="aarch64-linux-gnu"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_linaro_aarch64_gnu_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/aarch64-linux-gnu/gcc-linaro-7.1.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/aarch64-linux-gnu/gcc-linaro-7.1.1-2017.08-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/aarch64-linux-gnu/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
		#
		#site="https://snapshots.linaro.org"

		gcc_version="7.4"
		gcc_minor=".1"
		release="19.02"
		target="aarch64-linux-gnu"

		version="components/toolchain/binaries/${gcc_version}-20${release}/${target}"
		filename="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}.tar.xz"
		directory="gcc-linaro-${gcc_version}${gcc_minor}-20${release}-x86_64_${target}"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
		;;
	gcc_arm_aarch64_gnu_8)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/gcc-arm-8.2-2018.08-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.11/gcc-arm-8.2-2018.11-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2019.01/gcc-arm-8.2-2019.01-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz
		#
		site="https://developer.arm.com/-/media/Files/downloads/gnu-a"
		archive_site="https://developer.arm.com/-/media/Files/downloads/gnu-a"

		gcc_version="8.3"
		gcc_minor=""
		release="19.03"
		target="aarch64-linux-gnu"

		version="${gcc_version}-20${release}"
		filename="gcc-arm-${gcc_version}${gcc_minor}-20${release}-x86_64-${target}.tar.xz"
		directory="gcc-arm-${gcc_version}${gcc_minor}-20${release}-x86_64-${target}"
		subdir="/binrel"

		datestamp="${gcc_version}-20${release}-${target}"

		binary="bin/${target}-"
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
	if [ "x${ARCH}" = "xi686" ] ; then
		if [ "x${toolchain}" = "xgcc_linaro_eabi_4_9" ] ; then
			toolchain="gcc_linaro_eabi_4_9_i686"
		fi

		if [ "x${toolchain}" = "xgcc_linaro_gnueabihf_4_9" ] ; then
			toolchain="gcc_linaro_gnueabihf_4_9_i686"
		fi

	fi
	gcc_toolchain
fi

unset check
if [ "x${KERNEL_ARCH}" = "xarm" ] ; then
	check="arm"
fi
if [ "x${KERNEL_ARCH}" = "xarm64" ] ; then
	check="aarch64"
fi

GCC_TEST=$(LC_ALL=C "${CC}gcc" -v 2>&1 | grep "Target:" | grep ${check} || true)

if [ "x${GCC_TEST}" = "x" ] ; then
	echo "-----------------------------"
	echo "scripts/gcc: Error: The GCC Cross Compiler you setup in system.sh (CC variable) is invalid."
	echo "-----------------------------"
	gcc_toolchain
fi

echo "-----------------------------"
echo "scripts/gcc: Using: $(LC_ALL=C "${CC}"gcc --version)"
echo "-----------------------------"
echo "CC=${CC}" > "${DIR}/.CC"
