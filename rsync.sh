#!/bin/bash

# backup firefox every hours
while true; do bash -c 'rsync --checksum --owner --group --links --perms --hard-links --archive --delete --progress /tmp/firefox/ /mnt/nvme/firefox/'; clear; sleep 20m; done &

# backup user folder every hours
while true; do bash -c 'rsync --checksum --owner --group --links --perms --hard-links --archive --delete --progress /home/user/ /mnt/md0/backup/user/'; clear; sleep 20m; done &