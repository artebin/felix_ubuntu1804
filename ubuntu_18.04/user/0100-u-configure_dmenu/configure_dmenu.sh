#!/usr/bin/env bash

source ../../ubuntu_18.04.sh
is_bash

configure_dmenu(){
	cd ${BASEDIR}
	
	echo "Configuring dmenu ..."
	if [ -f ~/.config/dmenu ]; then
		backup_file rename ~/.config/dmenu
	fi
	if [ ! -f ~/.config/dmenu ]; then
		mkdir -p ~/.config/dmenu
	fi
	cp ./dmenu-bind.sh ~/.config/dmenu
	chmod +x ~/.config/dmenu/dmenu-bind.sh
	
	echo
}

cd ${BASEDIR}

configure_dmenu 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi