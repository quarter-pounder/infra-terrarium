#!/bin/bash
# Emits structured log lines to /var/log/terrarium-emitter.log for observability testing.
# Rate: a few lines per run; run interval controlled by systemd (e.g. every 30s).

LOG_FILE="/var/log/terrarium-emitter.log"
LEVELS=(info info warn error)
PATHS=("/api/health" "/api/users" "/api/orders" "/internal/status")
METHODS=("GET" "POST" "GET")

level=${LEVELS[$((RANDOM % ${#LEVELS[@]}))]}
path=${PATHS[$((RANDOM % ${#PATHS[@]}))]}
method=${METHODS[$((RANDOM % ${#METHODS[@]}))]}
status=$((RANDOM % 5 == 0 ? 500 : 200))
req_id=$(printf "%08x" $RANDOM)
ts=$(date -Iseconds)

echo "ts=$ts level=$level method=$method path=$path status=$status request_id=$req_id msg=\"request completed\"" >> "$LOG_FILE"
echo "ts=$ts level=info component=emitter msg=\"heartbeat\" hostname=$(hostname -s)" >> "$LOG_FILE"
