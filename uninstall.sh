#!/bin/bash
bold=$(tput bold)
green='\033[0;32m'

# Requesting root access to elevate script...
if (($EUID != 0)); then
  if [[ -t 1 ]]; then
    sudo "$0" "$@"
  else
    exec 1>output_file
    gksu "$0 $@"
  fi
  exit
fi

echo "Deleting PreMiD installed files..."
rm -rf /usr/lib/premid
echo "Deleting launch script..."
rm /usr/bin/premid
echo "Deleting application launcher entry..."
rm /usr/share/applications/premid.desktop
echo "Deleting license..."
rm /usr/share/licenses/premid/LICENSE
echo "Deleting icon..."
/usr/share/pixmaps/premid.png

echo -e "${green}${bold}PreMiD successfully uninstalled! Have a nice day!"
