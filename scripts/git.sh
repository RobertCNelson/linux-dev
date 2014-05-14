#!/bin/sh -e
#
# Copyright (c) 2009-2014 Robert Nelson <robertcnelson@gmail.com>
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
	echo "-----------------------------"
	echo "scripts/git: fetching from: ${linux_stable}"
	git fetch ${linux_stable} master --tags || true
}

git_kernel_torvalds () {
	echo "-----------------------------"
	echo "scripts/git: pulling from: ${torvalds_linux}"
	git pull ${GIT_OPTS} ${torvalds_linux} master --tags || true
	git tag | grep v${KERNEL_TAG} >/dev/null 2>&1 || git_kernel_stable
}

check_and_or_clone () {
	#For Legacy: moving to "${DIR}/ignore/linux-src/" for all new installs
	if [ ! "${LINUX_GIT}" ] && [ -f "${HOME}/linux-src/.git/config" ] ; then
		echo "-----------------------------"
		echo "scripts/git: Warning: LINUX_GIT not defined in system.sh"
		echo "using legacy location: ${HOME}/linux-src"
		LINUX_GIT="${HOME}/linux-src"
	fi

	if [ ! "${LINUX_GIT}" ]; then
		if [ -f "${DIR}/ignore/linux-src/.git/config" ] ; then
			echo "-----------------------------"
			echo "scripts/git: LINUX_GIT not defined in system.sh"
			echo "using default location: ${DIR}/ignore/linux-src/"
		else
			echo "-----------------------------"
			echo "scripts/git: LINUX_GIT not defined in system.sh"
			echo "cloning ${torvalds_linux} into default location: ${DIR}/ignore/linux-src"
			git clone ${torvalds_linux} ${DIR}/ignore/linux-src
		fi
		LINUX_GIT="${DIR}/ignore/linux-src"
	fi
}

git_kernel () {
	check_and_or_clone

	#In the past some users set LINUX_GIT = DIR, fix that...
	if [ -f "${LINUX_GIT}/version.sh" ] ; then
		unset LINUX_GIT
		echo "-----------------------------"
		echo "scripts/git: Warning: LINUX_GIT is set as DIR:"
		check_and_or_clone
	fi

	#is the git directory user writable?
	if [ ! -w "${LINUX_GIT}" ] ; then
		unset LINUX_GIT
		echo "-----------------------------"
		echo "scripts/git: Warning: LINUX_GIT is not writable:"
		check_and_or_clone
	fi

	#is it actually a git repo?
	if [ ! -f "${LINUX_GIT}/.git/config" ] ; then
		unset LINUX_GIT
		echo "-----------------------------"
		echo "scripts/git: Warning: LINUX_GIT is an invalid tree:"
		check_and_or_clone
	fi

	cd ${LINUX_GIT}/
	echo "-----------------------------"
	echo "scripts/git: Debug: LINUX_GIT is setup as..."
	pwd
	echo "-----------------------------"
	cat .git/config
	echo "-----------------------------"
	echo "scripts/git: Updating LINUX_GIT tree via: git fetch"
	git fetch || true
	cd -

	if [ ! -f "${DIR}/KERNEL/.git/config" ] ; then
		rm -rf ${DIR}/KERNEL/ || true
		git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
	fi

	#Automaticly, just recover the git repo from a git crash
	if [ -f "${DIR}/KERNEL/.git/index.lock" ] ; then
		rm -rf ${DIR}/KERNEL/ || true
		git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
	fi

	cd ${DIR}/KERNEL/

	#Debian Jessie: git version 2.0.0.rc0
	#Disable git's default setting of running `git gc --auto` in the background as the patch.sh script can fail.
	git config --local --list | grep gc.autodetach >/dev/null 2>&1 || git config --local gc.autodetach 0

	if [ "${RUN_BISECT}" ] ; then
		git bisect reset || true
	fi

	git am --abort || echo "git tree is clean..."
	git add --all
	git commit --allow-empty -a -m 'empty cleanup commit'

	git reset --hard HEAD
	git checkout master -f

	git pull ${GIT_OPTS} || true

	git tag | grep v${KERNEL_TAG} | grep -v rc >/dev/null 2>&1 || git_kernel_torvalds

	if [ "${KERNEL_SHA}" ] ; then
		git_kernel_torvalds
	fi

	#CentOS 6.4: git version 1.7.1 (no --list option)
	unset git_branch_has_list
	LC_ALL=C git help branch | grep -m 1 -e "--list" >/dev/null 2>&1 && git_branch_has_list=1
	if [ "${git_branch_has_list}" ] ; then
		test_for_branch=$(git branch --list v${KERNEL_TAG}-${BUILD})
		if [ "x${test_for_branch}" != "x" ] ; then
			git branch v${KERNEL_TAG}-${BUILD} -D
		fi
	else
		echo "git: the following error: [error: branch 'v${KERNEL_TAG}-${BUILD}' not found.] is safe to ignore."
		git branch v${KERNEL_TAG}-${BUILD} -D || true
	fi

	if [ ! "${KERNEL_SHA}" ] ; then
		git checkout v${KERNEL_TAG} -b v${KERNEL_TAG}-${BUILD}
	else
		git checkout ${KERNEL_SHA} -b v${KERNEL_TAG}-${BUILD}
	fi

	if [ "${TOPOFTREE}" ] ; then
		git pull ${GIT_OPTS} ${torvalds_linux} master || true
		git pull ${GIT_OPTS} ${torvalds_linux} master --tags || true
	fi

	git describe

	cd ${DIR}/
}

. ${DIR}/version.sh
. ${DIR}/system.sh

unset git_config_user_email
git_config_user_email=$(git config --get user.email || true)

unset git_config_user_name
git_config_user_name=$(git config --get user.name || true)

if [ ! "${git_config_user_email}" ] || [ ! "${git_config_user_name}" ] ; then
	echo "-----------------------------"
	echo "Error: git user.name/user.email not set:"
	echo ""
	echo "For help please read:"
	echo "https://help.github.com/articles/setting-your-username-in-git"
	echo "https://help.github.com/articles/setting-your-email-in-git"
	echo ""
	echo "For example, if your real name and email was: Billy Everteen & me@here.com"
	echo "you would type the following into the terminal window to set it up:"
	echo "-----------------------------"
	echo "git config --global user.name \"Billy Everyteen\""
	echo "git config --global user.email \"me@here.com\""
	echo "-----------------------------"
	exit 1
fi

torvalds_linux="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
linux_stable="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"

git_kernel
