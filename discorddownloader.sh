#!/bin/bash
# Title: discorddownloader
# Author: simonizor
# URL: http://www.simonizor.gq/discorddownloader
# Dependencies: Required: 'wget', 'curl'; Optional: 'dialog' (discorddownloader GUI); 'nodejs', 'npm', 'zip' (BetterDiscord); 'python3.x', 'python3-pip', 'psutil' (mydiscord).
# Description: A script that can install all versions of Discord. It can also install mydiscord and BetterDiscord. If you have 'dialog' installed, a GUI will automatically be shown.

DDVER="1.6.3"
X="v1.6.3 - Changed most echos to read -p so user can actually read output.  Also put in clears to get rid of some of the mess in terminal."
# ^^ Remember to update these and version.txt every release!
SCRIPTNAME="$0"

programisinstalled () {
    # set to 1 initially
    return=1
    # set to 0 if not found
    type $1 >/dev/null 2>&1 || { return=0; }
    # return value
}

updatescript () {
cat >/tmp/updatescript.sh <<EOL
runupdate () {
    if [ "$SCRIPTNAME" = "/usr/bin/discorddownloader" ]; then
        wget -O /tmp/discorddownloader.sh "https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/discorddownloader.sh"
        if [ -f "/tmp/discorddownloader.sh" ]; then
            sudo rm -f $SCRIPTNAME
            sudo mv /tmp/discorddownloader.sh $SCRIPTNAME
            sudo chmod +x $SCRIPTNAME
        else
            read -p "Update Failed! Try again? Y/N " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                runupdate
            else
                echo "discorddownloader was not updated!"
                exit 0
            fi
        fi
    else
        wget -O /tmp/discorddownloader.sh "https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/discorddownloader.sh"
        if [ -f "/tmp/discorddownloader.sh" ]; then
            rm -f $SCRIPTNAME
            mv /tmp/discorddownloader.sh $SCRIPTNAME
            chmod +x $SCRIPTNAME
        else
            read -p "Update Failed! Try again? Y/N " -n 1 -r
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                runupdate
            else
                echo "discorddownloader was not updated!"
                exit 0
            fi
        fi
    fi
    if [ -f $SCRIPTNAME ]; then
        echo "Update finished!"
        rm -f /tmp/updatescript.sh
        exec $SCRIPTNAME
    else
        read -p "Update Failed! Try again? Y/N " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            runupdate
        else
            echo "discorddownloader was not updated!"
            exit 0
        fi
    fi
}
runupdate
EOL
}

updatecheck () {
    echo "Checking for new version..."
    UPNOTES=$(curl -v --silent https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/version.txt 2>&1 | grep X= | tr -d 'X="')
    VERTEST=$(curl -v --silent https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/version.txt 2>&1 | grep DDVER= | tr -d 'DDVER="')
    if [[ $DDVER < $VERTEST ]]; then
        echo "Installed version: $DDVER -- Current version: $VERTEST"
        echo "A new version is available!"
        echo $UPNOTES
        read -p "Would you like to update? Y/N " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo
            echo "Creating update script..."
            updatescript
            chmod +x /tmp/updatescript.sh
            echo "Running update script..."
            exec /tmp/updatescript.sh
            exit 0
        else
            echo
            read - p "discorddownloader not updated; press ENTER to continue." NUL
            clear
            start
        fi
    else
        echo "Installed version: $DDVER -- Current version: $VERTEST"
        echo $UPNOTES
        echo "discorddownloader is up to date."
        echo
        read -p "Press ENTER to continue." NUL
        clear
        start
    fi
}

start () {
    programisinstalled "dialog"
    if [ "$return" = "1" ]; then
        MAINCHOICE=$(dialog --stdout --backtitle discorddownloader --no-cancel --menu "Welcome to discorddownloader\nVersion $DDVER\nWhat would you like to do?" 0 0 5 1 "Install Discord" 2 "Install mydiscord" 3 "Install BetterDiscord" 4 "Uninstall Discord" 5 Exit)
        main "$MAINCHOICE"
        exit 0
    else
        echo "Welcome to discorddownloader v$DDVER"
        echo "What would you like to do?"
        echo "1 - Install Discord"
        echo "2 - Install mydiscord"
        echo "3 - Install BetterDiscord to existing Discord install"
        echo "4 - Uninstall Discord"
        echo "5 - Exit script"
        read -p "Choice?" -n 1 -r
        echo
        clear
        main "$REPLY"
    fi
}

