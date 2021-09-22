#!/usr/bin/env bash
dirName=$1

cd "$dirName" || exit

combined=$(mktemp)
find . -type f -name 'failed_login_data.txt' -exec cat {} + > "$combined"

counts=$(mktemp)
awk 'match($0, /.{1,} ([a-zA-z0-9\_\-]{1,}) [0-9.]+/, groups) {print groups[1]}' "$combined" | sort | uniq -c > "$counts"

# Generate the "body" of the output file, meaning the part that sits between the header and footer.
body=$(mktemp)
awk 'match($0, /([0-9]+) ([a-zA-Z0-9\_\-]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);" }' "$counts" > "$body"

cd - || exit
./bin/wrap_contents.sh "$body" html_components/username_dist "$dirName"/username_dist.html

rm -rf "$combined"
rm -rf "$counts"
rm -rf "$body"