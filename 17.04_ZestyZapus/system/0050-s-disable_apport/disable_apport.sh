#!/bin/bash

source ../../common.sh
check_shell
exit_if_has_not_root_privileges

disable_apport(){
	cd ${BASEDIR}
	
	echo "Disabling apport ..."
	sed -i "/^enabled=/s/.*/enabled=0/" /etc/default/apport
}

cd ${BASEDIR}
disable_apport 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}