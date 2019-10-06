#!/usr/bin/env bash

declare -g RECIPE_DIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
declare -g FELIX_ROOT="${RECIPE_DIR%/felix/*}/felix"
if [[ ! -f "${FELIX_ROOT}/felix.sh" ]]; then
	printf "Cannot find ${FELIX_ROOT}/felix.sh\n"
	exit 1
fi
source "${FELIX_ROOT}/felix.sh"
init_recipe "${RECIPE_DIR}"

exit_if_not_bash
exit_if_has_root_privileges

configure_tint2(){
	echo "Configuring tint2 ..."
	if [[ -d "{$HOME}/.config/tint2" ]]; then
		backup_file rename "${HOME}/.config/tint2"
	fi
	mkdir -p "${HOME}/.config/tint2"
	cp "${RECIPE_FAMILY_DIR}/dotfiles/.config/tint2/tint2rc" "${HOME}/.config/tint2/tint2rc"
	echo
}

configure_tint2 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
