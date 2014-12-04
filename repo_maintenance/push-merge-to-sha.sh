#!/bin/sh -e

DIR=$PWD
repo="https://github.com/torvalds/linux/commit"
compare="https://github.com/torvalds/linux/compare"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset KERNEL_SHA
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	git commit -a -m "merge to: ${repo}/${KERNEL_SHA}" -m "Compare: ${compare}/${prev_KERNEL_SHA}...${KERNEL_SHA}" -s
	git push origin ${BRANCH}
fi

