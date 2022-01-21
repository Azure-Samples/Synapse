## Summary

Script to test Synapse connectivity endpoints and Ports needed
    
    This script does not really try to connect to endpoint, just check the ports. For full test you can use
        https://docs.microsoft.com/en-us/azure/synapse-analytics/troubleshoot/troubleshoot-synapse-studio-powershell
    For SQL connectivity test use
        https://github.com/Azure/SQL-Connectivity-Checker/blob/master/AzureSQLConnectivityChecker.ps1

    - Check Windows HOST File entries
    - Check DNS configuration
    - Check name resolution for all possible endpoints used by Synapse and compare it with public DNS
    - Check if ports needed are open (1433 / 1443 / 443)

## Sample execution

```
.\"Synapse-TestConnection.ps1" WORKSPACENAME
```

OR just copy and paste code to Powershell ISE and change parameter before run

```
[string]$WorkspaceName = "xpto"
```

# Sample Results

```
------------------------------------------------------------------------------
COLLECTING DATA
------------------------------------------------------------------------------
  ----------------------------------------------------------------------------
  GET HOSTS FILE ENTRIES
  ----------------------------------------------------------------------------
  GET DNS SERVERS

InterfaceAlias               Interface Address ServerAddresses
                             Index     Family
--------------               --------- ------- ---------------
Ethernet                             9 IPv4    {8.8.8.8, 8.8.4.4}
Wi-Fi                                4 IPv4    {8.8.8.8, 8.8.4.4}
  ----------------------------------------------------------------------------
  TEST NAME RESOLUTION - CX DNS
 -Trying to resolve DNS for SYNAPSEWORKSPACE.sql.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SYNAPSEWORKSPACE.dev.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SYNAPSEWORKSPACE.database.windows.net from Customer DNS
 -Trying to resolve DNS for web.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for management.azure.com from Customer DNS
  ----------------------------------------------------------------------------
  TEST NAME RESOLUTION - PUBLIC DNS TEST - NOT A PROBLEM IF FAIL
 -Trying to resolve DNS for SYNAPSEWORKSPACE.sql.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SYNAPSEWORKSPACE.dev.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SYNAPSEWORKSPACE.database.windows.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for web.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for management.azure.com with DNS Server 8.8.8.8
  ----------------------------------------------------------------------------
  TEST PORTS NEEDED
  ----------------------------------------------------------------------------
------------------------------------------------------------------------------
RESULTS
------------------------------------------------------------------------------
  ----------------------------------------------------------------------------
  HOSTS FILE [C:\Windows\System32\Drivers\etc\hosts]
   > NO RELATED ENTRY
  ----------------------------------------------------------------------------
  DNS SERVERS
   > DNS [8.8.8.8] CUSTOM
   > DNS [8.8.4.4] CUSTOM
  ----------------------------------------------------------------------------
  NAME RESOLUTION
   ----------------------------------------------------------------------------
   > DNS for (SYNAPSEWORKSPACE.sql.azuresynapse.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SYNAPSEWORKSPACE.dev.azuresynapse.net)
      > CX DNS:(40.113.176.228) / NAME:(a365rpprodwesteurope-1-a365data.westeurope.cloudapp.azure.com)
      > Public DNS:(40.113.176.228) / NAME:(a365rpprodwesteurope-1-a365data.westeurope.cloudapp.azure.com)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SYNAPSEWORKSPACE.database.windows.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (web.azuresynapse.net)
      > CX DNS:(65.52.226.18) / NAME:(synapse-web-prod.northeurope.cloudapp.azure.com)
      > Public DNS:(65.52.226.18) / NAME:(synapse-web-prod.northeurope.cloudapp.azure.com)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (management.azure.com)
      > CX DNS:(51.138.208.143) / NAME:(arm-fdweb.francecentral.cloudapp.azure.com)
      > Public DNS:(51.138.208.143) / NAME:(arm-fdweb.francecentral.cloudapp.azure.com)
      > CX DNS SERVER AND PUBLIC DNS ARE SAME
      > CX USING PUBLIC ENDPOINT
  ----------------------------------------------------------------------------
  PORTS OPEN
   > 1433 --------------------------------------------------------------------
    > Port 1433 for SYNAPSEWORKSPACE.sql.azuresynapse.net is OPEN
    > Port 1433 for SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net is OPEN
    > Port 1433 for SYNAPSEWORKSPACE.database.windows.net is OPEN
   > 1443 --------------------------------------------------------------------
    > Port 1443 for SYNAPSEWORKSPACE.sql.azuresynapse.net is OPEN
    > Port 1443 for SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net is OPEN
   > 443 ---------------------------------------------------------------------
    > Port 443 for SYNAPSEWORKSPACE.sql.azuresynapse.net is OPEN
    > Port 443 for SYNAPSEWORKSPACE-ondemand.sql.azuresynapse.net is OPEN
    > Port 443 for SYNAPSEWORKSPACE.dev.azuresynapse.net is OPEN
    > Port 443 for web.azuresynapse.net is OPEN
    > Port 443 for management.azure.com is OPEN
------------------------------------------------------------------------------
```

## References
- [Troubleshoot Synapse Studio connectivity - Azure Synapse Analytics](https://github.com/Azure/SQL-Connectivity-Checker/blob/master/AzureSQLConnectivityChecker.ps1)
- [Troubleshoot Azure Synapse Studio connectivity using PowerShell](https://docs.microsoft.com/en-us/azure/synapse-analytics/troubleshoot/troubleshoot-synapse-studio-powershell)

