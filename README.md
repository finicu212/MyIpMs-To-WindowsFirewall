# Windows Firewall Tool for myip.ms

A comprehensive tool that fetches IP range tables from `myip.ms`, converts them to CIDR notation in CSV format, and provides automation scripts for creating inbound rules on both Windows and Linux firewalls.

## Features

- Convert `myip.ms` IP ranges to a CIDR-formatted CSV.
- Automate inbound rule creation for a specific port for both TCP and UDP (Open a PR if you want to customize the protocols) on Windows using PowerShell - or on Linux using Bash.

## Usage

### Convert IP Range to CIDR CSV

First, copy paste use the desired IP ranges from myip.ms, as shown in the image, and save them as a `.txt` file:

![saving ip ranges](https://github.com/finicu212/MyIpMs-To-WindowsFirewall/assets/44416281/e6492a7a-a6c0-4820-ad79-d32ca3125c97)

Then, use the provided Python script to convert the copy-pasted table from `myip.ms` to a CSV:

```bash
python myipms-to-csv.py input.txt
```
This will create an output.csv file with the CIDRs:

```mathematica
Start IP,End IP,CIDR,Number of IPs
5.2.178.0,5.2.179.255,5.2.178.0/23,512
82.137.40.0,82.137.41.255,82.137.40.0/23,512
```

## Windows

On a Windows system, use the provided PowerShell script to apply inbound rules:

```powershell
.\firewall_script.ps1 -csvPath "path_to_csv_file.csv" -port 25565
```
Replace path_to_csv_file.csv with the path to your CSV file, and adjust the port as needed.
Linux

## Linux

On a Linux system, use the provided Bash script to apply iptables rules. Remember to chmod to make it executable:

```bash
chmod +x firewall_script.sh
sudo ./firewall_script.sh path_to_csv_file.csv 25565
```
