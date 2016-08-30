#!/bin/sh -e
#
# Copyright (c) 2009-2016 Robert Nelson <robertcnelson@gmail.com>
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
CORES=$(getconf _NPROCESSORS_ONLN)
debian_stable_git="2.1.4"
#git hard requirements:
#git: --local
#git: --list
#git: --no-edit

build_git () {
	echo "-----------------------------"
	echo "scripts/git: git is too old: [`LC_ALL=C ${git_bin} --version | awk '{print $3}'`], building and installing: [${debian_stable_git}] to /usr/local/"

	wget --quiet -c --directory-prefix="${DIR}/ignore/" https://www.kernel.org/pub/software/scm/git/git-${debian_stable_git}.tar.gz
	if [ -f "${DIR}/ignore/git-${debian_stable_git}.tar.gz" ] ; then
		cd "${DIR}/ignore/" || true
		tar xf git-${debian_stable_git}.tar.gz
		if [ -d git-${debian_stable_git} ] ; then
			cd ./git-${debian_stable_git}/ || true
			echo "scripts/git: building: [${debian_stable_git}]"

			echo "scripts/git: [make -j${CORES} prefix=/usr/local all]"
			make -j${CORES} prefix=/usr/local all >/dev/null 2>&1

			echo "scripts/git: [sudo make prefix=/usr/local install]"
			sudo make prefix=/usr/local install >/dev/null 2>&1

			cd "${DIR}/ignore/" || true
			rm -rf git-${debian_stable_git}/ || true
			git_bin=$(which git)
		else
			echo "scripts/git: failure to build: git-${debian_stable_git}.tar.gz"
			exit 2
		fi
	else
		echo "scripts/git: failure to download: git-${debian_stable_git}.tar.gz"
		exit 2
	fi
}

git_kernel_stable () {
	echo "-----------------------------"
	echo "scripts/git: fetching from: ${linux_stable}"
	${git_bin} fetch "${linux_stable}" master --tags || true
}

git_kernel_torvalds () {
	echo "-----------------------------"
	echo "scripts/git: pulling from: ${torvalds_linux}"
	${git_bin} pull --no-edit "${torvalds_linux}" master --tags || true
	${git_bin} tag | grep v"${KERNEL_TAG}" >/dev/null 2>&1 || git_kernel_stable
}

check_and_or_clone () {
	#For Legacy: moving to "${DIR}/ignore/linux-src/" for all new installs
	if [ ! "${LINUX_GIT}" ] && [ -f "${HOME}/linux-src/.git/config" ] ; then
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
			${git_bin} clone "${torvalds_linux}" "${DIR}/ignore/linux-src"
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

	cd "${LINUX_GIT}/" || exit
	echo "-----------------------------"
	echo "scripts/git: Debug: LINUX_GIT is setup as: [${LINUX_GIT}]."
	echo "scripts/git: [$(cat .git/config | grep url | sed 's/\t//g' | sed 's/ //g')]"
	${git_bin} fetch || true
	echo "-----------------------------"
	cd "${DIR}/" || exit

	if [ ! -f "${DIR}/KERNEL/.git/config" ] ; then
		rm -rf "${DIR}/KERNEL/" || true
		${git_bin} clone --shared "${LINUX_GIT}" "${DIR}/KERNEL"
	fi

	#Automaticly, just recover the git repo from a git crash
	if [ -f "${DIR}/KERNEL/.git/index.lock" ] ; then
		rm -rf "${DIR}/KERNEL/" || true
		${git_bin} clone --shared "${LINUX_GIT}" "${DIR}/KERNEL"
	fi

	cd "${DIR}/KERNEL/" || exit

	#Debian Jessie: git version 2.0.0.rc0
	#Disable git's default setting of running `git gc --auto` in the background as the patch.sh script can fail.
	${git_bin} config --local --list | grep gc.autodetach >/dev/null 2>&1 || ${git_bin} config --local gc.autodetach 0

	#disable git's auto Cleanup, ./KERNEL is a throw away branch...
	${git_bin} config --local --list | grep gc.auto >/dev/null 2>&1 || ${git_bin} config --local gc.auto 0

	if [ ! "${git_config_user_email}" ] ; then
		${git_bin} config --local user.email you@example.com
	fi

	if [ ! "${git_config_user_name}" ] ; then
		${git_bin} config --local user.name "Your Name"
	fi

	if [ "${RUN_BISECT}" ] ; then
		${git_bin} bisect reset || true
	fi

	${git_bin} am --abort || echo "${git_bin} tree is clean..."
	${git_bin} add --all
	${git_bin} commit --allow-empty -a -m 'empty cleanup commit'

	${git_bin} reset --hard HEAD
	${git_bin} checkout master -f

	${git_bin} pull --no-edit || true

	${git_bin} tag | grep "v${KERNEL_TAG}" | grep -v rc >/dev/null 2>&1 || git_kernel_torvalds

	if [ "${KERNEL_SHA}" ] ; then
		git_kernel_torvalds
	fi

	test_for_branch=$(${git_bin} branch --list "v${KERNEL_TAG}${BUILD}")
	if [ "x${test_for_branch}" != "x" ] ; then
		${git_bin} branch "v${KERNEL_TAG}${BUILD}" -D
	fi

	if [ ! "${KERNEL_SHA}" ] ; then
		${git_bin} checkout "v${KERNEL_TAG}" -b "v${KERNEL_TAG}${BUILD}"
	else
		${git_bin} checkout "${KERNEL_SHA}" -b "v${KERNEL_TAG}${BUILD}"
	fi

	if [ "${TOPOFTREE}" ] ; then
		${git_bin} pull --no-edit "${torvalds_linux}" master || true
		${git_bin} pull --no-edit "${torvalds_linux}" master --tags || true
	fi

	${git_bin} describe

	cd "${DIR}/" || exit
}

