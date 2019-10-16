#!/bin/sh -e

#yeah, i'm getting lazy..

wfile=$(mktemp /tmp/builder.XXXXXXXXX)
echo "Working on temp $wfile ..."

cat_files () {
	if [ -f ./patches/git/AUFS ] ; then
		cat ./patches/git/AUFS >> ${wfile}
	fi

	if [ -f ./patches/git/BBDTBS ] ; then
		cat ./patches/git/BBDTBS >> ${wfile}
	fi

	if [ -f ./patches/git/CAN-ISOTP ] ; then
		cat ./patches/git/CAN-ISOTP >> ${wfile}
	fi

	if [ -f ./patches/git/RT ] ; then
		cat ./patches/git/RT >> ${wfile}
	fi

	if [ -f ./patches/git/TI_AMX3_CM3 ] ; then
		cat ./patches/git/TI_AMX3_CM3 >> ${wfile}
	fi

	if [ -f ./patches/git/WIREGUARD ] ; then
		cat ./patches/git/WIREGUARD >> ${wfile}
	fi
}

DIR=$PWD
git_bin=$(which git)

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

	echo "kernel v${KERNEL_TAG} rebase with rt: v${KERNEL_REL}${kernel_rt} aufs/wireguard/etc" > ${wfile}
	cat_files

	${git_bin} commit -a -F ${wfile} -s
	echo "log: git push origin ${BRANCH}"
	${git_bin} push origin ${BRANCH}
fi

echo "Deleting $wfile ..."
rm -f "$wfile"
