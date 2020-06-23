#!/bin/bash
# Christopher Jackson

# Read in script argument flags
while getopts ":g:n:" opt; do
  case $opt in
    g) RG="$OPTARG"
    ;;
    n) NAME="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# Install Docker Engine
# az vm run-command invoke -g $ResourceGroupName -n $virtualMachineName --command-id RunShellScript --scripts

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo apt update" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo apt-key fingerprint 0EBFCD88" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo apt update" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo apt install -y docker-ce docker-ce-cli containerd.io" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo groupadd docker" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo usermod -aG docker hubbleadmin" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo systemctl enable docker" --output=yaml

az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "docker -v" --output=yaml