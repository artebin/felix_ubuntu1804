#!/bin/bash

. ../../common.sh
check_shell
get_root_privileges

install_bunsen_faenza(){
  cd ${BASEDIR}
  echo "Installing bunsen-faenza-icon-theme ..."
  git clone https://github.com/BunsenLabs/bunsen-faenza-icon-theme
  cd bunsen-faenza-icon-theme
  tar xzf bunsen-faenza-icon-theme.tar.gz
  cp -r ./Faenza-Bunsen /usr/share/icons/
  cp -r ./Faenza-Bunsen-common /usr/share/icons
  cp -r ./Faenza-Dark-Bunsen /usr/share/icons
  
  # Cleanup
  cd ${BASEDIR}
  rm -fr bunsen-faenza-icon-theme
  
  # Custumization: status icons are black but we want have them gray (tint2)
  rm -fr /usr/share/icon/Faenza-Bunsen/status
  cp -r /usr/share/icon/Faenza-Dark/state /usr/share/icons/Faenza-Bunsen
  
  update-icon-caches /usr/share/icons
}

cd ${BASEDIR}
install_bunsen_faenza 2>&1 | tee -a ./${SCRIPT_LOG_NAME}
