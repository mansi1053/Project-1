#!/usr/bin/env bash
# health-router.sh — requires: dnsmasq, curl, sudo privileges to write dnsmasq 
conf and reload
set-euo pipefail
DNSMASQ_D="/etc/dnsmasq.d"
CONF_FILE="$DNSMASQ_D/multicloud.conf"
DOMAIN_NAME="service.multicloud"
AWS_IP="$1" 
GCP_IP="$2" 
INTERVAL="15" 

if [[ $#-lt 2 ]]; then 
    echo "Usage: $0 <AWS_IP> <GCP_IP> [domain] [interval]" >&2
    exit 1
fi

[[ ${3-} ]] && DOMAIN_NAME="$3"
[[ ${4-} ]] && INTERVAL="$4"

declare -A STATUS=( [aws]="down" [gcp]="down" )

check() {
    local name="$1" ip="$2"
    if curl-fsS--max-time 2 "http://$ip/health" | grep-q "ok-"; then
        echo "$name healthy ($ip)" >&2
        echo healthy
     else
        echo "$name DOWN ($ip)" >&2
        echo down
    fi
}

update_dns() {
    local target_ip="$1"
    sudo mkdir -p "$DNSMASQ_D"
    echo "address=/$DOMAIN_NAME/$target_ip" | sudo tee "$CONF_FILE" >/dev/null
    sudo systemctl restart dnsmasq || sudo service dnsmasq restart
    echo "Routed $DOMAIN_NAME -> $target_ip" >&2
}

current_ip=""
    while true; do
        a=$(check aws "$AWS_IP")
        g=$(check gcp "$GCP_IP")

        if [[ "$a" == "healthy" ]]; then
            next_ip="$AWS_IP"
         elif [[ "$g" == "healthy" ]]; then
            next_ip="$GCP_IP"
        else
            next_ip="" 
        fi
        
        if [[ "$next_ip" != "$current_ip" ]]; then
            if [[-n "$next_ip" ]]; then
                update_dns "$next_ip"
                current_ip="$next_ip"
            else
                echo "No healthy backends; leaving dnsmasq as-is" >&2
            fi
        fi
        sleep "$INTERVAL"
done