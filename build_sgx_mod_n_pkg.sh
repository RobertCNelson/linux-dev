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

SGX_SHA="origin/master"

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
	make HOME=/home/${USER} CSTOOL_DIR=/opt/github/linaro-tools/cross-gcc/build/sysroot/home/voodoo/opt/gcc-linaro-cross CSTOOL_PREFIX=arm-linux-gnueabi- KERNEL_INSTALL_DIR="${DIR}/KERNEL" BUILD=release OMAPES=3.x FBDEV=yes SUPPORT_XORG=1 all
	cd ${DIR}/
}

git_sgx_modules
build_sgx_modules

