#!/bin/sh -e

DIR=$PWD

if [ -e ${DIR}/version.sh ]; then
	unset BRANCH
	. ${DIR}/version.sh

	git commit -a -m "scripts: sync with master" -s

	git push origin ${BRANCH}
fi

