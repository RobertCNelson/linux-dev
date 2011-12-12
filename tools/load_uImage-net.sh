#!/bin/bash -e
#
# Copyright (c) 2009-2011 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

unset KERNEL_UTS
unset MMC
unset ZRELADDR

DIR=$PWD

. version.sh

function mmc_write {

	#KERNEL_UTS=$(cat ${DIR}/KERNEL/include/linux/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )

	echo "Installing $KERNEL_UTS"

	cd ${DIR}/deploy
	mkdir -p disk
	sudo umount ${MMC}1 &> /dev/null || true
	sudo umount ${MMC}5 &> /dev/null || true

	sudo mount ${MMC}1 ${DIR}/deploy/disk

	sudo mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d ${DIR}/deploy/${KERNEL_UTS}.zImage ${DIR}/deploy/disk/uImage

	cd ${DIR}/deploy/disk
	sync
	sync
	cd ${DIR}/deploy/
	sudo umount ${DIR}/deploy/disk

	sudo umount ${MMC}1 &> /dev/null || true
	sudo umount ${MMC}5 &> /dev/null || true

	sudo mount ${MMC}5 ${DIR}/deploy/disk
	sudo rm -rf ${DIR}/deploy/disk/lib/modules/${KERNEL_UTS}

	sudo tar xfv ${DIR}/deploy/${KERNEL_UTS}-modules.tar.gz -C ${DIR}/deploy/disk

	cd ${DIR}/deploy/disk
	sync
	sync
	cd ${DIR}/deploy/
	sudo umount ${DIR}/deploy/disk
	echo "Done"
	cd ${DIR}/
}


if [ -e ${DIR}/system.sh ]; then
	. system.sh

if test "-$ZRELADDR-" = "--"
then
	echo "Please set ZRELADDR in system.sh"
else

if [ -e ${DIR}/KERNEL/arch/arm/boot/zImage ]; then
{
	if test "-$MMC-" = "--"
	then
 		echo "MMC is not defined in system.sh"
	else
		mmc_write
	fi
}
else
{

echo "run build_kernel.sh first"

}
fi
fi
else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

