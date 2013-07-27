#!/bin/sh -e

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset KERNEL_TAG
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	if [ ! "${KERNEL_TAG}" ] ; then
		echo 'KERNEL_TAG undefined'
		exit
	fi

	git commit -a -m "kernel bump: v${KERNEL_TAG}" -s
	git push origin ${BRANCH}
fi

