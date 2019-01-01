#!/usr/bin/env bash

source ../../Felix_Xubuntu_18.04.sh
is_bash
exit_if_has_not_root_privileges

install_brillo_from_sources(){
	echo "Install brillo from sources ..."
	
	# See <https://www.reddit.com/r/archlinux/comments/9mr58u/my_brightness_control_tool_brillo_has_a_new/>.
	
	cd ${BASEDIR}
	git clone https://gitlab.com/cameronnemo/brillo
	cd brillo
	make
	make install
	make dist
	make install-dist
	
	# Cleaning
	cd ${BASEDIR}
	rm -fr brillo
	
	echo
}

cd ${BASEDIR}

install_brillo_from_sources 2>&1 | tee -a ./${CURRENT_SCRIPT_LOG_FILE_NAME}
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi