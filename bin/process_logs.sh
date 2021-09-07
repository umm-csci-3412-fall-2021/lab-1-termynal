TEMPFOLDER=$(mktemp -d "temp.XXXXXXXXXXXXXXX")

for var in "$@"
do
	tar -xzf "../log_files/$var" -C "../bin/$TEMPFOLDER"
	./process_client_logs.sh
done

./create_username_dist.sh
./create_hours_dist.sh
./create_country_dist.sh
./assemble_report.sh

# mv failed_login_summary.html ./something
