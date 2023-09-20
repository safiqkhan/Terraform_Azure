#!/bin/bash
set -x
# exec 2>/dev/null
LOG_FILE="gitlab.log"
rm -rf $LOG_FILE
# Function to add timestamps to log messages
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}
#exec > >(tee -a "LOG_FILE") 2>&1
# Redirect stdout and stderr to a log file
exec > >(while read -r line; do log "$line"; done) 2>&1
log "Script started."
sudo apt update -y
# sudo dpkg --configure -a
log "Upgrading"
sudo apt upgrade -y
log "Installing a Azurecli"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

log "installing required other service"
sudo apt install -y curl openssh-server ca-certificates
log "installing Gitlab"
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
public_ip=$(curl ifcfg.me)
sudo EXTERNAL_URL=http://$public_ip apt install gitlab-ce
password=$(grep Password: /etc/gitlab/initial_root_password)
log "Gitlab username: root"
log "Gitlab ${password}"
log "installing Gitlab-runner"
sudo curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install -y gitlab-runner
# gitlab-runner register \
#   --non-interactive \
#   --url http://$public_ip \
#   --registration-token "YOUR_REGISTRATION_TOKEN" \
#   --executor "shell" \
#   --name "My Runner Name"
log "Start the gitlab service"
sudo gitlab-ctl start
sudo gitlab-ctl status
log "Start the gitlab-runner service"
sudo gitlab-runner start
sudo gitlab-runner enable
# sudo gitlab-runner verify
# sudo gitlab-runner run
log "Script completed."
