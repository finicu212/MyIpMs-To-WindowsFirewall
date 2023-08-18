#!/bin/bash

# Check if required arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <path_to_csv> <port>"
    exit 1
fi

CSV_PATH="$1"
PORT="$2"

# Extract CIDRs from the CSV file
CIDRS=$(awk -F, '/CIDR/ {cidr_idx = NR} cidr_idx {print $cidr_idx}' "$CSV_PATH" | tail -n +2)

# Add iptables rules for each CIDR
while IFS= read -r cidr; do
    # Check if the rule already exists before adding
    iptables -C INPUT -p tcp --dport "$PORT" -s "$cidr" -j ACCEPT 2>/dev/null
    if [[ $? -ne 0 ]]; then
        iptables -A INPUT -p tcp --dport "$PORT" -s "$cidr" -j ACCEPT
        echo "Added rule for TCP port $PORT and CIDR $cidr"
    else
        echo "Rule for TCP port $PORT and CIDR $cidr already exists!"
    fi
    
    iptables -C INPUT -p udp --dport "$PORT" -s "$cidr" -j ACCEPT 2>/dev/null
    if [[ $? -ne 0 ]]; then
        iptables -A INPUT -p udp --dport "$PORT" -s "$cidr" -j ACCEPT
        echo "Added rule for UDP port $PORT and CIDR $cidr"
    else
        echo "Rule for UDP port $PORT and CIDR $cidr already exists!"
    fi
done <<< "$CIDRS"
