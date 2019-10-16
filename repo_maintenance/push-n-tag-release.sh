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

#yeah, i'm getting lazy..

wfile=$(mktemp /tmp/builder.XXXXXXXXX)
echo "Working on temp $wfile ..."

cat_files () {
	if [ -f ./patches/git/AUFS ] ; then
		cat ./patches/git/AUFS >> ${wfile}
	fi

	if [ -f ./patches/git/BBDTBS ] ; then
		cat ./patches/git/BBDTBS >> ${wfile}
	fi

	if [ -f ./patches/git/CAN-ISOTP ] ; then
		cat ./patches/git/CAN-ISOTP >> ${wfile}
	fi

	if [ -f ./patches/git/RT ] ; then
		cat ./patches/git/RT >> ${wfile}
	fi

	if [ -f ./patches/git/TI_AMX3_CM3 ] ; then
		cat ./patches/git/TI_AMX3_CM3 >> ${wfile}
	fi

	if [ -f ./patches/git/WIREGUARD ] ; then
		cat ./patches/git/WIREGUARD >> ${wfile}
	fi
}

DIR=$PWD
git_bin=$(which git)

repo="git@github.com:RobertCNelson/linux-stable-rcn-ee.git"
example="rcn-ee"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	. ${DIR}/version.sh

	echo "${KERNEL_TAG}${BUILD} release" > ${wfile}
	cat_files

	${git_bin} commit -a -F ${wfile} -s
	${git_bin} tag -a "${KERNEL_TAG}${BUILD}" -m "${KERNEL_TAG}${BUILD}" -f

	${git_bin} push -f origin ${BRANCH}
	${git_bin} push -f origin ${BRANCH} --tags

	cd ${DIR}/KERNEL/
	make ARCH=${KERNEL_ARCH} distclean

	cp ${DIR}/patches/defconfig ${DIR}/KERNEL/.config
	make ARCH=${KERNEL_ARCH} savedefconfig
	cp ${DIR}/KERNEL/defconfig ${DIR}/KERNEL/arch/${KERNEL_ARCH}/configs/${example}_defconfig
	${git_bin} add arch/${KERNEL_ARCH}/configs/${example}_defconfig

	echo "${KERNEL_TAG}${BUILD} ${example}_defconfig" > ${wfile}
	cat_files

	${git_bin} commit -a -F ${wfile} -s
	${git_bin} tag -a "${KERNEL_TAG}${BUILD}" -m "${KERNEL_TAG}${BUILD}" -f

	#push tag
	echo "log: git push -f ${repo} \"${KERNEL_TAG}${BUILD}\""
	${git_bin} push -f ${repo} "${KERNEL_TAG}${BUILD}"

	cd ${DIR}/
fi

echo "Deleting $wfile ..."
rm -f "$wfile"
