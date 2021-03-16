#!/bin/bash

init(){
	echo $(osascript -e 'tell application "zoom.us" 
		activate
		end tell')
}

print_menu_bar(){		
	echo  $(osascript -e 'tell application "System Events"
	 	tell process "zoom.us"
	 		name of every menu of menu bar 1
	 	end tell
		end tell')

	
         read -r menu_bar_1 <<< $(osascript -e 'tell application "System Events"
	 tell process "zoom.us"
	 	name of every menu of menu bar 1
	 end tell
	end tell')
	
	echo "Please choose one menu option from above:"
}

print_menu(){
	     read -r menu_items <<< $(osascript -e 'on run argv
		     tell application "System Events"
		     tell process "zoom.us"
		 name of every menu item of menu (item 1 of argv) of menu bar 1
		     end tell
		     end tell
		     end run' $1)
		    
		   echo $(sed 's/missing value, //g' <<< $menu_items)	
		    echo "Please type in one of the above options:"	
}
click(){

	if [[ $1 =~ .*"Sign In".* ]];
	then
	   open "google address"
	elif [[ $1 =~ .*"Quit Zoom".* ]];
	then
		echo $(osascript -e 'tell application "System Events"
					tell process "zoom.us"
							set frontmost to true
							delay 0.25
							click menu item "Quit Zoom" of menu "zoom.us" of menu bar 1			
						end tell
					end tell')
	
	else
	 echo $(osascript ./zoom_delimiter.scpt "$1")
	fi
}


query_menu_bar(){
	while [ 1 ]
	do
	print_menu_bar
	read menu
	
	if [[ ! "$menu_bar_1" =~ "$menu" ]];
	then
	   echo "Can't find the option!"
	else
	while [ 1 ]
	do
	print_menu "$menu"
	read item_along_menu
	click "$item_along_menu"

	done
	fi
	done
}



init
query_menu_bar





