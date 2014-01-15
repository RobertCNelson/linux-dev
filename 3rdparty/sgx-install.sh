#!/bin/sh -e

if ! id | grep -q root; then
	echo "must be run as root"
	exit
fi

install_lib () {
	if [ -f ${libdir}/${file} ] ; then
		cp -v ${libdir}/${file} /usr/lib/${file}
	fi
}

install_bin () {
	if [ -f ${libdir}/${file} ] ; then
		cp -v ${libdir}/${file} /usr/local/bin/${file}
	fi
}

distro=$(lsb_release -si)

if [ -f /opt/gfxmodules/gfx_rel_es8.x/pvrsrvkm.ko ] ; then
	if [ ! -d /lib/modules/$(uname -r)/extra/ ] ; then
		mkdir -p /lib/modules/$(uname -r)/extra/ || true
	fi

	cp -v /opt/gfxmodules/gfx_rel_es8.x/pvrsrvkm.ko /lib/modules/$(uname -r)/extra/pvrsrvkm.ko

	grep -v -e "extra/pvrsrvkm.ko" /lib/modules/$(uname -r)/modules.dep >/tmp/modules.tmp
	echo "/lib/modules/$(uname -r)/extra/pvrsrvkm.ko:" >>/tmp/modules.tmp
	cp /tmp/modules.tmp /lib/modules/$(uname -r)/modules.dep

	if [ -f /opt/gfxmodules/gfx_rel_es8.x/omaplfb.ko ] ; then
		cp -v /opt/gfxmodules/gfx_rel_es8.x/omaplfb.ko /lib/modules/$(uname -r)/extra/omaplfb.ko

		grep -v -e "extra/omaplfb.ko" /lib/modules/$(uname -r)/modules.dep >/tmp/modules.tmp
		echo "/lib/modules/$(uname -r)/extra/omaplfb.ko: /lib/modules/$(uname -r)/extra/pvrsrvkm.ko" >>/tmp/modules.tmp
		cp /tmp/modules.tmp /lib/modules/$(uname -r)/modules.dep
	fi
	echo "Running [depmod -a]"
	depmod -a
fi

if [ -d /opt/gfxlibraries/gfx_rel_es8.x/ ] ; then
	echo "Copying libraries"
	libdir="/opt/gfxlibraries/gfx_rel_es8.x"

	# Install the standard libraries
	#
	file=libGLES_CM.so
	install_lib

	file=libusc.so
	install_lib

	file=libGLESv2.so
	install_lib

	file=libglslcompiler.so
	install_lib

	file=libIMGegl.so
	install_lib
	file=libEGL.so
	install_lib
	file=libpvr2d.so
	install_lib

	file=libpvrPVR2D_BLITWSEGL.so
	install_lib
	file=libpvrPVR2D_FLIPWSEGL.so
	install_lib
	file=libpvrPVR2D_FRONTWSEGL.so
	install_lib
	file=libpvrPVR2D_LINUXFBWSEGL.so
	install_lib

	file=libpvrEWS_WSEGL.so
	install_lib
	file=libpvrEWS_REMWSEGL.so
	install_lib

	file=libsrv_um.so
	install_lib
	file=libsrv_init.so
	install_lib
	file=libPVRScopeServices.so
	install_lib

	file=libews.so
	install_lib

	# Install the standard executables
	#
	file=pvrsrvctl
	install_bin
	file=sgx_init_test
	install_bin

	file=ews_server
	install_bin
	file=ews_server_es2
	install_bin

	# Install the standard unittests
	#

	file=services_test
	install_bin
	file=sgx_blit_test
	install_bin
	file=sgx_clipblit_test
	install_bin
	file=sgx_flip_test
	install_bin
	file=sgx_render_flip_test
	install_bin
	file=pvr2d_test
	install_bin

	file=gles1test1
	install_bin
	file=gles1_texture_stream
	install_bin

	file=gles2test1
	install_bin
	file=glsltest1_vertshader.txt
	install_bin
	file=glsltest1_fragshaderA.txt
	install_bin
	file=glsltest1_fragshaderB.txt
	install_bin
	file=gles2_texture_stream
	install_bin
	file=eglinfo
	install_bin

	file=ews_test_gles1
	install_bin
	file=ews_test_gles1_egl_image_external
	install_bin

	file=ews_test_gles2
	install_bin
	file=ews_test_gles2_main.vert
	install_bin
	file=ews_test_gles2_main.frag
	install_bin
	file=ews_test_gles2_pp.vert
	install_bin
	file=ews_test_gles2_pp.frag
	install_bin
	file=ews_test_gles2_egl_image_external
	install_bin
	file=ews_test_gles2_egl_image_external.vert
	install_bin
	file=ews_test_gles2_egl_image_external.frag
	install_bin
	file=ews_test_swrender
	install_bin
fi

case "${distro}" in
Debian)
	if [ -f /opt/gfxinstall/scripts/sgx-startup-debian.sh ] ; then
		if [ -f /etc/init.d/sgx-startup.sh ] ; then
			insserv --remove sgx-startup.sh
			rm -rf /etc/init.d/sgx-startup.sh || true
		fi

		cp -v /opt/gfxinstall/scripts/sgx-startup-debian.sh /etc/init.d/sgx-startup.sh
		chown root:root /etc/init.d/sgx-startup.sh
		chmod +x /etc/init.d/sgx-startup.sh
		insserv sgx-startup.sh || true
	fi
	;;
Ubuntu)
	if [ -f /opt/gfxinstall/scripts/sgx-startup-ubuntu.conf ] ; then
		cp -v /opt/gfxinstall/scripts/sgx-startup-ubuntu.conf /etc/init/sgx-startup.conf
		chown root:root /etc/init/sgx-startup.conf
		chmod +x /etc/init.d/sgx-startup.conf
	fi
	;;
esac
