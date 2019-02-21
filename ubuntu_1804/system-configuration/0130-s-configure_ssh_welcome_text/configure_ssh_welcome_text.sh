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
exit_if_has_not_root_privileges

configure_ssh_welcome_text(){
	echo "Setting SSH welcome text ..."
	
	echo "Disabling all previous 'message of the day' ..."
	cd /etc/update-motd.d
	for FILE in ./*; do
		backup_file rename ./"${FILE}"
	done
	chmod a-x ./*
	
	echo "Adding Tux Welcome Dude ..."
	cd "${RECIPE_DIR}"
	cp 00-welcome-dude /etc/update-motd.d/00-welcome-dude
	chmod 744 /etc/update-motd.d/00-welcome-dude
	cp tux /etc/update-motd.d/tux
	chmod 644 /etc/update-motd.d/tux
	
	echo
}

configure_ssh_welcome_text 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
