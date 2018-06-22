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
  echo "3.) Upload SQL Data     4.) Start Scheduled Jobs"
  echo "5.) Stop Scheduled Jobs 6.) Shell"
  echo "7.) Quit"
  read choice
  case "$choice" in
          1) # Update zPlanner Scripts from Github
              clear
	      echo "Updating zPlanner from github"
	      (cd /home/zerto/zplanner/ && git pull http://github.com/recklessop/zplanner/)
              ;;
          2) # Config Network Settings
              echo "Network config stuff here... later on."
              ;;
          3) # choice 3
              echo "you chose choice $REPLY which is $choice"
              ;;
          4) # choice 4
	      clear
	      echo "====================="
	      echo "Job Scheduling Wizard"
	      echo -e "=====================\n"
              while true
	      do
	      echo "How often should I collect VM info (CPU / Memory)?"
	      echo "W = Weekly; D = Daily; N = Never"
	      read cronvminfo
	        case "$cronvminfo" in
          	    "D" | "d") # Update VM info Daily
			line="@daily /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1"
			(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -
			break
			;;
		    "W" | "w") # Update VM info Weekly
			line="@weekly /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1"
			(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -
			break
			;;
		    "N" | "n") # Disable VM Info Collection
			echo -e "Not Collecting VM CPU or Memory Information\n"
			break
			;;
	            *) echo "invalid option try again";;
      		esac
	      done

	      echo "How Often should I collect stats (in minutes)?"
	      echo "Default = 5 minutes; Valid Options = 5, 10, 15, 20, 25, 30"
	      read cronstats
	      echo "Building Crontab..."
	      line="*/$cronstats * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	      (crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

	      crontab -l
	      # add code to write number of minutes between stats run to config file so the getio script can use it
              ;;
          5) # choice 5
              crontab -r
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
