#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash
exit_if_has_not_root_privileges

install_mps_youtube_from_sources(){
	echo "Install mps-youtube from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "python3-pip" "pandoc"
	
	# Install youtube-dl from sources
	cd ${BASEDIR}
	git clone https://github.com/rg3/youtube-dl
	cd youtube-dl
	make
	make install
	python3 setup.py install
	
	# Install mps-youtube and other dependencies
	pip3 install dbus-python pygobject
	pip3 install colorama
	pip3 install mps-youtube
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr youtube-dl
	
	echo
}



cd ${BASEDIR}
install_mps_youtube_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi