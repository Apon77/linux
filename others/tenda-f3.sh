#!/usr/bin/env bash
# tenda_bandwidth_logger.sh — pure bash + curl version.
# Same login/data flow as the Python script (see README.md), reimplemented
# with curl for the requests and standard coreutils for the hashing.
#
# Requires: bash, curl, base64, md5sum, sed, awk (all standard on
# Linux / WSL / Git Bash). On macOS, replace `md5sum | awk '{print $1}'`
# with `md5 -q` (see the login() function below).
#
# Setup: none — just make it executable and run it.
#   chmod +x tenda_bandwidth_logger.sh
#   ./tenda_bandwidth_logger.sh
# Stop with Ctrl+C.

set -uo pipefail

# ---------------------------- CONFIG ----------------------------
ROUTER_IP="192.168.0.1"
BASE_URL="http://${ROUTER_IP}"
PASSWORD="admin"                       # <-- your router admin password

GETSTOK_URL="${BASE_URL}/goform/getstok"
LOGIN_URL="${BASE_URL}/login/Auth"
DATA_URL="${BASE_URL}/goform/getQos"
DATA_MODULES="localhost,onlineList,blackList"

INTERVAL_SECONDS=10
OUTPUT_FILE="$(cd "$(dirname "$0")" && pwd)/bandwidth_log.txt"
COOKIE_JAR="$(mktemp)"
VALIDATION_KEYWORD="onlineList"         # must appear in a healthy response

PROXY_SERVER=""                         # e.g. "socks5://localhost:1080"; empty disables it
DEBUG=1                                 # 1 = verbose, 0 = quiet
# ------------------------------------------------------------------

CURL_OPTS=(-s -c "$COOKIE_JAR" -b "$COOKIE_JAR"
           -H "Accept: */*" -H "Referer: ${BASE_URL}/index.html"
           -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
[ -n "$PROXY_SERVER" ] && CURL_OPTS+=(--proxy "$PROXY_SERVER")

log() { echo "[$(date +%H:%M:%S)] $*"; }
dbg() { [ "$DEBUG" = "1" ] && echo "[DEBUG] $*"; }

cleanup() { rm -f "$COOKIE_JAR"; }
trap 'cleanup; echo; log "Stopped."; exit 0' INT

login() {
    local resp token b64 hash

    resp=$(curl "${CURL_OPTS[@]}" "${GETSTOK_URL}?random=0.${RANDOM}${RANDOM}")
    token=$(echo "$resp" | sed -n 's/.*"random":"\([^"]*\)".*/\1/p')
    if [ -z "$token" ]; then
        log "[WARN] could not get token from getstok: $resp"
        return 1
    fi
    dbg "token=$token"

    # Same hashing the router's own JS does: MD5( Base64(UTF8(password)) + token )
    b64=$(printf '%s' "$PASSWORD" | base64 | tr -d '\n')
    # macOS: replace the next line with: hash=$(printf '%s' "${b64}${token}" | md5 -q)
    hash=$(printf '%s' "${b64}${token}" | md5sum | awk '{print $1}')
    dbg "hash=$hash"

    curl "${CURL_OPTS[@]}" -X POST -d "password=${hash}" "$LOGIN_URL" -o /dev/null
}

fetch_data() {
    curl "${CURL_OPTS[@]}" "${DATA_URL}?random=0.${RANDOM}${RANDOM}&modules=${DATA_MODULES}"
}

is_valid() {
    [ -n "$1" ] && printf '%s' "$1" | grep -q "$VALIDATION_KEYWORD"
}

print_and_save() {
    local text="$1" ts out
    ts="$(date '+%Y-%m-%d %H:%M:%S')"

    if command -v jq >/dev/null 2>&1 && echo "$text" | jq -e '.onlineList' >/dev/null 2>&1; then
        out=$(echo "$text" | jq -r --arg ts "$ts" \
            '.onlineList[] | [$ts, .qosListIP, .qosListMac, .qosListDownSpeed, .qosListUpSpeed] | @tsv')
    else
        out="${ts}	${text}"
    fi

    echo "$out" | tee -a "$OUTPUT_FILE"
}

log "Logging to ${OUTPUT_FILE} every ${INTERVAL_SECONDS}s. Ctrl+C to stop."
login

while true; do
    reading=$(fetch_data)
    if ! is_valid "$reading"; then
        log "invalid reading — relogging in"
        : > "$COOKIE_JAR"
        login
        reading=$(fetch_data)
    fi
    print_and_save "$reading"
    log "saved (${#reading} chars)"
    sleep "$INTERVAL_SECONDS"
done
