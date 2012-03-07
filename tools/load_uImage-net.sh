#!/bin/bash -e
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
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

function check_mmc {
	FDISK=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk ${MMC}" | awk '{print $2}')

	if [ "x${FDISK}" = "x${MMC}:" ] ; then
		echo ""
		echo "I see..."
		echo "fdisk -l:"
		LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk /dev/" --color=never
		echo ""
		echo "mount:"
		mount | grep -v none | grep "/dev/" --color=never
		echo ""
		read -p "Are you 100% sure, on selecting [${MMC}] (y/n)? "
		[ "${REPLY}" == "y" ] && mmc_write
		echo ""
	else
		echo ""
		echo "Are you sure? I Don't see [${MMC}], here is what I do see..."
		echo ""
		echo "fdisk -l:"
		LC_ALL=C sudo fdisk -l 2>/dev/null | grep "Disk /dev/" --color=never
		echo ""
		echo "mount:"
		mount | grep -v none | grep "/dev/" --color=never
		echo "Please update MMC variable in system.sh"
	fi
}

if [ -f "${DIR}/system.sh" ] ; then
	. system.sh

	if [ "x${ZRELADDR}" == "x" ] ; then
		echo "ERROR: ZRELADDR is not defined in system.sh"
	else
		if [ -f "${DIR}/KERNEL/arch/arm/boot/zImage" ] ; then
			if [ "x${MMC}" == "x" ] ; then
				echo "ERROR: MMC is not defined in system.sh"
			else
				check_mmc
			fi
		else
			echo "ERROR: Please run build_kernel.sh before running this script..."
		fi
	fi
else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

