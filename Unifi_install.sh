# Script to Install Unifi in a Proxmox LXC container running Debian 12 template, updated 10/27/2023
# This will work on standard Debian 12 just add 'sudo' where appropriate
# FYI The Unifi installer will handle Java installation automatically

# Update Debian
apt-get update && apt-get -y upgrade

# Install required packages
apt-get -y install ca-certificates apt-transport-https gpg

# MongoDB requires older Debian package 'LibSSL'
wget https://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1n-0+deb10u6_amd64.deb
dpkg -i libssl1.1_1.1.1n-0+deb10u6_amd64.deb

# Add MongoDB 4.4 repo and install
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-4.4.gpg && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.4 main" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list
apt-get update && apt-get -y install mongodb-org

# Add Ubiquiti repo and install
wget -O /etc/apt/trusted.gpg.d/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg && echo 'deb https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list
apt-get update && apt-get -y install unifi

# check to fix dependancies, optional 
apt-get install -f

# Done, this should output the UniFi URL 
echo -e "\033[1;32mhttps://$(hostname -I | awk '{print $1}'):8443\033[0m"
