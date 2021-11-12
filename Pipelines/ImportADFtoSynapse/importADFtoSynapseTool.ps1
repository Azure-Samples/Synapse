<#
 .NOTES
        =========================================================================================================
        Created by:       Author: Fast Track, Synapse Analytics and Azure Data Factory team
        Created on:       03/22/2021
        =========================================================================================================

 .DESCRIPTION

       Please take note of the following:
       1. When you login to Azure using this script you can either login programmatically using a Service Principal or interactively using your Username/Password.
            a. For Service Principal and Username logins:
                - The service principal and your User will need an ownership role (or similar) on the Azure Data Factory to read Integration Runtimes
                - The service principal and your User will need an ownership role (or similar) on the Synapse Workspace to copy over Integration Runtimes
            a. For migrating Linked Services, Datasets, DataFlows, Pipelines, and Triggers:
                - You need to Grant access to your Service Principal and your User within the Synapse Studio Access Control Blade and give them Synapse Administrator Roles.
                - https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-synapse-rbac
                - https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-manage-synapse-rbac-role-assignments
                - https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-set-up-access-control
 .LINK

 .EXAMPLE
        You can run the script one of two ways:
        1. Using a Configuration file -> appsettings.json
            -Please make sure to populate your appsettings.json file with the appropriate values prior to running.
                .\importADFtoSynapseTool.ps1 -ConfigFile appsettings.json
        2. Using the Azure Data Factory Resource Id and the Synapse Workspace Resource Id
                .\importADFtoSynapseTool.ps1 -sourceADFResourceId /subscriptions/<SubscriptionID>/resourceGroups/<ADFResourceGroupName>/providers/Microsoft.DataFactory/factories/<ADFName>  -destSynapseResourceId /subscriptions/<SubscriptionID>/resourceGroups/<SynapseResourceGroupName>/providers/Microsoft.Synapse/workspaces/<SynapseName>

#>

#---------------------------------------------------------[Parameters]-----------------------------------------------------
#region Parameters
    [CmdletBinding(DefaultParameterSetName = "ByResourceID")]
    Param(
    [Parameter(ParameterSetName = 'ByResourceID')]
    [string]$sourceADFResourceId,
    [Parameter(ParameterSetName = 'ByResourceID')]
    [string]$destSynapseResourceId,

    [Parameter(ParameterSetName = 'ByConfigFile')]
    [string]$ConfigFile,

    [ValidateSet('Interactive','ServicePrincipal')]
    [string]$AuthenticationType = "Interactive",

    [string] $TenantId, #optional override for TenantId in config file
    [string] $SubscriptionId, #optional override for SubscriptionId in config file
    [string] $ResourceGroupDataFactory, #optional override for ResourceGroupDataFactory in config file
    [string] $DataFactoryName, #optional override for DataFactoryName in config file
    [string] $ResourceGroupSynapse, #optional override for ResourceGroupSynapse in config file
    [string] $SynapseName, #optional override for SynapseName in config file
    [string] $ClientID, #optional override for SynapseName in config file
    [string] $ClientSecret #optional override for SynapseName in config file
    )
#endregion Parameters

Clear-Host
Set-PSDebug -Trace 0 -Strict
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
Set-StrictMode -Version Latest

#---------------------------------------------------------[Load Utility File]-----------------------------------------------------
#region Utility

    #Load Utility File
    . "$PSScriptRoot\Utils.ps1" #include Utils for Console Messages, Logging, Config parsing

#endregion Utility

