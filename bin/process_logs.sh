TEMPFOLDER=$(mktemp -d "temp.XXXXXXXXXXXXXXX")

for var in "$@"
do
	CLIENTNAME=$(echo "$var" |sed 's/([a-zA-z]{1,})_secure.tgz/\1/')
	mkdir "$TEMPFOLDER/$CLIENTNAME"
	tar -xzf "../log_files/$var" -C "../bin/$TEMPFOLDER/$CLIENTNAME"
	./process_client_logs.sh
done

./create_username_dist.sh
./create_hours_dist.sh
./create_country_dist.sh
./assemble_report.sh


cd "$TEMPFOLDER"
mv failed_login_summary.html ../.
