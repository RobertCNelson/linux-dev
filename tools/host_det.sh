#!/bin/sh -e

#opensuse support added by: Antonio Cavallo
#https://launchpad.net/~a.cavallo

warning () { echo "! $@" >&2; }
error () { echo "* $@" >&2; exit 1; }
info () { echo "+ $@" >&2; }
ltrim () { echo "$1" | awk '{ gsub(/^[ \t]+/,"", $0); print $0}'; }
rtrim () { echo "$1" | awk '{ gsub(/[ \t]+$/,"", $0); print $0}'; }
trim () { local x="$( ltrim "$1")"; x="$( rtrim "$x")"; echo "$x"; }

detect_host () {
	local REV DIST PSEUDONAME

	if [ -f /etc/redhat-release ] ; then
		DIST='RedHat'
		PSEUDONAME=$(cat /etc/redhat-release | sed s/.*\(// | sed s/\)//)
		REV=$(cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//)
		echo "redhat-$REV"
	elif [ -f /etc/SuSE-release ] ; then
		DIST=$(cat /etc/SuSE-release | tr "\n" ' '| sed s/VERSION.*//)
		REV=$(cat /etc/SuSE-release | tr "\n" ' ' | sed s/.*=\ //)
		trim "suse-$REV"
	elif [ -f /etc/debian_version ] ; then
		DIST="Debian Based"
		debian="debian"
		echo "${debian}"
	fi
}

redhat_reqs () {
	echo "RH Not implemented yet"
}

suse_regs () {
    local BUILD_HOST="$1"   
# --- SuSE-release ---
    if [ ! -f /etc/SuSE-release ]
    then
        cat >&2 <<@@
Missing /etc/SuSE-release file
 this file is part of the efault suse system. If this is a
 suse system for real, please install the package with:
    
    zypper install openSUSE-release   
@@
        return 1
    fi


# --- patch ---
    if [ ! $( which patch ) ]
    then
        cat >&2 <<@@
Missing patch command,
 it is part of the opensuse $BUILD_HOST distribution so it can be 
 installed simply using:

    zypper install patch

@@
        return 1
    fi

# --- mkimage ---
    if [ ! $( which mkimage ) ]
    then
        cat >&2 <<@@
Missing mkimage command.
 This command is part of a package not provided directly from
 opensuse. It can be found under several places for suse.
 There are two ways to install the package: either using a rpm
 or using a repo.
 In the second case these are the command to issue in order to 
 install it:

    zypper addrepo -f http://download.opensuse.org/repositories/home:/jblunck:/beagleboard/openSUSE_11.2
    zypper install uboot-mkimage

@@
        return 1
    fi
    
}

debian_regs () {
	unset deb_pkgs
	dpkg -l | grep bc >/dev/null || deb_pkgs"${deb_pkgs}bc "
	dpkg -l | grep build-essential >/dev/null || deb_pkgs="${deb_pkgs}build-essential "
	dpkg -l | grep device-tree-compiler >/dev/null || deb_pkgs="${deb_pkgs}device-tree-compiler "
	dpkg -l | grep lsb-release >/dev/null || deb_pkgs="${deb_pkgs}lsb-release "
	dpkg -l | grep lzma >/dev/null || deb_pkgs="${deb_pkgs}lzma "
	dpkg -l | grep lzop >/dev/null || deb_pkgs="${deb_pkgs}lzop "
	dpkg -l | grep fakeroot >/dev/null || deb_pkgs="${deb_pkgs}fakeroot "

	unset warn_dpkg_ia32
	#lsb_release might not be installed...
	if [ $(which lsb_release) ] ; then
		deb_distro=$(lsb_release -cs)

		#Linux Mint: Compatibility Matrix
		#http://www.linuxmint.com/oldreleases.php
		case "${deb_distro}" in
		debian)
			deb_distro="jessie"
			;;
		maya)
			deb_distro="precise"
			;;
		nadia)
			deb_distro="quantal"
			;;
		olivia)
			deb_distro="raring"
			;;
		esac

		case "${deb_distro}" in
		squeeze|wheezy|jessie|sid)
			unset error_unknown_deb_distro
			unset warn_eol_distro
			;;
		lucid|precise|quantal|raring|saucy)
			unset error_unknown_deb_distro
			unset warn_eol_distro
			;;
		natty|oneiric)
			#http://us.archive.ubuntu.com/ubuntu/dists/
			#Still list the "prior" one as some people dont upgrade very fast...
			unset error_unknown_deb_distro
			warn_eol_distro=1
			;;
		*)
			error_unknown_deb_distro=1
			unset warn_eol_distro
			;;
		esac

		#pkg: mkimage
		case "${deb_distro}" in
		squeeze|lucid)
			dpkg -l | grep uboot-mkimage >/dev/null || deb_pkgs="${deb_pkgs}uboot-mkimage"
			;;
		wheezy|jessie|sid|precise|quantal|raring|saucy)
			dpkg -l | grep u-boot-tools >/dev/null || deb_pkgs="${deb_pkgs}u-boot-tools"
			;;
		esac

		#pkg: libncurses5-dev
		case "${deb_distro}" in
		precise)
			#ii  libncurses5-dev  5.9-4  developer's libraries for ncurses
			dpkg -l | grep libncurses5-dev >/dev/null || deb_pkgs="${deb_pkgs}libncurses5-dev "
			;;
		*)
			#ii  libncurses5-dev:amd64  5.9+20130504-1  amd64  developer's libraries for ncurses
			deb_arch=$(dpkg --print-architecture)
			dpkg -l | grep libncurses5-dev | grep ${deb_arch} >/dev/null || deb_pkgs="${deb_pkgs}libncurses5-dev "
			;;
		esac

		#pkg: ia32-libs
		cpu_arch=$(uname -m)
		if [ "x${cpu_arch}" = "xx86_64" ] ; then
			unset dpkg_multiarch
			case "${deb_distro}" in
			squeeze|lucid|natty|oneiric|precise)
				dpkg -l | grep ia32-libs >/dev/null || deb_pkgs="${deb_pkgs}ia32-libs "
				;;
			wheezy|jessie|sid|quantal|raring|saucy)
				dpkg -l | grep ia32-libs >/dev/null || deb_pkgs="${deb_pkgs}ia32-libs "
				dpkg -l | grep ia32-libs >/dev/null || dpkg_multiarch=1
				;;
			esac

			if [ "${dpkg_multiarch}" ] ; then
				unset check_foreign
				check_foreign=$(LC_ALL=C dpkg --print-foreign-architectures)
				if [ "x" = "x${check_foreign}" ] ; then
					warn_dpkg_ia32=1
				fi
			fi
		fi
	fi

	if [ "${warn_eol_distro}" ] ; then
		echo "End Of Life (EOL) deb based distro detected."
		echo "Dependency check skipped, you are on your own."
		echo "-----------------------------"
		unset deb_pkgs
	fi

	if [ "${error_unknown_deb_distro}" ] ; then
		echo "Unrecognized deb based system:"
		echo "-----------------------------"
		echo "Please cut, paste and email to: bugs@rcn-ee.com"
		echo "-----------------------------"
		echo "uname -m"
		uname -m
		echo "lsb_release -a"
		lsb_release -a
		echo "-----------------------------"
		return 1
	fi

	if [ "${deb_pkgs}" ] ; then
		echo "Debian/Ubuntu/Mint: missing dependicies, please install:"
		echo "-----------------------------"
		if [ "${warn_dpkg_ia32}" ] ; then
			echo "sudo dpkg --add-architecture i386"
		fi
		echo "sudo apt-get update"
		echo "sudo apt-get install ${deb_pkgs}"
		echo "-----------------------------"
		return 1
	fi
}

BUILD_HOST=${BUILD_HOST:="$( detect_host )"}
if [ $(which lsb_release) ] ; then
	info "Detected build host [`lsb_release -sd`]"
else
	info "Detected build host [$BUILD_HOST]"
fi
case "$BUILD_HOST" in
    redhat*)
	    redhat_reqs
        ;;
    debian*)
	    debian_regs || error "Failed dependency check"
        ;;
    suse*)
	    suse_regs "$BUILD_HOST" || error "Failed dependency check"
        ;;
esac