#---------------------------------------------------------[Migrate ADF to Synapse]-----------------------------------------------------
#region MigrateADFSynapse
function MigrateADFSynapse {
    #If Config file is specified, use the appsettings.json file
    if($ConfigFile) {
        Write-Host -ForegroundColor Yellow "Migration Config File: $ConfigFile"

        #Load Config file
        try{
            if (-Not [string]::IsNullOrEmpty($ConfigFile)) {
                $ConfigFile = "$PSScriptRoot\$ConfigFile"

                if ( Test-Path $ConfigFile ) {
                    $config = LoadConfig `
                    -fileLocation $ConfigFile `
                    -TenantId $TenantId `
                    -SubscriptionId $SubscriptionId `
                    -ResourceGroupDataFactory $ResourceGroupDataFactory `
                    -DataFactoryName $DataFactoryName `
                    -ResourceGroupSynapse $ResourceGroupSynapse `
                    -SynapseName $SynapseName `
                    -ClientID $ClientID `
                    -ClientSecret $ClientSecret

                    if ($null -eq $config) {
                        WriteError("[Error] reading config file - check the syntax within your config file. Make sure the JSON is properly formatted.")
                        exit 1
                    }
                }
                else {
                    WriteError("[Error] reading config file - File path, file name or directory does not exist: $($ConfigFile)")
                    exit -1
                }
            }
            else {
                WriteError("[Error] reading config file - Please provide the name of your config file (i.e. appsettings.json)")
                exit -1
            }
        }
        catch {
            CustomWriteHostError("[Error] $_.Exception.Message")
            exit -1
        }
    }
    elseif (-NOT [string]::IsNullOrEmpty($sourceADFResourceId) -and -NOT [string]::IsNullOrEmpty($destSynapseResourceId)) {
        Write-Host "Resource Ids:" -ForegroundColor White
        Write-Host "Azure Data Factory" -ForegroundColor Gray
        Write-Host "$sourceADFResourceId" -ForegroundColor Gray

        Write-Host "Azure Synapse Analytics" -ForegroundColor Gray
        Write-Host "$destSynapseResourceId" -ForegroundColor Gray

        Write-Host ""
        Write-Host "#--------------------------------------------------------------------------------------------------------";
        Write-Host "Migration Details" -ForegroundColor Yellow
        Write-Host ""

        #Check whether ResourceID string starts with /
        if ( -Not ( $sourceADFResourceId.StartsWith("/") ) ) {
            $sourceADFResourceId = "/" + $sourceADFResourceId
        }

        if ( -Not ( $destSynapseResourceId.StartsWith("/") ) ) {
            $destSynapseResourceId = "/" + $destSynapseResourceId
        }

        try {
            $match = "$sourceADFResourceId" | Select-String -Pattern '^\/subscriptions\/(.+)\/resourceGroups\/(\w.+)\/providers\/Microsoft.DataFactory\/factories\/(\w.+)'
            $SubscriptionId, $ResourceGroupDataFactory, $DataFactoryName =  $match.Matches[0].Groups[1..3].Value
            Write-host "From Azure Data Factory "

            Write-Host "    Data Factory Subscription Id: $SubscriptionId "
            Write-Host "    Resource Group: $ResourceGroupDataFactory "
            Write-host "    Data Factory Name: $DataFactoryName"

            Write-Host " "
            Write-host "To Azure Synapse Analytics Workspace "


            $match = "$destSynapseResourceId" | Select-String -Pattern '^\/subscriptions\/(.+)\/resourceGroups\/(\w.+)\/providers\/Microsoft.Synapse\/workspaces\/(\w.+)'
            $SynapseSubscriptionId, $ResourceGroupSynapse, $SynapseName =  $match.Matches[0].Groups[1..3].Value
            Write-Host "    Synapse Subscription Id: $SynapseSubscriptionId "
            Write-Host "    Resourec Group $ResourceGroupSynapse "
            Write-Host "    Synapse Analytics Workspace Name:  $SynapseName"
            Write-Host "#--------------------------------------------------------------------------------------------------------";
            Write-Host ""

            $config = LoadConfig `
                -SubscriptionId $SubscriptionId `
                -ResourceGroupDataFactory $ResourceGroupDataFactory `
                -DataFactoryName $DataFactoryName `
                -ResourceGroupSynapse $ResourceGroupSynapse `
                -SynapseName $SynapseName `
                -SourceADFResourceId $sourceADFResourceId `
                -DestSynapseResourceId $destSynapseResourceId `
                -ADFAPIVersion $ADFAPIVersion `
                -SynapseAPIVersion $SynapseAPIVersion
        }
        catch {
            CustomWriteHostError("[Error] $_")
            CustomWriteHostError("[Error] Resource ID provided is not correct. Please check and make sure you have the correct Resource ID for both your Azure Data Factory and Synapse Workspace.")
            CustomWriteHostError("[Error] Resource ID Examples:")
            CustomWriteHostError("   ADF     ResourceID: /subscriptions/<SubscriptionID>/resourcegroups/<ADFResourceGroupName>/providers/Microsoft.DataFactory/factories/<ADFName> ")
            CustomWriteHostError("   Synapse ResourceID: /subscriptions/<SubscriptionID>/resourcegroups/<SynapseResourceGroupName>/providers/Microsoft.Synapse/workspaces/<SynapseName> ")
            Write-Host "#--------------------------------------------------------------------------------------------------------";
            exit -1
        }
    }
    else {
        Write-Host "    ADF to Synapse Analytics Workspace Migration PowerShell script did not start correctly" -ForegroundColor Red
        Write-Host "    Please make sure you are using the correct syntax" -ForegroundColor Red
        Write-Host ""
        Write-Host "    Syntax:" -ForegroundColor Red
        Write-Host "        .\importADFtoSynapseTool.ps1 [-ConfigFile <Filename>] " -ForegroundColor Red
        Write-Host "        .\importADFtoSynapseTool.ps1 [-sourceADFResourceId <String>] [-destSynapseResourceId <String>] [-TenantId <String>]" -ForegroundColor Red
        Write-Host ""
        Write-Host "    Docs: " -ForegroundColor Blue
        Write-Host "        https://aka.ms/adf/adf2synapse-migration " -ForegroundColor Blue
        Write-Host "#--------------------------------------------------------------------------------------------------------";
        exit 0
    }

    #At this point, we have the resource ID for both source and destination
    #Disconnect the Azure account connect so it is a clean login
    Disconnect-AzAccount | Out-null

    try {
         #Let's login
        $LoggedIn = CheckLogin
        if($ConfigFile)
        {
            #Login with Service Principal or Interactively
            if (-Not $LoggedIn) {
                Write-Host "Migration tool supports authentication using Service Principal (S) or UserName/Password (I)" -ForegroundColor Yellow
                $Global:SignIn = Read-Host -prompt "Choose the Authentication Method: (S)Service Principal (I)Interactively. (S/I)?"
                $(if ($Global:SignIn -eq 'S') { $AuthenticationType = 'ServicePrincipal' } else { $AuthenticationType = 'Interactive' })
                Login $config $Global:SignIn
            }
        }
        elseif(-NOT [string]::IsNullOrEmpty($sourceADFResourceId) -and -NOT [string]::IsNullOrEmpty($destSynapseResourceId)) {
            #Login Intereactively
            $AuthenticationType = "Interactively"
            $Global:SignIn = "I"

            if (-NOT [string]::IsNullOrEmpty($TenantId) ) {
                Write-Host "Tenant Id provided"
                Login $config $Global:SignIn $TenantId
            }
            else {
                Login $config $Global:SignIn ""
            }
        }
    }
    catch {
        CustomWriteHostError("[Error] $_.Exception.Message")
        CustomWriteHostError("[Error] Connecting to Azure using Authentication Type: $AuthenticationType")
        exit -1
    }

    #Check if ADF, Synapse Resources Exist and if you have access to them
    $CheckResources = CheckResources
    if (-Not $CheckResources) {
        WriteError ("Please double check your appsettings.json entries and your RBAC roles within the portal.")
        exit 1
    }

    #Begin Migration
    Write-Host ""
    Write-Host "#--------------------------------------------------------------------------------------------------------";
    Write-Host ""
    CustomWriteHost("[Info] Start Migration")
    StartMigration $config.DataFactory.ResourceId $config.SynapseWorkspace.ResourceId
    CustomWriteHost("[Info] Migration Completed")
    Write-Host ""
}
#endregion MigrateADFSynapse

#---------------------------------------------------------[ProcessResource]-----------------------------------------------------
#region
function PollUntilCompletion {
    Param (
        [string] $uri,
        [string] $originalUri,
        [string] $resourceName,
        [bool] $isArmToken
        )

        Write-Output "Waiting for operation to complete..."

        try
        {
            $token = GetAuthenticationToken -armToken $isArmToken -signIn $signIn
            $response = Invoke-WebRequest -UseBasicParsing -Uri $uri -Method Get -ContentType "application/json" -Headers @{ Authorization = "Bearer $token" }

            if ($response.StatusCode -ge 203)
            {
                Write-Error "Error migrating resource $originalUri"
                throw
            }

            if ($response.StatusCode -ne 200)
            {
                Start-Sleep -Seconds 1
                PollUntilCompletion $uri $originalUri $resourceName $isArmToken
                return;
            }

            if ($response.StatusCode -eq 200)
            {
                WriteSuccess "Successfully migrated $resourceName"
                return;
            }

            #if ((ConvertFrom-Json -InputObject $response.Content).status -eq 'Failed') {
                #Write-Error "Error on creating resource $originalUri. Details: $response.Content"
                #throw
            #}
        }
        catch [Exception] {
            Write-Error "An occur has occured. Error Message: $($_.Exception.Message)"
            Write-Error "Error Details: $($_.ErrorDetails.Message)"
            throw
        }
}
#endregion

#---------------------------------------------------------[StartMigration]-----------------------------------------------------
#region
    function StartMigration {
        [CmdletBinding()]
        Param (
            [string]$srcResourceId,
            [string]$destResourceId
        )

        $allResources = New-Object Collections.Generic.List[String]
        $allResources.Add("integrationRuntimes");
        $allResources.Add("linkedServices");
        $allResources.Add("datasets");
        $allResources.Add("dataflows");
        $allResources.Add("pipelines");
        $allResources.Add("triggers");

        $allResources | ForEach-Object -Process { ProcessResource -srcResourceId $srcResourceId -destResourceId $destResourceId -resourceType $_ }
        Write-Host "#--------------------------------------------------------------------------------------------------------`n"
    }
#endregion

#---------------------------------------------------------[ProcessResource]-----------------------------------------------------
#region
function ProcessResource {
    [CmdletBinding()]
    Param (
        [string]$srcResourceId,
        [string]$destResourceId,
        [string]$resourceType
    )

    $numResourcesCopied = 0

    #$srcResource = Get-AzResource -ResourceId $config.DataFactory.ResourceId -ApiVersion $config.DataFactory.apiVersion
    $destResource = Get-AzResource -ResourceId $config.SynapseWorkspace.ResourceId -ApiVersion $config.SynapseWorkspace.apiVersion

    $srcUri = "https://management.azure.com" + $config.DataFactory.ResourceId

    if ($resourceType -eq "integrationRuntimes" -or $resourceType -eq "sqlPools" -or $resourceType -eq "sparkPools") {
        $isDestArm = $true;
        $destUri = "https://management.azure.com" + $config.SynapseWorkspace.ResourceId
    } else {
        $isDestArm = $false;
        $destUri = $destResource.Properties.connectivityEndpoints.dev
    }

    $resourcesToBeCopied =  New-Object Collections.Generic.List[Object]
    $uri = "$srcUri/$($resourceType)?api-version=$($config.DataFactory.apiVersion)"

    try {
        $token = GetAuthenticationToken -armToken $true -signIn $Global:SignIn
        $srcResponse = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -ContentType "application/json" -Headers @{ Authorization = "Bearer $token" }

        #For future versions of this tool think about think about deleting all schema entries inside of datasets before running invoke-restmethod

        if ($srcResponse.Value.Length -gt 0) {
            Write-Host ""
            Write-Host "Processing $resourceType" -ForegroundColor White
            $resourcesToBeCopied.AddRange($srcResponse.Value);

            while ($srcResponse.PSobject.Properties.Name.Contains("nextLink")) {
                Write-Host "Processing next page $srcResponse.nextLink"
                $nextLink = $srcResponse.nextLink
                $srcResponse = Invoke-RestMethod -UseBasicParsing -Uri $nextLink -Method Get -ContentType "application/json" -Headers @{ Authorization = "Bearer $token"} 
                if ($srcResponse.Value.Length -gt 0) {
                    $resourcesToBeCopied.AddRange($srcResponse.Value);
                }
            }

            WriteSuccessResponse("  Migrating $($resourcesToBeCopied.Count) $resourceType")
        }
        elseif($resourcesToBeCopied.Count -le 0) {
            return;
        }
    }
    catch [Exception] {
        Write-Error "[Error] Listing $resourceType : $_"
        throw
    }

    $resourcesToBeCopied | ForEach-Object -Process {
        $uri = "$destUri/$resourceType/$($_.name)?api-version=$($config.SynapseWorkspace.apiVersion)";
        $jsonBody = ConvertTo-Json $_ -Depth 30
        $name = $_.name

        $destResponse = $null;

        #Check if you have an Azure-SSIS Integration Runtime. Azure-SSIS is currently not supported in Synapse Workspaces
        #Check if you have an Self-Hosted Integration Runtime that is Shared or Linked. Linked IR are currently not supported in this PowerShell script because you of Managed Identity references.
        #Check if you have an Azure Integration Runtime that is using a Managed Virtual Network. Managed VNets are currently not supported in Synapse Workspaces
        $is_ssis = $false
        $is_link = $false
        $is_vnet = $false

        if($resourceType -eq "integrationRuntimes"){
            $ssisObj = $_.PSObject.Properties["properties"].value.typeProperties | Get-Member -Name "ssisProperties"
            $linkObj = $_.PSObject.Properties["properties"].value.typeProperties | Get-Member -Name "linkedInfo"
            $vnetObj = $_.PSObject.Properties["properties"].value | Get-Member -Name "managedVirtualNetwork"

            if ([bool]$ssisObj){
                $is_ssis = $true
            }
            else{
                $is_ssis = $false
            }

            if ([bool]$linkObj){
                $is_link = $true
            }
            else{
                $is_link = $false
            }

            if ([bool]$vnetObj){
                $is_vnet = $true
            }
            else{
                $is_vnet = $false
            }
        }

        try {
            #If Integration Runtime is SSIS then Skip
            if (-Not $is_ssis)
            {
                #If Integration Runtime has is a Linked IR then Skip
                if (-Not $is_link)
                {
                    #If Integration Runtime has a VNet then Skip
                    if (-Not $is_vnet)
                    {
                        $token = GetAuthenticationToken -armToken $isDestArm -signIn $Global:SignIn
                        $destResponse = Invoke-WebRequest -UseBasicParsing -Uri $uri -Method Put -ContentType "application/json" -Body $jsonBody -Headers @{ Authorization = "Bearer $token" }
                        $numResourcesCopied = $numResourcesCopied + 1

                        WriteInformation "Started migrating $resourceType : $($name)"

                        if ($destResponse.StatusCode -eq 202)
                        {
                            PollUntilCompletion $destResponse.Headers.Location $uri $name $isDestArm
                        }
                        elseif ($null -eq $destResponse -or $destResponse.StatusCode -ne 200) {
                            Write-Error "Creation failed for $($name). Error: $($_.Exception.Message)"
                            throw
                        }
                    }
                    else{
                        Write-Host "    Managed VNet Integration Runtime with the following name will be filtered and will NOT be migrated: $($name)" -ForegroundColor Yellow
                        Write-Host ""
                    }
                }
                else{
                    Write-Host "    Self-Hosted (Linked) Integration Runtime with the following name will be filtered and will NOT be migrated: $($name)" -ForegroundColor Yellow
                    Write-Host ""
                }
            }
            else{
                Write-Host "    Azure-SSIS Integration Runtime with the following name will be filtered and will NOT be migrated: $($name)" -ForegroundColor Yellow
                Write-Host ""
            }
        }
        catch [Exception] {
            Write-Error "An error occured during migration for $($name). Error: $($_.Exception.Message)"
            throw
        }
    }

    # Show number of resources copied
    WriteInformation "Azure Data Factory Resource migrated to Azure Synapse Analytics Workspace: $numResourcesCopied "
}
#endregion

#---------------------------------------------------------[Entry Point - Execution of Script Starts Here]-----------------------------------------------------
#region Entry Point
    Write-Host "#--------------------------------------------------------------------------------------------------------";
    Write-Host "  Migration of ADF Pipelines/Dataflows to Synapse Analytics Workspace" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  This script will migrate your existing Azure Data Factory Integration Runtimes, Linked Services," -ForegroundColor Gray
    Write-Host "  Datasets, Data Flows, Pipelines and Triggers into your designated Synapse Workspace" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Refer to README.md for the pre-requisites before you migrate ADF objects to Synapse Analytics." -ForegroundColor Gray
    Write-Host "  Please ensure you have the following items:" -ForegroundColor Gray
    Write-Host ""
    Write-Host "    If you are running the tool with the appsettings.json file please have the following and use the following syntax- " -ForegroundColor Gray
    Write-Host ""
    Write-Host "        1. Tenant ID" -ForegroundColor Yellow
    Write-Host "        2. Subscription ID" -ForegroundColor Yellow
    Write-Host "        3. Client ID (Optional)" -ForegroundColor Yellow
    Write-Host "        4. Client Secret (Optional)" -ForegroundColor Yellow
    Write-Host "        5. Azure Data Factory Resource Group" -ForegroundColor Yellow
    Write-Host "        6. Azure Data Factory Name" -ForegroundColor Yellow
    Write-Host "        7. Synapse Workspace Resource Group" -ForegroundColor Yellow
    Write-Host "        8. Synapse Workspace Name" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Syntax:" -ForegroundColor Gray
    Write-Host "        .\importADFtoSynapseTool.ps1 [-ConfigFile <Filename>] " -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    If you are running the tool with the Resource IDs please have the following - " -ForegroundColor Gray
    Write-Host ""
    Write-Host "        1. Azure Data Factory Resource ID" -ForegroundColor Yellow
    Write-Host "        2. Synapse Workspace Resource ID" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    Syntax:" -ForegroundColor Gray
    Write-Host "        .\importADFtoSynapseTool.ps1 [-sourceADFResourceId <String>] [-destSynapseResourceId <String>] [-TenantId <String>]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  (Please note that the following ADF resources will be filtered out and will not be migrated)" -ForegroundColor Gray
    Write-Host "      - Azure-SSIS Integration Runtimes "  -ForegroundColor Gray
    Write-Host "      - Integration Runtimes that use Managed VNets"  -ForegroundColor Gray
    Write-Host "#--------------------------------------------------------------------------------------------------------";

    #1. Check for PowerShell Module Prerequisites
    $PrerequisitesInstalled = CheckPrerequisites
    if (-Not $PrerequisitesInstalled) {
        WriteError("Pre-requisites are not installed. Please install the pre-requisites before running the PowerShell script.")
        exit 1
    }

    # Specify API version for ADF and Synapse
    Set-Variable ADFAPIVersion -Value '2018-06-01'
    Set-Variable SynapseAPIVersion -Value '2019-06-01-preview'

    #2. Entry Function to migration Script
 
    MigrateADFSynapse

    #3 End Script and Logout
    Write-Host "#--------------------------------------------------------------------------------------------------------";
    Write-Host "  Migration of Azure Data Factory to Synapse Analytics Workspace completed." -ForegroundColor White
    Write-Host "  Disconnecting from Azure" -ForegroundColor White
    Disconnect-AzAccount | Out-null
    Write-Host "#--------------------------------------------------------------------------------------------------------";

    Set-PSDebug -Off
#endregion Entry Point