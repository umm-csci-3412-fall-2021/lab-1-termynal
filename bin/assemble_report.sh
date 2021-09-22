#!/usr/bin/env bash

DIR=$1

cd "$DIR" || exit

combined=$(mktemp)
cat ./*_dist.html > "$combined"

cd - || exit

./bin/wrap_contents.sh  "$combined" ./html_components/summary_plots "$DIR"/failed_login_summary.html

