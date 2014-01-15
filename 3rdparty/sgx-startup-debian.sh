#!/bin/sh -e
### BEGIN INIT INFO
# Provides:          sgx-startup.sh
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

case "$1" in
start)
	if [ -d /sys/devices/ocp.*/56000000.sgx ] ; then
		echo "sgx: Starting PVR"

		modprobe -q pvrsrvkm

		# Delete the device for PVR services device and recreate with the
		# correct major number.
		#
		pvr_maj=$(grep "pvrsrvkm$" /proc/devices | cut -b1,2,3)

		if [ -e /dev/pvrsrvkm ] ; then
			rm -f /dev/pvrsrvkm
		fi

		mknod /dev/pvrsrvkm c $pvr_maj 0
		chmod 666 /dev/pvrsrvkm

		if [ -f /usr/local/bin/pvrsrvctl ] ; then
			/usr/local/bin/pvrsrvctl --start --no-module

			modprobe -q omaplfb
		fi
	fi
	;;
reload|force-reload|restart)
	if [ -d /sys/devices/ocp.*/56000000.sgx ] ; then
		echo "sgx: Restarting PVR"
	fi
	;;
stop)
	exit 0
	;;
*)
	echo "Usage: /etc/init.d/sgx-startup.sh {start|stop|reload|restart|force-reload}"
	exit 1
	;;
esac

exit 0
