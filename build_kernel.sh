#!/bin/bash -e

unset KERNEL_REL
unset STABLE_PATCH
unset RC_PATCH
unset PRE_RC
unset BUILD
unset CC
unset LINUX_GIT
unset BISECT
unset NO_DEVTMPS

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

function git_remote_add {
        #For some reason after 2.6.36-rc3 linux-2.6-stable hasn't been updated...
        git remote add -t torvalds torvalds_remote git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
        git fetch --tags torvalds_remote master
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
        git fetch
        git checkout master
        git pull

        #git remote | grep torvalds_remote && git fetch --tags torvalds_remote master

        if [ "${PRE_RC}" ]; then
                wget -c --directory-prefix=${DIR}/patches/ http://www.kernel.org/pub/linux/kernel/v2.6/snapshots/patch-${PRE_RC}.bz2
                git branch -D v${PRE_RC}-${BUILD} || true
                git checkout v${KERNEL_REL} -b v${PRE_RC}-${BUILD}
        else if [ "${RC_PATCH}" ]; then
                git tag | grep v${RC_KERNEL}${RC_PATCH} || git_remote_add
                git branch -D v${RC_KERNEL}${RC_PATCH}-${BUILD} || true
                git checkout v${RC_KERNEL}${RC_PATCH} -b v${RC_KERNEL}${RC_PATCH}-${BUILD}
        else if [ "${STABLE_PATCH}" ] ; then
                git branch -D v${KERNEL_REL}.${STABLE_PATCH}-${BUILD} || true
                git checkout v${KERNEL_REL}.${STABLE_PATCH} -b v${KERNEL_REL}.${STABLE_PATCH}-${BUILD}
        else
                git branch -D v${KERNEL_REL}-${BUILD} || true
                git checkout v${KERNEL_REL} -b v${KERNEL_REL}-${BUILD}
        fi
        fi
        fi

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
        if [ "${PRE_RC}" ]; then
                bzip2 -dc ${DIR}/patches/patch-${PRE_RC}.bz2 | patch -p1 -s
                git add .
                git commit -a -m ''$PRE_RC' patchset'
        fi
        export DIR BISECT
        /bin/bash -e ${DIR}/patch.sh || { git add . ; exit 1 ; }
#exit
        git add .
        if [ "${PRE_RC}" ]; then
                git commit -a -m ''$PRE_RC'-'$BUILD' patchset'
        else if [ "${RC_PATCH}" ]; then
                git commit -a -m ''$RC_KERNEL''$RC_PATCH'-'$BUILD' patchset'
        else if [ "${STABLE_PATCH}" ] ; then
                git commit -a -m ''$KERNEL_REL''$STABLE_PATCH'-'$BUILD' patchset'
        else
                git commit -a -m ''$KERNEL_REL'-'$BUILD' patchset'
        fi
        fi
        fi
#exit
        if [ "${LOCAL_PATCH_DIR}" ]; then
                for i in ${LOCAL_PATCH_DIR}/*.patch ; do patch  -s -p1 < $i ; done
                BUILD+='+'
        fi
#exit
        cd ${DIR}/
}

function copy_defconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} distclean
if [ "${NO_DEVTMPS}" ] ; then
	cp ${DIR}/patches/no_devtmps-defconfig .config
else
	cp ${DIR}/patches/defconfig .config
fi
	cd ${DIR}/
}

function make_menuconfig {
	cd ${DIR}/KERNEL/
	make ARCH=arm CROSS_COMPILE=${CC} menuconfig
if [ "${NO_DEVTMPS}" ] ; then
	cp .config ${DIR}/patches/no_devtmps-defconfig
else
	cp .config ${DIR}/patches/defconfig
fi
	cd ${DIR}/
}

function make_uImage {
	cd ${DIR}/KERNEL/
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" CONFIG_DEBUG_SECTION_MISMATCH=y uImage"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" CONFIG_DEBUG_SECTION_MISMATCH=y uImage
	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	cp arch/arm/boot/uImage ${DIR}/deploy/${KERNEL_UTS}.uImage
	cd ${DIR}
}

function make_modules {
	cd ${DIR}/KERNEL/
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" CONFIG_DEBUG_SECTION_MISMATCH=y modules

	echo ""
	echo "Building Module Archive"
	echo ""

	rm -rfd ${DIR}/deploy/mod &> /dev/null || true
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

	rm -rfd ${DIR}/deploy/headers &> /dev/null || true
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

if [ "${IS_LUCID}" ] ; then
	echo ""
	echo "IS_LUCID setting in system.sh is Depreciated"
	echo ""
fi

if [ "${NO_DEVTMPS}" ] ; then
	echo ""
	echo "Building for Debian Lenny & Ubuntu 9.04/9.10"
	echo ""
else
	echo ""
	echo "Building for Debian Squeeze/Sid & Ubuntu 10.04/10.10/11.04"
	echo ""
fi

	git_kernel
	#git_bisect
	patch_kernel
	copy_defconfig
	make_menuconfig
	make_uImage
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

