#!/usr/bin/env bash
FILENAME=$1
WRAPPERNAME=$2
TARGET=$3

cat "${WRAPPERNAME}_header.html" "$FILENAME" "${WRAPPERNAME}_footer.html" > "$TARGET"
