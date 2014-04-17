#!/bin/sh -e

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	. ${DIR}/version.sh

	if [ ! "${BRANCH}" ] ; then
		BRANCH="master"
	fi

	git commit -a -m "scripts: sync with master of: https://github.com/RobertCNelson/stable-kernel.git" -s

	git push origin ${BRANCH}
fi

