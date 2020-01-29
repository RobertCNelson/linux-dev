#!/bin/bash -e

#opensuse support added by: Antonio Cavallo
#https://launchpad.net/~a.cavallo

git_bin=$(which git)

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
	pkgtool="dnf"

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
	pkg="fakeroot"
	check_rpm
	pkg="xz"
	check_rpm
	pkg="lzop"
	check_rpm
	pkg="bison"
	check_rpm
	pkg="flex"
	check_rpm
	pkg="uboot-tools"
	check_rpm
	pkg="openssl-devel"
	check_rpm

	arch=$(uname -m)
	if [ "x${arch}" = "xx86_64" ] ; then
		pkg="ncurses-devel.x86_64"
		check_rpm
		pkg="libmpc-devel.x86_64"
		check_rpm
		if [ "x${ignore_32bit}" = "xfalse" ] ; then
			pkg="ncurses-devel.i686"
			check_rpm
			pkg="libmpc-devel.i686"
			check_rpm
			pkg="libstdc++.i686"
			check_rpm
			pkg="zlib.i686"
			check_rpm
		fi
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
	LC_ALL=C dpkg-query -s ${pkg} 2>&1 | grep Section: > /dev/null || deb_pkgs="${deb_pkgs}${pkg} "
}

debian_regs () {
	unset deb_pkgs
	pkg="bash"
	check_dpkg
	pkg="bc"
	check_dpkg
	pkg="build-essential"
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
	#git
	pkg="gettext"
	check_dpkg
	#v4.16-rc0
	pkg="bison"
	check_dpkg
	pkg="flex"
	check_dpkg
	#v4.18-rc0
	pkg="pkg-config"
	check_dpkg
	#GCC_PLUGINS
	pkg="libmpc-dev"
	check_dpkg
	#"mkimage" command not found - U-Boot images will not be built
	pkg="u-boot-tools"
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
				deb_distro="buster"
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

		if [ "x${deb_distro}" = "xunstable" ] ; then
			echo "+ Warning: [lsb_release -cs] just returned [unstable], so now testing [lsb_release -is] instead..."
			deb_lsb_is=$(lsb_release -is | awk '{print $1}')

			#lsb_release -a
			#Distributor ID: Deepin
			#Description:    Deepin 15.9.2
			#Release:        15.9.2
			#Codename:       unstable
			if [ "x${deb_lsb_is}" = "xDeepin" ] ; then
				deb_distro="stretch"
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

		#https://www.bunsenlabs.org/
		if [ "x${deb_distro}" = "xbunsen-hydrogen" ] ; then
			#Distributor ID:    BunsenLabs
			#Description:    BunsenLabs GNU/Linux 8.5 (Hydrogen)
			#Release:    8.5
			#Codename:    bunsen-hydrogen
			deb_distro="jessie"
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
		cindy)
			#LMDE 3 https://linuxmint.com/rel_cindy.php
			deb_distro="stretch"
			;;
		debbie)
			#LMDE 4
			deb_distro="buster"
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
		serena)
			#18.1
			#http://packages.linuxmint.com/index.php
			deb_distro="xenial"
			;;
		sonya)
			#18.2
			#http://packages.linuxmint.com/index.php
			deb_distro="xenial"
			;;
		sylvia)
			#18.3
			#http://packages.linuxmint.com/index.php
			deb_distro="xenial"
			;;
		tara)
			#19
			#http://blog.linuxmint.com/?p=2975
			deb_distro="bionic"
			;;
		tessa)
			#19.1
			#https://blog.linuxmint.com/?p=3671
			deb_distro="bionic"
			;;
		tina)
			#19.2
			#https://blog.linuxmint.com/?p=3736
			deb_distro="bionic"
			;;
		tricia)
			#19.3
			#http://packages.linuxmint.com/index.php
			deb_distro="bionic"
			;;
		esac

		#Future Debian Code names:
		case "${deb_distro}" in
		bookworm)
			#12 bookworm:
			deb_distro="sid"
			;;
		esac

		#https://wiki.ubuntu.com/Releases
		unset error_unknown_deb_distro
		case "${deb_distro}" in
		jessie|stretch|buster|bullseye|sid)
			#https://wiki.debian.org/LTS
			#8 jessie: https://wiki.debian.org/DebianJessie
			#9 stretch: https://wiki.debian.org/DebianStretch
			#10 buster: https://wiki.debian.org/DebianBuster
			#11 bullseye: https://wiki.debian.org/DebianBullseye
			unset warn_eol_distro
			;;
		squeeze|wheezy)
			#https://wiki.debian.org/LTS
			#6 squeeze: 2016-02-29 https://wiki.debian.org/DebianSqueeze
			#7 wheezy: 2018-05-31 https://wiki.debian.org/DebianWheezy
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		bionic|eoan|focal)
			#18.04 bionic: (EOL: April 2023) lts: bionic -> focal
			#19.10 eoan: (EOL: July, 2020)
			#20.04 focal: (EOL: 2030) lts: focal -> xyz
			unset warn_eol_distro
			;;
		cosmic|disco)
			#18.10 cosmic: (EOL: July 18, 2019)
			#19.04 disco: (EOL: January 23, 2020)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		yakkety|zesty|artful)
			#16.10 yakkety: (EOL: July 20, 2017)
			#17.04 zesty: (EOL: January 2018)
			#17.10 artful: (EOL: July 2018)
			warn_eol_distro=1
			stop_pkg_search=1
			;;
		xenial)
			#16.04 xenial: (EOL: April 2021) lts: xenial -> bionic
			unset warn_eol_distro
			;;
		hardy|lucid|maverick|natty|oneiric|precise|quantal|raring|saucy|trusty|utopic|vivid|wily)
			#8.04 hardy: (EOL: May 2013) lts: hardy -> lucid
			#10.04 lucid: (EOL: April 2015) lts: lucid -> precise
			#10.10 maverick: (EOL: April 10, 2012)
			#11.04 natty: (EOL: October 28, 2012)
			#11.10 oneiric: (EOL: May 9, 2013)
			#12.04 precise: (EOL: April 28 2017) lts: precise -> trusty
			#12.10 quantal: (EOL: May 16, 2014)
			#13.04 raring: (EOL: January 27, 2014)
			#13.10 saucy: (EOL: July 17, 2014)
			#14.04 trusty: (EOL: April 25, 2019) lts: trusty -> xenial
			#14.10 utopic: (EOL: July 23, 2015)
			#15.04 vivid: (EOL: February 4, 2016)
			#15.10 wily: (EOL: July 28, 2016)
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

		pkg="libncurses5-dev:${deb_arch}"
		check_dpkg
		pkg="libssl-dev:${deb_arch}"
		check_dpkg

		if [ "x${build_git}" = "xtrue" ] ; then
			#git
			pkg="libcurl4-gnutls-dev:${deb_arch}"
			check_dpkg
			pkg="libelf-dev:${deb_arch}"
			check_dpkg
			pkg="libexpat1-dev:${deb_arch}"
			check_dpkg
		fi

		#pkg: ia32-libs
		if [ "x${deb_arch}" = "xamd64" ] ; then
			unset dpkg_multiarch
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
		echo "git: [$(${git_bin} rev-parse HEAD)]"
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
	info "git HEAD commit: [$(${git_bin} rev-parse HEAD)]"
