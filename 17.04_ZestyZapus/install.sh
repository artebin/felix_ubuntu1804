#!/bin/bash

if [ ! "${BASH_VERSION}" ] ; then
  echo "This script should run with bash!" 1>&2
  exit 1
fi

source ./common.sh

# Build your initial list of scripts with:
# find ./system/ -iname "*.sh" -exec sh -c 'echo \""{}"\" \\' \; | sort

SYSTEM_SCRIPT_PATH_ARRAY=( \
"./system/0000-upgrade_system/upgrade_system.sh" \
"./system/0001-install_packages/install_packages.sh" \
"./system/0002-remove_unwanted_packages/remove_unwanted_packages.sh" \
"./system/0003-configure_grub/configure_grub.sh" \
"./system/0004-disable_apport/disable_apport.sh" \
"./system/0005-configure_bash_for_root/configure_bash_for_root.sh" \
"./system/0006-enable_hibernation/enable_hibernation.sh" \
"./system/0007-configure_alternatives/configure_alternatives.sh" \
"./system/0008-add_lightdm_greeter_badges/add_lightdm_greeter_badges.sh" \
"./system/0009-install_gtk_themes/install_gtk_themes.sh" \
"./system/0010-install_icon_themes/install_icon_themes.sh" \
"./system/0011-configure_gtk/configure_gtk.sh" \
"./system/0012-install_pasystray_from_sources/install_pasystray_from_sources.sh" \
"./system/0013-install_google_chome/install_google_chrome.sh" \
"./system/0015-install_skype/install_skype.sh" \
"./system/0016-install_remarquable/install_remarquable.sh" \
"./system/0017-configure_php_in_userdir/configure_php_in_userdir.sh" \
"./system/0018-configure_ssh_welcome_text/configure_ssh_welcome_text.sh" \
)

execute_all_system_scripts(){
  for SCRIPT_PATH in ${SYSTEM_SCRIPT_PATH_ARRAY[@]}; do
    cd ${BASEDIR}
    SCRIPT_NAME=$(basename "${SCRIPT_PATH}")
    echo "SCRIPT_NAME=${SCRIPT_NAME}"
    
    SCRIPT_PATH=$(readlink -f "${SCRIPT_PATH}")
    echo "SCRIPT_PATH=${SCRIPT_PATH}"
    
    SCRIPT_BASE_DIRECTORY=$(dirname "${SCRIPT_PATH}")
    echo "SCRIPT_BASE_DIRECTORY=${SCRIPT_BASE_DIRECTORY}"
    
    SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
    echo "SCRIPT_LOG_NAME=${SCRIPT_LOG_NAME}"
    
    cd ${SCRIPT_BASE_DIRECTORY}
    sudo bash ./${SCRIPT_NAME}
  done
}

USER_SCRIPT_PATH_ARRAY=( \
"./user/0000-configure_bash/configure_bash.sh" \
"./user/0001-configure_vim/configure_vim.sh" \
"./user/0002-install_fonts/install_fonts.sh" \
"./user/0003-configure_gtk/configure_gtk.sh" \
"./user/0004-openbox/configure_openbox.sh" \
"./user/0006-tint2/configure_tint2.sh" \
"./user/0007-configure_dmenu/configure_dmenu.sh" \
"./user/0007-configure_dmenu/dmenu-bind.sh" \
"./user/0008-configure_xfce4_power_manager/configure_xfce4_power_manager.sh" \
"./user/0009-configure_xfce4_thunar/configure_xfce4_thunar.sh" \
"./user/0010-configure_mate_terminal/configure_mate_terminal.sh" \
"./user/0011-configure_mate_caja/configure_mate_caja.sh" \
"./user/0012-configure_htop/configure_htop.sh" \
"./user/0013-vlc/configure_vlc.sh" \
"./user/0015-install_dokuwiki_in_userdir/install_dokuwiki_in_userdir.sh" \
"./user/0016_dbus_mpris_listener/mediaplayer2_title.sh" \
"./user/0017-configure_geany/configure_geany.sh" \
"./user/0100-configure_default_applications/configure_default_applications.sh" \
)

execute_all_user_scripts(){
  for SCRIPT_PATH in ${USER_SCRIPT_PATH_ARRAY[@]}; do
    cd ${BASEDIR}
    SCRIPT_NAME=$(basename "${SCRIPT_PATH}")
    echo "SCRIPT_NAME=${SCRIPT_NAME}"
    
    SCRIPT_PATH=$(readlink -f "${SCRIPT_PATH}")
    echo "SCRIPT_PATH=${SCRIPT_PATH}"
    
    SCRIPT_BASE_DIRECTORY=$(dirname "${SCRIPT_PATH}")
    echo "SCRIPT_BASE_DIRECTORY=${SCRIPT_BASE_DIRECTORY}"
    
    SCRIPT_LOG_NAME="${SCRIPT_NAME%.*}.log.$(date +'%y%m%d-%H%M%S')"
    echo "SCRIPT_LOG_NAME=${SCRIPT_LOG_NAME}"
    
    cd ${SCRIPT_BASE_DIRECTORY}
    bash ./${SCRIPT_NAME}
  done
}

check_xubuntu_version && (execute_all_system_scripts;execute_all_user_scripts)
