#!/bin/bash
##########################################################
#
# This will be a menu system or the v3 zPlanner Appliance
#
##########################################################

PS3='Please enter your choice: '
options=("Update zPlanner" "Option 2" "Option 3" "Option 4" "Option 5" "Option 6" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Update zPlanner")
            echo "Updating zPlanner from github"
	    git pull https://github.com/zerto-ta-public/zplanner/
            ;;
        "Option 2")
            echo "you chose choice 2"
            ;;
        "Option 3")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Option 4")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Option 5")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Option 6")
            echo "you chose choice $REPLY which is $opt"
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
