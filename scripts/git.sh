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

DIR=$PWD

git_kernel_stable () {
	echo "fetching from stable kernel.org tree"
	git fetch git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master --tags || true
}

git_kernel_torvalds () {
	echo "pulling from torvalds kernel.org tree"
	git pull ${GIT_OPTS} git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master --tags || true
	git tag | grep v${KERNEL_TAG} &>/dev/null || git_kernel_stable
}

check_and_or_clone () {
	if [ ! "${LINUX_GIT}" ] ; then
		if [ -f "${HOME}/linux-src/.git/config" ] ; then
			echo "Warning: LINUX_GIT not defined in system.sh, using default location: ${HOME}/linux-src"
		else
			echo "Warning: LINUX_GIT not defined in system.sh, cloning torvalds git tree to default location: ${HOME}/linux-src"
			git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ${HOME}/linux-src
		fi
		LINUX_GIT="${HOME}/linux-src"
	fi
}

git_kernel () {
	check_and_or_clone

	#In the past some users set LINUX_GIT = DIR, fix that...
	if [ -f "${LINUX_GIT}/version.sh" ] ; then
		unset LINUX_GIT
		check_and_or_clone
	fi

	if [ ! -f "${LINUX_GIT}/.git/config" ] ; then
		unset LINUX_GIT
		check_and_or_clone
	fi

	cd ${LINUX_GIT}/
	echo "Debug: LINUX_GIT setup..."
	pwd
	cat .git/config
	echo "Updating LINUX_GIT tree via: git fetch"
	git fetch || true
	cd -

	if [ ! -f ${DIR}/KERNEL/.git/config ] ; then
		rm -rf ${DIR}/KERNEL/ || true
		git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
	fi

	cd ${DIR}/KERNEL/
	#So we are now going to assume the worst, and create a new master branch
	git am --abort || echo "git tree is clean..."
	git add .
	git commit --allow-empty -a -m 'empty cleanup commit'

	git checkout origin/master -b tmp-master
	git branch -D master &>/dev/null || true

	git checkout origin/master -b master
	git branch -D tmp-master &>/dev/null || true

	git pull ${GIT_OPTS} || true

	if [ ! "${LATEST_GIT}" ] ; then
		git tag | grep v${KERNEL_TAG} | grep -v rc &>/dev/null || git_kernel_torvalds
		git branch -D v${KERNEL_TAG}-${BUILD} &>/dev/null || true
		git checkout v${KERNEL_TAG} -b v${KERNEL_TAG}-${BUILD}
	else
		git tag | grep v${KERNEL_TAG} | grep -v rc &>/dev/null || git_kernel_torvalds
		git branch -D top-of-tree &>/dev/null || true
		git checkout v${KERNEL_TAG} -b top-of-tree
		git describe
		git pull ${GIT_OPTS} git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master || true
	fi

	git describe

	cd ${DIR}/
}

source ${DIR}/version.sh
git_kernel

