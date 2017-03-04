---
layout: discorddownloader
---

![discorddownloader](https://raw.githubusercontent.com/simoniz0r/discorddownloader/master/Screenshot.png)


# Changelog

* v1.3.1 - Added dependency checks for `wget` and removed check for `nodejs`; BetterDiscord install should work as long as `npm` is present.
* v1.3.0 - 
		* Fixed output of custom directory installs (was showing wrong directory to be removed before installing, but had no actual effect)
		* Fixed script to detect if chosen version is already installed, and clean up everything properly before reinstalling.
* v1.2.9 - Added version number on first screen.
* v1.2.8 - Added fix from [tape.sh](https://github.com/Ckath/Discord-stuff/blob/master/scripts/tape.sh) for bdstorage.json issue. The script no longer creates a symlink in the BetterDiscord directory.
* v1.2.7 - Fixed output of install checks (thanks EastAPOLO)
* v1.2.6 - Added checks to make sure dependencies are installed before installing BetterDiscord and BeautifulDiscord.
* v1.2.5 - Added note that BeautifulDiscord requires python3-pip.
* v1.2.4 - Add symlink from ~/.config/BetterDiscord/bdstorage.json -> //bdStorage.json to prevent errors for some users.
* v1.2.3 - Added note that BetterDiscord install requires npm.
* v1.2.2 - Added note about install process needing root access.
* v1.2.1 - Wording.
* v1.2.0 - Made it more clear that BetterDiscord is to be installed to Discord directory.
* v1.1.9 - Fixed some syntax.
* v1.1.8 - Condensed amount of functions by creating more variables.
* v1.1.7 - Cleaned up the main screen by moving custom install question to happen after version choice.  Added a few more things to functions to clean up the script a bit.
* v1.1.6 - Added option to install BeautifulDiscord to the first screen.
* v1.1.5 - Changed BetterDiscord installer to use [tape.sh](https://github.com/Ckath/Discord-stuff/blob/master/scripts/tape.sh) to allow BetterDiscord to be installed to any directory and to multiple installs. (Ckath)
* v1.1.4 - Cleaned up the script a bit by moving all functions to the top.
* v1.1.3 - Added failsafe for invalid directories with custom installs.
* v1.1.2 - Added warning to be careful to input the correct directory during custom install.  It will be removed before installation.
* v1.1.1 - Spelling.
* v1.1.0 - Added support for custom install directories into the new script.  Config files have changed, so before you can uninstall previously installed versions, you will have to run the install process through the new script first.
* v1.0.8 - Added git to requirements for BetterDiscord.
* v1.0.7 - Fixed output message when trying to uninstall if a version of Discord is not already installed through this script.
* v1.0.6 - Cosmetic.
* v1.0.5 - Added warning about creating symlink to /opt/DiscordCanary when installing BetterDiscord with DiscordPTB and DiscordCanary.
* v1.0.4 - Added a warning that tells users to uninstall Discord if they have installed it through another method.
* v1.0.3 - Added output if user chooses not to uninstall.
* v1.0.2 - Fixed spelling errors.
* v1.0.1 - Added Exit option.
* v1.0.0 - The script has been rewritten to use questions instead of arguments for ease of use.
* v0.9.1 - Cleaned up some formatting.
* v0.9.0 - Added options for .deb packages for Debian based distros.  This script is now feature complete.
* v0.8.1 - Added confirmations for all arguments to help prevent user error.
* v0.8.0 - A config file is now created on installation that contains the installation directory.  Manually inputting the directory when uninstalling is no longer needed.
* v0.7.4 - Commands work with or without the `/` after directories, so warnings about this have been removed.
* v0.7.3 - Fixed all arguments so they will still work if the user includes a `/` after the directory. (unrealcroissant)
* v0.7.2 - Changed all arguments to use root permissions by default to avoid confusion. (unrealcroissant)
* v0.7.1 - Fixed the symbolic link for the PTB png file.
* v0.7.0 - Added support for all versions of Discord.  
	* Added confirmations before uninstalling to help prevent user error.  
	* Changed "-i" to "-c" to be more in line with the rest of the arguments.  
	* Made it so that symbolic links are created by default, so "-l" is no longer needed.
* v0.6.0 - Prevent users from adding / with some arguments (unrealcroissant)
* v0.5.0 - Cleaned up a bit
* v0.4.0 - Changed "-s" argument to "-l"
* v0.3.0 - First upload
