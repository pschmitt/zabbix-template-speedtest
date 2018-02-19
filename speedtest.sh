#!/usr/bin/env bash

set -e

CACHE_FILE=/tmp/speedtest.log
LOCK_FILE=/tmp/speedtest.lock

run_speedtest() {
    cd "$(readlink -f "$(dirname "$0")")" || exit 9

    # Lock
    if [[ -e "$LOCK_FILE" ]]
    then
        echo "A speedtest is already running" >&2
        exit 2
    fi
    touch "$LOCK_FILE"
    trap "rm -rf $LOCK_FILE" EXIT HUP INT QUIT PIPE TERM

    local output date location_id location ping download upload
    local download_mb upload_mb

    output=$(./speedtest -r)

    # Debug
    # output='2017-09-22 09:15:02 +0000|4997|"inexio (Saarlouis, Germany)"|30.30|82121|19392'
    # sleep 10

    echo "Output: $output"

    # Extract fields
    date=$(echo "$output" | cut -f1 -d '|')
    location_id=$(echo "$output" | cut -f2 -d '|')
    location=$(echo "$output" | cut -f3 -d '|' | sed 's/^"\(.*\)"$/\1/g')
    ping=$(echo "$output" | cut -f4 -d '|')
    download=$(echo "$output" | cut -f5 -d '|')
    upload=$(echo "$output" | cut -f6 -d '|')

    # Convert to MBit/s
    download_mb=$(echo "$download" | awk '{ printf("%.2f\n", $1 / 1024) }')
    upload_mb=$(echo "$upload" | awk '{ printf("%.2f\n", $1 / 1024) }')

    {
        echo "Date: $date"
        echo "Server: $location [${location_id}]"
        echo "Ping: $ping ms"
        echo "Download: $download bit/s"
        echo "Upload: $upload bit/s"
        echo "Download (MB): $download_mb Mbit/s"
        echo "Upload (MB): $upload_mb Mbit/s"
    } > "$CACHE_FILE"

    # Make sure to remove the lock file (may be redundant)
    rm -rf "$LOCK_FILE"
}

case "$1" in
    -c|--cached)
        cat "$CACHE_FILE"
        ;;
    -u|--upload)
        awk '/Upload \(MB\)/ { print $3 }' "$CACHE_FILE"
        ;;
    -d|--download)
        awk '/Download \(MB\)/ { print $3 }' "$CACHE_FILE"
        ;;
    -p|--ping)
        awk '/Ping/ { print $2 }' "$CACHE_FILE"
        ;;
    -f|--force)
        rm -rf "$LOCK_FILE"
        run_speedtest
        ;;
    *)
        run_speedtest
        ;;
esac
