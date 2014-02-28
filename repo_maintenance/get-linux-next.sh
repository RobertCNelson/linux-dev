#!/bin/sh -e

if [ -f /tmp/finger_banner ] ; then
	rm -rf /tmp/finger_banner || true
fi
wget --no-verbose --directory-prefix=/tmp/ https://www.kernel.org/finger_banner

if [ -f /tmp/finger_banner ] ; then
	next=$(cat /tmp/finger_banner | grep next | awk '{print $10}' | awk -F"next-" '{print $2}')
fi

old=$(cat version.sh | grep tag | awk -F"\"" '{print $2}')
sed -i -e 's:'${old}':'${next}':g' version.sh

