#!/bin/bash
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

BOOT_PARITION="1"

DIR=$PWD

. version.sh

backup_config () {
	if [ -f "${DIR}/patches/previous_defconfig" ] ; then
		rm -f "${DIR}/patches/previous_defconfig" || true
	fi
	if [ -f "${DIR}/patches/current_defconfig" ] ; then
		mv "${DIR}/patches/current_defconfig" "${DIR}/patches/previous_defconfig"
	fi
	cp "${DIR}/KERNEL/.config" "${DIR}/patches/current_defconfig"
	echo "-----------------------------"
	echo "This script has finished successfully..."
}

mmc_write_modules () {
	echo "Installing ${KERNEL_UTS}-modules.tar.gz to rootfs partition"
	echo "-----------------------------"

	if [ -d "${DIR}/deploy/disk/lib/modules/${KERNEL_UTS}" ] ; then
		sudo rm -rf ${DIR}/deploy/disk/lib/modules/${KERNEL_UTS} || true
	fi

	sudo tar xf "${DIR}/deploy/${KERNEL_UTS}-modules.tar.gz" -C "${DIR}/deploy/disk"
}

mmc_find_rootfs () {
	echo "Starting search for rootfs"
	echo "-----------------------------"
	NUMBER=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "^${MMC}" | grep "Linux" | grep -v "swap" | wc -l)

	for (( c=1; c<=${NUMBER}; c++ ))
	do
		PART=$(LC_ALL=C sudo fdisk -l 2>/dev/null | grep "^${MMC}" | grep "Linux" | grep -v "swap" | head -${c} | tail -1 | awk '{print $1}')
		echo "Trying ${PART}"

		if [ ! -d "${DIR}/deploy/disk/" ] ; then
			mkdir -p "${DIR}/deploy/disk/"
		fi

		if sudo mount ${PART} "${DIR}/deploy/disk/" ; then

			if [ -f "${DIR}/deploy/disk/etc/fstab" ] ; then
				echo "Found /etc/fstab, using ${PART}"
				echo "-----------------------------"
				mmc_write_modules
			fi

			cd "${DIR}/deploy/disk"
			sync
			sync
			cd -
			sudo umount "${DIR}/deploy/disk" || true

		else
			echo "-----------------------------"
			echo "Trying Next Partition"
		fi
	done

	backup_config
}

mmc_write_boot () {
	echo "Installing ${KERNEL_UTS} to boot partition"
	echo "-----------------------------"

	if [ ! -d "${DIR}/deploy/disk/" ] ; then
		mkdir -p "${DIR}/deploy/disk/"
	fi

	if sudo mount -t vfat ${MMC}${PARTITION_PREFIX}${BOOT_PARITION} "${DIR}/deploy/disk/" ; then

		if [ -f "${DIR}/deploy/disk/SOC.sh" ] ; then
			source "${DIR}/deploy/disk/SOC.sh"
			ZRELADDR=${load_addr}
			if [ "x${dtb_file}" != "x" ] ; then
				if [ -f "${DIR}/KERNEL/arch/arm/boot/${dtb_file}" ] ; then
					sudo cp -v "${DIR}/KERNEL/arch/arm/boot/${dtb_file}" "${DIR}/deploy/disk/"
				fi
			fi
		fi

		if [ -f "${DIR}/deploy/disk/uImage_bak" ] ; then
			sudo rm -f "${DIR}/deploy/disk/uImage_bak" || true
		fi

		if [ -f "${DIR}/deploy/disk/uImage" ] ; then
			sudo mv "${DIR}/deploy/disk/uImage" "${DIR}/deploy/disk/uImage_bak"
			sudo mkimage -A arm -O linux -T kernel -C none -a ${ZRELADDR} -e ${ZRELADDR} -n ${KERNEL_UTS} -d "${DIR}/deploy/${KERNEL_UTS}.zImage" "${DIR}/deploy/disk/uImage"
		fi

		if [ -f "${DIR}/deploy/disk/zImage_bak" ] ; then
			sudo rm -f "${DIR}/deploy/disk/zImage_bak" || true
		fi

		if [ -f "${DIR}/deploy/disk/zImage" ] ; then
			sudo mv "${DIR}/deploy/disk/zImage" "${DIR}/deploy/disk/zImage_bak"
		fi

		sudo cp -v "${DIR}/deploy/${KERNEL_UTS}.zImage" "${DIR}/deploy/disk/zImage"

		cd "${DIR}/deploy/disk"
		sync
		sync
		cd -
		sudo umount "${DIR}/deploy/disk" || true
		mmc_find_rootfs
	else
		echo "-----------------------------"
		echo "ERROR: Unable to mount ${MMC}${PARTITION_PREFIX}${BOOT_PARITION} at "${DIR}/deploy/disk/" to copy uImage..."
		echo "Please retry running the script, sometimes rebooting your system helps."
		echo "-----------------------------"
	fi
}

unmount_partitions () {
	echo ""
	echo "Unmounting Partitions"
	echo "-----------------------------"

	NUM_MOUNTS=$(mount | grep -v none | grep "${MMC}" | wc -l)

	for (( c=1; c<=${NUM_MOUNTS}; c++ ))
	do
		DRIVE=$(mount | grep -v none | grep "${MMC}" | tail -1 | awk '{print $1}')
		sudo umount ${DRIVE} &> /dev/null || true
	done

	mkdir -p "${DIR}/deploy/disk/"
	mmc_write_boot
}

check_mmc () {
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
		[ "${REPLY}" == "y" ] && unmount_partitions
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
			KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )
			if [ "x${MMC}" == "x" ] ; then
				echo "ERROR: MMC is not defined in system.sh"
			else
				unset PARTITION_PREFIX
				if [[ "${MMC}" =~ "mmcblk" ]] ; then
					PARTITION_PREFIX="p"
				fi
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

