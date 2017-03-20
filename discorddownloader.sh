#!/bin/bash
# discorddownloader by simonizor
# http://www.simonizor.gq/discorddownloader

DDVER="1.5.2"
X="v1.5.2 - Added check to make sure discorddownloader is not running as root."
# ^^ Remember to update these and version.txt every release!
SCRIPTNAME="$0"

maininst () {
    if [ -f ~/.config/discorddownloader/"$VER"dir.conf ]; then
        echo "Discord $VER is already installed.  Would you like to remove your previous install?"
        echo "1 - Yes, update Discord $VER or install to a new directory."
        echo "2 - No, leave my Discord $VER install alone."
        read -p "Choice?" -n 1 -r
        echo
        if [[ $REPLY =~ ^[1]$ ]]; then
            INSTDIR="$(< ~/.config/discorddownloader/"$VER"dir.conf)"
            if [ "$VER" = "stable" ]; then
                stableuninst
                maininst
            else
                canaryptbuninst
                maininst
            fi
        else
            echo "Discord $VER was not installed and your previous install was untouched."
            exit 1
        fi
    elif [ -f $DIR/content_shell.pak ]; then
        read -p "Discord$VERCAP is already installed to $DIR; remove and continue with install? Y/N" -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]];then
            INSTDIR="$DIR"
            if [ "$VER" = "stable" ]; then
                stableuninst
                maininst
            else
                canaryptbuninst
                maininst
            fi
        else
            echo "Exiting."
            exit 1
        fi
    else
        echo "Installing Discord$VERCAP to" "$DIR" "..."
        echo "Downloading Discord$VERCAP ..."
        if [ "$VER" = "stable" ]; then
            wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download?platform=linux&format=tar.gz"
        else
            wget -O /tmp/discord-linux.tar.gz "https://discordapp.com/api/download/$VER?platform=linux&format=tar.gz"
        fi
        echo "Extracting Discord$VERCAP to /tmp ..."
        tar -xzvf /tmp/discord-linux.tar.gz -C /tmp/
        echo "Moving /tmp/Discord$VERCAP/ to" "$DIR" "..."
        sudo mv /tmp/Discord"$VERCAP"/ "$DIR"/
        rm /tmp/discord-linux.tar.gz
        echo "Creating symbolic links for .desktop file ..."
        if [ "$VER" = "stable" ]; then
            sudo ln -s "$DIR"/discord.desktop /usr/share/applications/
            sudo ln -s "$DIR"/discord.png /usr/share/icons/discord.png
            sudo ln -s "$DIR"/Discord /usr/bin/Discord
            sudo ln -s "$DIR" /usr/share/discord
        else
            sudo ln -s "$DIR"/discord-"$VER".desktop /usr/share/applications/
            sudo ln -s "$DIR"/discord.png /usr/share/icons/discord-"$VER".png
            sudo ln -s "$DIR"/Discord"$VERCAP" /usr/bin/Discord"$VERCAP"
            sudo ln -s "$DIR" /usr/share/discord-"$VER"
        fi
        echo "Symbolic links have been created!"
        echo "Creating config file for uninstall ..."
        mkdir ~/.config/discorddownloader/
        echo "$DIR" > ~/.config/discorddownloader/"$VER"dir.conf
    fi
}

