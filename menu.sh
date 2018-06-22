#!/bin/bash
##########################################################
#
# Info and Config Menu for zPlanner Appliance
#
##########################################################
while true
do
  # get network information (get each time in case it changes)
  interface=$(cat /etc/network/interfaces | grep -i "iface" | grep -vi "lo" | awk '{print $2}')
  iptype=$(cat /etc/network/interfaces | grep -vi "lo" | grep -i "inet" | awk '{print $NF}')
  ipinfo=$(ifconfig $interface | awk '/inet addr/' | sed "s/^[ \t]*//")
  ipgw=$(ip route | grep -i "default" | awk '{ print $3 }')
  
  # start menu output
  clear
  echo "=================================================="
  echo " zPlanner Info and Config menu "
  echo "=================================================="
  echo "Current Network Config:"
  echo "   Interface Name: $interface"
  echo "   Static \ DHCP: $iptype"
  echo "   Details: $ipinfo"
  echo "   Default Gateway: $ipgw"
  echo "=================================================="
  echo -e "Select an action from the menu below\n"
  echo "1.) Update zPlanner     2.) Configure Network Settings" 
  echo "3.) Option 3            4.) Option 4"
  echo "5.) Option 5            6.) Shell" 
  echo "7.) Quit"
  read choice
  case "$choice" in
          1) # Update zPlanner Scripts from Github
              clear
	      echo "Updating zPlanner from github"
	      git-dir=/home/zerto/zplanner/.git pull
              ;;
          2) # Config Network Settings
              echo "Network config stuff here... later on."
              ;;
          3) # choice 3
              echo "you chose choice $REPLY which is $choice"
              ;;
          4) # choice 4
              echo "you chose choice $REPLY which is $choice"
              ;;
          5) # choice 5
              echo "you chose choice $REPLY which is $choice"
              ;;
          6) # enter bash shell prompt
              clear
	      /bin/bash
              ;;
          7) # exit the menu script
              exit
              ;;
          *) echo "invalid option try again";;
      esac
      echo "Press any key to Continue..."
      read input
  done
done
