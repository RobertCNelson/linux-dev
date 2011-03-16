#!/bin/bash -e
#yeah, i'm getting lazy..

unset NO_DEVTMPS

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	. version.sh

        if [ "${RC_PATCH}" ]; then
		git commit -a -m "${RC_KERNEL}${RC_PATCH}-${BUILD} release" -s
		git tag -a "${RC_KERNEL}${RC_PATCH}-${BUILD}" -m "${RC_KERNEL}${RC_PATCH}-${BUILD}"
		git push origin --tags
		git push origin
	else if [ "${STABLE_PATCH}" ] ; then
		git commit -a -m "${KERNEL_REL}.${STABLE_PATCH}-${BUILD} release" -s
		git tag -a "${KERNEL_REL}.${STABLE_PATCH}-${BUILD}" -m "${KERNEL_REL}.${STABLE_PATCH}-${BUILD}"
		git push origin --tags
		git push origin
	else
		git commit -a -m "${KERNEL_REL}-${BUILD} release" -s
		git tag -a "${KERNEL_REL}-${BUILD}" -m "${KERNEL_REL}-${BUILD}"
		git push origin --tags
		git push origin
	fi
	fi
fi

