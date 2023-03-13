# BF1942 RPi Server Setup
Setup a Battlefield 1942 Dedicated Server on a Raspberry Pi


# Install Box86 on RPi4
1. Download or send the script "box86-install-rpi4-64bit-v01.sh" to the home folder of your user on your RPi (E.g. /home/rpi/)

2. Run the following command in terminal: 
  chmod +x ~/box86-install-rpi4-64bit-v01.sh

3. Run the script to install Box86 on your RPi with the following command:
  ./box86-install-rpi4-64bit-v01.sh


# Setup & Install BF1942 Server on a RPi4
1. Send the script: (bf1942-server-install-v01.sh) to your linux server via FileZilla or similar along with "bf1942_lnxded-1.6-rc2.tar" and "bf1942-update-1.61.tar.gz" .


2. SSH in to the server and make the script executable with the following command: 
  chmod +x bf1942-linux-server-setup-v01.sh

3. Then you run the script with:
  ./bf1942-linux-server-setup-v01.sh
 
You will then be guided through the setup of your server! 
Enjoy!

(The required master server patch is baked into the script for now. It will download it and patch your server automatically.)

# Download links:

Battlefield 1942 Linux Standalone Server 1.6.19 (bf1942_lnxded-1.6-rc2.tar)
https://community.pcgamingwiki.com/files/file/1002-battlefield-1942-linux-standalone-server-1619/

Battlefield 1942 Linux Server Incremental Patch 1.6.19 to 1.61b (bf1942-update-1.61.tar.gz)
https://community.pcgamingwiki.com/files/file/1003-battlefield-1942-linux-server-incremental-patch-1619-to-161b/
