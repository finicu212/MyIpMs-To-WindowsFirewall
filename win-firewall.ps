param (
    [Parameter(Mandatory=$true)]
    [string]$csvPath,

    [Parameter(Mandatory=$true)]
    [int]$port
)

# Ensure the NetSecurity module is imported
Import-Module NetSecurity

# Function to create the firewall rule
function CreateFirewallRule {
    param (
        [string]$protocol,
        [string]$cidr,
        [int]$port
    )
    
    $ruleName = "Allow $protocol $cidr Port $port"
    $exists = Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue

    if (-not $exists) {
        New-NetFirewallRule -DisplayName $ruleName `
                            -Direction Inbound `
                            -LocalPort $port `
                            -Protocol $protocol `
                            -Action Allow `
                            -RemoteAddress $cidr `
                            -Enabled True
        Write-Host "Created rule: $ruleName"
    }
    else {
        Write-Host "Rule $ruleName already exists!"
    }
}

# Read the CSV and extract CIDRs
$csvData = Import-Csv -Path $csvPath
$cidrs = $csvData | ForEach-Object { $_."CIDR" }

# For each CIDR, create a firewall rule for both TCP and UDP
foreach ($cidr in $cidrs) {
    CreateFirewallRule -protocol TCP -cidr $cidr -port $port
    CreateFirewallRule -protocol UDP -cidr $cidr -port $port
}
