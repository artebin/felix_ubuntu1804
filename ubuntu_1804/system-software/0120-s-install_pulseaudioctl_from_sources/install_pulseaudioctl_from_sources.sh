#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_pulseaudioctl_from_sources(){
	echo "Installing pulseaudio-ctl from sources ..."
	
	# Clone git repository
	git clone https://github.com/graysky2/pulseaudio-ctl
	
	# Build and install
	cd pulseaudio-ctl
	make
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr pulseaudio-ctl
	
	echo
}



cd ${BASEDIR}
install_pulseaudioctl_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi