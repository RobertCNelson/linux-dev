#!/bin/bash -e

#opensuse support added by: Antonio Cavallo
#https://launchpad.net/~a.cavallo

function warning { echo "! $@" >&2; }
function error { echo "* $@" >&2; exit 1; }
function info { echo "+ $@" >&2; }
function ltrim { echo "$1" | awk '{ gsub(/^[ \t]+/,"", $0); print $0}'; }
function rtrim { echo "$1" | awk '{ gsub(/[ \t]+$/,"", $0); print $0}'; }
function trim { local x="$( ltrim "$1")"; x="$( rtrim "$x")"; echo "$x"; }



function detect_host {
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
	REV=""
    echo "debian-$REV"
fi

}

function redhat_reqs
{
	echo "RH Not implemented yet"
}

function suse_regs
{
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

function debian_regs
{
	unset deb_pkgs
	dpkg -l | grep build-essential >/dev/null || deb_pkgs+="build-essential "
	dpkg -l | grep ccache >/dev/null || deb_pkgs+="ccache "
	dpkg -l | grep device-tree-compiler >/dev/null || deb_pkgs+="device-tree-compiler "
	dpkg -l | grep lsb-release >/dev/null || deb_pkgs+="lsb-release "
	dpkg -l | grep lzma >/dev/null || deb_pkgs+="lzma "
	dpkg -l | grep fakeroot >/dev/null || deb_pkgs+="fakeroot "

	#Lucid -> Oneiric
	if [ ! -f "/usr/lib/libncurses.so" ] ; then
		#Precise ->
		if [ ! -f "/usr/lib/`dpkg-architecture -qDEB_HOST_MULTIARCH 2>/dev/null`/libncurses.so" ] ; then
			deb_pkgs+="libncurses5-dev "
		else
		echo "-----------------------------"
			echo "Debug: found libncurses.so: /usr/lib/`dpkg-architecture -qDEB_HOST_MULTIARCH 2>/dev/null`/libncurses.so"
		echo "-----------------------------"
		fi
	else
		echo "-----------------------------"
		echo "Debug: found libncurses.so: /usr/lib/libncurses.so"
		echo "-----------------------------"
	fi

	#lsb_release might not be installed...
	if [ $(which lsb_release) ] ; then
		deb_distro=$(lsb_release -cs)

		#mkimage
		case "${deb_distro}" in
		squeeze|lucid|maverick)
			dpkg -l | grep uboot-mkimage >/dev/null || deb_pkgs+="uboot-mkimage "
			;;
		wheezy|natty|oneiric|precise|quantal|raring)
			dpkg -l | grep u-boot-tools >/dev/null || deb_pkgs+="u-boot-tools "
			;;
		esac

		cpu_arch=$(uname -m)
		if [ "x${cpu_arch}" == "xx86_64" ] ; then
			case "${deb_distro}" in
			squeeze|wheezy|lucid|maverick|natty|oneiric|precise|quantal|raring)
				dpkg -l | grep ia32-libs >/dev/null || deb_pkgs+="ia32-libs "
				;;
			esac
		fi

	fi

	if [ "${deb_pkgs}" ] ; then
		echo "Missing Dependicies: Please Install"
		echo "-----------------------------"
		echo "Ubuntu/Debian"
		echo "sudo apt-get install ${deb_pkgs}"
		echo "-----------------------------"
		return 1
	fi
}

BUILD_HOST=${BUILD_HOST:="$( detect_host )"}
info "Detected build host [$BUILD_HOST]"
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

