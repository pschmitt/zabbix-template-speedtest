#!/usr/bin/env bash

CACHE_FILE=/tmp/speedtest.log
LOCK_FILE=/tmp/speedtest.lock

usage() {
    echo "$(basename $0) [-c|--cached]"
}

exec {lock_fd}>"$LOCK_FILE" || exit 1
flock -w 60 "$lock_fd" || { echo "ERROR: flock() failed." >&2; exit 1; }

case "$1" in
    -c|--cached)
        cat "$CACHE_FILE"
        ;;
    -u|--upload)
        awk '/Upload/ { print $2 }' "$CACHE_FILE"
        ;;
    -d|--download)
        awk '/Download/ { print $2 }' "$CACHE_FILE"
        ;;
    -p|--ping)
        awk '/Ping/ { print $2 }' "$CACHE_FILE"
        ;;
    *)
        if speedtest --help | grep -q -- --secure >/dev/null 2>&1
        then
            speedtest --secure --simple > "$CACHE_FILE"
        else
            speedtest --simple > "$CACHE_FILE"
        fi
        ;;
esac

flock -u "$lock_fd"
