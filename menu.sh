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
  echo "=      zPlanner Info and Config menu v3.0.4      ="
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
  echo "7.) Config Zerto Op Info   8.) Delete Scheduled Jobs"
  echo "9.) Bash Shell             0.) Quit"
  read choice
  case "$choice" in
          1) # Update zPlanner Scripts from Github
              clear
	      echo "Updating zPlanner from github"
	      (cd /home/zerto/zplanner/ && git reset --hard HEAD && git pull http://www.github.com/zerto-ta-public/zplanner/)
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
          4) # Config Customer Information
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
	      echo "Default = 5 minutes; Valid Options = 5, 10, 15, 20, 30, 60"
	      read cronstats
	      echo "Building Crontab..."
	      echo "$cronstats" > /home/zerto/include/interval.txt
	      if [ $cronstats -eq 60 ]
	      then
	      	line="0 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	      else
		line="*/$cronstats * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	      fi
	      (crontab -u zerto -l; echo "$line" ) | crontab -u zerto -
	      /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1

	      crontab -l
              ;;
          7) # Config Zerto opp Information
	      cfgfile=/home/zerto/include/config.ini
	      echo "Enter Customer Name:"
	      read custname
	      echo "Enter Customer Site Name:"
	      read custsite
	      echo "Enter Zerto Account Manager Name:"
	      read zAM
	      echo "Enter Zerto SE Name:"
	      read zSE

	      # add names to values
	      custname="company=${custname}"
	      custsite="site=${custsite}"
	      zAM="am=${zAM}"
	      zSE="se=${zSE}"

	      if [ -f "$cfgfile" ]
	      then
		echo "$custname" > "$cfgfile"
		echo "$custsite" >> "$cfgfile"
		echo "$zAM" >> "$cfgfile"
		echo "$zSE" >> "$cfgfile"
	      fi
	      /usr/bin/php /home/zerto/zplanner/loaders/loadConfigmysql.php
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
          *) echo "invalid option try again";;
      esac
      echo "Press any key to Continue..."
      read input
  done
done
