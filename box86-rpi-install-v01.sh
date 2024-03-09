#!/bin/bash
set -eou pipefail

#variables
rpi="$(grep -c 'Raspberry Pi' /proc/cpuinfo)"
rpiv="$(grep -i 'Raspberry Pi' /proc/cpuinfo | cut -d ' ' -f4)"
osbit="$(getconf LONG_BIT)"

if [ "$rpi" == "0" ]; then
    sleep 0.5
    echo "Your device is not a Raspberry Pi!"
    sleep 0.5
    echo ""
    echo "Exiting... No changes have been made."
    echo ""
    sleep 0.5
fi

if [ "$rpiv" -lt "2" ]; then
    sleep 0.5
    echo "Your Raspberry Pi is incompatible with Box86"
    sleep 0.5
    echo ""
    echo "Exiting... No changes have been made."
    echo ""
    sleep 0.5
fi

sudo apt update && sudo apt full-upgrade -y


if [ "$osbit" == "64" ]; then

    sudo dpkg --add-architecture armhf && sudo apt update -y
    sudo apt install gcc-arm-linux-gnueabihf libc6:armhf libncurses5:armhf libstdc++6:armhf -y

fi

sudo apt install git build-essential cmake -y

git clone https://github.com/ptitSeb/box86

mkdir ~/box86/build

cd ~/box86/build

if [ $rpiv -gt "4" ]; then
rpiv="4"
fi

if [ $osbit == "64" ]; then
osbitcmake="ARM64"
else
osbitcmake=""
fi

if [ $rpiv -lt "4" ]; then
osbitcmake=""
fi

cmake .. -DRPI$rpiv$osbitcmake=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

make -j$(nproc)

sudo make install

sudo systemctl restart systemd-binfmt

read -p "Reboot now (y/n)? " answer
case ${answer:0:1} in
    y|Y )
    echo "Rebooting..."
    sudo reboot
    ;;
    n|N )
    exit
    ;;
esac

