<#   
.NOTES     
    Author: Sergio Fonseca
    Twitter @FonsecaSergio
    Email: sergio.fonseca@microsoft.com
    Last Updated: 2022-01-21

.SYNOPSIS   
    TEST SYNAPSE ENDPOINTS AND PORTS NEEDED
    
    This script does not really try to connect to endpoint, just check the ports. For full test you can use
        https://docs.microsoft.com/en-us/azure/synapse-analytics/troubleshoot/troubleshoot-synapse-studio-powershell

    For SQL connectivity test use
        https://github.com/Azure/SQL-Connectivity-Checker/blob/master/AzureSQLConnectivityChecker.ps1

.PARAMETER WorkspaceName

.DESCRIPTION
    - Check all Windows HOST File entries
    - Check DNS configuration
    - Check name resolution for all possible endpoints used by Synapse and compare it with public DNS
    - Check if ports needed are open (1433 / 1443 / 443)

#UPDATES
    - 2021-11-04 - Name resolution now also looks to host files to check if HOST file entry match Public DNS entry
    - 2022-01-21 - Shows note when open dns / cx dns name resultion fail
                 - Fix for when name resultion fails "No such host is known". Sample workspaces conected to former SQL DW does not resolve SERVERNAME.sql.azuresynapse.net

#> 

using namespace System.Net

param (
    [string]$WorkspaceName = "xpto"
)

Clear-Host

####################################################
#OTHER PARAMETERS
$DNSPublic = "8.8.8.8" #GoogleDNS
$TestPortConnectionTimeoutMs = 1000

