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
unset PACKAGE
unset APT

if [ ! $(dpkg -l | grep build-essential | awk '{print $2}') ] ; then
	echo "Missing build-essential"
	UPACKAGE="build-essential "
	DPACKAGE="build-essential "
	APT=1
fi

if [ ! $(which mkimage) ];then
 echo "Missing uboot-mkimage"
 UPACKAGE="u-boot-tools "
 DPACKAGE="uboot-mkimage "
 APT=1
fi

if [ ! $(which ccache) ];then
 echo "Missing ccache"
 UPACKAGE+="ccache "
 DPACKAGE+="ccache "
 APT=1
fi

if [ ! $(which dtc) ];then
 echo "Missing device-tree-compiler"
 UPACKAGE+="device-tree-compiler "
 DPACKAGE+="device-tree-compiler "
 APT=1
fi

#Note: Without dpkg-dev from build-essential, this can be a false positive
MULTIARCHLIB="/usr/lib/`dpkg-architecture -qDEB_HOST_MULTIARCH 2>/dev/null`"

#oneiric is multiarch, but libncurses.so is under /usr/lib
CHECK_ONEIRIC=$(lsb_release -c | grep oneiric | awk '{print $2}' 2>/dev/null)
if [ "x${CHECK_ONEIRIC}" == "xoneiric" ] ; then
	MULTIARCHLIB="/usr/lib/"
fi

if [ ! -f ${MULTIARCHLIB}/libncurses.so ] ; then
	echo "Missing ncurses"
	UPACKAGE+="libncurses5-dev "
	DPACKAGE+="libncurses5-dev "
	APT=1
fi

if [ "${APT}" ];then
 echo "Missing Dependicies"
 echo "Ubuntu: please install: sudo aptitude install ${UPACKAGE}"
 echo "Debian: please install: sudo aptitude install ${DPACKAGE}"
 echo "---------------------------------------------------------"
 return 1
fi
}

LC_ALL=C git --version

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

