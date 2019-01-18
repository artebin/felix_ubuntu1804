#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

disable_automatic_update_and_upgrade(){
	echo "Disable apt-daily.service ..."
	
	# See <https://askubuntu.com/questions/1057458/how-to-remove-ubuntus-automatic-internet-connection-needs/1057463#1057463>
	
	systemctl stop apt-daily.timer
	systemctl disable apt-daily.timer
	systemctl disable apt-daily.service
	systemctl stop apt-daily-upgrade.timer
	systemctl disable apt-daily-upgrade.timer
	systemctl disable apt-daily-upgrade.service
	
	echo
	
	echo "Remove unattended-upgrades ..."
	apt-get remove -y --purge unattended-upgrades
	
	echo
}

cd ${BASEDIR}
disable_automatic_update_and_upgrade 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi