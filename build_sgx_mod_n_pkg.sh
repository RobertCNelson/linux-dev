#!/bin/bash -e
#
# Copyright (c) 2012 Robert Nelson <robertcnelson@gmail.com>
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

VERSION="v2012.04-1"

unset DIR

DIR=$PWD

SGX_SHA="origin/4.06.00.01"

set_sgx_make_vars () {
	GRAPHICS_PATH="GRAPHICS_INSTALL_DIR="${DIR}/ti-sdk-pvr/Graphics_SDK/""
	KERNEL_PATH="KERNEL_INSTALL_DIR="${DIR}/KERNEL""
	USER_VAR="HOME=/home/${USER}"
	CSTOOL_PREFIX=${CC##*/}

	#Will probally have to revist this one later...
	CSTOOL_DIR=$(echo ${CC} | awk -F "/bin/${CSTOOL_PREFIX}" '{print $1}')

	if [ "x${CSTOOL_PREFIX}" == "x${CSTOOL_DIR}" ] ; then
		CSTOOL_DIR="/usr"
	fi

	CROSS="CSTOOL_PREFIX=${CSTOOL_PREFIX} CSTOOL_DIR=${CSTOOL_DIR}"
}

git_sgx_modules () {
	if [ ! -f "${DIR}/ti-sdk-pvr/.git/config" ] ; then
		git clone git://github.com/RobertCNelson/ti-sdk-pvr.git
		cd "${DIR}/ti-sdk-pvr/"
		git checkout ${SGX_SHA} -b tmp-build
		cd ${DIR}/
	else
		cd "${DIR}/ti-sdk-pvr/"
		git add .
		git commit --allow-empty -a -m 'empty cleanup commit'
		git checkout origin/master -b tmp-scratch
		git branch -D tmp-build &>/dev/null || true
		git fetch
		git checkout ${SGX_SHA} -b tmp-build
		git branch -D tmp-scratch &>/dev/null || true
		cd ${DIR}/
	fi
}

build_sgx_modules () {
	cd "${DIR}/ti-sdk-pvr/Graphics_SDK/"
	echo "make ${GRAPHICS_PATH} ${KERNEL_PATH} ${USER_VAR} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" SUPPORT_XORG="$4" "$5""
	make ${GRAPHICS_PATH} ${KERNEL_PATH} ${USER_VAR} ${CROSS} BUILD="$1" OMAPES="$2" FBDEV="$3" SUPPORT_XORG="$4" "$5"
	cd ${DIR}/
}

if [ -e ${DIR}/system.sh ] ; then
	source system.sh
	source version.sh

	set_sgx_make_vars

	git_sgx_modules
	build_sgx_modules release 3.x yes 1 all
#	build_sgx_modules release 5.x yes 1 all
#	build_sgx_modules release 6.x yes 1 all
#	build_sgx_modules release 8.x yes 1 all
else
	echo ""
	echo "ERROR: Missing (your system) specific system.sh, please copy system.sh.sample to system.sh and edit as needed."
	echo ""
	echo "example: cp system.sh.sample system.sh"
	echo "example: gedit system.sh"
	echo ""
fi

