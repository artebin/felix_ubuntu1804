#!/usr/bin/env bash

source ../../../felix.sh
source ../../ubuntu_1804.conf
is_bash
exit_if_has_not_root_privileges

install_sxhkd_from_sources(){
	echo "Installing sxhkd from sources ..."
	
	# Install dependencies
	install_package_if_not_installed "libxcb-util-dev" "libxcb-keysyms1-dev"
	
	# Clone git repository
	git clone https://github.com/baskerville/sxhkd
	
	# Build and install
	cd sxhkd
	make
	make install
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr sxhkd
	
	echo
}

BASEDIR="$(dirname ${BASH_SOURCE})"

cd ${BASEDIR}
install_sxhkd_from_sources 2>&1 | tee -a "$(retrieve_log_file_name ${BASH_SOURCE})"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
