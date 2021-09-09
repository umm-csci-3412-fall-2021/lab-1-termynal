DIRECTORY=$1

cd "$DIRECTORY"

cat * > combined.txt
awk 'match($0, /([a-zA-z]{3} [0-9]{2}) ([0-9]{2})[0-9:]+ ([a-zA-z]+).+ Failed password .+ ([a-zA-z ]+) from ([0-9.]+)/, groups) {print "1. " groups[1] "\n" "2. " groups[2] "\n" }' combined.txt > failed_login_data.txt


