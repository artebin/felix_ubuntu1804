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
exit_if_has_not_root_privileges

configure_trackpad_mtrack(){
	if [[ "${DRIVER_INPUT_DEVICES}" != "mtrack" ]]; then
		printf "This recipe is not applicable (DRIVER_INPUT_DEVICES: ${DRIVER_INPUT_DEVICES})\n"
		return
	fi
	
	printf "Configuring trackpad mtrack ...\n"
	
	install_package_if_not_installed "xserver-xorg-input-mtrack"
	
	# For reference, the X11 mouse button numbering:
	#   1 = left button
	#   2 = middle button (pressing the scroll wheel)
	#   3 = right button
	#   4 = turn scroll wheel up
	#   5 = turn scroll wheel down
	#   6 = push scroll wheel left
	#   7 = push scroll wheel right
	#   8 = 4th button (aka browser backward button)
	#   9 = 5th button (aka browser forward button)
	#
	# See <http://xahlee.info/linux/linux_x11_mouse_button_number.html>.
	
	cd "${RECIPE_DIR}"
	cp 80-mtrack.conf /usr/share/X11/xorg.conf.d
	
	printf "\n"
}

configure_trackpad_mtrack 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
