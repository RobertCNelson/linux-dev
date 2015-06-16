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

check_rpm () {
	pkg_test=$(LC_ALL=C rpm -q ${pkg})
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
		pkg="ncurses-devel.i686"
		check_rpm
		pkg="libstdc++.i686"
		check_rpm
		pkg="zlib.i686"
		check_rpm
	fi

	if [ $(which lsb_release) ] ; then
		rpm_distro=$(lsb_release -rs)
		echo "RPM distro version: [${rpm_distro}]"

		case "${rpm_distro}" in
		6.4|6.5|6.6|6.7)
			echo "-----------------------------"
			echo "Warning: RHEL/CentOS [${rpm_distro}] has no [uboot-tools] pkg by default"
			echo "add: [EPEL] repo: https://fedoraproject.org/wiki/EPEL"
			echo "http://download.fedoraproject.org/pub/epel/6/i386/repoview/epel-release.html"
			echo "-----------------------------"
			pkg="uboot-tools"
			check_rpm
			;;
		7.0|7.1)
			echo "-----------------------------"
			echo "Warning: RHEL/CentOS [${rpm_distro}] has no [uboot-tools] pkg by default"
			echo "add: [EPEL] repo: https://fedoraproject.org/wiki/EPEL"
			echo "http://download.fedoraproject.org/pub/epel/7/x86_64/repoview/epel-release.html"
			echo "-----------------------------"
			pkg="uboot-tools"
			check_rpm
			;;
		22)
			pkgtool="dnf"
			pkg="uboot-tools"
			check_rpm
			;;
		20|21)
			pkg="uboot-tools"
			check_rpm
			;;
		17|18|19)
			#end of life...
			pkg="uboot-tools"
			check_rpm
			;;
		*)
			echo "Warning: [uboot-tools] package check still in development"
			echo "Please email to: bugs@rcn-ee.com"
			echo "Success/Failure of [${pkgtool} install uboot-tools]"
			echo "RPM distro version: [${rpm_distro}]"
			pkg="uboot-tools"
			check_rpm
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
	if [ $(which lsb_release) ] ; then
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
		petra)
			deb_distro="saucy"
			;;
		qiana)
			deb_distro="trusty"
			;;
		rebecca)
			#http://blog.linuxmint.com/?p=2688
			deb_distro="trusty"
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
		squeeze|wheezy|jessie|stretch|sid)
			unset warn_eol_distro
			;;
		utopic|vivid|wily)
			#14.10 (EOL: July 2015)
			#15.04 (EOL: January 2016)
			#15.10 (EOL: July 2016)
			unset warn_eol_distro
			;;
		trusty)
			#14.04 (EOL: April 2019) lts: trusty -> xyz
			unset warn_eol_distro
			;;
		quantal|raring|saucy)
			#12.10 (EOL: May 16, 2014)
			#13.04 (EOL: January 27, 2014)
			#13.10 (EOL: July 17, 2014)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		precise)
			#12.04 (EOL: April 2017) lts: precise -> trusty
			unset warn_eol_distro
			;;
		maverick|natty|oneiric)
			#10.10 (EOL: April 10, 2012)
			#11.04 (EOL: October 28, 2012)
			#11.10 (EOL: May 9, 2013)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		lucid)
			#10.04 (EOL: April 2015) lts: lucid -> precise
			unset warn_eol_distro
			;;
		hardy)
			#8.04 (EOL: May 2013) lts: hardy -> lucid
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
		deb_arch=$(LC_ALL=C dpkg --print-architecture)
		
		#pkg: mkimage
		case "${deb_distro}" in
		squeeze|lucid)
			pkg="uboot-mkimage"
			check_dpkg
			;;
		*)
			pkg="u-boot-tools"
			check_dpkg
			;;
		esac

		#Libs; starting with jessie/sid, lib<pkg_name>-dev:<arch>
		case "${deb_distro}" in
		squeeze|wheezy|lucid|precise)
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
			squeeze|lucid|precise)
				pkg="ia32-libs"
				check_dpkg
				;;
			*)
				pkg="libc6:i386"
				check_dpkg
				pkg="libncurses5:i386"
				check_dpkg
				pkg="libstdc++6:i386"
				check_dpkg
				pkg="zlib1g:i386"
				check_dpkg
				dpkg_multiarch=1
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
		echo "git: [`git rev-parse HEAD`]"
		echo "git: [`cat .git/config | grep url | sed 's/\t//g' | sed 's/ //g'`]"
		echo "uname -m: [`uname -m`]"
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
if [ $(which lsb_release) ] ; then
	info "Detected build host [`lsb_release -sd`]"
	info "host: [`uname -m`]"
	info "git HEAD commit: [`git rev-parse HEAD`]"
else
	info "Detected build host [$BUILD_HOST]"
	info "host: [`uname -m`]"
	info "git HEAD commit: [`git rev-parse HEAD`]"
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

