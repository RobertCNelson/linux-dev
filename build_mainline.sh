#!/bin/bash -e

unset BUILD
unset CC
unset LINUX_GIT
unset BISECT
unset NO_DEVTMPS
unset LATEST_GIT

unset LOCAL_PATCH_DIR

ARCH=$(uname -m)
CCACHE=ccache

DIR=$PWD

CORES=1
if test "-$ARCH-" = "-x86_64-" || test "-$ARCH-" = "-i686-"
then
 CORES=$(cat /proc/cpuinfo | grep processor | wc -l)
 let CORES=$CORES+1
fi

mkdir -p ${DIR}/deploy/

function git_mirror {
  #Encase linux-2.6-stable or linus tree's are behind on kernel.org
  echo "Pulling from github.com mirror of linux.git tree"
  git pull git://github.com/torvalds/linux.git master --tags
  echo "Pulling from kernel.org linux.git tree"
  git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master --tags
}

function git_kernel {

  cd ${LINUX_GIT}/
  git fetch
  cd -

  if [[ ! -a ${DIR}/KERNEL ]]; then
    git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
  fi

  cd ${DIR}/KERNEL

  git reset --hard
  git checkout master -f
  git pull

  git_mirror

  git branch -D TOT || true
  git checkout origin/master -b TOT

  git describe

  cd ${DIR}/
}

function git_bisect {
        cd ${DIR}/KERNEL

        git bisect start
        git bisect bad v2.6.35-rc2
        git bisect good v2.6.35-rc1
#        git bisect good <>

read -p "bisect look good... (y/n)? "
[ "$REPLY" == "y" ] || exit

        cd ${DIR}/
}

function patch_kernel {
        cd ${DIR}/KERNEL

        cd ${DIR}/
}

function defconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} distclean
	make ARCH=arm CROSS_COMPILE=${CC} omap2plus_defconfig
	cd ${DIR}/
}

function make_menuconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} menuconfig
	cd ${DIR}/
}

function make_zImage {
        cd ${DIR}/KERNEL/
        echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" CONFIG_DEBUG_SECTION_MISMATCH=y zImage"
        time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" CONFIG_DEBUG_SECTION_MISMATCH=y zImage
        KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
        cp arch/arm/boot/zImage ${DIR}/deploy/${KERNEL_UTS}.zImage
        cd ${DIR}
}

function make_modules {
	cd ${DIR}/KERNEL/
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" CONFIG_DEBUG_SECTION_MISMATCH=y modules

	echo ""
	echo "Building Module Archive"
	echo ""

	rm -rf ${DIR}/deploy/mod &> /dev/null || true
	mkdir -p ${DIR}/deploy/mod
	make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/mod
	echo "Building ${KERNEL_UTS}-modules.tar.gz"
	cd ${DIR}/deploy/mod
	tar czf ../${KERNEL_UTS}-modules.tar.gz *
	cd ${DIR}
}

function make_headers {
	cd ${DIR}/KERNEL/

	echo ""
	echo "Building Header Archive"
	echo ""

	rm -rf ${DIR}/deploy/headers &> /dev/null || true
	mkdir -p ${DIR}/deploy/headers/usr
	make ARCH=arm CROSS_COMPILE=${CC} headers_install INSTALL_HDR_PATH=${DIR}/deploy/headers/usr
	cd ${DIR}/deploy/headers
	echo "Building ${KERNEL_UTS}-headers.tar.gz"
	tar czf ../${KERNEL_UTS}-headers.tar.gz *
	cd ${DIR}
}

	/bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }
if [ -e ${DIR}/system.sh ]; then
	. system.sh
	. version.sh
if [ "-${LINUX_GIT}-" != "--" ]; then

if [ "${IS_LUCID}" ] ; then
	echo ""
	echo "IS_LUCID setting in system.sh is Depreciated"
	echo ""
fi

if [ "${LATEST_GIT}" ] ; then
	echo ""
	echo "Warning LATEST_GIT is enabled from system.sh i hope you know what your doing.."
	echo ""
fi

if [ "${NO_DEVTMPS}" ] ; then
	echo ""
	echo "Building for Debian Lenny & Ubuntu 9.04/9.10"
	echo ""
else
	echo ""
	echo "Building for Debian Squeeze/Wheezy/Sid & Ubuntu 10.04/10.10/11.04/11.10"
	echo ""
fi

	git_kernel
	#git_bisect
	#patch_kernel
	defconfig
	make_menuconfig
	make_zImage
	make_modules
	make_headers
else
	echo "The LINUX_GIT variable is not definted in system.sh"
	echo "Follow the git clone directions in system.sh.sample"
	echo "and make sure to remove the comment # from LINUX_GIT"
	echo "gedit system.sh"
fi
else
	echo "Missing system.sh, please copy system.sh.sample to system.sh and edit as needed"
	echo "cp system.sh.sample system.sh"
	echo "gedit system.sh"
fi

