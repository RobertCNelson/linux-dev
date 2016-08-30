#!/bin/sh -e

DIR=$PWD
git_bin=$(which git)

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	${git_bin} commit -a -m "scripts: sync with master of: https://github.com/RobertCNelson/stable-kernel.git" -s

	${git_bin} push origin ${BRANCH}
fi

