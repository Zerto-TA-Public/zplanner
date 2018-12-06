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
  echo "=      zPlanner Info and Config menu v4.0.2      ="
  echo "=================================================="
  echo "Current Network Config:"
  echo "   Interface Name: $interface"
  echo "   Static \ DHCP: $iptype"
  echo "   Details: $ipinfo"
  echo "   Default Gateway: $ipgw"
  echo "=================================================="
  echo -e "Select an action from the menu below\n"
  echo "1.) Update zPlanner        2.) Configure Network Settings"
  echo "3.) Config Hypervisor Info 4.) Test Hypervisor Connectivity"
  echo "5.) Generate VM List       6.) Start Scheduled Jobs"
  echo "7.) Config Auto Login      8.) Delete Scheduled Jobs"
  echo "9.) Bash Shell             0.) Quit"
  read choice
  case "$choice" in
          1) # Update zPlanner Scripts from Github
              clear
	      echo "Updating zPlanner from github"
	      (cd /home/zerto/zplanner/ && git reset --hard HEAD && git pull http://www.github.com/zerto-ta-public/zplanner/)
	      echo "Running Update Helper Script"
	      (/bin/bash /home/zerto/zplanner/updates.sh)
	      ;;
          2) # Config Network Settings
	      clear
	      echo "====================="
	      echo "Network Config Wizard"
	      echo -e "=====================\n"
	      echo "Configure appliance with DHCP or STATIC IP? (S=Static, D=DHCP)"
	      read cronvminfo
	        case "$cronvminfo" in
          	    "S" | "s") # update /etc/network/interface with static config
				echo "Enter IP address (xxx.xxx.xxx.xxx):"
				read nicip
				echo "Enter Subnet Mask (xxx.xxx.xxx.xxx):"
				read nicmask
				echo "Enter Default Gateway (xxx.xxx.xxx.xxx):"
				read nicgw
				echo "Enter DNS Servers (Seperate by space):"
				read nicdns
				echo "Does everything look correct? (Y/N)"
				read confirm
				case "$confirm" in
				   "Y" | "y")
					awk -f /home/zerto/zplanner/modules/changeInterface.awk /etc/network/interfaces device="$interface" mode=static address="$nicip" netmask="$nicmask" dns="$nicdns" gateway="$nicgw" | sudo tee /etc/network/interfaces
					sudo /etc/init.d/networking restart
					;;
				   *)
					break
					;;
				esac
				;;
	            "D" | "d") # update /etc/network/interface with dhcp config
				awk -f /home/zerto/zplanner/modules/changeInterface.awk /etc/network/interfaces device=enp0s17 mode=dhcp | sudo tee /etc/network/interfaces
				sudo /etc/init.d/networking restart
				;;
		    *) echo "invalid option try again";;
      		esac
              ;;
          3) # Config Customer Information
	      clear
	      echo "========================"
	      echo "Hypervizor Config Wizard"
	      echo -e "========================\n"
              /usr/bin/pwsh /home/zerto/zplanner/workers/vm-setenv.ps1
              ;;
          4) # Test Hypervisor connectivity
	      clear
	      echo "==============================="
	      echo "Testing Hypervizor Connectivity"
	      echo -e "===============================\n"
              /usr/bin/pwsh /home/zerto/zplanner/workers/vm-testenv.ps1
	      echo "If an error occured please run Hypervisor Configuration Wizard"
              ;;
          5) # Config Customer Information
	      clear
	      echo "========================"
	      echo "Generating List of VMs"
	      echo -e "========================\n"
              /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getvms.ps1
              ;;
	  6) # Schedule Cron Jobs
	      clear
	      echo "====================="
	      echo "Job Scheduling Wizard"
	      echo -e "=====================\n"
	      echo "Generating Crontab configuration..."

	      #Add Line to gather CPU and Memory information
	      line="@daily /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1"
	      (crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

	      #Add cron for gathering statistics every 5 minutes
	      echo "5" > /home/zerto/include/interval.txt
	      line="*/5 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	      (crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

	      #Add Log cleanup to run once per day
	      line="@daily /usr/bin/find /home/zerto/logs -mtime +7 -type f -delete"
	      (crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

	      crontab -l
              ;;
          7) # Config Auto Login
	      enacfgfile=/etc/systemd/system/getty@tty1.service.d/override.conf
	      discfgfile=/etc/systemd/system/getty@tty1.service.d/override.conf.disabled
	      # see if override.conf is in place
	      if [ -f "$enacfgfile" ]
	      then
		echo "Enabled"
		login="Enabled"
		nigol="Disabled"
	      else
		echo "Disabled"
		login="Disabled"
		nigol="Enabled"
	      fi
	      echo "Current Autologin status: $login"

	      echo "Would you like to change this? (Y/N):"
      	      read autologin
	        case "$autologin" in
	             "y" | "Y") # switch autologin status 
			echo "Reconfiguring Auto Login from $login to $nigol"
		     	if [ "$login" == "Enabled" ]
	      	     	then
			    sudo mv $enacfgfile $discfgfile
			    echo "Disabling Auto Login Completed"
	      	        else
			    sudo mv $discfgfile $enacfgfile
			    echo "Enabling Auto Login Completed"
	      	        fi
			;;
	             *) # do nothing
			echo "Nothing to do..."
			;;
	        esac
              ;;
          8) # Kill all exisint CronJobs
	      clear
	      echo "=============================="
	      echo "Existing Cron jobs "
	      echo "=============================="
	      crontab -l
	      echo "=========== WARNING =========="
	      echo "Remove all existing Cron Jobs? (Y/N)"
      	      read crondel
	        case "$crondel" in
	             "y" | "Y") # delete crontab
			crontab -r
	  	        #Add Log cleanup to run once per day
	      	 	line="@daily /usr/bin/find /home/zerto/logs -mtime +7 -type f -delete"
	      	 	(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -
	  	        #Add auto update to run once per day
	      	 	line="@daily /bin/bash /home/zerto/modules/nightlyupdate.sh"
	      	 	(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

			;;
	             *) # do nothing
			;;
	        esac
              ;;
          9) # enter bash shell prompt
              clear
	      /bin/bash
              ;;
          0) # exit the menu script
              exit
              ;;
          A) # Advanced Menu
      	      while true
	      do
                clear
		echo "=============================="
	      	echo "Advanced Menu "
	      	echo "=============================="
	      	echo -e "Select an action from the menu below\n"
  	      	echo "1.) Manually Run VMInfo Script"
	      	echo "2.) Dump SQL DB to Zerto FTP"
  	      	echo "3.) Reserved"
   	      	echo "4.) Reserved"
  	      	echo "0.) Back to Main Menu"
  	      	read adv
  	      	case "$adv" in
          		1) # Manually run VMInfo Script
			   /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1
              	   	   ;;
          		2) # Dump SQL DB to Zerto FTP
			   echo "==================================="
			   echo "Dumping database to file"
			   #do some db dump stuff here
              	   	   ;;
          		3) # reserved
			   break
              	   	   ;;
          		4) # reserved
			   break
              	   	   ;;
			0) # go back to main menu
			   break
			   ;;
          		*) echo "invalid option try again";;
      		esac
	      done
	      ;;
          *) echo "invalid option try again";;
      esac
      echo "Press any key to Continue..."
      read input
done
done

