This just a simple set of scripts to rebuild a known working kernel for omap devices..

Script Bugs: "bugs@rcn-ee.com"

To Build:
Kernel with Modules, easy to build and test:

"./build_kernel.sh"

Debian Package

"./build_deb.sh"

Create SGX install Package:

"./create_sgx_package.sh"

Create DSP install Package:

"./create_dsp_package.sh"

Some Defconfig Requirement notes:

Ubuntu Lucid (10.04) ++++

CONFIG_ARM_ERRATA_430973=y
https://bugs.launchpad.net/ubuntu/+source/fakeroot/+bug/495536

CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
https://bugs.launchpad.net/ubuntu/lucid/+source/mountall/+bug/510130
https://lists.ubuntu.com/archives/kernel-team/2010-January/008518.html

CONFIG_ARM_THUMBEE=y
https://lists.ubuntu.com/archives/kernel-team/2010-January/008561.html

#rcn-ee's notes for comparing to ubuntu's config..
#ubuntu git clone git://kernel.ubuntu.com/ubuntu/ubuntu-natty.git

sudo apt-get install fakeroot build-essential
sudo apt-get install crash kexec-tools makedumpfile kernel-wedge
sudo apt-get build-dep linux
sudo apt-get install git-core libncurses5 libncurses5-dev
sudo apt-get install libelf-dev asciidoc binutils-dev

fakeroot debian/rules clean
debian/rules updateconfigs
debian/rules editconfigs
(n) to all execpt omap:
defconfig should be in:  gedit /tmp/tmp.<random>/CONFIGS/armel-config.flavour.omap

