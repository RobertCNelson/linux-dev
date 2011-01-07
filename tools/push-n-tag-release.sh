#!/bin/bash -e
#yeah, i'm getting lazy..

unset IS_LUCID
REPO=2.6.38-devel

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	. version.sh

        if [ "${RC_PATCH}" ]; then
		bzr commit -m "${RC_KERNEL}${RC_PATCH}-${BUILD} release"
		bzr tag "${RC_KERNEL}${RC_PATCH}-${BUILD}"
		bzr push lp:~beagleboard-kernel/+junk/${REPO}
	else if [ "${STABLE_PATCH}" ] ; then
		bzr commit -m "${KERNEL_REL}.${STABLE_PATCH}-${BUILD} release"
		bzr tag "${KERNEL_REL}.${STABLE_PATCH}-${BUILD}"
		bzr push lp:~beagleboard-kernel/+junk/${REPO}
	else
		bzr commit -m "${KERNEL_REL}-${BUILD} release"
		bzr tag "${KERNEL_REL}.${STABLE_PATCH}"
		bzr push lp:~beagleboard-kernel/+junk/${REPO}
	fi
	fi
fi

