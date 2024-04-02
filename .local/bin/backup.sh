#!/bin/sh
# DEPENDENCIES: fzf, gpg
echo -n "Enter external full path to folder to backup to: " || exit 1
read external_dir
mkdir -p external_dir

gpg_id=$(gpg --list-secret-keys --keyid-format LONG | grep sec | awk '{print $2}' | awk -F '/' '{print $2}' | fzf)
gpg --export-secret-keys $gpg_id > $external_dir/my-private-key.asc
cp ~/.ssh/id_* $external_dir
