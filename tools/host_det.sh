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
	pkg="bc"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="build-essential"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="device-tree-compiler"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="fakeroot"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="lsb-release"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="lzma"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
	pkg="lzop"
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "

	unset warn_dpkg_ia32
	unset stop_pkg_search
	#lsb_release might not be installed...
	if [ $(which lsb_release) ] ; then
		deb_distro=$(lsb_release -cs)

		#Linux Mint: Compatibility Matrix
		#http://www.linuxmint.com/oldreleases.php
		case "${deb_distro}" in
		debian)
			deb_distro="jessie"
			;;
		isadora)
			deb_distro="lucid"
			;;
		julia)
			deb_distro="maverick"
			;;
		katya)
			deb_distro="natty"
			;;
		lisa)
			deb_distro="oneiric"
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
		maverick|natty|oneiric)
			#http://us.archive.ubuntu.com/ubuntu/dists/
			#list: dists between LTS's...
			unset error_unknown_deb_distro
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		*)
			error_unknown_deb_distro=1
			unset warn_eol_distro
			stop_pkg_search=1
			;;
		esac
	fi

	if [ $(which lsb_release) ] && [ ! "${stop_pkg_search}" ] ; then
		deb_distro=$(lsb_release -cs)

		#pkg: mkimage
		case "${deb_distro}" in
		squeeze|lucid)
			pkg="uboot-mkimage"
			LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
			;;
		*)
			pkg="u-boot-tools"
			LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
			;;
		esac

		#lsb_release -cs ; dpkg --list | grep libncurses5-dev
		#squeeze : [ii  libncurses5-dev                 5.7+20100313-5               developer's libraries and docs for ncurses]
		#wheezy :  [ii  libncurses5-dev                  5.9-10                    armhf        developer's libraries for ncurses]
		#jessie :  [ii  libncurses5-dev:armhf            5.9+20130608-1            armhf        developer's libraries for ncurses]
		#sid :     [ii  libncurses5-dev:armhf            5.9+20130608-1        armhf        developer's libraries for ncurses]
		#lucid :   [ii  libncurses5-dev                 5.7+20090803-2ubuntu3        developer's libraries and docs for ncurses]
		#oneiric : [ii  libncurses5-dev                  5.9-1ubuntu5.1               developer's libraries for ncurses]
		#precise : [ii  libncurses5-dev                  5.9-4                        developer's libraries for ncurses]
		#quantal : [ii  libncurses5-dev                  5.9-10ubuntu1                armhf        developer's libraries for ncurses]
		#raring :  [ii  libncurses5-dev                  5.9-10ubuntu4                armhf        developer's libraries for ncurses]
		#saucy :   [ii  libncurses5-dev                  5.9-10ubuntu4                armhf        developer's libraries for ncurses]

		#pkg: libncurses5-dev
		echo "host debug: dpkg --list libncurses5-dev: [`LC_ALL=C dpkg --list | awk '{print $2}' | grep "^libncurses5-dev"`]"
		case "${deb_distro}" in
		*)
			pkg="libncurses5-dev"
			LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
			;;
		esac

		#pkg: ia32-libs
		deb_arch=$(LC_ALL=C dpkg --print-architecture)
		if [ "x${deb_arch}" = "xamd64" ] ; then
			unset dpkg_multiarch
			case "${deb_distro}" in
			squeeze|lucid|precise)
				pkg="ia32-libs"
				LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
				;;
			*)
				pkg="ia32-libs"
				LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
				LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}" >/dev/null || dpkg_multiarch=1
				;;
			esac

			if [ "${dpkg_multiarch}" ] ; then
				unset check_foreign
				check_foreign=$(LC_ALL=C dpkg --print-foreign-architectures)
				if [ "x${check_foreign}" = "x" ] ; then
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
	info "[debug: `git rev-parse HEAD`]"
else
	info "Detected build host [$BUILD_HOST]"
	info "[debug: `git rev-parse HEAD`]"
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

