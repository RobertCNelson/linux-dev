#!/bin/sh
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

# Split out, so build_kernel.sh and build_deb.sh can share..

git="git am"

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		git format-patch -${number} -o ${DIR}/patches/
	fi
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-arm-dts-am335x-boneblack-lcdc-add-panel-info.patch"
	${git} "${DIR}/patches/dts/0002-arm-dts-am335x-boneblack-add-cpu0-opp-points.patch"
}

sgx () {
	echo "dir: sgx"
	${git} "${DIR}/patches/sgx/0001-reset-Add-driver-for-gpio-controlled-reset-pins.patch"
	${git} "${DIR}/patches/sgx/0002-prcm-port-from-ti-linux-3.12.y.patch"
	${git} "${DIR}/patches/sgx/0003-ARM-DTS-AM335x-Add-SGX-DT-node.patch"
	${git} "${DIR}/patches/sgx/0004-arm-Export-cache-flush-management-symbols-when-MULTI.patch"
	${git} "${DIR}/patches/sgx/0005-hack-port-da8xx-changes-from-ti-3.12-repo.patch"
	${git} "${DIR}/patches/sgx/0006-Revert-drm-remove-procfs-code-take-2.patch"
	${git} "${DIR}/patches/sgx/0007-Changes-according-to-TI-for-SGX-support.patch"
}

saucy () {
	echo "dir: saucy"
	#Ubuntu Saucy: so Ubuntu decided to enable almost every Warning -> Error option...
	${git} "${DIR}/patches/saucy/0001-saucy-error-variable-ilace-set-but-not-used-Werror-u.patch"
	${git} "${DIR}/patches/saucy/0002-saucy-disable-Werror-pointer-sign.patch"
	${git} "${DIR}/patches/saucy/0003-saucy-disable-stack-protector.patch"
}

###
arm
dts
sgx
saucy

echo "patch.sh ran successful"
