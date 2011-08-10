#!/bin/bash -e
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
	sudo rm -rfd ${DIR}/deploy/disk/lib/modules/${KERNEL_UTS}

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

