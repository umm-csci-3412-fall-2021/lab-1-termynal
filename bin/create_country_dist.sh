#!/usr/bin/env bash
dirName=$1

cd "$dirName" || exit

combined=$(mktemp)
find . -type f -name 'failed_login_data.txt' -exec cat {} + > "$combined"

IPList=$(mktemp)
awk 'match($0, /.{1,} ([0-9\.]+)/, groups) {print groups[1]}' "$combined" | sort > "$IPList"

cd - || exit

mapped=$(mktemp)
join "$IPList" ./etc/country_IP_map.txt |  awk 'match($0, /.{1,} ([a-zA-Z]+)/, groups) {print groups[1]}' | sort > "$mapped"

counts=$(mktemp)
uniq -c "$mapped" | awk '{print "data.addRow([\x27"$2"\x27, " $1"]);"}'  > "$counts"

./bin/wrap_contents.sh "$counts"  html_components/country_dist "$dirName"/country_dist.html