instdirtest () {
    if [[ "$DIR" != /* ]]; then
        if [[ "$DIR" == "back" ]]; then
            main
            exit 0
        else
            echo "Invalid directory; try again or type 'back' to return to main menu."
            echo -n "Input the directory you would like to install Discord$VERCAP to and press [ENTER]:"
            read DIR
            instdirtest
        fi
    fi
}

betterdirtest () {
    if [[ "$DIR" != /* ]]; then
        if [[ "$DIR" == "back" ]]; then
            main
            exit 0
        else
            echo "Directory must start with '/'; try again or type 'back' to return to main menu."
            echo -n "Input the directory you would like to install BetterDiscord to and press [ENTER]:"
            read DIR
            betterdirtest
        fi
    fi
}

betterdiscordtest () {
    if [ -f $DIR/content_shell.pak ]; then
        if [ "${DIR: -1}" = "/" ]; then
            DIR="${DIR::-1}"
        fi
        betterinst
        echo "Cleaning up..."
        sudo rm /tmp/bd.zip
        sudo rm -rf /tmp/bd
        echo "Finished!"
    elif [[ "$DIR" == "back" ]]; then
        main
        exit 0
    else
        echo "Discord is not installed to this directory; try again or type 'back' to return to main menu."
        echo -n "Input the directory you would like to install BetterDiscord to and press [ENTER]:"
        read DIR
        betterdiscordtest
    fi
}

inststart () {
    echo "Where would you like to install Discord$VERCAP?"
    echo "1 - Install to '/opt/Discord$VERCAP/'"
    echo "2 - Install to custom directory."
    echo "3 - Return to main menu."
    read -p "Choice?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[1]$ ]]; then
        DIR="/opt/Discord$VERCAP"
        maininst
        betterorbeautiful
    elif [[ $REPLY =~ ^[2]$ ]]; then
        echo "Please be careful to input the correct directory.  It will be removed before installation."
        echo -n "Input the directory you would like to install Discord$VERCAP to and press [ENTER]:"
        read DIR
        echo
        instdirtest
        if [ "${DIR: -1}" = "/" ]; then
            DIR="${DIR::-1}"
        fi
        maininst
        betterorbeautiful
    elif [[ $REPLY =~ ^[3]$ ]]; then
        echo "Returning to main menu..."
        main
        exit 0
    else
        echo "Invalid choice."
        inststart
        exit 0
    fi
}

betterorbeautiful () {
    echo "Would you like to install BetterDiscord or BeautifulDiscord?"
    echo "Note: BetterDiscord does not fully support Linux and may break at any time."
    echo "1 - BetterDiscord (requires npm, nodejs, unzip)"
    echo "2 - BeautifulDiscord (requires python 3.x, python3-pip, psutil)"
    echo "3 - No thanks.  Just let me use Discord."
    read -p "Choice?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[1]$ ]]; then
        PROGRAM="npm"
        PROGRAM2="wget"
        PROGRAM3="unzip"
        npmisinstalled
        if [ "$return" = "1" ]; then
            if [ "$return2" = "1" ]; then
                if [ "$return3" = "1" ]; then
                    betterinst
                    echo "Cleaning up..."
                    sudo rm /tmp/bd.zip
                    sudo rm -rf /tmp/bd
                    echo "Finished!"
                    exit 1
                else
                    echo "$PROGRAM3 not installed!"
                    exit 1
                fi
            else
                echo "$PROGRAM2 not installed!"
                exit 1
            fi
        else
            echo "$PROGRAM not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[2]$ ]]; then
        programisinstalled
        if [ "$return" = "1" ]; then
            beautifulinst
        else
            echo "pip is not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[3]$ ]]; then
        echo "Finished!"
        exit 1
    else
        echo "Invalid choice."
        betterorbeautiful
    fi
}

betterinst () {
    echo "Installing BetterDiscord to" "$DIR" "..."
    echo "Closing any open Discord instances"
    killall -SIGKILL Discord
    killall -SIGKILL DiscordCanary
    killall -SIGKILL DiscordPTB
    
    echo "Installing asar"
    sudo npm install asar -g

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
    exit 1
}

beautifulinst () {
    python3 -m pip install -U https://github.com/leovoel/BeautifulDiscord/archive/master.zip
    wget -O ~/.config/discorddownloader/ArcDarkAutohideMod.css "https://raw.githubusercontent.com/simoniz0r/DiscordThemes/master/ArcDarkMods/ArcDarkAutohideMod.theme.css"
    echo "To use BeautifulDiscord, run Discord, and then execute 'beautifuldiscord --css ~/.config/discorddownloader/ArcDarkAutohideMod.css'"
    echo "Finished!"
    exit 1
}

canaryptbuninst () {
    echo "Uninstalling Discord$VERCAP from" "$INSTDIR" "..."
    sudo rm -r "$INSTDIR"/
    sudo rm /usr/share/applications/discord-"$VER".desktop
    sudo rm /usr/bin/Discord"$VERCAP"
    rm ~/.config/discorddownloader/"$VER"dir.conf
    sudo rm /usr/share/icons/discord-"$VER".png
    sudo rm /usr/share/discord-"$VER"
    echo "Discord$VERCAP has been uninstalled and symbolic links have been removed!"
}

stableuninst () {
    echo "Uninstalling Discord Stable from" "$INSTDIR" "..."
    sudo rm -r "$INSTDIR"/
    sudo rm /usr/share/applications/discord.desktop
    sudo rm /usr/bin/Discord
    rm ~/.config/discorddownloader/stabledir.conf
    sudo rm /usr/share/discord
    sudo rm /usr/share/icons/discord.png
    echo "Discord has been uninstalled and symbolic links have been removed!"
}

npmisinstalled () {
    # set to 1 initially
    return=1
    return2=1
    return3=1
    # set to 0 if not found
    type $PROGRAM >/dev/null 2>&1 || { return=0; }
    type $PROGRAM2 >/dev/null 2>&1 || { return2=0; }
    type $PROGRAM3 >/dev/null 2>&1 || { return3=0; }
    # return value
}

programisinstalled () {
    # set to 1 initially
    return=1
    # set to 0 if not found
    type $PROGRAM >/dev/null 2>&1 || { return=0; }
    # return value
}

updatescript () {
cat >/tmp/updatescript.sh <<EOL
runupdate () {
    rm -f $SCRIPTNAME
    wget -O $SCRIPTNAME "https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/discorddownloader.sh"
    chmod +x $SCRIPTNAME
    if [ -f $SCRIPTNAME ]; then
        echo "Update finished!"
        rm -f /tmp/updatescript.sh
        exec $SCRIPTNAME
        exit 0
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
    if [[ $DDVER != $VERTEST ]]; then
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
            main
        fi
    else
        echo "Installed version: $DDVER -- Current version: $VERTEST"
        echo "discorddownloader is up to date."
        echo
        main
    fi
}

main () {
    echo "What would you like to do?"
    echo "1 - Install DiscordCanary (DiscordCanary requires libc++)"
    echo "2 - Install DiscordPTB"
    echo "3 - Install Discord Stable"
    echo "4 - Install BetterDiscord to existing Discord install (requires npm, nodejs, unzip)"
    echo "5 - Install BeautifulDiscord (requires python3.x, python3-pip, psutil)"
    echo "6 - Uninstall Discord"
    echo "7 - Exit script"
    read -p "Choice?" -n 1 -r
    echo
    if [[ $REPLY =~ ^[1]$ ]]; then
        PROGRAM="wget"
        programisinstalled
        if [ "$return" = "1" ]; then
            VER="canary"
            VERCAP="Canary"
            inststart
        else
            echo "$PROGRAM is not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[2]$ ]]; then
        PROGRAM="wget"
        programisinstalled
        if [ "$return" = "1" ]; then
            VER="ptb"
            VERCAP="PTB"
            inststart
        else
            echo "$PROGRAM is not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[3]$ ]]; then
        PROGRAM="wget"
        programisinstalled
        if [ "$return" = "1" ]; then
            VER="stable"
            VERCAP=""
            inststart
        else
            echo "$PROGRAM is not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[4]$ ]]; then
        echo -n "Input the directory you would like to install BetterDiscord to and press [ENTER]:"
        read DIR
        echo
        betterdirtest
        if [ "${DIR: -1}" = "/" ]; then
            DIR="${DIR::-1}"
        fi
        PROGRAM="npm"
        PROGRAM2="wget"
        PROGRAM3="unzip"
        npmisinstalled
        if [ "$return" = "1" ]; then
            if [ "$return2" = "1" ]; then
                if [ "$return3" = "1" ]; then
                    betterdiscordtest
                else
                    echo "$PROGRAM3 not installed!"
                    exit 1
                fi
            else
                echo "$PROGRAM2 not installed!"
                exit 1
            fi
        else
            echo "$PROGRAM not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[5]$ ]]; then
        echo "Installing BeautifulDiscord..."
        PROGRAM=pip
        programisinstalled
        if [ "$return" = "1" ]; then
            beautifulinst
        else
            echo "$PROGRAM is not installed!"
            exit 1
        fi
    elif [[ $REPLY =~ ^[6]$ ]]; then
        echo "Choose the version of Discord to uninstall..."
        echo "1 - DiscordCanary"
        echo "2 - DiscordPTB"
        echo "3 - Discord"
        echo "4 - Return to main menu."
        read -p "Choice?" -n 1 -r
        echo
        if [[ $REPLY =~ ^[1]$ ]]; then
            if [ -f ~/.config/discorddownloader/canarydir.conf ]; then
                INSTDIR="$(< ~/.config/discorddownloader/canarydir.conf)"
                VER="canary"
                VERCAP="Canary"
                read -p "Uninstall Discord$VERCAP? Y/N " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo
                    canaryptbuninst
                    echo
                    main
                    exit 0
                else
                    echo
                    echo "Discord$VERCAP was not uninstalled."
                    echo
                    main
                    exit 0
                fi
            else
                echo "DiscordCanary has not been installed through this script!"
                echo
                main
                exit 0
            fi
        elif [[ $REPLY =~ ^[2]$ ]]; then
            if [ -f ~/.config/discorddownloader/ptbdir.conf ]; then
                INSTDIR="$(< ~/.config/discorddownloader/ptbdir.conf)"
                VER="ptb"
                VERCAP="PTB"
                read -p "Uninstall Discord$VERCAP? Y/N " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo
                    canaryptbuninst
                    echo
                    main
                    exit 0
                else
                    echo
                    echo "Discord$VERCAP was not uninstalled."
                    echo
                    main
                    exit 0
                fi
            else
                echo "DiscordPTB has not been installed through this script!"
                echo
                main
                exit 0
            fi
        elif [[ $REPLY =~ ^[3]$ ]]; then
            if [ -f ~/.config/discorddownloader/stabledir.conf ]; then
                INSTDIR="$(< ~/.config/discorddownloader/stabledir.conf)"
                read -p "Uninstall Discord? Y/N " -n 1 -r
                if [[ $REPLY =~ ^[Yy]$ ]]; then
                    echo
                    stableuninst
                    echo
                    main
                    exit 0
                else
                    echo
                    echo "Discord was not uninstalled."
                    echo
                    main
                    exit 0
                fi
            else
                echo "Discord Stable has not been installed through this script!"
                echo
                main
                exit 0
            fi
        else
            echo
            main
            exit 0
        fi
    else
        echo "Exiting."
    fi
}

if [ "$EUID" -ne 0 ]; then
    PROGRAM="curl"
    programisinstalled
    if [ "$return" = "1" ]; then
        echo "Welcome to discorddownloader."
        echo
        echo "Downloads, extracts, and creates symlinks for all versions of Discord."
        echo
        echo "Some of the commands involved in the install process will require root access."
        echo
        echo "Can also be used as an update tool or to install BeautifulDiscord or"
        echo "BetterDiscord to an existing  Discord install directory."
        echo
        updatecheck
    else
        read -p "$PROGRAM is not installed; run discorddownloader without checking for new version? Y/N " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo
            echo "Welcome to discorddownloader."
            echo
            echo "Downloads, extracts, and creates symlinks for all versions of Discord."
            echo
            echo "Some of the commands involved in the install process will require root access."
            echo
            echo "Can also be used as an update tool or to install BeautifulDiscord or"
            echo "BetterDiscord to an existing  Discord install directory."
            echo
            main
        else
            echo
            echo "Exiting."
            exit 0
        fi
    fi
else
    echo "Do not run discorddownloader as root!"
fi