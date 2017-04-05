#!/bin/bash
# Title: discorddownloader
# Author: simonizor
# URL: http://www.simonizor.gq/discorddownloader
# Dependencies: Required: 'wget', 'curl'; Optional: 'dialog' (discorddownloader GUI); 'nodejs', 'npm', 'zip' (BetterDiscord); 'python3.x', 'python3-pip', 'psutil' (mydiscord).
# Description: A script that can install all versions of Discord. It can also install mydiscord and BetterDiscord. If you have 'dialog' installed, a GUI will automatically be shown.

DDVER="1.5.4"
X="v1.5.4 - Check if ~/.config/discorddownloader/ exists before creating directory for config files."
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
            start
        fi
    else
        echo "Installed version: $DDVER -- Current version: $VERTEST"
        echo $UPNOTES
        echo "discorddownloader is up to date."
        echo
        read -p "Press ENTER to continue." NUL
        start
    fi
}

start () {
    programisinstalled "dialog"
    if [ "$return" = "1" ]; then
        MAINCHOICE=$(dialog --stdout --menu "What would you like to do?" 0 0 5 1 "Install Discord" 2 "Install mydiscord" 3 "Install BetterDiscord" 4 "Uninstall Discord" 5 Exit)
        main "$MAINCHOICE"
        exit 0
    else
        echo "What would you like to do?"
        echo "1 - Install Discord"
        echo "2 - Install mydiscord"
        echo "3 - Install BetterDiscord to existing Discord install"
        echo "4 - Uninstall Discord"
        echo "5 - Exit script"
        read -p "Choice?" -n 1 -r
        echo
        main "$REPLY"
    fi
}

