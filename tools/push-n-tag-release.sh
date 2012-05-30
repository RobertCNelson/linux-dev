#!/bin/bash -e
#
# Copyright (c) 2009-2011 Robert Nelson <robertcnelson@gmail.com>
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

unset NO_DEVTMPS

DIR=$PWD
BRANCH="am33x-v3.2"

if [ -e ${DIR}/version.sh ]; then
	. version.sh

	if [ "${RC_PATCH}" ]; then
		git commit -a -m "${RC_KERNEL}${RC_PATCH}-${BUILD} release" -s
		git tag -a "${RC_KERNEL}${RC_PATCH}-${BUILD}" -m "${RC_KERNEL}${RC_PATCH}-${BUILD}"
		git push origin ${BRANCH} --tags
		git push origin ${BRANCH}
	else if [ "${STABLE_PATCH}" ] ; then
		git commit -a -m "${KERNEL_REL}.${STABLE_PATCH}-${BUILD} release" -s
		git tag -a "${KERNEL_REL}.${STABLE_PATCH}-${BUILD}" -m "${KERNEL_REL}.${STABLE_PATCH}-${BUILD}"
		git push origin ${BRANCH} --tags
		git push origin ${BRANCH}
	else
		git commit -a -m "${KERNEL_REL}-${BUILD} release" -s
		git tag -a "${KERNEL_REL}-${BUILD}" -m "${KERNEL_REL}-${BUILD}"
		git push origin ${BRANCH} --tags
		git push origin ${BRANCH}
	fi
	fi
fi

