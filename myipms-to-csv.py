import ipaddress
import csv
import sys

def ip_range_to_cidrs(start_ip, end_ip):
    """Convert IP range to CIDRs."""
    start_int = int(ipaddress.IPv4Address(start_ip))
    end_int = int(ipaddress.IPv4Address(end_ip))
    return [str(cidr) for cidr in ipaddress.summarize_address_range(ipaddress.IPv4Address(start_int), ipaddress.IPv4Address(end_int))]

def parse_input(data):
    """Parse the input data and return a list of IP ranges."""
    lines = data.strip().split("\n")
    ip_ranges = []
    for line in lines:
        # Split by multiple spaces
        tokens = line.split()
        start_ip = tokens[1]
        end_ip = tokens[3]

        ip_ranges.append((start_ip, end_ip))
    return ip_ranges

def main(filename):
    with open(filename, 'r') as f:
        data = f.read()

    ip_ranges = parse_input(data)
    output = []
    for start_ip, end_ip in ip_ranges:
        cidrs = ip_range_to_cidrs(start_ip, end_ip)
        total_ips = sum([ipaddress.ip_network(cidr).num_addresses for cidr in cidrs])
        for cidr in cidrs:
            output.append([str(ipaddress.ip_network(cidr).network_address), str(ipaddress.ip_network(cidr).broadcast_address), cidr, total_ips])

    with open("output.csv", "w", newline='') as f:
        writer = csv.writer(f)
        writer.writerow(["Start IP", "End IP", "CIDR", "Number of IPs"])
        writer.writerows(output)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python myipms-to-csv.py input.txt")
        sys.exit(1)
    main(sys.argv[1])
