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

install_sw_from_sources(){
	printf "\nInstalling sw (StopWatch) from sources ...\n\n"
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/artebin/sw
	cp sw/sw /usr/local/bin
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr sw
	
	printf "\n"
}

install_sw_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
