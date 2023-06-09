#!/bin/bash

figlet -c -f ansi-shadow -t "Auto-recon.sh" | lolcat
echo "Finding subdomains, open ports and services and directories ofinterest"

url=$1
TODAY=$(date)
echo "This scan was created on $TODAY"

if [ ! -d "$url" ];then
        mkdir $url
fi

if [ ! -d "$url/recon" ];then
        mkdir $url/recon
fi

if [ ! -d "$url/recon/subdomains" ];then
        mkdir $url/recon/subdomains
fi

if [ ! -d "$url/recon/dir_enum" ];then
        mkdir $url/recon/dir_enum
fi

echo "[+] Harvesting subdomains that may be of interest for you..."
assetfinder $url >> $url/recon/assets.txt
cat $url/recon/assets.txt | grep $1 >> $url/recon/final.txt
rm $url/recon/assets.txt
echo "[+] Querying cert.sh for subdomains..."
curl -s "https://crt.sh/?q=%25.$url&output=json" | jq -r '.[].name_value'| sed 's/\*\.//g' | sort -u > $url/recon/subdomains/crt.txt

echo "[+] Performing directory enumeration..."
gobuster dir -u $url -k -r -w /usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-medium.txt  > $url/recon/dir_enum/scan.txt
#echo "[+] Finding more subdomains..."
#amass enum -d $url >> $url/recon/f.txt
#sort -u $url/recon/f.txt >> $url/recon/final.txt
#rm $url/recon/f.txt
echo "[+] Querying for subject alternative names on $url"
curl -s "https://crt.sh/?q=%25.$url&output=json" | jq -r '.[].name_value'| sort -u > $url/recon/san.txt

echo "[+] Probing for alive domains..."
cat $url/recon/final.txt | sort -u | httprobe -s -p https:443 | sed 's/https\?:\/\///' | tr -d ':443' >> $url/recon/alive.txt  
#echo "[+] Scanning for open ports..."
#nmap -iL $url/recon/final.txt -T4 -oA $url/recon/scanned.txt
echo "[+] Taking screenshots of subdomains..."
gowitness file -f $url/recon/final.txt --disable-logging --disable-db -P $url/recon/screenshots
echo "[+] Saved screenshots to ${url}/recon/screenshots!"
echo "Happy Hacking! ^-^" | lolcat