startinst () {
    case $1 in
        DiscordCanary) # Canary
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --menu "Where would you like to install DiscordCanary?" 0 0 2 1 "/opt/DiscordCanary" 2 "Use a custom directory")
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
                    canaryinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install DiscordCanary? Ex: '/home/simonizor/DiscordCanary'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordCanary'"
                        DIR=""
                        main "DiscordCanary"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    canaryinst
                    ;;
                *)
                    start
            esac
            ;;
        DiscordPTB) # PTB
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --menu "Where would you like to install DiscordPTB?" 0 0 2 1 "/opt/DiscordPTB" 2 "Use a custom directory")
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
                    ptbinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install DiscordPTB? Ex: '/home/simonizor/DiscordPTB'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordPTB'"
                        DIR=""
                        main "DiscordPTB"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    ptbinst
                    ;;
                *)
                    start
            esac
            ;;
        Discord*) # Stable
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                REPLY=$(dialog --stdout --menu "Where would you like to install Discord?" 0 0 2 1 "/opt/Discord" 2 "Use a custom directory")
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
                    stableinst
                    ;;
                2) # Custom
                    programisinstalled "dialog"
                    if [ "$return" = "1" ]; then
                        DIR=$(dialog --stdout --dselect ~/ 0 0)
                    else
                        read -p "Where would you like to install Discord? Ex: '/home/simonizor/Discord'" DIR
                    fi
                    if [[ "$DIR" != /* ]];then
                        echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/Discord'"
                        DIR=""
                        main "Discord"
                        exit 0
                    fi
                    if [ "${DIR: -1}" = "/" ]; then
                        DIR="${DIR::-1}"
                    fi
                    stableinst
                    ;;
                *)
                    start
            esac
            ;;
    esac
}

canaryinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            CANARYINSTDIR="$DIR"
            uninst "DiscordCanary"
        else
            echo "DiscordCanary was not installed."
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download/canary?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        echo "Download failed; try again later!"
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
    if [ ! -d "~/.config/discorddownloader" ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/canarydir.conf
    read -p "DiscordCanary has been installed; press ENTER to return to main menu." NUL
    start
}

ptbinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            PTBINSTDIR="$DIR"
            uninst "DiscordPTB"
        else
            echo "DiscordPTB was not installed."
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download/ptb?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        echo "Download failed; try again later!"
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
    if [ ! -d "~/.config/discorddownloader" ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/ptbdir.conf
    read -p "DiscordPTB has been installed; press ENTER to return to main menu." NUL
    start
}

stableinst () {
    if [ -d "$DIR" ]; then
        read -p "$DIR exists; remove and proceed with install? Y/N " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            STABLEINSTDIR="$DIR"
            uninst "Discord"
        else
            echo "Discord was not installed."
            start
        fi
    fi
    wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
    if [ ! -f /tmp/discord-linux.tar.gz ]; then
        echo "Download failed; try again later!"
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
    if [ ! -d "~/.config/discorddownloader" ];then
        mkdir ~/.config/discorddownloader
    fi
    echo "$DIR" > ~/.config/discorddownloader/stabledir.conf
    read -p "Discord has been installed; press ENTER to return to main menu." NUL
    start
}

uninst () {
    case $1 in
        DiscordCanary*)
            read -p "Are you sure you want to uninstall DiscordCanary? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "DiscordCanary was not uninstalled"
                start
            fi
            echo "Removing install directory..."
            if [[ "$CANARYINSTDIR" != "/home/*" ]]; then
                sudo rm -rf $CANARYINSTDIR
            else
                rm -rf $CANARYINSTDIR
            fi
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord-canary.desktop
            sudo rm -f /usr/share/icons/discord-canary.png
            sudo rm -f /usr/bin/DiscordCanary
            sudo rm -f /usr/share/discord-canary
            rm -f ~/.config/discorddownloader/canarydir.conf
            CANARYISINST="0"
            read -p "DiscordCanary has been uninstalled; press ENTER to return to main menu."
            start
            ;;
        DiscordPTB*)
            read -p "Are you sure you want to uninstall DiscordPTB? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "DiscordPTB was not uninstalled"
                start
            fi
            echo "Removing install directory..."
            if [[ "$PTBINSTDIR" != "/home/*" ]]; then
                sudo rm -rf $PTBINSTDIR
            else
                rm -rf $PTBINSTDIR
            fi
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord-ptb.desktop
            sudo rm -f /usr/share/icons/discord-ptb.png
            sudo rm -f /usr/bin/DiscordPTB
            sudo rm -f /usr/share/discord-ptb
            rm -f ~/.config/discorddownloader/ptbdir.conf
            PTBISINST="0"
            read -p "DiscordPTB has been uninstalled; press ENTER to return to main menu."
            start
            ;;
        Discord*)
            read -p "Are you sure you want to uninstall Discord? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "DiscordPTB was not uninstalled"
                start
            fi
            echo "Removing install directory..."
            if [[ "$STABLEINSTDIR" != "/home/*" ]]; then
                sudo rm -rf $STABLEINSTDIR
            else
                rm -rf $STABLEINSTDIR
            fi
            echo "Removing symbolic links..."
            sudo rm -f /usr/share/applications/discord.desktop
            sudo rm -f /usr/share/icons/discord.png
            sudo rm -f /usr/bin/Discord
            sudo rm -f /usr/share/discord
            rm -f ~/.config/discorddownloader/stabledir.conf
            STABLEISINST="0"
            read -p "Discord has been uninstalled; press ENTER to return to main menu."
            start
            ;;
        *)
            start
    esac
}

mydiscordinst () {
    programisinstalled "pip"
    if [ "$return" = "1" ]; then
        if [ -f ~/.config/discorddownloader/BD.conf ]; then
            read -p "BetterDiscord is installed; using mydiscord with BetterDiscord may cause issues.  Continue? Y/N" -n 1 -r
            echo
            if [[ $REPLY =~ ^[Nn]$ ]]; then
                echo "mydiscord was not installed."
                start
            fi
        fi
        python3 -m pip install -U https://github.com/justinoboyle/MyDiscord/archive/master.zip
        echo "Installed" > ~/.config/discorddownloader/mydiscord.conf 
        echo "To use 'mydiscord', first launch 'Discord' and then execute 'mydiscord' in a terminal."
        read -p "mydiscord install finished; press ENTER to return to main menu." NUL
        start
    else
        echo "python3-pip is not installed!"
        exit 0
    fi
}

betterinst () {
    if [ -f ~/.config/discorddownloader/mydiscord.conf ]; then
        read -p "mydiscord is installed; using BetterDiscord with mydiscord may cause issues.  Continue? Y/N" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo "BetterDiscord was not installed."
            start
        fi
    fi
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
        echo "$PROGRAM 2nd check passed..."
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
    # mkdir ~/.config/BetterDiscord/
    # ln -s ~/.config/BetterDiscord/bdstorage.json ~/.config/BetterDiscord//bdStorage.json
    read -p "Assuming there are no errors above, BetterDiscord has been installed. Press ENTER to return to main menu."
    start
}

main () {
    case $1 in
        1*)
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                VERCHOICE=$(dialog --stdout --menu "Install or update:" 0 0 3 DiscordCanary "" DiscordPTB "" "Discord Stable" "")
                startinst "$VERCHOICE"
                exit 0
            else
                echo "DiscordCanary"
                echo "DiscordPTB"
                echo "Discord Stable"
                echo "Return to main menu"
                read -p "Choice? " -r
                echo
                startinst "$REPLY"
                exit 0
            fi
            ;;
        2*)
            mydiscordinst
            ;;
        3*)
            programisinstalled "npm"
            if [ "$return" = "0" ]; then
                echo "npm is not installed; cannot install BetterDiscord."
                exit 0
            fi
            programisinstalled "zip"
            if [ "$return" = "0" ]; then
                echo "zip is not installed; cannot install BetterDiscord."
                exit 0
            fi
            programisinstalled "dialog"
            if [ "$return" = "1" ]; then
                DIR=$(dialog --stdout --dselect /opt/ 0 0)
            else
                read -p "Where would you like to install DiscordCanary? Ex: '/home/simonizor/DiscordCanary'" DIR
            fi
            if [[ "$DIR" != /* ]];then
                echo "Invalid directory format; use full directory path.  Ex: '/home/simonizor/DiscordCanary'"
                DIR=""
                main "DiscordCanary"
                exit 0
            fi
            if [ "${DIR: -1}" = "/" ]; then
                DIR="${DIR::-1}"
            fi
            if [ ! -f "$DIR/content_shell.pak" ]; then
                read -p "Discord is not installed to this directory; press ENTER to return to main menu." NUL
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
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 3 DiscordCanary "" DiscordPTB "" "Discord Stable" "")
                else
                    echo "DiscordCanary"
                    echo "DiscordPTB"
                    echo "Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" && "$PTBISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 2 DiscordCanary "" DiscordPTB "")
                else
                    echo "DiscordCanary"
                    echo "DiscordPTB"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" && "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 2 DiscordCanary "" "Discord Stable" "")
                else
                    echo "DiscordCanary"
                    echo "Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$CANARYISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 1 DiscordCanary "")
                else
                    echo "DiscordCanary"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$PTBISINST" = "1" && "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 2 DiscordPTB "" "Discord Stable" "")
                else
                    echo "DiscordPTB"
                    echo "Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$PTBISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 1 DiscordPTB "")
                else
                    echo "DiscordPTB"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            elif [[ "$STABLEISINST" = "1" ]]; then
                programisinstalled "dialog"
                if [ "$return" = "1" ]; then
                    REPLY=$(dialog --stdout --menu "Uninstall:" 0 0 1 "Discord Stable" "")
                else
                    echo "Discord Stable"
                    echo "Return to main menu"
                    read -p "Choice? " -r
                    echo
                fi
            else
                read -p "No versions of Discord are installed; press ENTER to return to main menu" NUL
                start
            fi
            uninst "$REPLY"
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        R*)
            start
            ;;
        *)
            echo "Exiting..."
            exit 0
            ;;
    esac
}

if [ "$EUID" -ne 0 ]; then
    programisinstalled "wget"
    if [ "$return" = "1" ]; then
        updatecheck
    else
        echo "wget is not installed!"
    fi
else
    echo "Do not run discorddownloader as root!"
    exit 0
fi