startinst () {
    case $1 in
        1*) # Canary
            if [ -f ~/.config/discorddownloader/canarydir.conf ]; then
                CANARYINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/canarydir.conf)
                CANARYISINST="1"
                read -p "DiscordCanary is already installed; remove and proceed with install? Y/N " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]];then
                    clear
                    uninst "1"
                else
                    read -p "DiscordCanary was not installed; press ENTER to continue." NUL
                    clear
                    start
                fi
            fi
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --menu "Where would you like to install DiscordCanary?" 0 0 2 1 "/opt/DiscordCanary" 2 "Use a custom directory")
            else
                echo "Where would you like to install DiscordCanary?"
                echo "1 - /opt/DiscordCanary"
                echo "2 - Use custom directory"
                read -p "Choice?" -n 1 -r
                echo
            fi
            case $REPLY in
                1) # /opt
                    DIR="/opt/DiscordCanary"
                    clear
                    canaryinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install DiscordCanary? Ex: '/home/simonizor/DiscordCanary'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordCanary'"
                        read -p "Press ENTER to continue." NUL
                        clear
                        DIR=""
                        startinst "1"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    clear
                    canaryinst
                    ;;
                *)
                    clear
                    start
            esac
            ;;
        2*) # PTB
            if [ -f ~/.config/discorddownloader/ptbdir.conf ]; then
                PTBINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/ptbdir.conf)
                PTBISINST="1"
                read -p "DiscordPTB is already installed; remove and proceed with install? Y/N " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]];then
                    clear
                    uninst "2"
                else
                    echo "DiscordPTB was not installed."
                    clear
                    start
                fi
            fi
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --menu "Where would you like to install DiscordPTB?" 0 0 2 1 "/opt/DiscordPTB" 2 "Use a custom directory")
            else
                echo "Where would you like to install DiscordPTB?"
                echo "1 - /opt/DiscordPTB"
                echo "2 - Use custom directory"
                read -p "Choice?" -n 1 -r
                echo
            fi
            case $REPLY in
                1) # /opt
                    DIR="/opt/DiscordPTB"
                    clear
                    ptbinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install DiscordPTB? Ex: '/home/simonizor/DiscordPTB'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordPTB'"
                        read -p "Press ENTER to continue." NUL
                        clear
                        DIR=""
                        startinst "2"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    clear
                    ptbinst
                    ;;
                *)
                    clear
                    start
            esac
            ;;
        3*) # Stable
            if [ -f ~/.config/discorddownloader/stabledir.conf ]; then
                STABLEINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/stabledir.conf)
                STABLEISINST="1"
                read -p "Discord is already installed; remove and proceed with install? Y/N " -n 1 -r
                echo
                if [[ $REPLY =~ ^[Yy]$ ]];then
                    clear
                    uninst "3"
                else
                    read -p "Discord was not installed; press ENTER to continue." NUL
                    clear
                    start
                fi
            fi
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --menu "Where would you like to install Discord?" 0 0 2 1 "/opt/Discord" 2 "Use a custom directory")
            else
                echo "Where would you like to install Discord?"
                echo "1 - /opt/Discord"
                echo "2 - Use custom directory"
                read -p "Choice?" -n 1 -r
                echo
            fi
            case $REPLY in
                1) # /opt
                    DIR="/opt/Discord"
                    clear
                    stableinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install Discord? Ex: '/home/simonizor/Discord'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/Discord'"
                        read -p "Press ENTER to continue." NUL
                        clear
                        DIR=""
                        startinst "3"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    clear
                    stableinst
                    ;;
                *)
                    clear
                    start
            esac
            ;;
        *)
            clear
            start
    esac
}

canaryinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            CANARYINSTDIR="$DIR"
            clear
            uninst "1"
        else
            read -p "DiscordCanary was not installed; press ENTER to continue." NUL
            clear
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download/canary?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        read -p "Download failed; try again later! Press ENTER to continue."
        clear
        start
    fi
    echo "Extracting DiscordCanary to /tmp ..."
    tar -xzvf /tmp/discord-linux.tar.gz -C /tmp/
    echo "Moving /tmp/DiscordCanary/ to" "$DIR ..."
    if [[ "$DIR" != /home/* ]]; then
        sudo mv /tmp/DiscordCanary/ $DIR/
    else
        mv /tmp/DiscordCanary/ $DIR/
    fi
    rm /tmp/discord-linux.tar.gz
    echo "Creating symbolic links for .desktop file ..."
    sudo ln -s $DIR/discord-canary.desktop /usr/share/applications/
    sudo ln -s $DIR/discord.png /usr/share/icons/discord-canary.png
    sudo ln -s $DIR/DiscordCanary /usr/bin/DiscordCanary
    sudo ln -s $DIR /usr/share/discord-canary
    echo "Creating config file..."
    if [ ! -d ~/.config/discorddownloader ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/canarydir.conf
    read -p "DiscordCanary has been installed; press ENTER to return to main menu." NUL
    clear
    start
}

ptbinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            PTBINSTDIR="$DIR"
            clear
            uninst "2"
        else
            read -p "DiscordPTB was not installed; press ENTER to continue." NUL
            clear
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download/ptb?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        read -p "Download failed; try again later! Press ENTER to continue." NUL
        clear
        start
    fi
    echo "Extracting DiscordPTB to /tmp ..."
    tar -xzvf /tmp/discord-linux.tar.gz -C /tmp/
    echo "Moving /tmp/DiscordPTB/ to" "$DIR ..."
    if [[ "$DIR" != /home/* ]]; then
        sudo mv /tmp/DiscordPTB/ $DIR/
    else
        mv /tmp/DiscordPTB/ $DIR/
    fi
    rm /tmp/discord-linux.tar.gz
    echo "Creating symbolic links for .desktop file ..."
    sudo ln -s $DIR/discord-ptb.desktop /usr/share/applications/
    sudo ln -s $DIR/discord.png /usr/share/icons/discord-ptb.png
    sudo ln -s $DIR/DiscordPTB /usr/bin/DiscordPTB
    sudo ln -s $DIR /usr/share/discord-ptb
    echo "Creating config file..."
    if [ ! -d ~/.config/discorddownloader ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/ptbdir.conf
    read -p "DiscordPTB has been installed; press ENTER to return to main menu." NUL
    clear
    start
}

stableinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            STABLEINSTDIR="$DIR"
            clear
            uninst "3"
        else
            read -p "Discord was not installed; press ENTER to continue." NUL
            clear
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        read -p "Download failed; try again later! Press ENTER to continue." NUL
        clear
        start
    fi
    echo "Extracting Discord to /tmp ..."
    tar -xzvf /tmp/discord-linux.tar.gz -C /tmp/
    echo "Moving /tmp/Discord/ to" "$DIR ..."
    if [[ "$DIR" != /home/* ]]; then
        sudo mv /tmp/Discord/ $DIR/
    else
        mv /tmp/Discord/ $DIR/
    fi
    rm /tmp/discord-linux.tar.gz
    echo "Creating symbolic links for .desktop file ..."
    sudo ln -s $DIR/discord.desktop /usr/share/applications/
    sudo ln -s $DIR/discord.png /usr/share/icons/discord.png
    sudo ln -s $DIR/Discord /usr/bin/Discord
    sudo ln -s $DIR /usr/share/discord
    echo "Creating config file..."
    if [ ! -d ~/.config/discorddownloader ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/stabledir.conf
    read -p "Discord has been installed; press ENTER to return to main menu." NUL
    clear
    start
}

uninst () {
    case $1 in
        1*)
            read -p "Are you sure you want to uninstall DiscordCanary? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                read -p "DiscordCanary was not uninstalled; press ENTER to continue." NUL
                clear
                start
            fi
            echo "Removing install directory..."
            sudo rm -rf $CANARYINSTDIR
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord-canary.desktop
            sudo rm -f /usr/share/icons/discord-canary.png
            sudo rm -f /usr/bin/DiscordCanary
            sudo rm -f /usr/share/discord-canary
            rm -f ~/.config/discorddownloader/canarydir.conf
            CANARYISINST="0"
            read -p "DiscordCanary has been uninstalled; press ENTER to return to main menu."
            clear
            start
            ;;
        2*)
            read -p "Are you sure you want to uninstall DiscordPTB? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                read -p "DiscordPTB was not uninstalled; press ENTER to continue." NUL
                clear
                start
            fi
            echo "Removing install directory..."
            sudo rm -rf $PTBINSTDIR
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord-ptb.desktop
            sudo rm -f /usr/share/icons/discord-ptb.png
            sudo rm -f /usr/bin/DiscordPTB
            sudo rm -f /usr/share/discord-ptb
            rm -f ~/.config/discorddownloader/ptbdir.conf
            PTBISINST="0"
            read -p "DiscordPTB has been uninstalled; press ENTER to return to main menu."
            clear
            start
            ;;
        3*)
            read -p "Are you sure you want to uninstall Discord? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                read -p "DiscordPTB was not uninstalled; press ENTER to continue." NUL
                clear
                start
            fi
            echo "Removing install directory..."
            sudo rm -rf $STABLEINSTDIR
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord.desktop
            sudo rm -f /usr/share/icons/discord.png
            sudo rm -f /usr/bin/Discord
            sudo rm -f /usr/share/discord
            rm -f ~/.config/discorddownloader/stabledir.conf
            STABLEISINST="0"
            read -p "Discord has been uninstalled; press ENTER to return to main menu."
            clear
            start
            ;;
        *)
            clear
            start
    esac
}

mydiscordinst () {
    programisinstalled "pip"
    if [ "$return" = "1" ]; then
        python3 -m pip install -U https://github.com/justinoboyle/MyDiscord/archive/master.zip
        echo "Installed" > ~/.config/discorddownloader/mydiscord.conf 
        echo "To use 'mydiscord', first launch 'Discord' and then execute 'mydiscord' in a terminal."
        read -p "mydiscord install finished; press ENTER to return to main menu." NUL
        start
    else
        read -p "python3-pip is not installed; press ENTER to return to main menu."
        clear
        start
    fi
}

betterinst () {
    echo "Installing BetterDiscord to" "$DIR" "..."
    echo "Closing any open Discord instances"
    killall -SIGKILL Discord
    killall -SIGKILL DiscordCanary
    killall -SIGKILL DiscordPTB
    
    programisinstalled "asar"
    if [ "$return" = "0" ]; then
        echo "Installing asar..."
        sudo npm install asar -g
    else
        echo "asar is already installed; skipping..."
    fi
    programisinstalled "asar"
    if [ "$return" = "0" ]; then
        echo "Failed to install asar!"
        echo "Exiting."
        exit 1
    else
        echo "asar 2nd check passed..."
    fi

    echo "Downloading BetterDiscord..."
    wget -O /tmp/bd.zip https://github.com/Jiiks/BetterDiscordApp/archive/stable16.zip

    echo "Preparing BetterDiscord files..."
    unzip /tmp/bd.zip 
    sudo mv ./BetterDiscordApp-stable16 /tmp/bd
    sudo mv /tmp/bd/lib/Utils.js /tmp/bd/lib/utils.js
    sed -i "s/'\/var\/local'/process.env.HOME + '\/.config'/g" /tmp/bd/lib/BetterDiscord.js
    sed -i "s/bdstorage/bdStorage/g" /tmp/bd/lib/BetterDiscord.js

    echo "Removing app folder from Discord directory..."
    sudo rm -rf "$DIR/resources/app"

    echo "Unpacking Discord asar..."
    sudo asar e "$DIR/resources/app.asar" "$DIR/resources/app"

    echo "Preparing Discord files..."
    sed "/_fs2/ a var _betterDiscord = require('betterdiscord'); var _betterDiscord2;" "$DIR/resources/app/index.js" > /tmp/bd/index.js
    sudo mv /tmp/bd/index.js "$DIR/resources/app/index.js"
    sed "/mainWindow = new/ a _betterDiscord2 = new _betterDiscord.BetterDiscord(mainWindow);" "$DIR/resources/app/index.js" > /tmp/bd/index.js
    sudo mv /tmp/bd/index.js "$DIR/resources/app/index.js"

    echo "Finishing up..."
    sudo mv /tmp/bd "$DIR/resources/app/node_modules/betterdiscord"
    echo "Installed" > ~/.config/discorddownloader/BD.conf
    read -p "Assuming there are no errors above, BetterDiscord has been installed. Press ENTER to return to main menu."
    start
}

main () {
    case $1 in
        1*)
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                VERCHOICE=$(dialog --stdout --backtitle "discorddownloader - Install Discord" --menu "Install or update:" 0 0 3 1 DiscordCanary 2 DiscordPTB 3 "Discord Stable")
                clear
                startinst "$VERCHOICE"
            else
                echo "1 - DiscordCanary"
                echo "2 - DiscordPTB"
                echo "3 - Discord Stable"
                echo "Return to main menu"
                read -p "Choice? " -n 1 -r
                echo
                clear
                startinst "$REPLY"
            fi
            ;;
        2*)
            if [ -f ~/.config/discorddownloader/BD.conf ]; then
                read -p "BetterDiscord is installed; using mydiscord with BetterDiscord may cause issues.  Continue? Y/N" -n 1 -r
                echo
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    read -p "mydiscord was not installed; press ENTER to continue." NUL
                    clear
                    start
                fi
            fi
            echo "mydiscord is a fork of beautifuldiscord that can hot-load CSS and JS."
            echo "mydiscord requires 'python3.x' and 'python3-pip'; 'psutil' will be installed for you."
            read -p "Press ENTER to continue." NUL
            clear
            mydiscordinst
            ;;
        3*)
            if [ -f ~/.config/discorddownloader/mydiscord.conf ]; then
                read -p "mydiscord is installed; using BetterDiscord with mydiscord may cause issues.  Continue? Y/N" -n 1 -r
                echo
                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    read -p "BetterDiscord was not installed; press ENTER to continue."
                    clear
                    start
                fi
            fi
            echo "BetterDiscord is a modification of the Discord client that allows CSS loading and JS plugins."
            echo "BetterDiscord requires 'nodejs', 'npm', 'asar', and 'zip'; 'asar' will be installed for you if not already installed."
            read -p "Press ENTER to continue." NUL
            programisinstalled "npm"
            if [ "$return" = "0" ]; then
                read -p "npm is not installed; cannot install BetterDiscord. Press ENTER to return to main menu." NUL
                clear
                start
            fi
            programisinstalled "zip"
            if [ "$return" = "0" ]; then
                read -p "zip is not installed; cannot install BetterDiscord. Press ENTER to return to main menu." NUL
                clear
                start
            fi
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                DIR=$(dialog --stdout --backtitle "discorddownloader -- Install BetterDiscord" --dselect /opt/ 0 0)
            else
                read -p "Input the Discord directory to install BetterDiscord to: " DIR
            fi
            if [[ "$DIR" != /* ]]; then
                echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordCanary'"
                read -p "Presss ENTER to return to main menu." NUL
                clear
                DIR=""
                start
            fi
            if [ "${DIR: -1}" = "/" ]; then
                DIR="${DIR::-1}"
            fi
            if [ ! -f "$DIR/content_shell.pak" ]; then
                read -p "Discord is not installed to this directory; press ENTER to return to main menu." NUL
                clear
                start
            fi
            echo "$DIR"
            betterinst
            ;;
        4*)
            if [ -f ~/.config/discorddownloader/canarydir.conf ]; then
                CANARYINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/canarydir.conf)
                CANARYISINST="1"
            fi
            if [ -f ~/.config/discorddownloader/ptbdir.conf ]; then
                PTBINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/ptbdir.conf)
                PTBISINST="1"
            fi
            if [ -f ~/.config/discorddownloader/stabledir.conf ]; then
                STABLEINSTDIR=$(sed -n '1p' ~/.config/discorddownloader/stabledir.conf)
                STABLEISINST="1"
            fi
            if [[ "$CANARYISINST" = "1" && "$PTBISINST" = "1" && "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 3 1 DiscordCanary 2 DiscordPTB 3 "Discord Stable")
                else
                    echo "1 - DiscordCanary"
                    echo "2 - DiscordPTB"
                    echo "3 - Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" && "$PTBISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 2 1 DiscordCanary 2 DiscordPTB)
                else
                    echo "1 - DiscordCanary"
                    echo "2 - DiscordPTB"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" && "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 2 1 DiscordCanary 3 "Discord Stable")
                else
                    echo "1 - DiscordCanary"
                    echo "3 - Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 1 1 DiscordCanary)
                else
                    echo "1 - DiscordCanary"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$PTBISINST" = "1" && "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 2 2 DiscordPTB 3 "Discord Stable")
                else
                    echo "2 - DiscordPTB"
                    echo "3 - Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$PTBISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 1 2 DiscordPTB)
                else
                    echo "2 - DiscordPTB"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            elif [[ "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --backtitle "discorddownloader - Uninstall" --menu "Uninstall:" 0 0 1 3 "Discord Stable")
                else
                    echo "3 - Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -n 1 -r
                    echo
                fi
            else
                read -p "No versions of Discord are installed; press ENTER to return to main menu" NUL
                clear
                start
            fi
            clear
            uninst "$REPLY"
            ;;
        5)
            clear
            echo "Exiting..."
            exit 0
            ;;
        *)
            clear
            start
            ;;
    esac
}

if [ "$EUID" -ne 0 ]; then
    programisinstalled "wget"
    if [ "$return" = "1" ]; then
        programisinstalled "curl"
        if [ "$return" = "1" ]; then
            updatecheck
        else
            read -p "curl is not installed; press ENTER to run discorddownloader without checking for updates!" NUL
            start
        fi
    else
        echo "wget is not installed!"
        exit 0
    fi
else
    echo "Do not run discorddownloader as root!"
    exit 0
fi