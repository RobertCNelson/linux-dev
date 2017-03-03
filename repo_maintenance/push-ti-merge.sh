#!/bin/sh -e

DIR=$PWD
git_bin=$(which git)
repo="https://github.com/RobertCNelson/ti-linux-kernel/compare"

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	unset KERNEL_SHA
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	${git_bin} commit -a -m "merge ti: ${repo}/${ti_git_pre}...${ti_git_post}" -s
	${git_bin} push origin ${BRANCH}
fi

