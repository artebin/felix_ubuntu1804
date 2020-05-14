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

install_geany_markdown_plugin_from_sources(){
	printf "Install Geany / Markdown plugin from sources ...\n"
	
	# Install dependencies
	install_package_if_not_installed "intltool" "libwebkit2gtk-4.0-dev"
	
	# Clone git repository
	cd ${RECIPE_DIRECTORY}
	git clone https://github.com/geany/geany-plugins
	
	# Compile and install
	cd ${RECIPE_DIRECTORY}
	cd geany-plugins
	./autogen.sh
	./configure
	cd markdown
	make
	make install
	
	# Clean
	cd ${RECIPE_DIRECTORY}
	rm -fr ./geany-plugins
	
	printf "\n"
}



cd ${RECIPE_DIRECTORY}
install_geany_markdown_plugin_from_sources 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [ "${EXIT_CODE}" -ne 0 ]; then
	exit "${EXIT_CODE}"
fi
