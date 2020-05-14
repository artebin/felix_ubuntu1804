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

install_pasystray(){
	echo "Installing pasystray from sources ..."
	
	# Install dependencies
	DEPENDENCIES=(  "libavahi-client-dev"
					"libavahi-common-dev"
					"libavahi-compat-libdnssd-dev"
					"libavahi-core-dev"
					"libavahi-glib-dev"
					"libavahi-gobject-dev"
					"libavahi-ui-gtk3-dev"
					"libappindicator-dev"
					"libappindicator3-dev" )
	install_package_if_not_installed "${DEPENDENCIES[@]}"
	
	# Clone git repository <https://github.com/christophgysin/pasystray>
	cd "${RECIPE_DIRECTORY}"
	git clone https://github.com/christophgysin/pasystray
	
	# Compile and install
	cd "${RECIPE_DIRECTORY}"
	cd pasystray
	./bootstrap.sh
	./configure
	make
	make install
	
	# Cleanup
	cd "${RECIPE_DIRECTORY}"
	rm -fr pasystray
	
	echo
}

cd "${RECIPE_DIRECTORY}"
install_pasystray 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
