#!/bin/bash -e

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




