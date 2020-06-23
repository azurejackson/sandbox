#!/bin/bash
# Christopher Jackson

# Read in script argument flags
while getopts ":g:n:c:p:" opt; do
  case $opt in
    g) RG="$OPTARG"
    ;;
    n) NAME="$OPTARG"
    ;;
    c) CONTAINER="$OPTARG"
    ;;
    p) PORT="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

# az vm run-command invoke -g $ResourceGroupName -n $virtualMachineName --command-id RunShellScript --scripts

# Setup local directory structure in preparation of volume mounts
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo mkdir -p /home/share/user1 && sudo mkdir -p /home/share/user2 && sudo mkdir -p /home/share/ubuntu" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo chown -R 999:999 /home/share" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo chmod -R 777 /home/share" --output=yaml

# Download docker image and start ubuntu-xrdp Container 
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker pull danielguerra/ubuntu-xrdp" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container run -d --name $CONTAINER -p $PORT:3389 -v /home/share:/home -v /home/share/data:/home/data/ danielguerra/ubuntu-xrdp" --output=yaml

# Add Users to the container
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container exec -d $CONTAINER useradd -p \$(openssl passwd -1 'user1') user1" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container exec -d $CONTAINER useradd -p \$(openssl passwd -1 'user2') user2" --output=yaml

# Print out the Docker output of the current container
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container ps -f \"name=$CONTAINER\"" --output=yaml
