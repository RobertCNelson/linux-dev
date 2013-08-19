#!/bin/sh -e

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset KERNEL_TAG
	unset tag
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	if [ ! "${KERNEL_TAG}" ] ; then
		echo 'KERNEL_TAG undefined'
		exit
	fi

	if [ ! "${tag}" ] ; then
		echo 'tag undefined'
		exit
	fi

	git commit -a -m "kernel bump: v${KERNEL_TAG} + ${tag}" -s
	git push origin ${BRANCH}
fi

