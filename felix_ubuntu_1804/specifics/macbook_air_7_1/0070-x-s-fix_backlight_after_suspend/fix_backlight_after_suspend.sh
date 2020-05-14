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

fix_backlight_after_suspend(){
	echo "Fixing backlight after suspend ..."
	
	# Install dependencies
	install_package_if_not_installed "elfutils" "libelf-dev"
	
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/patjak/mba6x_bl
	cd ./mba6x_bl
	make
	make install
	depmod -a
	modprobe mba6x_bl
	
	cd "${RECIPE_DIRECTORY}"
	cp 98-mba6bl.conf /usr/share/X11/xorg.conf.d/98-mba6bl.conf
	if [[ -f "/usr/share/X11/xorg.conf.d/20-intel.conf" ]]; then
		backup_file rename /usr/share/X11/xorg.conf.d/20-intel.conf
	fi
	
	# Cleaning
	cd "${RECIPE_DIRECTORY}"
	rm -rf ./mba6x_bl
	
	echo
}

fix_backlight_after_suspend 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
