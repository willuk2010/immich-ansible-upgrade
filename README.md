# Immich upgrade - Ansible
The following repo, contains some ansible code, and a shell script that can upgrade an install of Immich on Proxmox LXC (https://github.com/loeeeee/immich-in-lxc.git) to the latest version,

The shell script, (update-release.sh) will change the .env and install.env REPO_TAG to the latest, this is based on a script i found in this issue https://github.com/loeeeee/immich-in-lxc/issues/70

# This currently does the following, 

- **Stops immich-web and immich-ml**
- **Takes a backup of the app folder**
- **Copies the update-release.sh script up to the immich server**
- **Executes the update-release.sh script to get the latest TAG**
- **Executes the install.sh script to upgrade**
- **Starts immich-web and immich-ml**

# ToDo,

- Check if an update is really needed, right now this will just change the tag, and upgrade even if its not needed
- Zip backup, and keep only the last one


# How to use,

```
ansible-playbook -i inventory playbook.yaml

``` 
