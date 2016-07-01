#!/bin/bash -e

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

check_rpm () {
	pkg_test=$(LC_ALL=C rpm -q "${pkg}")
	if [ "x${pkg_test}" = "xpackage ${pkg} is not installed" ] ; then
		rpm_pkgs="${rpm_pkgs}${pkg} "
	fi
}

redhat_reqs () {
	pkgtool="yum"

	#https://fedoraproject.org/wiki/Releases
	unset rpm_pkgs
	pkg="redhat-lsb-core"
	check_rpm
	pkg="gcc"
	check_rpm
	pkg="lzop"
	check_rpm
	pkg="ncurses-devel"
	check_rpm
	pkg="wget"
	check_rpm

	arch=$(uname -m)
	if [ "x${arch}" = "xx86_64" ] ; then
		pkg="ncurses-devel.x86_64"
		check_rpm
		if [ "x${ignore_32bit}" = "xfalse" ] ; then
			pkg="ncurses-devel.i686"
			check_rpm
			pkg="libstdc++.i686"
			check_rpm
			pkg="zlib.i686"
			check_rpm
		fi
	fi

	if [ "$(which lsb_release)" ] ; then
		rpm_distro=$(lsb_release -rs)
		echo "RPM distro version: [${rpm_distro}]"

		case "${rpm_distro}" in
		22|23|24)
			pkgtool="dnf"
			;;
		esac
	fi

	if [ "${rpm_pkgs}" ] ; then
		echo "Red Hat, or derivatives: missing dependencies, please install:"
		echo "-----------------------------"
		echo "${pkgtool} install ${rpm_pkgs}"
		echo "-----------------------------"
		return 1
	fi
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
    if [ ! "$( which patch )" ]
    then
        cat >&2 <<@@
Missing patch command,
 it is part of the opensuse $BUILD_HOST distribution so it can be 
 installed simply using:

    zypper install patch

@@
        return 1
    fi
    
}

check_dpkg () {
	LC_ALL=C dpkg --list | awk '{print $2}' | grep "^${pkg}$" >/dev/null || deb_pkgs="${deb_pkgs}${pkg} "
}

