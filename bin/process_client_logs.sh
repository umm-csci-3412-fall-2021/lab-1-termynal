#!/usr/bin/env bash

DIRECTORY=$1

cd "$DIRECTORY" || exit

cat var/log/* > combined.txt
awk 'match($0, /([a-zA-z]{3})  ?([0-9]{1,2}) ([0-9]{2})[0-9:]+ .+ Failed password .+ (.+) from ([0-9.]+)/, groups) {print groups[1] " " groups[2] " " groups[3] " " groups[4]  " " groups[5] "\n" }' combined.txt > failed_login_data.txt


