#!/usr/bin/env bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#----------------------------------------------------------#
# General UI/UX
#----------------------------------------------------------#

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

#----------------------------------------------------------#
# Screen                                                                      
#----------------------------------------------------------#

# Require password immediately after sleep or screen saver begins
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


#----------------------------------------------------------#
# Finder                                                                      #
#----------------------------------------------------------#

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

#----------------------------------------------------------#
# Terminal
#----------------------------------------------------------#

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

cat <<EOF > SolarizedDark.terminal
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>BackgroundColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECgw
	LjAxNTkyNDQwNTMxIDAuMTI2NTIwOTE2OCAwLjE1OTY5NjAxMjcAEAGAAtIQERITWiRj
	bGFzc25hbWVYJGNsYXNzZXNXTlNDb2xvcqISFFhOU09iamVjdF8QD05TS2V5ZWRBcmNo
	aXZlctEXGFRyb290gAEIERojLTI3O0FITltijY+RlqGqsrW+0NPYAAAAAAAAAQEAAAAA
	AAAAGQAAAAAAAAAAAAAAAAAAANo=
	</data>
	<key>BlinkText</key>
	<false/>
	<key>CursorColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjQ0MDU4MDI0ODggMC41MDk2MjkzMDkyIDAuNTE2ODU3OTgxNwAQAYAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>Font</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGGBlYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKQHCBESVSRudWxs1AkKCwwNDg8QVk5TU2l6ZVhOU2ZGbGFnc1ZOU05hbWVWJGNs
	YXNzI0AqAAAAAAAAEBCAAoADXU1lbmxvLVJlZ3VsYXLSExQVFlokY2xhc3NuYW1lWCRj
	bGFzc2VzVk5TRm9udKIVF1hOU09iamVjdF8QD05TS2V5ZWRBcmNoaXZlctEaG1Ryb290
	gAEIERojLTI3PEJLUltiaXJ0dniGi5afpqmyxMfMAAAAAAAAAQEAAAAAAAAAHAAAAAAA
	AAAAAAAAAAAAAM4=
	</data>
	<key>FontAntialias</key>
	<true/>
	<key>FontHeightSpacing</key>
	<real>1.1000000000000001</real>
	<key>FontWidthSpacing</key>
	<integer>1</integer>
	<key>ProfileCurrentVersion</key>
	<real>2.02</real>
	<key>SelectionColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECgw
	LjAzOTM4MDczNjY1IDAuMTYwMTE2NDYzOSAwLjE5ODMzMjc1NjgAEAGAAtIQERITWiRj
	bGFzc25hbWVYJGNsYXNzZXNXTlNDb2xvcqISFFhOU09iamVjdF8QD05TS2V5ZWRBcmNo
	aXZlctEXGFRyb290gAEIERojLTI3O0FITltijY+RlqGqsrW+0NPYAAAAAAAAAQEAAAAA
	AAAAGQAAAAAAAAAAAAAAAAAAANo=
	</data>
	<key>ShowWindowSettingsNameInTitle</key>
	<true/>
	<key>TerminalType</key>
	<string>xterm-256color</string>
	<key>TextBoldColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECYw
	LjUwNTk5MTkzNTcgMC41NjQ4NTgzNzcgMC41NjM2MzY1NDE0ABABgALSEBESE1okY2xh
	c3NuYW1lWCRjbGFzc2VzV05TQ29sb3KiEhRYTlNPYmplY3RfEA9OU0tleWVkQXJjaGl2
	ZXLRFxhUcm9vdIABCBEaIy0yNztBSE5bYouNj5SfqLCzvM7R1gAAAAAAAAEBAAAAAAAA
	ABkAAAAAAAAAAAAAAAAAAADY
	</data>
	<key>TextColor</key>
	<data>
	YnBsaXN0MDDUAQIDBAUGFRZYJHZlcnNpb25YJG9iamVjdHNZJGFyY2hpdmVyVCR0b3AS
	AAGGoKMHCA9VJG51bGzTCQoLDA0OVU5TUkdCXE5TQ29sb3JTcGFjZVYkY2xhc3NPECcw
	LjQ0MDU4MDI0ODggMC41MDk2MjkzMDkyIDAuNTE2ODU3OTgxNwAQAYAC0hAREhNaJGNs
	YXNzbmFtZVgkY2xhc3Nlc1dOU0NvbG9yohIUWE5TT2JqZWN0XxAPTlNLZXllZEFyY2hp
	dmVy0RcYVHJvb3SAAQgRGiMtMjc7QUhOW2KMjpCVoKmxtL3P0tcAAAAAAAABAQAAAAAA
	AAAZAAAAAAAAAAAAAAAAAAAA2Q==
	</data>
	<key>UseBrightBold</key>
	<true/>
	<key>blackColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg7JNIT2DkvUjPoO+F0s+AYY=
	</data>
	<key>blueColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmgyqcAj6DtOHsPoO+RUg/AYY=
	</data>
	<key>brightBlackColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg+ZzgjyDs44BPoNahyM+AYY=
	</data>
	<key>brightBlueColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg7yT4T6DEXcCP4POUAQ/AYY=
	</data>
	<key>brightCyanColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg7CIAT+Dj5oQP4N8ShA/AYY=
	</data>
	<key>brightGreenColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmgzyujT6DFZy2PoOYFsQ+AYY=
	</data>
	<key>brightMagentaColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmgxMjsj6D+uazPoNkyTc/AYY=
	</data>
	<key>brightRedColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmgyfkPT+D/15aPoMgl5Y9AYY=
	</data>
	<key>brightWhiteColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg49LfT+D0Dt1P4MGM10/AYY=
	</data>
	<key>brightYellowColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg1MTpj6DeHnQPoPQg+A+AYY=
	</data>
	<key>cyanColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg4VRFj6DfyESP4PkZwY/AYY=
	</data>
	<key>greenColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg9lI5j6DIYkKP4PVjKU8AYY=
	</data>
	<key>magentaColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg/4CRz+DBTzdPYMgzt4+AYY=
	</data>
	<key>name</key>
	<string>Solarized Dark xterm-256color</string>
	<key>redColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg6i7UT+DUATePYMl2hA+AYY=
	</data>
	<key>type</key>
	<string>Window Settings</string>
	<key>whiteColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmgzqGaj+D2tdjP4NYPUw/AYY=
	</data>
	<key>yellowColour</key>
	<data>
	BAtzdHJlYW10eXBlZIHoA4QBQISEhAdOU0NvbG9yAISECE5TT2JqZWN0AIWEAWMBhARm
	ZmZmg0DAJT+DB17vPoM4Y8A8AYY=
	</data>
