#!/usr/bin/env ash

set -e

DATA_FILE=/tmp/speedtest.json

usage() {
  echo "Usage: \"$(basename "$0")\" OPTION"
  echo
  echo "-u: Display last measured upload speed"
  echo "-d: Display last measured download speed"
  echo "-j: Display last measured jitter"
  echo "-p: Display last measured ping latency"
  echo "-t: Display last measurement timestamp"
  echo "-s: Display last server used for measurements"
  echo "--run: Run speedtest"
}

bytes_to_mbit() {
  echo "scale=2; $1 / 125000" | bc -l
}

case "$1" in
  -f|--data-file)
    DATA_FILE="$2"
    shift 2
    ;;
esac

case "$1" in
  -h|--help|help)
    usage
    exit 0
    ;;
  -d|--download)
    bytes_to_mbit "$(jq -r '.download.bandwidth' "$DATA_FILE")"
    ;;
  -u|--upload)
    bytes_to_mbit "$(jq -r '.upload.bandwidth' "$DATA_FILE")"
    ;;
  -j|--jitter)
    jq -r '.ping.jitter' "$DATA_FILE"
    ;;
  -p|--ping)
    jq -r '.ping.latency' "$DATA_FILE"
    ;;
  -s|--server)
    data="$(jq -r '.server' "$DATA_FILE")"
    id="$(echo "$data" | jq -r '.id')"
    name="$(echo "$data" | jq -r '.name')"
    location="$(echo "$data" | jq -r '.location')"
    country="$(echo "$data" | jq -r '.country')"
    echo "$id: $name @$location ($country)"
    ;;
  -t|--timestamp)
    jq -r '.timestamp | fromdate' "$DATA_FILE"
    ;;
  -r|--run)
    if speedtest --accept-license --accept-gdpr -f json > "${DATA_FILE}.new"
    then
      mv "${DATA_FILE}.new" "$DATA_FILE"
    fi
    ;;
  *)
    usage
    exit 2
esac
