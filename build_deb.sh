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

unset KERNEL_REL
unset STABLE_PATCH
unset RC_KERNEL
unset RC_PATCH
unset BUILD
unset CC
unset LINUX_GIT
unset LATEST_GIT
unset DEBARCH

unset LOCAL_PATCH_DIR

config="omap2plus_defconfig"

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

function git_kernel_torvalds {
  echo "pulling from torvalds kernel.org tree"
  git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master --tags || true
}

function git_kernel_stable {
  echo "fetching from stable kernel.org tree"
  git pull git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master --tags || true
}

function git_kernel {
	if [ -f ${LINUX_GIT}/.git/config ] ; then
		cd ${LINUX_GIT}/
		echo "Updating LINUX_GIT tree via: git fetch"
		git fetch
		cd -

		if [ ! -f ${DIR}/KERNEL/.git/config ] ; then
			rm -rf ${DIR}/KERNEL/ || true
			git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
		fi

		cd ${DIR}/KERNEL/

		git reset --hard
		git checkout master -f
		git pull

		if [ ! "${LATEST_GIT}" ] ; then
			if [ "${RC_PATCH}" ] ; then
				git tag | grep v${RC_KERNEL}${RC_PATCH} || git_kernel_torvalds
				git branch -D v${RC_KERNEL}${RC_PATCH}-${BUILD} || true
				git checkout v${RC_KERNEL}${RC_PATCH} -b v${RC_KERNEL}${RC_PATCH}-${BUILD}
			elif [ "${STABLE_PATCH}" ] ; then
				git tag | grep v${KERNEL_REL}.${STABLE_PATCH} || git_kernel_stable
				git branch -D v${KERNEL_REL}.${STABLE_PATCH}-${BUILD} || true
				git checkout v${KERNEL_REL}.${STABLE_PATCH} -b v${KERNEL_REL}.${STABLE_PATCH}-${BUILD}
			else
				git tag | grep v${KERNEL_REL} | grep -v rc || git_kernel_torvalds
				git branch -D v${KERNEL_REL}-${BUILD} || true
				git checkout v${KERNEL_REL} -b v${KERNEL_REL}-${BUILD}
			fi
		else
			git branch -D top-of-tree || true
			git checkout v${KERNEL_REL} -b top-of-tree
			git describe
			git pull git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master || true
		fi

		git describe

		cd ${DIR}/
	else
		echo ""
		echo "ERROR: LINUX_GIT variable in system.sh seems invalid, i'm not finding a valid git tree..."
		echo ""
		echo "Quick Fix:"
		echo "example: cd ~/"
		echo "example: git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
		echo "example: Set: LINUX_GIT=~/linux-stable/ in system.sh"
		echo ""
		exit
	fi
}

function patch_kernel {
	cd ${DIR}/KERNEL
	export DIR
	/bin/bash -e ${DIR}/patch.sh || { git add . ; exit 1 ; }

	git add .
	if [ "${RC_PATCH}" ] ; then
		git commit --allow-empty -a -m ''$RC_KERNEL''$RC_PATCH'-'$BUILD' patchset'
	elif [ "${STABLE_PATCH}" ] ; then
		git commit --allow-empty -a -m ''$KERNEL_REL'.'$STABLE_PATCH'-'$BUILD' patchset'
	else
		git commit --allow-empty -a -m ''$KERNEL_REL'-'$BUILD' patchset'
	fi

#Test Patches:
#exit

	if [ "${LOCAL_PATCH_DIR}" ] ; then
		for i in ${LOCAL_PATCH_DIR}/*.patch ; do patch  -s -p1 < $i ; done
		BUILD+='+'
	fi

	cd ${DIR}/
}

function copy_defconfig {
  cd ${DIR}/KERNEL/
  make ARCH=arm CROSS_COMPILE=${CC} distclean
  make ARCH=arm CROSS_COMPILE=${CC} ${config}
  cp -v .config ${DIR}/patches/ref_${config}
  cp -v ${DIR}/patches/defconfig .config
  cd ${DIR}/
}

function make_menuconfig {
  cd ${DIR}/KERNEL/
  make ARCH=arm CROSS_COMPILE=${CC} menuconfig
  cp -v .config ${DIR}/patches/defconfig
  cd ${DIR}/
}

function make_deb {
  cd ${DIR}/KERNEL/
  echo "make -j${CORES} ARCH=arm KBUILD_DEBARCH=${DEBARCH} LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" KDEB_PKGVERSION=${BUILDREV}${DISTRO} deb-pkg"
  time fakeroot make -j${CORES} ARCH=arm KBUILD_DEBARCH=${DEBARCH} LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" KDEB_PKGVERSION=${BUILDREV}${DISTRO} deb-pkg
  mv ${DIR}/*.deb ${DIR}/deploy/
  cd ${DIR}/
}

  /bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ -e ${DIR}/system.sh ]; then
  . system.sh
  . version.sh
	GCC="gcc"
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		GCC="${GCC_OVERRIDE}"
	fi
	echo ""
	echo "Using : $(LC_ALL=C ${CC}${GCC} --version)"
	echo ""

if [ "${LATEST_GIT}" ] ; then
	echo ""
	echo "Warning LATEST_GIT is enabled from system.sh I hope you know what your doing.."
	echo ""
fi

  git_kernel
  patch_kernel
  copy_defconfig
  make_menuconfig
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)gcc:CROSS_COMPILE)'$GCC_OVERRIDE':g' ${DIR}/KERNEL/Makefile
	fi
  make_deb
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)'$GCC_OVERRIDE':CROSS_COMPILE)gcc:g' ${DIR}/KERNEL/Makefile
	fi
else
  echo ""
  echo "ERROR: Missing (your system) specific system.sh, please copy system.sh.sample to system.sh and edit as needed."
  echo ""
  echo "example: cp system.sh.sample system.sh"
  echo "example: gedit system.sh"
  echo ""
fi

