#!/bin/bash
set -eou pipefail

# functions
brkslp () {
  echo -e "\n"
  sleep 0.3
}



set -eou pipefail

brkslp
echo "WARNING! This script is currently only compatible with RPi4 running a 64-Bit OS (E.g. Raspberry Pi OS Lite 64-Bit)"
echo "This script will be updated with more features and support more RPi models and 32-Bit Operating Systems in the future"
brkslp

read -p "Would you like to continue with the Box86 installation (y/n)? " answer
case ${answer:0:1} in
    y|Y )
    echo "Proceeding with Box86 Installation..."
    ;;
    n|N )
    echo "Exiting script, nothing has been modified..."
    sleep 1
    exit
    ;;
    *)
    echo "Invalid option: Exiting script, nothing has been modified..."
    sleep 1
    exit
    ;;
esac

brkslp

sudo apt update && sudo apt full-upgrade -y

sudo apt install git build-essential cmake -y

git clone https://github.com/ptitSeb/box86

sudo dpkg --add-architecture armhf

sudo apt update

sudo apt install gcc-arm-linux-gnueabihf libc6:armhf libncurses5:armhf libstdc++6:armhf -y

cd ~/box86

mkdir build

cd build

cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo

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