else
	info "Detected build host [$BUILD_HOST]"
	info "host: [$(uname -m)]"
	info "git HEAD commit: [$(${git_bin} rev-parse HEAD)]"
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
	gcc_linaro_eabi_6|gcc_linaro_gnueabihf_6|gcc_linaro_aarch64_gnu_6)
		ignore_32bit="true"
		;;
	gcc_linaro_eabi_7|gcc_linaro_gnueabihf_7|gcc_linaro_aarch64_gnu_7)
		ignore_32bit="true"
		;;
	gcc_arm_eabi_8|gcc_arm_gnueabihf_8|gcc_arm_aarch64_gnu_8)
		ignore_32bit="true"
		;;
	*)
		ignore_32bit="false"
		;;
	esac
fi

git_bin=$(which git)

git_major=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f1)
git_minor=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f2)
git_sub=$(LC_ALL=C ${git_bin} --version | awk '{print $3}' | cut -d. -f3)

#debian Stable:
#https://packages.debian.org/stable/git -> 2.1.4

compare_major="2"
compare_minor="1"
compare_sub="4"

unset build_git

if [ "${git_major}" -lt "${compare_major}" ] ; then
	build_git="true"
elif [ "${git_major}" -eq "${compare_major}" ] ; then
	if [ "${git_minor}" -lt "${compare_minor}" ] ; then
		build_git="true"
	elif [ "${git_minor}" -eq "${compare_minor}" ] ; then
		if [ "${git_sub}" -lt "${compare_sub}" ] ; then
			build_git="true"
		fi
	fi
fi

echo "-----------------------------"
unset NEEDS_COMMAND
check_for_command () {
	if ! which "$1" >/dev/null 2>&1 ; then
		echo "You're missing command $1"
		NEEDS_COMMAND=1
	else
		version=$(LC_ALL=C $1 $2 | head -n 1)
		echo "$1: $version"
	fi
}

unset NEEDS_COMMAND
check_for_command cpio --version
check_for_command lzop --version

if [ "${NEEDS_COMMAND}" ] ; then
	echo "Please install missing commands"
	echo "-----------------------------"
	exit 2
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

