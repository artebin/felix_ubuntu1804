#!/usr/bin/env bash

source ../../../common.sh
check_shell
exit_if_has_not_root_privileges

install_wifi(){
	cd ${BASEDIR}
	
	echo "Installing Wi-Fi ..."
	apt-get install -y bcmwl-kernel-source
}

cd ${BASEDIR}
install_wifi 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi