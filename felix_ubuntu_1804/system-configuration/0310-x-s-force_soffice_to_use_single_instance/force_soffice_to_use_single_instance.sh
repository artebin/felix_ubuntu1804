#!/usr/bin/env bash

RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIRECTORY}"

force_soffice_to_use_single_instance(){
	printf "Force soffice to use single instance ...\n"
	
	cp soffice_single_instance.sh /usr/local/bin
	chmod 755 /usr/local/bin/soffice_single_instance.sh
	update-alternatives --install /usr/bin/soffice soffice /usr/local/bin/soffice_single_instance.sh 10
	
	printf "\n"
}

exit_if_not_bash
exit_if_has_not_root_privileges

force_soffice_to_use_single_instance 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
