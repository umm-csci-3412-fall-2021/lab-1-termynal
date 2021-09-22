#!/usr/bin/env bash

TEMPFOLDER=$(mktemp -d "temp.XXXXXXXXXXXXXXX")

# Iterate through each file argument passed
for var in "$@"
do
  # Extract the file name without the extension
	CLIENTNAME=$(echo "$var" | awk 'match($0, /([a-zA-z]{1,}).tgz/, groups) {print groups[1]}')
	mkdir "$TEMPFOLDER/$CLIENTNAME"
	tar -xzf "$var" -C "$TEMPFOLDER/$CLIENTNAME"
	./bin/process_client_logs.sh "$TEMPFOLDER/$CLIENTNAME"
done

./bin/create_username_dist.sh "$TEMPFOLDER"
./bin/create_hours_dist.sh "$TEMPFOLDER"
./bin/create_country_dist.sh "$TEMPFOLDER"
./bin/assemble_report.sh "$TEMPFOLDER"


cd "$TEMPFOLDER" || exit
mv failed_login_summary.html ../.

rm -rf "$TEMPFOLDER"