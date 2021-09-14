#!/usr/bin/env bash
dirName=$1

cd "$dirName" || exit

combined=$(mktemp)
find . -type f -name 'failed_login_data.txt' -exec cat {} \; > "$combined"

counts=$(mktemp)
awk 'match($0, /.{1,} ([a-zA-z0-9]{1,}) [0-9.]+/, groups) {print groups[1] "\n" }' "$combined" | uniq -c > "$counts"

body=$(mktemp)
awk 'match($0, /([0-9]+) ([a-zA-Z0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] ");" "\n" }' "$counts" > "$body"

cd ..
bin/wrap_contents.sh "$body" "username_dist" "username_dist.html"

#dirs=("$(find . -type d)")
#for dir in "${dirs[@]}"; do
#  awk 'match($0, /.{1,} ([a-zA-z0-9]{1,}) [0-9.]+/, groups) {print groups[1] "\n" }' "$dir/failed_login_data.txt" | uniq -c
#done




