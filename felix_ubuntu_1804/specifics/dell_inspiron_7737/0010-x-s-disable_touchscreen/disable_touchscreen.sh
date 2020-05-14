#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

disable_touchscreen(){
	cd "${RECIPE_DIRECTORY}"
	
	# For disabling the touchscreen we can use use:
	#  - 'xinput' and 'xinput disable <device ID>', it can be done when we login via the '.xsession'
	#  - disable it directly in the X.org configuration in '/usr/share/X11/xorg.conf/40-libinput.conf'
	# Here we disable it in X.org configuration
	
	LIB_INPUT_CONF_FILE="/usr/share/X11/xorg.conf.d/40-libinput.conf"
	if [[ ! -f "${LIB_INPUT_CONF_FILE}" ]]; then
		printf "Can not find ${LIB_INPUT_CONF_FILE}\n"
		printf "Exiting ...\n"
		return 1
	fi
	
	backup_file copy "${LIB_INPUT_CONF_FILE}"
	
	echo "Disabling touchscreen ..."
	sed -i "s/MatchIsTouchscreen \"on\"/MatchIsTouchscreen \"off\"/g" "${LIB_INPUT_CONF_FILE}"
	
	echo
}

disable_touchscreen 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
