#!/bin/bash

# Functions Section
##########################################################

# This function allow you to print the banner
function print_banner(){
	figlet -c -f ansishadow -t "Auto-recon.sh" | lolcat
	echo "Finding subdomains, open ports and services and directories of interest"
}

# This function allow you to print the attack mode selection menu
function attack_mode_selection_menu(){
	echo -e "\nWhich type of recon would you like to do?"
    echo "1 - Find Subdomains"
	echo "2 - Find Open Ports"
    echo "e - Exit"
	read -p "Selection: " selection
    case $selection in
		1) find_subdomains_menu;;
		2) find_open_ports_menu;;
		e) exit 1;;
		*) echo "This color is not available. Please choose a different one.";; 
    esac
}

# Find subdomains menu function
function find_subdomains_menu(){
	echo -e "\nA - Active subdomain finders"
	echo "P - Passive subdomain finders"
	echo "U - Upper Menu"
	echo "E - Exit"
	read -p "Selection: " selection
		case $selection in
		a) active_subdomain_finders_menu;;
		p) passive_subdomain_finders_menu;;
		u) attack_mode_selection_menu;;
		e) exit 1;;
		*) echo "This is not available. Please choose a different one.";; 
    esac
}

# Find subdomains menu function
function find_open_ports_menu(){
	echo -e "\n1 - Nmap"
	echo "U - Upper Menu"
	echo "E - Exit"
	read -p "Selection: " selection
		case $selection in
		1) run_nmap;;
		u) attack_mode_selection_menu;;
		e) exit 1;;
		*) echo "This is not available. Please choose a different one.";; 
    esac
}

# Active subdomains menu function
function active_subdomain_finders_menu(){
	echo -e "\nActive subdomain finders"
	echo "1 - Assetfinder"
	echo "2 - Httprobe"
	echo "3 - Gowitness"
	echo "4 - Amass"
	echo "U - Upper Menu"
	echo "E - Exit"
	read -p "Selection: " selection
		case $selection in
		1) run_assetfinder;;
		2) run_httprobe;;
		3) run_gowitness;;
		4) run_amass;;
		u) find_subdomains_menu;;
		e) exit 1;;
		*) echo "This is not available. Please choose a different one.";; 
    esac
}

# Passive subdomains menu function
function passive_subdomain_finders_menu(){
	echo -e "\nPassive subdomain finders"
	echo "1 - crt.sh"
	echo "U - Upper Menu"
	echo "E - Exit"
	read -p "Selection: " selection
		case $selection in
		1) run_crtsh;;
		u) find_subdomains_menu;;
		e) exit 1;;
		*) echo "This is not available. Please choose a different one.";; 
    esac
}

# assetfinder run function
function run_assetfinder(){
	echo "[+] Harvesting subdomains that may be of interest for you..."
	assetfinder $url >> $url/recon/assets.txt
	cat $url/recon/assets.txt | grep $url >> $url/recon/final.txt
	rm $url/recon/assets.txt
}


# httprobe run function
function run_httprobe(){
	echo "[+] Probing for alive domains..."
	cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alive.txt 
}

# gowitness run function
function run_gowitness(){
	echo "[+] Taking screenshots of subdomains..."
	gowitness file -f $url/recon/final.txt --disable-logging --disable-db -P $url/recon/screenshots
	echo "[+] Saved screenshots to ${url}/recon/screenshots!"
}

# amass run function
function run_amass(){
	echo "[+] Finding more subdomains..."
	#amass enum -d $url >> $url/recon/f.txt
	#sort -u $url/recon/f.txt >> $url/recon/final.txt
	#rm $url/recon/f.txt
}

# crt.sh run function
function run_crtsh(){
	echo "[+] Querying cert.sh for subdomains..."
	curl -s "https://crt.sh/?q=%25.$url&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u >> $url/recon/subdomains/crt.txt
}

# nmap run function
function run_nmap(){
	echo "[+] Scanning for open ports..."
	#nmap -iL $url/recon/final.txt -T4 -oA $url/recon/scanned.txt
}

# End of the Functions Section
##########################################################
# Start of the Main Section

print_banner # Calling print_banner function

# Setting the target
echo -e "\nPlease set the target"
read -p "Target: " url

# Creating target directory
if [ ! -d "$url" ];then
	mkdir $url
fi 

if [ ! -d "$url/recon" ];then
	mkdir $url/recon
fi

if [ ! -d "$url/recon/subdomains" ];then
        mkdir $url/recon/subdomains
fi

# Calling Main Menu
attack_mode_selection_menu

# End of the program banner
echo -e "\nHappy Hacking! ^-^" | lolcat
