## Summary

Script to test Synapse connectivity endpoints and Ports needed
    - Check Windows HOST File entries
    - Check DNS configuration
    - Check name resolution for all possible endpoints used by Synapse and compare it with public DNS
    - Check if ports needed are open (1433 / 443)
    - Check Internet and ADF Self Hosted IR proxy that change name resolution from local machine to proxy

    Last Updated: 2022-05-17

    This script does not really try to connect to endpoint, just check the ports. For full test you can use
        https://docs.microsoft.com/en-us/azure/synapse-analytics/troubleshoot/troubleshoot-synapse-studio-powershell

    For SQL connectivity test use
        https://github.com/Azure/SQL-Connectivity-Checker/

    Script available at
     - https://github.com/Azure-Samples/Synapse/blob/main/PowerShell/Synapse-TestConnection.ps1
     - Last dev version from
        https://github.com/FonsecaSergio/ScriptCollection/blob/master/Powershell/Synapse-TestConnection.ps1




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
Ethernet                             8 IPv4    {8.8.8.8, 8.8.4.4}
Local Area Connection* 1             9 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
Local Area Connection* 2            17 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
Wi-Fi                                3 IPv4    {8.8.8.8, 8.8.4.4}
MSFTVPN-Manual                      73 IPv6    {::}
Bluetooth Network Connection         4 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
Loopback Pseudo-Interface 1          1 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
vEthernet (Wi-Fi)                   27 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
vEthernet (Ethernet)                34 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
vEthernet (MSFTVPN-Manual)          74 IPv6    {fec0:0:0:ffff::1, fec0:0:0:ffff::2, fec0:0:0:ffff::3}
  ----------------------------------------------------------------------------
  TEST NAME RESOLUTION - CX DNS
 -Trying to resolve DNS for SERVERNAME.sql.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SERVERNAME-ondemand.sql.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SERVERNAME.dev.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for SERVERNAME.database.windows.net from Customer DNS
 -Trying to resolve DNS for web.azuresynapse.net from Customer DNS
 -Trying to resolve DNS for management.azure.com from Customer DNS
  ----------------------------------------------------------------------------
  TEST NAME RESOLUTION - PUBLIC DNS TEST - NOT A PROBLEM IF FAIL
 -Trying to resolve DNS for SERVERNAME.sql.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SERVERNAME-ondemand.sql.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SERVERNAME.dev.azuresynapse.net with DNS Server 8.8.8.8
 -Trying to resolve DNS for SERVERNAME.database.windows.net with DNS Server 8.8.8.8
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
  Computer Internet Settings - LOOK FOR PROXY SETTINGS
   > NO INTERNET PROXY ON SERVER / BROWSER
  ----------------------------------------------------------------------------
  SHIR Proxy Settings - Will fail if this is not SHIR machine
Get-EventLog: The event log 'Integration Runtime' on computer '.' does not exist.
  ----------------------------------------------------------------------------
  ----------------------------------------------------------------------------
  NAME RESOLUTION
   ----------------------------------------------------------------------------
   > DNS for (SERVERNAME.sql.azuresynapse.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SERVERNAME-ondemand.sql.azuresynapse.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SERVERNAME.dev.azuresynapse.net)
      > CX DNS:(40.113.176.228) / NAME:(a365rpprodwesteurope-1-a365data.westeurope.cloudapp.azure.com)
      > Public DNS:(40.113.176.228) / NAME:(a365rpprodwesteurope-1-a365data.westeurope.cloudapp.azure.com)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (SERVERNAME.database.windows.net)
      > CX DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > Public DNS:(104.40.168.105) / NAME:(cr4.westeurope1-a.control.database.windows.net)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (web.azuresynapse.net)
      > CX DNS:(65.52.226.18) / NAME:(synapse-web-prod.northeurope.cloudapp.azure.com)
      > Public DNS:(65.52.226.18) / NAME:(synapse-web-prod.northeurope.cloudapp.azure.com)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
   ----------------------------------------------------------------------------
   > DNS for (management.azure.com)
      > CX DNS:(40.79.131.240) / NAME:(rpfd-prod-pa-01.cloudapp.net)
      > Public DNS:(40.79.131.240) / NAME:(rpfd-prod-pa-01.cloudapp.net)
      > INFO: CX DNS SERVER AND PUBLIC DNS ARE SAME. That is not an issue. Just a notice that they are currently EQUAL
      > CX USING PUBLIC ENDPOINT
  ----------------------------------------------------------------------------
  PORTS OPEN (Used CX DNS or Host File entry listed above)
   > 1433 --------------------------------------------------------------------
    > Port 1433 for SERVERNAME.sql.azuresynapse.net is OPEN
    > Port 1433 for SERVERNAME-ondemand.sql.azuresynapse.net is OPEN
    > Port 1433 for SERVERNAME.database.windows.net is OPEN
   > 443 ---------------------------------------------------------------------
    > Port 443 for SERVERNAME.sql.azuresynapse.net is OPEN
    > Port 443 for SERVERNAME-ondemand.sql.azuresynapse.net is OPEN
    > Port 443 for SERVERNAME.dev.azuresynapse.net is OPEN
    > Port 443 for web.azuresynapse.net is OPEN
    > Port 443 for management.azure.com is OPEN
------------------------------------------------------------------------------
END OF SCRIPT
------------------------------------------------------------------------------
```
