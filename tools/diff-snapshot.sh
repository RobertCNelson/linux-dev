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

DIR=$PWD

. system.sh
. version.sh

START_PRE_RC=2.6.34-git6
END_PRE_RC=2.6.34-git7

        cd ${LINUX_GIT}/
        git fetch
        cd -

        if [[ ! -a ${DIR}/KERNEL ]]; then
                git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
        fi

function git-start_kernel {

        cd ${DIR}/KERNEL

        git reset --hard
        git fetch
        git checkout master

        if [ "${START_PRE_RC}" ]; then
                wget -c --directory-prefix=${DIR}/patches/ http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-${START_PRE_RC}.bz2
                git branch -D v${START_PRE_RC}-${BUILD} || true
                git checkout v${KERNEL_REL} -b v${START_PRE_RC}-${BUILD}
		bzip2 -dc ${DIR}/patches/patch-${START_PRE_RC}.bz2 | patch -p1 -s
		git add .
                git commit -a -m ''$START_PRE_RC'-'$BUILD' patchset'
        fi

        cd ${DIR}/
}

function git-end_kernel {

        cd ${DIR}/KERNEL

        git reset --hard
        git fetch
        git checkout master

        if [ "${END_PRE_RC}" ]; then
                wget -c --directory-prefix=${DIR}/patches/ http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-${END_PRE_RC}.bz2
                git branch -D v${END_PRE_RC}-${BUILD} || true
                git checkout v${KERNEL_REL} -b v${END_PRE_RC}-${BUILD}
		bzip2 -dc ${DIR}/patches/patch-${END_PRE_RC}.bz2 | patch -p1 -s
		git add .
                git commit -a -m ''$END_PRE_RC'-'$BUILD' patchset'
        fi

        cd ${DIR}/
}

git-start_kernel
git-end_kernel


cd ${DIR}/KERNEL
git diff v${START_PRE_RC}-${BUILD}..v${END_PRE_RC}-${BUILD} > ../${START_PRE_RC}-to-${END_PRE_RC}.diff
cd ${DIR}/

gedit ${START_PRE_RC}-to-${END_PRE_RC}.diff




