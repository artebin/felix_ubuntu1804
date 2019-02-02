#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash

blueman_applet_should_not_auto_enable_bluetooth_adapter(){
	cd ${BASEDIR}
	
	echo "Blueman applet should not auto enable the bluetooth adapter when starting (keep the current state of the adpater) ..."
	# See <https://wiki.archlinux.org/index.php/Blueman>
	gsettings set org.blueman.plugins.powermanager auto-power-on false
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
blueman_applet_should_not_auto_enable_bluetooth_adapter 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
