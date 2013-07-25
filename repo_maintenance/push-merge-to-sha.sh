#!/bin/sh -e

DIR=$PWD
repo="https://github.com/RobertCNelson/linux/commit"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset KERNEL_SHA
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	git commit -a -m "merge to: ${repo}/${KERNEL_SHA}" -s
	git push origin ${BRANCH}
fi

