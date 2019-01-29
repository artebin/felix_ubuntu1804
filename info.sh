#!/usr/bin/env bash

source ./common.sh
is_bash
exit_if_has_not_root_privileges

print_dmi_info_bios(){
	print_section_heading "DMI information BIOS (dmidecode)"
	echo "bios-vendor: $(dmidecode -s bios-vendor)"
	echo "bios-version: $(dmidecode -s bios-version)"
	echo "bios-release-date: $(dmidecode -s bios-release-date)"
	print_section_ending
}

print_dmi_info_system(){
	print_section_heading "DMI information System (dmidecode)"
	echo "system-manufacturer: $(dmidecode -s system-manufacturer)"
	echo "system-product-name: $(dmidecode -s system-product-name)"
	echo "system-version: $(dmidecode -s system-version)"
	print_section_ending
}

print_dmi_info_memory(){
	print_section_heading "DMI table decoder (dmidecode)"
	dmidecode
	print_section_ending
}

print_hardware_info_inxi(){
	print_section_heading "Hardware information (inxi -Fxz)"
	inxi -Fxz
	print_section_ending
}

print_display_info_xrandr(){
	print_section_heading "Display information (xrandr --current)"
	xrandr --current
	print_section_ending
}

print_lsb_release(){
	print_section_heading "Distribution name (cat /etc/lsb-release)"
	cat /etc/lsb-release
	print_section_ending
}

print_video_card_model_and_driver(){
	print_section_heading "Video card model and driver"
	lspci -k | grep -EA3 'VGA|3D|Display' 
	print_section_ending
}

print_linux_kernel_version(){
	print_section_heading "Linux Kernel Version"
	cat /proc/version
	print_section_ending
}

print_memory_info(){
	print_section_heading "Memory info (cat /proc/meminfo)"
	cat /proc/meminfo
	print_section_ending
}

print_free_memory(){
	print_section_heading "Free memory (free -m)"
	free -m
	print_section_ending
}

print_swap_information(){
	print_section_heading "Swap information (cat /proc/swaps)"
	cat /proc/swaps
	print_section_ending
}

print_temperature_sensors(){
	print_section_heading "Temperature sensors (sensors)"
	sensors
	print_section_ending
}

print_gtk_version(){
	print_section_heading "GTK+ version (dpkg -l libgtk2.0-0 libgtk-3-0)"
	dpkg -l libgtk2.0-0 libgtk-3-0
	print_section_ending
}

print_key_codes(){
	print_section_heading "Key codes (xmodmap -pke)"
	xmodmap -pke
	print_section_ending
}

print_dmi_info_bios
print_dmi_info_system
print_hardware_info_inxi | remove_terminal_control_sequences
print_display_info_xrandr
print_lsb_release
print_linux_kernel_version
print_memory_info
print_free_memory
print_swap_information
print_temperature_sensors
print_gtk_version
print_key_codes
