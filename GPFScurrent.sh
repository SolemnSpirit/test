#!/bin/bash
#======================================================================================
#title:         Frontend-Switcher.sh
#description:   Lets you switch between Emulationstation and Pegasus frontends easily
#author:        SolemnSpirit
#created:       September 19 2019
#version:       0.8
#last updated: October 10 2019
#usage:         ./Frontend-Switcher.sh
#======================================================================================

if [ ! -f "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc" ]
then

dialog --create-rc "/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"
fi

# General Declarations
export DIALOGRC="/home/pi/RetroPie/retropiemenu/gpitools/GPi-Frontend-Switcher/GPFS.dialogrc"
#echo $TERM
sleep 20s

function main_menu() {
 while true; do
 tput civis 
        Menu_Options=$(dialog --begin 3 1 --no-shadow \
	    --title " GPi FRONTEND SWITCHER " --hline "  GPi Case Users  " --backtitle "Main Menu"  \
            --ok-label Select --cancel-label Cancel \
            --menu "\nSelect an option:\n\n" 26 38 20\
            1 "EmulationStation" \
            2 "Pegasus" \
            2>&1 > /dev/tty)

        case "$Menu_Options" in
            1)EmulationStation  ;;
            2)Pegasus  ;;
            *) break ;;
        esac
    done
}

function EmulationStation() {
    tput civis
    # Check autostart.sh for EmulationStation
    if grep -q emulationstation /opt/retropie/configs/all/autostart.sh; then
    # EmulationStation already set as frontend
    MessageBox "\Z1\ZbFRONTEND ALREADY SET\Zn" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\n${FUNCNAME[0]} is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
   
    else

    # EmulationStation not set
    ( 
        # Configure autostart
        sudo sed -i "1 cemulationstation #auto" /opt/retropie/configs/all/autostart.sh | echo 25; echo "XXX"; echo "Configuring autostart"; echo "XXX" ;
        sleep 1s ;
        # Configure safe shutdown
        sudo rm /opt/RetroFlag/multi_switch.sh | echo 50; echo "XXX"; echo "Configuring safe shutdown"; echo "XXX" ;sleep 1s ; 
        sleep 1s ;
        sudo curl https://raw.githubusercontent.com/SolemnSpirit/test/master/multi_switch_es.sh --output /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1 | echo 75; echo "XXX"; echo "Configuring safe shutdown"; echo "XXX" ;
		sleep 1s ;  
        echo 100; echo "XXX"; echo "Done !"; echo "XXX" ;
        sleep 1s ; 
    ) | dialog --hline "  GPi Case Users  " --backtitle "Switching to ${FUNCNAME[0]}..." --gauge "Switching to "${FUNCNAME[0]}"" 6 50

    YesNoPrompt "Reboot required" "  GPi Case Users  " "Reboot required" "Now" "Later" "\nA reboot is required for the changes to take effect.\n\nDo you want to do this now?" "exit" "sudo reboot"

    fi

}

function Pegasus() {
    tput civis
    # Check autostart.sh for EmulationStation
    #if grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh; then
    # Pegasus already set as frontend
    #MessageBox "\Z1\ZbFRONTEND ALREADY SET\Zn" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\n${FUNCNAME[0]} is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
    
    #else

    #if [ -d "/opt/retropie/configs/all/pegasus-fe" ]; then
    #echo "Pegasus installed"
    #sleep 10s
    #else
    # Install Pegasus

    #(       
   #        tput civis 
            cd ~/RetroPie-Setup
            Steps=0 
            sudo ./retropie_packages.sh pegasus-fe |
            while IFS= read i; do
                ((++Steps))
                StepsPercent=$((Steps*3))
                #if [ $StepsPercent -lt 100 ]
                #then
                #    echo $StepsPercent | dialog --hline "  GPi Case Users  " --backtitle "Brought to you by GPi Case Users Group" --gauge "Installing Pegasus" 6 50
                #else
               #    echo 100 | dialog --hline "  GPi Case Users  " --backtitle "Brought to you by GPi Case Users Group" --gauge "Installing Pegasus" 6 50
                #fi
            done
            sleep 10s
    #) | dialog --hline "  GPi Case Users  " --backtitle "Switching to ${FUNCNAME[0]}..." --gauge "Switching to "${FUNCNAME[0]}"" 6 50
    #fi
    #fi
}

function Progress_Bar() {
    echo $((StepsComplete * 100 / Steps)) | dialog --begin 3 1 --title "$1" --hline "$2" --backtitle "$3" --gauge "$4" 26 38 20    
} 

function YesNoPrompt {
    if ! dialog --colors --begin 3 1 --title "$1" --hline "$2" \
        --backtitle "$3" --yes-label "$4" --no-label "$5" \
        --yesno "$6" 26 38 20>&1 > /dev/tty
    then
    	eval "$7" > /dev/null 2>&1
    else
    	eval "$8" > /dev/null 2>&1
    fi
}

function MessageBox {
	dialog --begin 3 1 --title "$1" --hline "$2" --backtitle "$3" --colors --msgbox "$4" 27 38
	sleep 1s
	exit 1
}

main_menu