####################################################
#ENDPOINTS
$SynapseSQLEndpoint = @{ NAME = "$($WorkspaceName).sql.azuresynapse.net"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

$SynapseServelessEndpoint = @{ NAME = "$($WorkspaceName)-ondemand.sql.azuresynapse.net"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

$SynapseDevEndpoint = @{ NAME = "$($WorkspaceName).dev.azuresynapse.net"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

$SQLDatabaseEndpoint = @{ NAME = "$($WorkspaceName).database.windows.net"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

$SynapseStudioEndpoint = @{ NAME = "web.azuresynapse.net"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

$AzureManagementEndpoint = @{ NAME = "management.azure.com"
ENDPOINT_CX = $null
ENDPOINT_PUBLICDNS = $null
};

####################################################

function Resolve-DnsName_Internal {
    param(
        [Parameter(Position = 0)] $Name,
        [string] $Server
    );
    process {
        try {
            if ($Server -ne $null -and $Server -ne "") {
                Write-Host " -Trying to resolve DNS for $($Name) with DNS Server $($Server)" -ForegroundColor DarkGray
                $DNSResults = (Resolve-DnsName -Name $Name -DnsOnly -Type A -QuickTimeout -Server $Server  -ErrorAction Stop) | Where-Object {$_.QueryType -eq 'A'}
            }
            else {
                Write-Host " -Trying to resolve DNS for $($Name) from Customer DNS" -ForegroundColor DarkGray
                $DNSResults = (Resolve-DnsName -Name $Name -DnsOnly -Type A -QuickTimeout -ErrorAction Stop) | Where-Object {$_.QueryType -eq 'A'}
            }

            return $DNSResults

            #return @{ IPAddress = [System.Net.DNS]::GetHostAddresses($Name).IPAddressToString };
        }
        catch {
            Write-Host " -Error at Resolve-DnsName_Internal: $($_.Exception.Message)" -ForegroundColor REd
        }
    }
}


#----------------------------------------------------------------------------------------------------------------------
#https://copdips.com/2019/09/fast-tcp-port-check-in-powershell.html
function Test-Port {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, HelpMessage = 'Could be suffixed by :Port')]
        [String[]]$ComputerName,

        [Parameter(HelpMessage = 'Will be ignored if the port is given in the param ComputerName')]
        [Int]$Port = 1433,

        [Parameter(HelpMessage = 'Timeout in millisecond. Increase the value if you want to test Internet resources.')]
        [Int]$Timeout = 1000
    )

    begin {
        $result = [System.Collections.ArrayList]::new()
    }

    process {
        foreach ($originalComputerName in $ComputerName) {
            $remoteInfo = $originalComputerName.Split(":")
            if ($remoteInfo.count -eq 1) {
                # In case $ComputerName in the form of 'host'
                $remoteHostname = $originalComputerName
                $remotePort = $Port
            } elseif ($remoteInfo.count -eq 2) {
                # In case $ComputerName in the form of 'host:port',
                # we often get host and port to check in this form.
                $remoteHostname = $remoteInfo[0]
                $remotePort = $remoteInfo[1]
            } else {
                $msg = "Got unknown format for the parameter ComputerName: " `
                    + "[$originalComputerName]. " `
                    + "The allowed formats is [hostname] or [hostname:port]."
                Write-Error $msg
                return
            }

            $tcpClient = New-Object System.Net.Sockets.TcpClient
            try {
                $portOpened = $tcpClient.ConnectAsync($remoteHostname, $remotePort).Wait($Timeout)    
            }
            catch {
                if ($_.Exception.InnerException.InnerException -ne $null)
                {
                    if ($_.Exception.InnerException.InnerException.ErrorCode -eq 11001) { #11001 No such host is known                        
                        Write-Host " -Error at Test-Port: ($($remoteHostname):$($remotePort)) - $($_.Exception.InnerException.InnerException.Message)" -ForegroundColor REd
                    }
                }
                else {
                    Write-Host " -Error at Test-Port: $($_.Exception.Message)" -ForegroundColor REd
                }                
            }           

            $null = $result.Add([PSCustomObject]@{
                RemoteHostname       = $remoteHostname
                RemotePort           = $remotePort
                PortOpened           = $portOpened
                TimeoutInMillisecond = $Timeout
                SourceHostname       = $env:COMPUTERNAME
                OriginalComputerName = $originalComputerName
                })
        }
    }

    end {
        return $result
    }
}

#----------------------------------------------------------------------------------------------------------------------
function Get-HostsFilesEntries {   
    $Pattern = '^(?<IP>\d{1,3}(\.\d{1,3}){3})\s+(?<Host>.+)$'
    $File    = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"

    $result = [System.Collections.ArrayList]::new()

    (Get-Content -Path $File)  | ForEach-Object {
        If ($_ -match $Pattern) {
            $Entries += "$($Matches.IP),$($Matches.Host)"

            $null = $result.Add([PSCustomObject]@{
                IP   = $Matches.IP
                HOST = $Matches.Host
                })
        }
    }

    return @( $result )
}

#----------------------------------------------------------------------------------------------------------------------
function Get-DnsCxServerAddresses {   
    $AddressFamilyIPV4 = 2 #AddressFamily -eq 2 = "IPv4"

    $DNSServers = Get-DnsClientServerAddress | `
        Where-Object {$_.AddressFamily -eq $AddressFamilyIPV4 } | ` 
        Select-Object –ExpandProperty ServerAddresses -Unique

    return $DNSServers
}
#----------------------------------------------------------------------------------------------------------------------

# RESERVED FOR FUTURE USE
<#
#http://www.padisetty.com/2014/05/powershell-bit-manipulation-and-network.html
#checkSubnet "20.36.105.32/29" "20.36.104.6" #FALSE
#checkSubnet "20.36.105.0/24" "20.36.105.10" #TRUE

function checkSubnet ([string]$cidr, [string]$ip) {
    $network, [int]$subnetlen = $cidr.Split('/')
    $a = [uint32[]]$network.split('.')
    [uint32] $unetwork = ($a[0] -shl 24) + ($a[1] -shl 16) + ($a[2] -shl 8) + $a[3]

    $mask = (-bnot [uint32]0) -shl (32 - $subnetlen)

    $a = [uint32[]]$ip.split('.')
    [uint32] $uip = ($a[0] -shl 24) + ($a[1] -shl 16) + ($a[2] -shl 8) + $a[3]

    $unetwork -eq ($mask -band $uip)
}
#>
#----------------------------------------------------------------------------------------------------------------------


####################################################
# COLLECTING DATA

Write-Host "------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "COLLECTING DATA" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------------------" -ForegroundColor Yellow

####################################################
# GET HOSTS FILE ENTRIES
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  GET HOSTS FILE ENTRIES"
$HostsFileEntries = @(Get-HostsFilesEntries)



####################################################
# GET DNS SERVERS
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  GET DNS SERVERS"
$DnsCxServerAddresses = @(Get-DnsCxServerAddresses)

Get-DnsClientServerAddress | ? serveraddresses


####################################################
# Resolve using current DNS
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  TEST NAME RESOLUTION - CX DNS"
$SynapseSQLEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $SynapseSQLEndpoint.NAME
$SynapseServelessEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $SynapseServelessEndpoint.NAME
$SynapseDevEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $SynapseDevEndpoint.NAME
$SQLDatabaseEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $SQLDatabaseEndpoint.NAME
$SynapseStudioEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $SynapseStudioEndpoint.NAME
$AzureManagementEndpoint.ENDPOINT_CX = Resolve-DnsName_Internal $AzureManagementEndpoint.NAME

Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  TEST NAME RESOLUTION - PUBLIC DNS TEST - NOT A PROBLEM IF FAIL"
$SynapseSQLEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $SynapseSQLEndpoint.NAME -Server $DNSPublic
$SynapseServelessEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $SynapseServelessEndpoint.NAME -Server $DNSPublic
$SynapseDevEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $SynapseDevEndpoint.NAME -Server $DNSPublic
$SQLDatabaseEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $SQLDatabaseEndpoint.NAME -Server $DNSPublic
$SynapseStudioEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $SynapseStudioEndpoint.NAME -Server $DNSPublic
$AzureManagementEndpoint.ENDPOINT_PUBLICDNS = Resolve-DnsName_Internal $AzureManagementEndpoint.NAME -Server $DNSPublic


####################################################
# Test Ports
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  TEST PORTS NEEDED"
#1433
$Results1433 = $SynapseSQLEndpoint.NAME, $SynapseServelessEndpoint.NAME, $SQLDatabaseEndpoint.NAME | Test-Port -Port 1433 -Timeout $TestPortConnectionTimeoutMs
#1443
$Results1443 = $SynapseSQLEndpoint.NAME, $SynapseServelessEndpoint.NAME | Test-Port -Port 1443 -Timeout $TestPortConnectionTimeoutMs
#443
$Results443 = $SynapseSQLEndpoint.NAME, $SynapseServelessEndpoint.NAME, $SynapseDevEndpoint.NAME, $SynapseStudioEndpoint.NAME, $AzureManagementEndpoint.NAME | Test-Port -Port 443 -Timeout $TestPortConnectionTimeoutMs

Write-Host "  ----------------------------------------------------------------------------"



####################################################
# RESULTS
####################################################



Write-Host "------------------------------------------------------------------------------" -ForegroundColor Yellow
Write-Host "RESULTS " -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------------------" -ForegroundColor Yellow

$File    = "$env:SystemDrive\Windows\System32\Drivers\etc\hosts"

Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  HOSTS FILE [$($File)]"

if ($HostsFileEntries.Count -gt 0) {
    foreach ($HostsFileEntry in $HostsFileEntries)
    {
        if (
            $HostsFileEntry.HOST.Contains($WorkspaceName) -or `
            $HostsFileEntry.HOST.Contains($SynapseStudioEndpoint.NAME) -or `
            $HostsFileEntry.HOST.Contains($AzureManagementEndpoint.NAME)`
        ) {
            Write-Host "   > IP [$($HostsFileEntry.IP)] / NAME [$($HostsFileEntry.HOST)]" -ForegroundColor Red    
        }
        else {
            Write-Host "   > IP [$($HostsFileEntry.IP)] / NAME [$($HostsFileEntry.HOST)]"
        }    
    }     
}
else {
    Write-Host "   > NO RELATED ENTRY" -ForegroundColor Green
}




#####################################################################################
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  DNS SERVERS"
foreach ($DnsCxServerAddress in $DnsCxServerAddresses)
{
    #https://docs.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16
    if ($DnsCxServerAddress -eq "168.63.129.16") {
        Write-Host "   > DNS [$($DnsCxServerAddress)] AZURE DNS" -ForegroundColor Cyan
    }
    else {
        Write-Host "   > DNS [$($DnsCxServerAddress)] CUSTOM" -ForegroundColor Cyan
    } 
       
}



#####################################################################################
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  NAME RESOLUTION "

<#
.SYNOPSIS
Just internal function to simplify tests and notes
#>
function Test-Endpoint {
    param(
        [Parameter(Position = 0)] $Endpoint
    );
    process {        
        Write-Host "   ----------------------------------------------------------------------------"
        Write-Host "   > DNS for ($($Endpoint.NAME))"
        Write-Host "      > CX DNS:($($Endpoint.ENDPOINT_CX.IPAddress)) / NAME:($($Endpoint.ENDPOINT_CX.Name))"

        $_HaveHostsFileEntry = $false

        # CHECK ENTRY ON HOSTS

        if ($HostsFileEntries.Count -gt 0) {
            foreach ($HostsFileEntry in $HostsFileEntries)
            {
                if ($HostsFileEntry.HOST -eq $Endpoint.NAME) {
                    $_HaveHostsFileEntry = $true
                    Write-Host "      > CX HOST FILE:($($HostsFileEntry.IP)) / NAME:($($HostsFileEntry.HOST))" -ForegroundColor Red
                    break
                }    
            }     
        }
        Write-Host "      > Public DNS:($($Endpoint.ENDPOINT_PUBLICDNS.IPAddress)) / NAME:($($Endpoint.ENDPOINT_PUBLICDNS.Name))"

        

        if ($Endpoint.ENDPOINT_PUBLICDNS.IPAddress -eq $null) 
        { Write-Host "      > PUBLIC NAME RESOLUTION DIDN'T WORK - DOES NOT MEAN A PROBLEM - Just could not reach Public DNS ($($DNSPublic)) to compare" -ForegroundColor Yellow }

        if ($_HaveHostsFileEntry)
        {# HAVE HOST FILE ENTRY
            
            if ($HostsFileEntry.IP -eq $Endpoint.ENDPOINT_PUBLICDNS.IPAddress) 
            { Write-Host "      > VM HOST FILE ENTRY AND PUBLIC DNS ARE SAME" -ForegroundColor Green }
            else { Write-Host "      > VM HOST FILE ENTRY AND PUBLIC DNS ARE NOT SAME" -ForegroundColor Yellow }

            Write-Host "      > CHECK HOSTS FILE ENTRY TO CHECK IF USING PRIVATE LINK or PUBLIC ENDPOINT" -ForegroundColor Yellow
        }
        else
        {# DOES NOT HAVE HOST FILE ENTRY
            if ($Endpoint.ENDPOINT_CX.IPAddress -eq $null) 
            { Write-Host "      > CX NAME RESOLUTION DIDN'T WORK" -ForegroundColor Red }
            else {
                if ($Endpoint.ENDPOINT_CX.IPAddress -eq $Endpoint.ENDPOINT_PUBLICDNS.IPAddress) 
                { Write-Host "      > CX DNS SERVER AND PUBLIC DNS ARE SAME" -ForegroundColor Green }
                else { Write-Host "      > CX DNS SERVER AND PUBLIC DNS ARE NOT SAME" -ForegroundColor Yellow }
    
                if ($Endpoint.ENDPOINT_CX.Name -like "*.cloudapp.*" -or $Endpoint.ENDPOINT_CX.Name -like "*.control.*") 
                { Write-Host "      > CX USING PUBLIC ENDPOINT" -ForegroundColor Cyan }
                elseif ($Endpoint.ENDPOINT_CX.Name -like "*.privatelink.*") 
                { Write-Host "      > CX USING PRIVATE ENDPOINT" -ForegroundColor Yellow }                   
            } 
        }
    }
}

Test-Endpoint $SynapseSQLEndpoint
Test-Endpoint $SynapseServelessEndpoint
Test-Endpoint $SynapseDevEndpoint
Test-Endpoint $SQLDatabaseEndpoint
Test-Endpoint $SynapseStudioEndpoint
Test-Endpoint $AzureManagementEndpoint




#####################################################################################
Write-Host "  ----------------------------------------------------------------------------"
Write-Host "  PORTS OPEN"

<#
.SYNOPSIS
Just internal function to simplify tests and notes
#>
function Test-Ports {
    param(
        [Parameter(Position = 0)] $PortResults
    );
    process {
        foreach ($result in $PortResults)
        {
            if($result.PortOpened -eq $true)
            {Write-host "    > Port $($result.RemotePort) for $($result.RemoteHostname) is OPEN" -ForegroundColor Green }
            else
            {Write-host "    > Port $($result.RemotePort) for $($result.RemoteHostname) is CLOSED" -ForegroundColor Red } 
        }
    }
}

Write-Host "   > 1433 --------------------------------------------------------------------"
Test-Ports $Results1433
Write-Host "   > 1443 --------------------------------------------------------------------"
Test-Ports $Results1443
Write-Host "   > 443 ---------------------------------------------------------------------"
Test-Ports $Results443


Write-Host "------------------------------------------------------------------------------" -ForegroundColor Yellow
