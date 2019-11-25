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

if [ ! -f "/home/pi/RetroPie/retropiemenu/gpitools/GPFS.dialogrc" ]
then
    dialog --create-rc "/home/pi/RetroPie/retropiemenu/gpitools/GPFS.dialogrc"
fi

# General Declarations
export DIALOGRC="/home/pi/RetroPie/retropiemenu/gpitools/GPFS.dialogrc"
#echo $TERM
#sleep 20s

function main_menu() {
    while true; do
        tput civis
        Menu_Options=$(dialog --help-button --help-label "test" --item-help  --begin 1 1 --no-shadow \
	    --title " GPi FRONTEND SWITCHER " --hline "  GPi Case Users  "   \
        --ok-label "Select" --cancel-label "Cancel" --menu "\nSelect an option:\n\n\n" 26 38 20\
        EmulationStation "" "Set EmulationStation as your frontend" \
        Pegasus "" "Set Pegasus as your frontend" \
        2>&1 > /dev/tty)

        case "$Menu_Options" in
            EmulationStation) EmulationStation ;;
            Pegasus) Pegasus ;;
            $DIALOG_HELP) echo "Help pressed." ;;
            *) break ;;
        esac
    done
}

function EmulationStation() {
    tput civis
    notify-send "My name is bash and I rock da house"
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
        YesNoPrompt "Reboot required" "  GPi Case Users  " "Now" "Later" "\nA reboot is required for the changes to take effect.\n\nDo you want to do this now?" "exit" "sudo reboot"
    fi
}


function Pegasus() {
    tput civis
    # Check autostart.sh for Pegasus
    if grep -q pegasus-fe /opt/retropie/configs/all/autostart.sh; then
        # Pegasus already set as frontend
        MessageBox "\Z1\ZbFRONTEND ALREADY SET\Zn" "  GPi Case Users  " "Brought to you by GPi Case Users Group" "\n\n${FUNCNAME[0]} is already set as your frontend.\n\nPress OK to go back to the Retropie menu."
    else
        # Pegasus not set
        echo "Pegasus not set"
        # Check for Pegasus install   
        if [ -d "/opt/retropie/configs/all/pegasus-fe" ]; then
            # Pegasus already installed
            echo "Pegasus installed"
            sleep 10s
        else
            # Install Pegasus
            tput civis 
            cd ~/RetroPie-Setup
            #dialog --clear
            test=0
            sudo ./retropie_packages.sh pegasus-fe |
            while IFS= read i; do
                ((++test))
                test2=$((test*3))
                if [ $test2 -lt 100 ]
                then
                    echo $test2 | dialog --hline "  GPi Case Users  " --backtitle "TESTES..." --gauge "Installing Pegasus" 6 50
                else
                    echo 100 | dialog --hline "  GPi Case Users  " --backtitle "TESTES..." --gauge "Installing Pegasus" 6 50
                fi
            done
            sleep 10s
        fi
        (
        # Check for GPiOS
        if [ -d "/opt/retropie/configs/all/pegasus-fe/themes/pegasus-theme-gpiOS" ]; then
            # Check for update
            cd ~/.config/pegasus-frontend/themes/pegasus-theme-gpiOS
            if ! git diff --quiet remotes/origin/HEAD; then
            # Prompt to update
            YesNoPrompt "Update available" "  GPi Case Users  " "Update available" "Now" "Later" "\nAn update is available for GPiOS.\n\nDo you want to install this now?" "git pull" ":"
            else
            # No changes
            :
            fi
        else
        # Install GPiOS
            tput civis 
            cd ~/.config/pegasus-frontend/themes/
            #dialog --clear
            test=0
            sudo  git clone --progress https://github.com/SinisterSpatula/pegasus-theme-gpiOS.git --branch master --depth 1 2>&1 | tr '\r' '\n' |
            while IFS= read i; do
                ((++test))
                test2=$((test*3))
                if [ $test2 -lt 100 ]
                then
                    echo $test2 | dialog --hline "  GPi Case Users  " --backtitle "theme TESTES..." --gauge "Installing GPiOS" 6 50
                else
                    echo 100 | dialog --hline "  GPi Case Users  " --backtitle "theme TESTES..." --gauge "Installing GPiOS" 6 50
                fi
            done
            sleep 10s
        fi
        # Set theme
        echo "general.theme: themes/pegasus-theme-gpiOS/" > ~/.config/pegasus-frontend/settings.txt | echo 20; echo "XXX"; echo "Setting theme"; echo "XXX" ;
        # Configure autostart
        sudo sed -i "1 cpegasus-fe --silent &>\/dev\/null #auto" /opt/retropie/configs/all/autostart.sh | echo 20; echo "XXX"; echo "Configuring autostart"; echo "XXX" ;
        sleep 1s ;
        # Configure safe shutdown
        sudo rm /opt/RetroFlag/multi_switch.sh | echo 50; echo "XXX"; echo "Configuring safe shutdown"; echo "XXX" ;sleep 1s ;
        sleep 1s ;
        sudo curl https://raw.githubusercontent.com/SolemnSpirit/test/master/multi_switch_pegasus.sh --output /opt/RetroFlag/multi_switch.sh > /dev/null 2>&1 | echo 75; echo "XXX"; echo "Configuring safe shutdown"; echo "XXX" ;
        sleep 1s ;
        echo 100; echo "XXX"; echo "Done !"; echo "XXX" ;
        sleep 1s ;
    ) | dialog --hline "  GPi Case Users  " --backtitle "Switching to ${FUNCNAME[0]}..." --gauge "Switching to "${FUNCNAME[0]}"" 6 50

    fi
}

function Progress_Bar() {
    echo $((StepsComplete * 100 / Steps)) | dialog --begin 3 1 --title "$1" --hline "$2" --backtitle "$3" --gauge "$4" 26 38 20
}

function YesNoPrompt {
    if ! dialog --colors --begin 3 1 --title "$1" --hline "$2" --yes-label "$3" --no-label "$4" --yesno "$5" 26 38 20>&1 > /dev/tty
    then
        eval "$6" > /dev/null 2>&1
    else
    	eval "$7" > /dev/null 2>&1
    fi
}

function MessageBox {
	dialog --begin 3 1 --title "$1" --hline "$2" --backtitle "$3" --colors --msgbox "$4" 27 38
	sleep 1s
	exit 1
}

main_menu
