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

AUTO_LOGIN_USER_NAME=''

configure_auto_login(){
	echo "Configuring auto login ..."
	
	if [[ -z "${AUTO_LOGIN_USER_NAME}" ]]; then
		echo "AUTO_LOGIN_USER_NAME should not be empty. Please edit the script and specify a user name."
		exit 1
	fi
	
	echo "AUTO_LOGIN_USER_NAME: ${AUTO_LOGIN_USER_NAME}"
	
	if [[ -d /etc/lightdm/lightdm.conf.d ]]; then
		if [[ -f /etc/lightdm/lightdm.conf.d/50-autologin.conf ]]; then
			echo "/etc/lightdm/lightdm.conf.d/50-autologin.conf already exists"
			exit 1
		fi
	else
		mkdir /etc/lightdm/lightdm.conf.d
	fi
	
	cd "${RECIPE_DIR}"
	sed -i "/^autologin-user=/s/.*/autologin-user=${AUTO_LOGIN_USER_NAME}/" 50-autologin.conf
	cp 50-autologin.conf /etc/lightdm/lightdm.conf.d/50-autologin.conf
	
	echo
}

configure_auto_login 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
