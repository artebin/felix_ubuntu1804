#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

configure_apt_mirror(){
	echo "Configure apt-mirror ..."
	
	# Configure apt-mirror
	cd ${BASEDIR}
	if [[ -f /etc/apt/mirror.list ]]; then
		backup_file rename /etc/apt/mirror.list
	fi
	cp apt.mirror.list /etc/apt/mirror.list
	
	# Adding the local mirror into the sources
	cd ${BASEDIR}
	if [[ -f /etc/apt/sources.list.d/local_mirror.list ]]; then
		backup_file rename /etc/apt/sources.list.d/local_mirror.list
	fi
	cp apt.mirror.list /etc/apt/sources.list.d/local_mirror.list
	
	echo
}



cd ${BASEDIR}
configure_apt_mirror 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi