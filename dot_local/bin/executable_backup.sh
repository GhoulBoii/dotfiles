#!/bin/sh
# DEPENDENCIES: fzf, gpg
shopt -s extglob
echo -n "Enter external full path to folder to backup to: " || exit 1
read external_dir
mkdir -p external_dir

echo "Select gpg key to backup: "
gpg_id=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | awk -F '/' '{print $2}' | fzf)
gpg --export-secret-keys $gpg_id > $external_dir/my-private-key.asc

sudo chown $(whoami):$(whoami) ~/.ssh/*
sudo chmod 600 ~/.ssh/id_+([[:alnum:]])
sudo chmod 644 ~/.ssh/id_*.pub
cp ~/.ssh/id_* $external_dir
