#!/bin/sh

updates_log=/var/log/update_script.log

printf "\nPackages Update %s" "$(date)" >> $updates_log
sudo apt update -y	| sudo tee -a "$(updates_log)"
sudo apt upgrade -y	| sudo tee -a "$(updates_log)"