#!/bin/bash
bold=$(tput bold)
green='\033[0;32m'

# If script was elevated, exit. We don't want to run as root (yet)
if [ `id -u` = 0 ] ; then
    echo "Error: don't run the script as sudo!"
    exit 1
fi

set -e

# Check for presence of dependencies git, node and npm.
if [ "$(which git)" = "" ] ;then
    echo "This script requires git, please resolve and try again."
    exit 1
fi

if [ "$(which node)" = "" ] ;then
    echo "This script requires NodeJS, please resolve and try again."
    exit 1
fi

if [ "$(which npm)" = "" ] ;then
    echo "This script requires npm, please resolve and try again."
    exit 1
fi

echo "Cloning the PreMiD source files..."
git clone https://github.com/PreMiD/PreMiD

echo "Installing dependencies for building..."
cd PreMiD
npm install
cd src
npm install
cd ..

echo "Packaging Linux files..."
npm run pkglinux

echo "Adding PreMiD to /usr/bin and shortcut to Application launcher..."
sudo bash -c 'cp src/assets/images/logo.png "${pkgdir}/usr/share/pixmaps/premid.png"'
sudo bash -c  'mkdir /usr/lib/premid'
sudo bash -c 'echo "#!/bin/bash
cd /usr/lib/premid/
./PreMiD" > /usr/bin/premid'
sudo bash -c 'chmod +x /usr/bin/premid'
sudo bash -c 'echo "[Desktop Entry]
Name=PreMiD
GenericName=PreMiD
Comment=PreMiD adds Discord Rich Presence support to a lot of services you use and love.
Exec=/usr/bin/premid
Terminal=false
Type=Application
Icon=premid.png" > /usr/share/applications/premid.desktop'
sudo bash -c 'cp src/assets/images/logo.png "${pkgdir}/usr/share/pixmaps/premid.png"'

echo "Copying PreMiD to /usr/lib..."
cd out/PreMiD-linux-x64
sudo bash -c 'cp -r ./* /usr/lib/premid'
sudo bash -c 'install -Dm644 LICENSE /usr/share/licenses/premid/LICENSE'

echo "Cleaning up..."
cd ../../../
rm -rf PreMiD

echo -e "${green}Done!"
echo "${bold}Don't forget to install the web extension for your browser! Visit our GitHub for instructions: \n"
echo "https://github.com/PreMiD/PreMiD#installation"