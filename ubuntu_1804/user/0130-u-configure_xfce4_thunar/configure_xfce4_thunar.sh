#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
RECIPE_FAMILY_DIR=$(retrieve_recipe_family_dir "${RECIPE_DIR}")
RECIPE_FAMILY_CONF_FILE=$(retrieve_recipe_family_conf_file "${RECIPE_DIR}")
if [[ ! -f "${RECIPE_FAMILY_CONF_FILE}" ]]; then
	printf "Cannot find RECIPE_FAMILY_CONF_FILE: ${RECIPE_FAMILY_CONF_FILE}\n"
	exit 1
fi
source "${RECIPE_FAMILY_CONF_FILE}"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"

exit_if_not_bash

configure_xfce4_thunar(){
	cd ${RECIPE_DIR}
	
	echo "Configuring xfce4-thunar ..."
	CONFIG_FILE="thunar.xml"
	if [ -f ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}" ]; then
		backup_file rename ~/.config/xfce4/xfconf/xfce-perchannel-xml/"${CONFIG_FILE}"
	fi
	mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml
	cp "${CONFIG_FILE}" ~/.config/xfce4/xfconf/xfce-perchannel-xml
	
	echo
}



cd ${RECIPE_DIR}
configure_xfce4_thunar 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
