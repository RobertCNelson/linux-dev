#!/bin/sh -e

DIR=$PWD
git_bin=$(which git)
repo="https://github.com/torvalds/linux/commit"
compare="https://github.com/torvalds/linux/compare"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset BUILD
	unset prev_KERNEL_SHA
	unset KERNEL_SHA
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	if [ "x${prev_KERNEL_SHA}" = "x" ] ; then
		${git_bin} commit -a -m "${KERNEL_TAG}${BUILD}: merge to: ${repo}/${KERNEL_SHA}" -s
	else
		${git_bin} commit -a -m "${KERNEL_TAG}${BUILD}: merge to: ${repo}/${KERNEL_SHA}" -m "Compare: ${compare}/${prev_KERNEL_SHA}...${KERNEL_SHA}" -s
	fi

	echo "log: git push origin ${BRANCH}"
	${git_bin} push origin ${BRANCH}
fi

