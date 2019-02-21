#!/usr/bin/env bash

BASEDIR="$(dirname ${BASH_SOURCE}|xargs readlink -f)"
FELIX_ROOT="${BASEDIR%/felix/*}/felix"
source "${FELIX_ROOT}/felix.sh"
LOGFILE="$(retrieve_log_file_name ${BASH_SOURCE}|xargs readlink -f)"
source "${FELIX_ROOT}/ubuntu_1804/ubuntu_1804.conf"

exit_if_not_bash
exit_if_has_not_root_privileges

disable_startup_chime(){
	echo "Disabling startup chime ..."
	
	# See <https://linux-tips.com/t/disable-startup-sound-of-macbook-and-imac/606/2>
	
	SYSTEM_AUDIO_VOLUME_PATH="/sys/firmware/efi/efivars/SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82"
	if [[ ! -f "${SYSTEM_AUDIO_VOLUME_PATH}" ]]; then
		echo "Cannot find variable at path: ${SYSTEM_AUDIO_VOLUME_PATH}"
		exit 1
	fi
	
	# Some variable are immutable by default in /sys/firware/efi/efivars notably 'SystemAudioVolume-7c436110-ab2a-4bbb-a880-fe41995c9f82'
	# See <https://www.linuxtechi.com/file-directory-attributes-in-linux-using-chattr-lsattr-command>
	lsattr /sys/firmware/efi/efivars
	chattr -i "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	printf "\x07\x00\x00\x00\x00" > "${SYSTEM_AUDIO_VOLUME_PATH}"
	
	echo
}

disable_startup_chime 2>&1 | tee -a "${LOGFILE}"
EXIT_CODE="${PIPESTATUS[0]}"
if [[ "${EXIT_CODE}" -ne 0 ]]; then
	exit "${EXIT_CODE}"
fi
