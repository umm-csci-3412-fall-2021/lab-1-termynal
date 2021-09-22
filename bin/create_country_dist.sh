#!/usr/bin/env bash
dirName=$1

cd "$dirName" || exit

# Combine all failed_login_data.txt files from each folder into one file.
combined=$(mktemp)
find . -type f -name 'failed_login_data.txt' -exec cat {} + > "$combined"

# Fetch all IP addresses and save them in a temp file
IPList=$(mktemp)
awk 'match($0, /[a-zA-Z]{3} [0-9 ]+ .+ ([0-9.]+)/, groups) {print groups[1]}' "$combined" | sort > "$IPList"

cd - || exit

# Join the earlier file with country_IP_map.txt to create a mapping for IP -> Country
mapped=$(mktemp)
join "$IPList" ./etc/country_IP_map.txt |  awk 'match($0, /.{1,} (.+)/, groups) {print groups[1]}' | sort > "$mapped"

# Count the occurrence of each country
counts=$(mktemp)
uniq -c "$mapped" | awk '{print "data.addRow([\x27"$2"\x27, " $1"]);"}'  > "$counts"

./bin/wrap_contents.sh "$counts"  html_components/country_dist "$dirName"/country_dist.html

rm "$combined"
rm "$IPList"
rm "$mapped"
rm "$counts"