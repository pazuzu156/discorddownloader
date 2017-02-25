---
title: discorddownloader
layout: discorddownloader
permalink: /index.html
---

![discorddownloader](https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/Screenshot.png)
<br>
<br>

# Installation

#### Just download `discorddownloader.sh` from the [releases page](https://github.com/simoniz0r/discorddownloader/releases/latest) or grab the [raw script](https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/discorddownloader.sh) and run it.
<br>
<br>

# Usage

#### Run `discordownloader.sh` and select one of the installation options.

#### Some of the commands involved in the install process will require root access.

#### You do not need to run this script as root; you will be asked to input your password when root access is needed.

1. Discord Canary will be installed to either `/opt/DiscordCanary/` or the directory of your choice.

2. Discord PTB will be installed to either `/opt/DiscordPTB/` or the directory of your choice.

3. Discord Stable will be installed to either `/opt/Discord/` or the directory of your choice.

4. Install [BetterDiscord](https://github.com/Jiiks/BetterDiscordApp) to existing Discord install directory (requires npm, nodejs, unzip).

5. Install [BeautifulDiscord](https://github.com/leovoel/BeautifulDiscord) (requires python3.x, python3-pip).

6. Uninstall: choose the version of Discord to uninstall.

7. Exit script without installing.
	
#### After your selected version of Discord has been installed, you will then be asked if you would like to install BetterDiscord or BeautifulDiscord.

1. Install [BetterDiscord](https://github.com/Jiiks/BetterDiscordApp) (requires npm, nodejs, unzip)
	* BetterDiscord install uses [tape.sh](https://github.com/Ckath/Discord-stuff/blob/master/scripts/tape.sh) to allow installation to any directory and with multiple Discord installs.
	* BetterDiscord does not fully support Linux and may break at any time.
	* If you install BetterDiscord, I recommend grabbing the [Even Better Repo](https://github.com/IRDeNial/BD-Even-Better-Repo) plugin.  It allows you to install plugins and themes through the Discord Settings menu.

2. Install [BeautifulDiscord](https://github.com/leovoel/BeautifulDiscord) (requires python3.x, python3-pip)
	* BeautifulDiscord will be installed and [sans' Arc-Dark theme](https://userstyles.org/styles/127986/discord-arc-dark) ([license](https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode)) will be downloaded to `~/.config/discorddownloader/arc-dark.css`
	* To use BeautifulDiscord, run Discord, and then execute `beautifuldiscord --css ~/.config/discorddownloader/arc-dark.css`
	* BeautifulDiscord requires `psutil`; the script will take care of installing it for you.  If you have an older version of psutil on your system, you should remove it before running this script or update it yourself using `pyton3-pip`

3. No thanks.  Just let me use Discord.

### If run into any problems, join the [discorddownloader Discord Server](https://discord.gg/FFWVWPA) and ask for help in #dd-help.

[Changelog](CHANGELOG)
============

[Credits](CREDITS)
============