</dict>
</plist>

EOF

# Use a modified version of the Solarized Dark theme by default in Terminal.app
osascript <<EOD
tell application "Terminal"
	local allOpenedWindows
	local initialOpenedWindows
	local windowID
	set themeName to "SolarizedDark"
	(* Store the IDs of all the open terminal windows. *)
	set initialOpenedWindows to id of every window
	(* Open the custom theme so that it gets added to the list
	   of available terminal themes (note: this will open two
	   additional terminal windows). *)
	do shell script "open 'SolarizedDark.terminal'"
	(* Wait a little bit to ensure that the custom theme is added. *)
	delay 1
	(* Set the custom theme as the default terminal theme. *)
	set default settings to settings set themeName
	(* Get the IDs of all the currently opened terminal windows. *)
	set allOpenedWindows to id of every window
	repeat with windowID in allOpenedWindows
		(* Close the additional windows that were opened in order
		   to add the custom theme to the list of terminal themes. *)
		if initialOpenedWindows does not contain windowID then
			close (every window whose id is windowID)
		(* Change the theme for the initial opened terminal windows
		   to remove the need to close them in order for the custom
		   theme to be applied. *)
		else
			set current settings of tabs of (every window whose id is windowID) to settings set themeName
		end if
	end repeat
end tell
EOD

rm SolarizedDark.terminal

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.terminal SecureKeyboardEntry -bool true
