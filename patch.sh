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

imx () {
	echo "dir: imx"
	#http://www.spinics.net/lists/arm-kernel/msg258247.html
	#http://patchwork.ozlabs.org/project/linux-ide/list/
	${git} "${DIR}/patches/imx/0001-ARM-dtsi-enable-ahci-sata-on-imx6q-platforms.patch"
	${git} "${DIR}/patches/imx/0002-ARM-imx6q-update-the-sata-bits-definitions-of-gpr13.patch"
	${git} "${DIR}/patches/imx/0003-sata-imx-add-ahci-sata-support-on-imx-platforms.patch"
}

dts () {
	echo "dir: dts"
	${git} "${DIR}/patches/dts/0001-imx6q-wandboard-add-as-a-copy-of-imx6dl-wandboard.patch"
	${git} "${DIR}/patches/dts/0002-imx6sl-wandboard-add-as-a-copy-of-imx6dl-wandboard.patch"
}

arm
imx
dts

echo "patch.sh ran successful"
