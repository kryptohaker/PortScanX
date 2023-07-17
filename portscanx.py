import argparse
import subprocess
import os
from concurrent.futures import ThreadPoolExecutor

def process_target(target, interface):
    # Extract hostname and IP address
    hostname, ip_address = target.strip().split(':')

    print(f"Processing target: {hostname} ({ip_address})")
    # Create folders
    os.makedirs(hostname, exist_ok=True)
    os.makedirs(os.path.join(hostname, 'nmap'), exist_ok=True)
    print(f"Created folders for target: {hostname}")

    # Perform masscan
    print(f"Performing masscan for {hostname} ({ip_address})")
    masscan_command = f"masscan -p1-65535,U:1-65535 {ip_address} --rate=1000 -e {interface} --output-format list --output-filename {os.path.join(hostname, 'ports.lst')}"
    subprocess.run(masscan_command, shell=True, check=True)
    print(f"Performed masscan for target: {hostname} ({ip_address})")
    print(f"Found open ports saved to: {os.path.join(hostname, 'ports.lst')}")

    # Get port list
    ports = subprocess.check_output(f"awk '{{print $3}}' {os.path.join(hostname, 'ports.lst')} | awk -F '/' '{{print $1}}' | sort -n | tr '\\n' ',' | sed 's/,$//'", shell=True, text=True)
    
    # Check if ports are found
    if ports:
        # Found Open Ports
        ports = ports.strip(',')
        print(f"Found Ports for {hostname}: {ports}")
        # Perform nmap scans
        tcp_scan_command = f"nmap -Pn -sV -sC -p{ports} {ip_address} -vv -oN {os.path.join(hostname, 'nmap', 'tcp.txt')}"
        subprocess.run(tcp_scan_command, shell=True, check=True)
        print(f"Performed TCP scan for target: {hostname}")

        udp_scan_command = f"sudo nmap -Pn -sU -sV -sC -p{ports} {ip_address} -vv -oN {os.path.join(hostname, 'nmap', 'udp.txt')}"
        subprocess.run(udp_scan_command, shell=True, check=True)
        print(f"Performed UDP scan for target: {hostname}")
    else:
        print(f"No ports found for target: {hostname}")
    
# Parse command-line arguments
parser = argparse.ArgumentParser()
parser.add_argument('-t', '--target-file', help='File containing targets in the format: hostname:ip_address', required=True)
parser.add_argument('-e', '--interface', help='Interface to use for masscan', required=True)
args = parser.parse_args()

# Read targets from file
with open(args.target_file) as file:
    targets = file.readlines()

# Process targets in parallel
with ThreadPoolExecutor() as executor:
    executor.map(process_target, targets, [args.interface] * len(targets))

