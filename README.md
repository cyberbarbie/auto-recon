# auto-recon![iScreen Shoter - VirtualBox VM - 230608101353](https://github.com/cyberbarbie/auto-recon/assets/34199879/74080353-b6b3-4a89-9b85-5e97b786d196)


Published by Cyberbarbie
An automated Bash script that performs reconnaissance 

# Required Dependencies 
1. Make sure Golang is installed on your system
2. `sudo apt-get install assetfinder`
3. `sudo apt-get install amass`
4. `go install github.com/tomnomnom/httprobe@latest`
5. `go install github.com/sensepost/gowitness@latest`
6. Add the following lines to the end of the zhrc/bashrc/etc shell configuration file:
  `export GOPATH=$HOME/go`
  `export PATH=$(go env GOPATH)/bin
7. Add the tool directory to your environment path
  

# Usage 
`autorecon.sh [target]`
Example: `autorecon.sh tesla.com`
