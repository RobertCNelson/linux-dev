#!/bin/sh -e
#
# Copyright (c) 2013 Robert Nelson <robertcnelson@gmail.com>
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

DIR=$PWD

#Yuck, this error script can be called two directories...
offset="/"
if [ -f ${DIR}/../version.sh ] ; then
	. ${DIR}/../version.sh
	offset="../"
fi
if [ -f ${DIR}/../../version.sh ] ; then
	. ${DIR}/../../version.sh
	offset="../../"
fi

echo "-----------------------------"
echo "Script Error: please cut and paste the following into an email to: bugs@rcn-ee.com"
echo "**********************************************************"
echo "Error: [${ERROR_MSG}]"

if [ -f "${DIR}/${offset}.git/config" ] ; then
	gitrepo=$(cat "${DIR}/${offset}.git/config" | grep url | awk '{print $3}')
	gitwhatchanged=$(cd ${offset} ; git whatchanged -1)
	echo "git repo: [${gitrepo}]"
	echo "-----------------------------"
	echo "${gitwhatchanged}"
	echo "-----------------------------"
else
	if [ "${BRANCH}" ] ; then
		echo "nongit: [${BRANCH}]"
	else
		echo "nongit: [master]"
	fi
fi

if [ ! "${KERNEL_SHA}" ] ; then
	echo "kernel: [v${KERNEL_TAG}-${BUILD}]"
else
	echo "kernel: [v${KERNEL_TAG}-${BUILD}] + [${KERNEL_SHA}]"
fi

echo "uname -m"
uname -m
if [ $(which lsb_release) ] ; then
	echo "lsb_release -a"
	lsb_release -a
fi
echo "**********************************************************"

