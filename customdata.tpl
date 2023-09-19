#!/bin/bash
sudo yum update -y
sudo yum install -y curl policycoreutils-python openssh-server 2>&1 /dev/null
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc 
sudo yum install azure-cli 
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash
public_ip=$(curl ifcfg.me 2> /dev/null)
sudo EXTERNAL_URL=http://$public_ip yum install -y gitlab-ce
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install -y gitlab-runner
sudo systemctl enable gitlab-runner
