#!/bin/sh
exec 2>/dev/null
sudo apt update -y
# sudo apt upgrade -y
sudo apt install -y azure-cli

sudo apt install -y curl openssh-server ca-certificates postfix
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash
public_ip=$(curl ifcfg.me)
sudo EXTERNAL_URL=http://$public_ip apt install gitlab-ce

sudo curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install -y gitlab-runner
# gitlab-runner register \
#   --non-interactive \
#   --url http://$public_ip \
#   --registration-token "YOUR_REGISTRATION_TOKEN" \
#   --executor "shell" \
#   --name "My Runner Name"
sudo gitlab-ctl start
sudo gitlab-ctl status
sudo gitlab-runner start
sudo gitlab-runner enable
# sudo gitlab-runner verify
sudo gitlab-runner run