debian_regs () {
	unset deb_pkgs
	pkg="bc"
	check_dpkg
	pkg="build-essential"
	check_dpkg
	pkg="device-tree-compiler"
	check_dpkg
	pkg="fakeroot"
	check_dpkg
	pkg="lsb-release"
	check_dpkg
	pkg="lzma"
	check_dpkg
	pkg="lzop"
	check_dpkg
	pkg="man-db"
	check_dpkg

	unset warn_dpkg_ia32
	unset stop_pkg_search
	#lsb_release might not be installed...
	if [ "$(which lsb_release)" ] ; then
		deb_distro=$(lsb_release -cs | sed 's/\//_/g')

		if [ "x${deb_distro}" = "xn_a" ] ; then
			echo "+ Warning: [lsb_release -cs] just returned [n/a], so now testing [lsb_release -rs] instead..."
			deb_lsb_rs=$(lsb_release -rs | awk '{print $1}' | sed 's/\//_/g')

			#http://docs.kali.org/kali-policy/kali-linux-relationship-with-debian
			#lsb_release -a
			#Distributor ID:    Debian
			#Description:    Debian GNU/Linux Kali Linux 1.0
			#Release:    Kali Linux 1.0
			#Codename:    n/a
			if [ "x${deb_lsb_rs}" = "xKali" ] ; then
				deb_distro="wheezy"
			fi

			#Debian "testing"
			#lsb_release -a
			#Distributor ID: Debian
			#Description:    Debian GNU/Linux testing/unstable
			#Release:        testing/unstable
			#Codename:       n/a
			if [ "x${deb_lsb_rs}" = "xtesting_unstable" ] ; then
				deb_distro="stretch"
			fi
		fi

		if [ "x${deb_distro}" = "xtesting" ] ; then
			echo "+ Warning: [lsb_release -cs] just returned [testing], so now testing [lsb_release -ds] instead..."
			deb_lsb_ds=$(lsb_release -ds | awk '{print $1}')

			#http://solydxk.com/about/solydxk/
			#lsb_release -a
			#Distributor ID: SolydXK
			#Description:    SolydXK
			#Release:        1
			#Codename:       testing
			if [ "x${deb_lsb_ds}" = "xSolydXK" ] ; then
				deb_distro="jessie"
			fi
		fi

		if [ "x${deb_distro}" = "xluna" ] ; then
			#http://distrowatch.com/table.php?distribution=elementary
			#lsb_release -a
			#Distributor ID:    elementary OS
			#Description:    elementary OS Luna
			#Release:    0.2
			#Codename:    luna
			deb_distro="precise"
		fi

		if [ "x${deb_distro}" = "xfreya" ] ; then
			#http://distrowatch.com/table.php?distribution=elementary
			#lsb_release -a
			#Distributor ID: elementary OS
			#Description:    elementary OS Freya
			#Release:        0.3.1
			#Codename:       freya
			deb_distro="trusty"
		fi

		if [ "x${deb_distro}" = "xtoutatis" ] ; then
			#http://listas.trisquel.info/pipermail/trisquel-announce/2013-March/000014.html
			#lsb_release -a
			#Distributor ID:    Trisquel
			#Description:    Trisquel GNU/Linux 6.0.1, Toutatis
			#Release:    6.0.1
			#Codename:    toutatis
			deb_distro="precise"
		fi

		if [ "x${deb_distro}" = "xbelenos" ] ; then
			#http://listas.trisquel.info/pipermail/trisquel-announce/2014-November/000018.html
			#lsb_release -a
			#Distributor ID:    Trisquel
			#Description:    Trisquel GNU/Linux 7.0, Belenos
			#Release:    7.0
			#Codename:    belenos
			deb_distro="trusty"
		fi

		#https://bugs.kali.org/changelog_page.php
		if [ "x${deb_distro}" = "xmoto" ] ; then
			#lsb_release -a
			#Distributor ID:    Kali
			#Description:    Kali GNU/Linux 1.1.0
			#Release:    1.1.0
			#Codename:    moto
			deb_distro="wheezy"
		fi

		if [ "x${deb_distro}" = "xsana" ] ; then
			#EOL: 15th of April 2016.
			#lsb_release -a
			#Distributor ID:    Kali
			#Description:    Kali GNU/Linux 2.0
			#Release:    2.0
			#Codename:    sana
			deb_distro="jessie"
		fi

		if [ "x${deb_distro}" = "xkali-rolling" ] ; then
			#lsb_release -a:
			#Distributor ID:    Kali
			#Description:    Kali GNU/Linux Rolling
			#Release:    kali-rolling
			#Codename:    kali-rolling
			deb_distro="stretch"
		fi

		#Linux Mint: Compatibility Matrix
		#http://www.linuxmint.com/download_all.php (lists current versions)
		#http://www.linuxmint.com/oldreleases.php
		#http://packages.linuxmint.com/index.php
		#http://mirrors.kernel.org/linuxmint-packages/dists/
		case "${deb_distro}" in
		betsy)
			#LMDE 2
			deb_distro="jessie"
			;;
		debian)
			deb_distro="jessie"
			;;
		isadora)
			#9
			deb_distro="lucid"
			;;
		julia)
			#10
			deb_distro="maverick"
			;;
		katya)
			#11
			deb_distro="natty"
			;;
		lisa)
			#12
			deb_distro="oneiric"
			;;
		maya)
			#13
			deb_distro="precise"
			;;
		nadia)
			#14
			deb_distro="quantal"
			;;
		olivia)
			#15
			deb_distro="raring"
			;;
		petra)
			#16
			deb_distro="saucy"
			;;
		qiana)
			#17
			deb_distro="trusty"
			;;
		rebecca)
			#17.1
			deb_distro="trusty"
			;;
		rafaela)
			#17.2
			deb_distro="trusty"
			;;
		rosa)
			#17.3
			deb_distro="trusty"
			;;
		sarah)
			#18
			#http://blog.linuxmint.com/?p=2975
			deb_distro="xenial"
			;;
		esac

		#Future Debian Code names:
		case "${deb_distro}" in
		buster)
			#Debian 10
			deb_distro="sid"
			;;
		esac

		#https://wiki.ubuntu.com/Releases
		unset error_unknown_deb_distro
		case "${deb_distro}" in
		wheezy|jessie|stretch|sid)
			#7 wheezy: https://wiki.debian.org/DebianWheezy
			#8 jessie: https://wiki.debian.org/DebianJessie
			#9 stretch: https://wiki.debian.org/DebianStretch
			unset warn_eol_distro
			;;
		squeeze)
			#6 squeeze: 2016-02-06 https://wiki.debian.org/DebianSqueeze
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		yakkety)
			#16.10 yakkety: (EOL: July 2017)
			unset warn_eol_distro
			;;
		xenial)
			#16.04 xenial: (EOL: April 2021) lts: xenial -> xyz
			unset warn_eol_distro
			;;
		wily)
			#15.10 wily: (EOL: July 2016)
			unset warn_eol_distro
			;;
		utopic|vivid)
			#14.10 utopic: (EOL: July 23, 2015)
			#15.04 vivid: (EOL: February 4, 2016)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		trusty)
			#14.04 trusty: (EOL: April 2019) lts: trusty -> xenial
			unset warn_eol_distro
			;;
		quantal|raring|saucy)
			#12.10 quantal: (EOL: May 16, 2014)
			#13.04 raring: (EOL: January 27, 2014)
			#13.10 saucy: (EOL: July 17, 2014)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		precise)
			#12.04 precise: (EOL: April 2017) lts: precise -> trusty
			unset warn_eol_distro
			;;
		hardy|lucid|maverick|natty|oneiric)
			#8.04 hardy: (EOL: May 2013) lts: hardy -> lucid
			#10.04 lucid: (EOL: April 2015) lts: lucid -> precise
			#10.10 maverick: (EOL: April 10, 2012)
			#11.04 natty: (EOL: October 28, 2012)
			#11.10 oneiric: (EOL: May 9, 2013)
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

	if [ "$(which lsb_release)" ] && [ ! "${stop_pkg_search}" ] ; then
		deb_arch=$(LC_ALL=C dpkg --print-architecture)
		
		#Libs; starting with jessie/sid, lib<pkg_name>-dev:<arch>
		case "${deb_distro}" in
		wheezy|precise)
			pkg="libncurses5-dev"
			check_dpkg
			;;
		*)
			pkg="libncurses5-dev:${deb_arch}"
			check_dpkg
			;;
		esac
		
		#pkg: ia32-libs
		if [ "x${deb_arch}" = "xamd64" ] ; then
			unset dpkg_multiarch
			case "${deb_distro}" in
			precise)
				if [ "x${ignore_32bit}" = "xfalse" ] ; then
					pkg="ia32-libs"
					check_dpkg
				fi
				;;
			*)
				if [ "x${ignore_32bit}" = "xfalse" ] ; then
					pkg="libc6:i386"
					check_dpkg
					pkg="libncurses5:i386"
					check_dpkg
					pkg="libstdc++6:i386"
					check_dpkg
					pkg="zlib1g:i386"
					check_dpkg
					dpkg_multiarch=1
				fi
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
		echo "-----------------------------"
	fi

	if [ "${stop_pkg_search}" ] ; then
		echo "Dependency check skipped, you are on your own."
		echo "-----------------------------"
		unset deb_pkgs
	fi

	if [ "${error_unknown_deb_distro}" ] ; then
		echo "Unrecognized deb based system:"
		echo "-----------------------------"
		echo "Please cut, paste and email to: bugs@rcn-ee.com"
		echo "-----------------------------"
		echo "git: [$(git rev-parse HEAD)]"
		echo "git: [$(cat .git/config | grep url | sed 's/\t//g' | sed 's/ //g')]"
		echo "uname -m: [$(uname -m)]"
		echo "lsb_release -a:"
		lsb_release -a
		echo "-----------------------------"
		return 1
	fi

	if [ "${deb_pkgs}" ] ; then
		echo "Debian/Ubuntu/Mint: missing dependencies, please install:"
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
if [ "$(which lsb_release)" ] ; then
	info "Detected build host [$(lsb_release -sd)]"
	info "host: [$(uname -m)]"
	info "git HEAD commit: [$(git rev-parse HEAD)]"
else
	info "Detected build host [$BUILD_HOST]"
	info "host: [$(uname -m)]"
	info "git HEAD commit: [$(git rev-parse HEAD)]"
fi

DIR=$PWD
. "${DIR}/version.sh"

if [  -f "${DIR}/.yakbuild" ] ; then
	. "${DIR}/recipe.sh"
fi

ARCH=$(uname -m)

ignore_32bit="false"
if [ "x${ARCH}" = "xx86_64" ] ; then
	case "${toolchain}" in
	gcc_linaro_eabi_5|gcc_linaro_gnueabihf_5|gcc_linaro_aarch64_gnu_5)
		ignore_32bit="true"
		;;
	*)
		ignore_32bit="false"
		;;
	esac
fi

case "$BUILD_HOST" in
    redhat*)
	    redhat_reqs || error "Failed dependency check"
        ;;
    debian*)
	    debian_regs || error "Failed dependency check"
        ;;
    suse*)
	    suse_regs "$BUILD_HOST" || error "Failed dependency check"
        ;;
esac

