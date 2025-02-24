#!/bin/bash

# Ensure a hosts file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 hosts.txt"
    exit 1
fi

HOSTS_FILE="$1"

# Check if the file exists
if [ ! -f "$HOSTS_FILE" ]; then
    echo "Error: File '$HOSTS_FILE' not found!"
    exit 1
fi

# Read each IP from the hosts file
while IFS= read -r IP; do
    echo "Processing IP: $IP"
    
    # Create a directory for each IP
    mkdir -p "$IP"

    # Full TCP scan to find open ports
    nmap -sT -p- -Pn "$IP" -oA "$IP/all_tcp" -vv

    # Extract open ports and convert newlines to commas
    cat "$IP/all_tcp.nmap" | grep "open" | awk '{print $1}' | cut -d "/" -f1 | tr '\n' ',' > "$IP/open_tcp.list"
    
    # Run detailed scans on open ports
    if [ -s "$IP/open_tcp.list" ]; then
        OPEN_PORTS=$(cat "$IP/open_tcp.list")
        
        # Service detection scan
        sudo nmap -sS -sV -Pn -p"$OPEN_PORTS" "$IP" -oA "$IP/open_tcp_services" -vv
        
        # Vulnerability scan
        sudo nmap -sS -sV -Pn -sC -p"$OPEN_PORTS" "$IP" -oA "$IP/open_tcp_vuln" -vv
        
        # Extract HTTP-related services
        cat "$IP/open_tcp_services.nmap" | grep -i "http" | cut -d "/" -f1 > "$IP/http_services.txt"

        # Extract SSL-related services (HTTPS, SSL/TLS)
        cat "$IP/open_tcp_services.nmap" | grep -Ei "ssl|https|tls" | cut -d "/" -f1 > "$IP/ssl_services.txt"

    else
        echo "No open ports found for $IP."
    fi

    echo "Finished processing $IP"
    echo "-----------------------------"

done < "$HOSTS_FILE"

echo "All scans completed!"
