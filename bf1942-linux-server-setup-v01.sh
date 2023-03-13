#!/bin/bash
set -eou pipefail

# functions
brkslp () {
  echo -e "\n"
  sleep 0.3
}

# Variables
localusr=$(whoami)

# SHA 256 checksums
bfsrvinstall_checksum=c1079b1e3cc346aa17c4e058e4b0c6d965cbc6e45f40f47c9fa5e4796da69356
bfsrvpatch161b_checksum=6c60b6af994fba9e98f8e3a20ca04602f6f0ad2b40b4c549441918217bc02160
bfsrvpatchmastersrv_checksum=bf148b1f96532659bcb6a031acd5d6196e1695f30c3660274cec3502272a5fd6

brkslp
echo "BATTLEFIELD 1942 Linux Server Installer Script v1.0"
sleep 0.2
echo "by Järnet Strongrogg"
brkslp

PS3='Please select an option: '
options=("Create and install into a new directory." "Install into an existing directory." "Quit.")
select opt in "${options[@]}"; do
    case $opt in
        "Create and install into a new directory.")

            read -p "Please enter a name for the BF1942 Server destination directory: " srvdir
              read -p "$srvdir — Proceed with this name (y/n)? " answer
                case ${answer:0:1} in
                y|Y )
                  read -ep "Please select where you want to create '$srvdir' : " srvdst
                    if [ -d "$srvdst" ]
                    then

                      cd $srvdst
                      sudo mkdir $srvdir
                      sudo chown $localusr:$localusr $srvdir
                      cd $srvdir
                      srvdst=$(pwd)
                      brkslp
                      echo "BF1942 Server path: "
                      sleep 0.5
                      echo "$srvdst"
                      sleep 0.5

                      break

                    else

                      echo "Error: $srvdst does not exist."
                      sleep 0.5
                      echo "Exiting script, nothing has been modified..."
                      sleep 0.5
                      exit

                    fi

                  ;;
                n|N )
                  echo "Please make a choice."
                  brkslp
                  sleep 0.5
                  ;;
                esac
        ;;

        "Install into an existing directory.")
        read -p "Install BF1942 Server into an existing directory - Proceed with this (y/n)? " answer
          case ${answer:0:1} in
          y|Y )
            read -ep "Please set the destination directory for the BF1942 Server : " srvdst
              if [ -d "$srvdst" ]
              then

                cd $srvdst
                srvdst=$(pwd)

                # sudo chown $localusr:$localusr $srvdst
                brkslp
                echo "The BF1942 Server installation path is: "
                sleep 0.5
                echo "$srvdst"
                sleep 0.5

                break

              else

                echo "Error: $srvdst does not exist."

              fi

            ;;
          n|N )
            echo "Please make a choice."
            brkslp
            sleep 1
            ;;
          esac
        ;;
        "Quit.")
            echo "Exiting script, nothing has been modified..."
            sleep 1
            exit
	       ;;

        *)
        echo "Invalid option";;
    esac
done


brkslp

read -ep "Please select the 'BF1942 Linux Standalone Server 1.6.19 Installer' (bf1942_lnxded-1.6-rc2.tar) : " bfsrvinstall

brkslp
echo "Verifying SHA256 checksum..."
sleep 0.5
bfsrvinstall_sha256=$(shasum -a 256 $bfsrvinstall | cut -f1 -d' ')


if [ "$bfsrvinstall_checksum" == "$bfsrvinstall_sha256" ]; then
    sleep 0.5
    echo "Success! SHA256 Checksum matched!"
    sleep 0.5
    echo ""
    echo "Continuing with installation"
    echo ""
    sleep 0.5
  else
    sleep 0.5
    read -p "WARNING! Checksum mismatch, do you still want to continue (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
        echo "Continuing with installation..."
        ;;
        n|N )
        echo "Exiting script, nothing has been modified..."
        sleep 1
        exit
        ;;
        * )
        echo "Invalid option"
        exit
        ;;
    esac
fi
cd $srvdst
mkdir tmp
cp $bfsrvinstall $srvdst/tmp
cd tmp
tar -xf bf1942_lnxded-1.6-rc2.tar
bfsrvinstallrun=$(ls *run)
echo "Please note the exact path to the BF1942 Server written bellow:"
echo "$srvdst/"
echo "You need to enter this exact path in the installer"
brkslp
read -p "Press enter to continue"
./$bfsrvinstallrun

#tar -xvf $bfsrvinstall

brkslp

read -p "Continue with 1.61b Update (y/n)? " answer
case ${answer:0:1} in
    y|Y )
    echo "Continuing with installation..."
    ;;
    n|N )
    echo "Exiting script, nothing has been modified..."
    sleep 1
    exit
    ;;
esac

brkslp

read -ep "Please select the 'Battlefield 1942 Linux Server Incremental Patch 1.6.19 to 1.61b' (bf1942-update-1.61.tar.gz) : " bfsrvpatch161b

brkslp

echo "Verifying SHA256 checksum..."
sleep 0.5
bfsrvpatch161b_sha256=$(shasum -a 256 $bfsrvpatch161b | cut -f1 -d' ')


if [ "$bfsrvpatch161b_checksum" == "$bfsrvpatch161b_sha256" ]; then
    sleep 0.5
    echo "Success! SHA256 Checksum matched!"
    sleep 0.5
    echo ""
    echo "Continuing with installation"
    echo ""
    sleep 0.5
  else
    sleep 0.5
    read -p "WARNING! Checksum mismatch, do you still want to continue (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
        echo "Continuing with installation..."
        ;;
        n|N )
        echo "Exiting script, nothing has been modified..."
        sleep 1
        exit
        ;;
        * )
        echo "Invalid option"
        exit
        ;;
    esac
fi
cp $bfsrvpatch161b $srvdst/tmp
bfsrvpatch161btar=$(ls *gz)
tar -zxf $bfsrvpatch161btar
cp bf1942/bf1942_lnxded.dynamic ../bf1942/bf1942_lnxded.dynamic
cp bf1942/bf1942_lnxded.static ../bf1942/bf1942_lnxded.static
cp bf1942/mods/bf1942/* ../bf1942/mods/bf1942/
rm -rf bf1942

echo "Downloading Master Server Patch 'master.bf1942.org'"
wget https://www.mediafire.com/file/xvuiqio0etxb3ad/bf1942_lnxded_-_master.bf1942.org_-_Patch.zip -q --show-progress
unzip -qq bf1942_lnxded_-_master.bf1942.org_-_Patch.zip
cp bf1942_lnxded\ -\ master.bf1942.org\ -\ Patch/bf1942_lnxded.dynamic ../bf1942/bf1942_lnxded.dynamic
cp bf1942_lnxded\ -\ master.bf1942.org\ -\ Patch/bf1942_lnxded.static ../bf1942/bf1942_lnxded.static
echo "Success! Master Server patched!"
echo "Cleaning up"
cd $srvdst
rm -rf tmp

echo "Script finished successfully!"
sleep 2
exit
