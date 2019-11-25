#!/bin/bash
#======================================================================================
#title:         GPFS-Installer.sh
#description:   Installs GPi Frontend Switcher
#author:        SolemnSpirit
#created:       November 25 2019
#version:       0.1
#======================================================================================

(
sudo curl https://raw.githubusercontent.com/SolemnSpirit/test/master/GPFS.png --output /home/pi/RetroPie/retropiemenu/icons/GPFS.png > /dev/null 2>&1 | echo 25; echo "XXX"; echo "Installing GPFS"; echo "XXX" ;
sudo sed -i '$ d' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
(
echo "<game>" ;	
echo "<path>./gpitools/GPi-Frontend-Switcher/frontend-switcher.sh</path>";	
echo "<name>Frontend Switcher</name>";	
echo "<desc>Easily switch between EmulationStation and Pegasus as your frontend - by SolemnSpirit.</desc>";	
echo "<image>./icons/GPFS.png</image>";	
echo "</game>" ;
echo "</gameList>" ;
) >>/opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml | echo 50; echo "XXX"; echo "Installing GPFS"; echo "XXX" ;

sudo curl https://raw.githubusercontent.com/SolemnSpirit/test/master/GPFS.dialogrc --output /home/pi/RetroPie/retropiemenu/gpitools/GPFS.dialogrc > /dev/null 2>&1 | echo 75; echo "XXX"; echo "Installing GPFS"; echo "XXX" ;

sudo curl https://raw.githubusercontent.com/SolemnSpirit/test/master/GPFS.sh --output /home/pi/RetroPie/retropiemenu/gpitools/GPFS.sh > /dev/null 2>&1 | echo 100; echo "XXX"; echo "Installing GPFS"; echo "XXX" ;
) | dialog --hline "  GPi Case Users  " --backtitle "Brought to you by GPi Case Users Group" --gauge "Installing GPFS" 6 50
