param (
    [Parameter(Mandatory=$true)]
    [string]$csvPath,

    [Parameter(Mandatory=$true)]
    [int]$port
)

# Ensure the NetSecurity module is imported
Import-Module NetSecurity

# Read the CSV and extract CIDRs
$csvData = Import-Csv -Path $csvPath
$cidrs = $csvData | ForEach-Object { $_."CIDR" }

# Function to create or update the firewall rule
function SetFirewallRule {
    param (
        [string]$protocol,
        [Array]$cidrList,
        [int]$port
    )

    $ruleName = "Allow $protocol Port $port for Specified CIDRs"

    # Check if the rule exists
    $exists = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

    if (-not $exists) {
        # If not, create a new rule
        New-NetFirewallRule -DisplayName $ruleName `
                            -Direction Inbound `
                            -LocalPort $port `
                            -Protocol $protocol `
                            -Action Allow `
                            -RemoteAddress $cidrList `
                            -Enabled True
        Write-Host "Created rule: $ruleName"
    } else {
        # If exists, just update the remote address list
        Set-NetFirewallRule -DisplayName $ruleName -RemoteAddress $cidrList
        Write-Host "Updated rule: $ruleName"
    }
}

# Create/Update the rule for both TCP and UDP
SetFirewallRule -protocol TCP -cidrList $cidrs -port $port
SetFirewallRule -protocol UDP -cidrList $cidrs -port $port
