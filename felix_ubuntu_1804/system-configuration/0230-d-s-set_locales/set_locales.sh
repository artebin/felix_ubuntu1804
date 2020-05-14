#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIRECTORY\%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
initialize_recipe "${RECIPE_DIRECTORY}"

exit_if_not_bash
exit_if_has_not_root_privileges

set_locales(){
	echo "Generating locales ..."
	locale-gen ${LOCALES_TO_GENERATE}
	
	echo "Setting locales ..."
	update-locale LANG="${LOCALE_TO_USE_LANG}"
	update-locale LC_ALL="${LOCALE_TO_USE_LC_ALL}"
	update-locale LC_COLLATE="${LOCALE_TO_USE_LC_COLLATE}"
	update-locale LC_NUMERIC="${LOCALE_TO_USE_LC_NUMERIC}"
	update-locale LC_TIME="${LOCALE_TO_USE_LC_TIME}"
	update-locale LC_MONETARY="${LOCALE_TO_USE_LC_MONETARY}"
	update-locale LC_PAPER="${LOCALE_TO_USE_LC_PAPER}"
	update-locale LC_NAME="${LOCALE_TO_USE_LC_NAME}"
	update-locale LC_ADDRESS="${LOCALE_TO_USE_LC_ADDRESS}"
	update-locale LC_TELEPHONE="${LOCALE_TO_USE_LC_TELEPHONE}"
	update-locale LC_MEASUREMENT="${LOCALE_TO_USE_LC_MEASUREMENT}"
	update-locale LC_IDENTIFICATION="${LOCALE_TO_USE_LC_IDENTIFICATION}"
	
	cat /etc/default/locale
	
	echo
}

set_locales 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
