#!/bin/sh -e
#
# Copyright (c) 2009-2015 Robert Nelson <robertcnelson@gmail.com>
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

DIR=$PWD

. "${DIR}/version.sh"

mmc_write_rootfs () {
	echo "Installing ${KERNEL_UTS}-modules.tar.gz"

	if [ -d "${location}/lib/modules/${KERNEL_UTS}" ] ; then
		sudo rm -rf "${location}/lib/modules/${KERNEL_UTS}" || true
	fi

	sudo tar xf "${DIR}/deploy/${KERNEL_UTS}-modules.tar.gz" -C "${location}/"
	sync

	if [ -f "${DIR}/deploy/config-${KERNEL_UTS}" ] ; then
		if [ -f "${location}/boot/config-${KERNEL_UTS}" ] ; then
			sudo rm -f "${location}/boot/config-${KERNEL_UTS}" || true
		fi
		sudo cp -v "${DIR}/deploy/config-${KERNEL_UTS}" "${location}/boot/config-${KERNEL_UTS}"
		sync
	fi
	sudo update-initramfs -ck "${KERNEL_UTS}"
	echo "info: [${KERNEL_UTS}] now installed..."
}

mmc_write_boot_uname () {
	echo "Installing ${KERNEL_UTS}"

	if [ -f "${location}/vmlinuz-${KERNEL_UTS}_bak" ] ; then
		sudo rm -f "${location}/vmlinuz-${KERNEL_UTS}_bak" || true
	fi

	if [ -f "${location}/vmlinuz-${KERNEL_UTS}" ] ; then
		sudo mv "${location}/vmlinuz-${KERNEL_UTS}" "${location}/vmlinuz-${KERNEL_UTS}_bak"
	fi

	sudo cp -v "${DIR}/deploy/${KERNEL_UTS}.zImage" "${location}/vmlinuz-${KERNEL_UTS}"

	if [ -f "${location}/initrd.img-${KERNEL_UTS}" ] ; then
		sudo rm -rf "${location}/initrd.img-${KERNEL_UTS}" || true
	fi

	if [ -f "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" ] ; then
		if [ -d "${location}/dtbs/${KERNEL_UTS}_bak/" ] ; then
			sudo rm -rf "${location}/dtbs/${KERNEL_UTS}_bak/" || true
		fi

		if [ -d "${location}/dtbs/${KERNEL_UTS}/" ] ; then
			sudo mv "${location}/dtbs/${KERNEL_UTS}/" "${location}/dtbs/${KERNEL_UTS}_bak/" || true
		fi

		sudo mkdir -p "${location}/dtbs/${KERNEL_UTS}/"

		echo "Installing ${KERNEL_UTS}-dtbs.tar.gz to ${partition}"
		sudo tar xf "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" -C "${location}/dtbs/${KERNEL_UTS}/"
		sync
	fi

	unset older_kernel
	older_kernel=$(grep uname_r "${location}/uEnv.txt" | grep -v '#' | awk -F"=" '{print $2}' || true)

	if [ ! "x${older_kernel}" = "x" ] ; then
		if [ ! "x${older_kernel}" = "x${KERNEL_UTS}" ] ; then
			sudo sed -i -e 's:uname_r='${older_kernel}':uname_r='${KERNEL_UTS}':g' "${location}/uEnv.txt"
		fi
		echo "info: /boot/uEnv.txt: $(grep uname_r ${location}/uEnv.txt)"
	fi
}

mmc_write_boot () {
	if [ ! -f "${location}/zImage" ] ; then
		echo "Error: no current ${location}/zImage, this might not boot..."
	fi

	echo "Installing ${KERNEL_UTS}"

	if [ -f "${location}/zImage_bak" ] ; then
		sudo rm -f "${location}/zImage_bak" || true
	fi

	if [ -f "${location}/zImage" ] ; then
		sudo mv "${location}/zImage" "${location}/zImage_bak"
	fi

	#Assuming boot via zImage on first partition...
	sudo cp -v "${DIR}/deploy/${KERNEL_UTS}.zImage" "${location}/zImage"

	if [ -f "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" ] ; then

		if [ -d "${location}/dtbs" ] ; then
			sudo rm -rf "${location}/dtbs" || true
		fi

		sudo mkdir -p "${location}/dtbs"

		echo "Installing ${KERNEL_UTS}-dtbs.tar.gz to ${partition}"
		sudo tar xf "${DIR}/deploy/${KERNEL_UTS}-dtbs.tar.gz" -C "${location}/dtbs/"
		sync
	fi
}

if [ -f "${DIR}/system.sh" ] ; then
	. "${DIR}/system.sh"

	if [ -f "${DIR}/KERNEL/arch/arm/boot/zImage" ] ; then
		KERNEL_UTS=$(cat "${DIR}/KERNEL/include/generated/utsrelease.h" | awk '{print $3}' | sed 's/\"//g' )
		if [ -f "/boot/uEnv.txt" ] ; then
			location="/boot/"
			mmc_write_boot_uname
			location=""
			mmc_write_rootfs
			sync

		elif [ -f "/boot/uboot/uEnv.txt" ] ; then
			location="/boot/uboot"
			mmc_write_boot
			location=""
			mmc_write_rootfs
			sync
		else
			echo "ERROR: /boot/uboot/uEnv.txt not found, this is for local install only..."
		fi
	else
		echo "ERROR: arch/arm/boot/zImage not found, Please run build_kernel.sh before running this script..."
	fi
else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

