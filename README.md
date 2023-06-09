# auto-recon![iScreen Shoter - VirtualBox VM - 230608101353](https://github.com/cyberbarbie/auto-recon/assets/34199879/74080353-b6b3-4a89-9b85-5e97b786d196)


Published by Cyberbarbie
An automated Bash script that performs reconnaissance on a web app target. It performs subdomain enumeration, checks if the findings are valid and alive and screenshots each subdomain. Everything is stored in a directory it creates specifically for your target.

# Required Dependencies 
- Golang
- httprobe `go install github.com/tomnomnom/httprobe@latest`
- Gowitness  `go install github.com/sensepost/gowitness@latest
  
# Usage 
`autorecon.sh [target]`
Example: `autorecon.sh tesla.com`