git_shallow () {
	if [ "x${kernel_tag}" = "x" ] ; then
		echo "error: set kernel_tag in recipe.sh"
		exit 2
	fi
	if [ ! -f "${DIR}/KERNEL/.ignore-${kernel_tag}" ] ; then
		if [ -d "${DIR}/KERNEL/" ] ; then
			rm -rf "${DIR}/KERNEL/" || true
		fi
		mkdir "${DIR}/KERNEL/" || true
		echo "git: [git clone -b ${kernel_tag} https://github.com/RobertCNelson/linux-stable-rcn-ee]"
		${git_bin} clone --depth=100 -b ${kernel_tag} https://github.com/RobertCNelson/linux-stable-rcn-ee "${DIR}/KERNEL/"
		touch "${DIR}/KERNEL/.ignore-${kernel_tag}"
	fi
}

. "${DIR}/version.sh"
. "${DIR}/system.sh"

git_bin=$(which git)

git_major=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f1)
git_minor=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f2)
git_sub=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f3)

#debian Stable:
#https://packages.debian.org/stable/git -> 2.1.4

compare_major="2"
compare_minor="1"
compare_sub="4"

if [ "${git_major}" -lt "${compare_major}" ] ; then
	build_git
elif [ "${git_major}" -eq "${compare_major}" ] ; then
	if [ "${git_minor}" -lt "${compare_minor}" ] ; then
		build_git
	elif [ "${git_minor}" -eq "${compare_minor}" ] ; then
		if [ "${git_sub}" -lt "${compare_sub}" ] ; then
			build_git
		fi
	fi
fi

echo "scripts/git: [`LC_ALL=C ${git_bin} --version`]"

unset git_config_user_email
git_config_user_email=$(${git_bin} config --global --get user.email || true)
if [ ! "${git_config_user_email}" ] ; then
	${git_bin} config --local user.email you@example.com
fi

unset git_config_user_name
git_config_user_name=$(${git_bin} config --global --get user.name || true)
if [ ! "${git_config_user_name}" ] ; then
	${git_bin} config --local user.name "Your Name"
fi

torvalds_linux="https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git"
linux_stable="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"

if [ ! -f "${DIR}/.yakbuild" ] ; then
	git_kernel
else
	. "${DIR}/recipe.sh"
	git_shallow
fi

#
