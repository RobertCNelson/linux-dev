#!/bin/sh -e

DIR=$PWD

check_config () {
	unset test_config
	test_config=$(grep "${config}=" ${DIR}/patches/defconfig || true)
	if [ "x${test_config}" = "x" ] ; then
		echo "Config: [${config}] not enabled"
		exit
	fi
}

#2013-12-19: make sure zram is enabled...
config="CONFIG_ZRAM"
check_config

#
