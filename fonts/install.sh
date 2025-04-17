#!/bin/bash

# script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# source directories of the fonts
ttf_dir="$script_dir/ttf"
ms_fonts_dir="$script_dir/MS Fonts"

# check for .ttf files in source directories
if [ -z "$(ls -A "$ttf_dir"/*.ttf 2>/dev/null)" ] && [ -z "$(ls -A "$ms_fonts_dir"/*.ttf 2>/dev/null)" ]; then
    echo "No .ttf files found in the source directories"
    exit 1
fi

# text formatting
BOLD='\033[1m'
RESET='\033[0m'

# user install options
echo -e "${BOLD}Please select an install option:${RESET}"
echo "1) Install for single user"
echo "2) Install system-wide"
read -p "Your installation choice [1 or 2]: " choice

# destination directories
single_user_dir="$HOME/.local/share/fonts"
system_wide_dir="/usr/share/fonts/ttf"

# copy .ttf files
copy_files() {
    local dest_dir=$1
    mkdir -p "$dest_dir"
    
    # copy ttf files if they exist
    if [ -d "$ttf_dir" ] && [ "$(ls -A "$ttf_dir"/*.ttf 2>/dev/null)" ]; then
        cp "$ttf_dir"/*.ttf "$dest_dir"
        echo "TTF fonts copied to $dest_dir"
    fi
    
    # copy ms fonts if they exist
    if [ -d "$ms_fonts_dir" ] && [ "$(ls -A "$ms_fonts_dir"/*.ttf 2>/dev/null)" ]; then
        cp "$ms_fonts_dir"/*.ttf "$dest_dir"
        echo "MS Fonts copied to $dest_dir"
    fi
}

# copy based on the user choice
case $choice in
    1)
        copy_files "$single_user_dir"
        ;;
    2)
        if [ "$EUID" -ne 0 ]; then
            echo -e "${BOLD}Please re-run as root to install system-wide.${RESET}"
            exit 1
        fi
        copy_files "$system_wide_dir"
        ;;
    *)
        echo -e "${BOLD}Invalid choice. Please run the script again and select a valid option.${RESET}"
        exit 1
        ;;
esac

# update the font cache
fc-cache -f -v

# print completion message
echo -e "${BOLD}
Installation Completed!${RESET}"