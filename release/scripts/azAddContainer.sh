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

# Add new container instances
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container run -d --name $CONTAINER -p $PORT:3389 -v /home/share:/home -v /home/share/data:/home/data/ danielguerra/ubuntu-xrdp" --output=yaml

# Add Users to the container
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container exec -d $CONTAINER useradd -p \$(openssl passwd -1 'user1') user1" --output=yaml
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container exec -d $CONTAINER useradd -p \$(openssl passwd -1 'user2') user2" --output=yaml

# Print out the Docker output of the current container
az vm run-command invoke -g $RG -n $NAME --command-id RunShellScript --scripts "sudo docker container ps -f \"name=$CONTAINER\"" --output=yaml
