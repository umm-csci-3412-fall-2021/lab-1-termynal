#!/usr/bin/env bash
dirName=$1

cd "$dirName" || exit

# Combine all failed_login_data.txt files from each folder into one file.
combined=$(mktemp)
find . -type f -name 'failed_login_data.txt' -exec cat {} + > "$combined"

counts=$(mktemp)
awk 'match($0, /[a-zA-Z]{3} [0-9]{1,2} ([0-9]{1,2}) .+/, groups) {print groups[1]}' "$combined" | sort | uniq -c > "$counts"

# Generate the "body" of the output file, meaning the part that sits between the header and footer.
body=$(mktemp)
awk 'match($0, /([0-9]+) ([0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);" }' "$counts" > "$body"

cd - || exit
./bin/wrap_contents.sh "$body" html_components/hours_dist "$dirName"/hours_dist.html

rm -rf "$combined"
rm -rf "$counts"
rm -rf "$body"