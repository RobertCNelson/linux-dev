#!/bin/sh -e
#
# Copyright (c) 2009-2020 Robert Nelson <robertcnelson@gmail.com>
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
	if [ ! -f "${gcc_dir}/${gcc_filename_prefix}/${datestamp}" ] ; then
		echo "Installing Toolchain: ${toolchain}"
		echo "-----------------------------"
		${WGET} "${gcc_html_path}${gcc_filename_prefix}.tar.xz"
		if [ -d "${gcc_dir}/${gcc_filename_prefix}" ] ; then
			rm -rf "${gcc_dir}/${gcc_filename_prefix}" || true
		fi
		tar -xf "${gcc_dir}/${gcc_filename_prefix}.tar.xz" -C "${gcc_dir}/"
		if [ -f "${gcc_dir}/${gcc_filename_prefix}/${binary}gcc" ] ; then
			touch "${gcc_dir}/${gcc_filename_prefix}/${datestamp}"
		fi
	else
		echo "Using Existing Toolchain: ${toolchain}"
	fi

	if [ "x${ARCH}" = "xarmv7l" ] ; then
		#using native gcc
		CC=
	else
		CC="${gcc_dir}/${gcc_filename_prefix}/${binary}"
	fi
}

gcc_toolchain () {
	case "${toolchain}" in
	gcc_linaro_eabi_4_8)
		#
		#https://releases.linaro.org/archive/14.04/components/toolchain/binaries/gcc-linaro-arm-none-eabi-4.8-2014.04_linux.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/archive/14.04/components/toolchain/binaries/"
		gcc_filename_prefix="gcc-linaro-arm-none-eabi-4.8-2014.04_linux"
		gcc_banner="arm-none-eabi-gcc (crosstool-NG linaro-1.13.1-4.8-2014.04 - Linaro GCC 4.8-2014.04) 4.8.3 20140401 (prerelease)"
		gcc_copyright="2013"
		datestamp="2014.04-gcc-arm-none-eabi"

		binary="bin/arm-none-eabi-"
		;;
	gcc_linaro_eabi_4_9)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-eabi/gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-eabi/"
		gcc_filename_prefix="gcc-linaro-4.9.4-2017.01-x86_64_arm-eabi"
		gcc_banner="arm-eabi-gcc (Linaro GCC 4.9-2017.01) 4.9.4"
		gcc_copyright="2015"
		datestamp="2017.01-gcc-arm-none-eabi"

		binary="bin/arm-eabi-"
		;;
	gcc_linaro_eabi_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-eabi/gcc-linaro-5.4.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-eabi/gcc-linaro-5.5.0-2017.10-x86_64_arm-eabi.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-eabi/"
		gcc_filename_prefix="gcc-linaro-5.5.0-2017.10-x86_64_arm-eabi"
		gcc_banner="arm-eabi-gcc (Linaro GCC 5.5-2017.10) 5.5.0"
		gcc_copyright="2015"
		datestamp="2017.10-gcc-arm-none-eabi"

		binary="bin/arm-eabi-"
		;;
	gcc_linaro_eabi_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/arm-eabi/gcc-linaro-6.3.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/arm-eabi/gcc-linaro-6.4.1-2017.08-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/arm-eabi/gcc-linaro-6.4.1-2017.11-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/arm-eabi/gcc-linaro-6.4.1-2018.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-eabi/gcc-linaro-6.5.0-2018.12-x86_64_arm-eabi.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-eabi/"
		gcc_filename_prefix="gcc-linaro-6.5.0-2018.12-x86_64_arm-eabi"
		gcc_banner="arm-eabi-gcc (Linaro GCC 6.5-2018.12) 6.5.0"
		gcc_copyright="2017"
		datestamp="2018.12-gcc-arm-none-eabi"

		binary="bin/arm-eabi-"
		;;
	gcc_linaro_eabi_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/arm-eabi/gcc-linaro-7.1.1-2017.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-eabi/gcc-linaro-7.1.1-2017.08-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-eabi/gcc-linaro-7.2.1-2017.11-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-eabi/gcc-linaro-7.3.1-2018.05-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-eabi/gcc-linaro-7.4.1-2019.02-x86_64_arm-eabi.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-eabi/gcc-linaro-7.5.0-2019.12-x86_64_arm-eabi.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-eabi/"
		gcc_filename_prefix="gcc-linaro-7.5.0-2019.12-x86_64_arm-eabi"
		gcc_banner="arm-eabi-gcc (Linaro GCC 7.5-2019.12) 7.5.0"
		gcc_copyright="2017"
		datestamp="2019.12-gcc-arm-none-eabi"

		binary="bin/arm-eabi-"
		;;
	gcc_arm_eabi_8)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-eabi.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/"
		gcc_filename_prefix="gcc-arm-8.3-2019.03-x86_64-arm-eabi"
		gcc_banner="arm-eabi-gcc (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 8.3.0"
		gcc_copyright="2018"
		datestamp="2019.03-gcc-arm-none-eabi"

		binary="bin/arm-eabi-"
		;;
	gcc_arm_eabi_9)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-eabi.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/"
		gcc_filename_prefix="gcc-arm-9.2-2019.12-x86_64-arm-none-eabi"
		gcc_banner="arm-none-eabi-gcc (GNU Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10)) 9.2.1 20191025"
		gcc_copyright="2019"
		datestamp="2019.12-gcc-arm-none-eabi"

		binary="bin/arm-none-eabi-"
		;;
	gcc_linaro_gnueabihf_4_7)
		#
		#https://releases.linaro.org/archive/13.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/archive/13.04/components/toolchain/binaries/"
		gcc_filename_prefix="gcc-linaro-arm-linux-gnueabihf-4.7-2013.04-20130415_linux"
		gcc_banner="arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.7-2013.04-20130415 - Linaro GCC 2013.04) 4.7.3 20130328 (prerelease)"
		gcc_copyright="2012"
		datestamp="2013.04-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_8)
		#
		#https://releases.linaro.org/archive/14.04/components/toolchain/binaries/gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/archive/14.04/components/toolchain/binaries/"
		gcc_filename_prefix="gcc-linaro-arm-linux-gnueabihf-4.8-2014.04_linux"
		gcc_banner="arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-4.8-2014.04 - Linaro GCC 4.8-2014.04) 4.8.3 20140401 (prerelease)"
		gcc_copyright="2013"
		datestamp="2014.04-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_4_9)
		#
		#https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/arm-linux-gnueabihf/"
		gcc_filename_prefix="gcc-linaro-4.9.4-2017.01-x86_64_arm-linux-gnueabihf"
		gcc_banner="arm-linux-gnueabihf-gcc (Linaro GCC 4.9-2017.01) 4.9.4"
		gcc_copyright="2015"
		datestamp="2017.01-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-linux-gnueabihf/gcc-linaro-5.5.0-2017.10-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/arm-linux-gnueabihf/"
		gcc_filename_prefix="gcc-linaro-5.5.0-2017.10-x86_64_arm-linux-gnueabihf"
		gcc_banner="arm-linux-gnueabihf-gcc (Linaro GCC 5.5-2017.10) 5.5.0"
		gcc_copyright="2015"
		datestamp="2017.10-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/arm-linux-gnueabihf/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/arm-linux-gnueabihf/gcc-linaro-6.4.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/arm-linux-gnueabihf/gcc-linaro-6.4.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/arm-linux-gnueabihf/gcc-linaro-6.4.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-linux-gnueabihf/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-linux-gnueabihf/"
		gcc_filename_prefix="gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf"
		gcc_banner="arm-linux-gnueabihf-gcc (Linaro GCC 6.5-2018.12) 6.5.0"
		gcc_copyright="2017"
		datestamp="2018.12-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_linaro_gnueabihf_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/arm-linux-gnueabihf/gcc-linaro-7.1.1-2017.08-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/arm-linux-gnueabihf/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/arm-linux-gnueabihf/gcc-linaro-7.3.1-2018.05-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/arm-linux-gnueabihf/"
		gcc_filename_prefix="gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf"
		gcc_banner="arm-linux-gnueabihf-gcc (Linaro GCC 7.5-2019.12) 7.5.0"
		gcc_copyright="2017"
		datestamp="2019.12-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_arm_gnueabihf_8)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/gcc-arm-8.2-2018.08-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.11/gcc-arm-8.2-2018.11-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2019.01/gcc-arm-8.2-2019.01-x86_64-arm-linux-gnueabihf.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/"
		gcc_filename_prefix="gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf"
		gcc_banner="arm-linux-gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 8.3.0"
		gcc_copyright="2018"
		datestamp="2019.03-gcc-arm-linux-gnueabihf"

		binary="bin/arm-linux-gnueabihf-"
		;;
	gcc_arm_gnueabihf_9)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/"
		gcc_filename_prefix="gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf"
		gcc_banner="arm-none-linux-gnueabihf-gcc (GNU Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10)) 9.2.1 20191025"
		gcc_copyright="2019"
		datestamp="2019.12-gcc-arm-linux-gnueabihf"

		binary="bin/arm-none-linux-gnueabihf-"
		;;
	gcc_linaro_aarch64_gnu_5)
		#
		#https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/aarch64-linux-gnu/gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/5.5-2017.10/aarch64-linux-gnu/"
		gcc_filename_prefix="gcc-linaro-5.5.0-2017.10-x86_64_aarch64-linux-gnu"
		gcc_banner="aarch64-linux-gnu-gcc (Linaro GCC 5.5-2017.10) 5.5.0"
		gcc_copyright="2015"
		datestamp="2017.10-gcc-aarch64-linux-gnu"

		binary="bin/aarch64-linux-gnu-"
		;;
	gcc_linaro_aarch64_gnu_6)
		#
		#https://releases.linaro.org/components/toolchain/binaries/6.3-2017.05/aarch64-linux-gnu/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.08/aarch64-linux-gnu/gcc-linaro-6.4.1-2017.08-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2017.11/aarch64-linux-gnu/gcc-linaro-6.4.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.4-2018.05/aarch64-linux-gnu/gcc-linaro-6.4.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/aarch64-linux-gnu/"
		gcc_filename_prefix="gcc-linaro-6.5.0-2018.12-x86_64_aarch64-linux-gnu"
		gcc_banner="aarch64-linux-gnu-gcc (Linaro GCC 6.5-2018.12) 6.5.0"
		gcc_copyright="2017"
		datestamp="2018.12-gcc-aarch64-linux-gnu"

		binary="bin/aarch64-linux-gnu-"
		;;
	gcc_linaro_aarch64_gnu_7)
		#
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.05/aarch64-linux-gnu/gcc-linaro-7.1.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.1-2017.08/aarch64-linux-gnu/gcc-linaro-7.1.1-2017.08-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/aarch64-linux-gnu/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-linux-gnu/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/aarch64-linux-gnu/gcc-linaro-7.4.1-2019.02-x86_64_aarch64-linux-gnu.tar.xz
		#https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu.tar.xz
		#

		gcc_html_path="https://releases.linaro.org/components/toolchain/binaries/7.5-2019.12/aarch64-linux-gnu/"
		gcc_filename_prefix="gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu"
		gcc_banner="aarch64-linux-gnu-gcc (Linaro GCC 7.5-2019.12) 7.5.0"
		gcc_copyright="2017"
		datestamp="2019.12-gcc-aarch64-linux-gnu"

		binary="bin/aarch64-linux-gnu-"
		;;
	gcc_arm_aarch64_gnu_8)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.08/gcc-arm-8.2-2018.08-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2018.11/gcc-arm-8.2-2018.11-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.2-2019.01/gcc-arm-8.2-2019.01-x86_64-aarch64-linux-gnu.tar.xz
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/"
		gcc_filename_prefix="gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu"
		gcc_banner="aarch64-linux-gnu-gcc (GNU Toolchain for the A-profile Architecture 8.3-2019.03 (arm-rel-8.36)) 8.3.0"
		gcc_copyright="2018"
		datestamp="2019.03-gcc-aarch64-linux-gnu"

		binary="bin/aarch64-linux-gnu-"
		;;
	gcc_arm_aarch64_gnu_9)
		#
		#https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz
		#

		gcc_html_path="https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/"
		gcc_filename_prefix="gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu"
		gcc_banner="aarch64-none-linux-gnu-gcc (GNU Toolchain for the A-profile Architecture 9.2-2019.12 (arm-9.10)) 9.2.1 20191025"
		gcc_copyright="2019"
		datestamp="2019.12-gcc-aarch64-linux-gnu"

		binary="bin/aarch64-none-linux-gnu-"
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
