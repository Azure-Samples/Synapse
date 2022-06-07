<#   
.NOTES     
    Author: Charith Caldera
    LinkedIn: https://www.linkedin.com/in/charith-caldera-52590a10b/
    Email: ccaldera@microsoft.com
    Last Updated: 2022-06-03

.SYNOPSIS   
    Find the username in Synapse RBAC
    
#UPDATES
#> 

Clear-Host

# Map Role Assignment IDs with Roles
function GetASynapseRoleDefinition{
    param($roleid)

    Get-AzSynapseRoleDefinition -id $roleid -WorkspaceName $workspacename
    
}


# Get Synapse RBAC Users
function GetSynapseRBACUsers{
    
    $profile = Get-AzADUser -UserPrincipalName $username
    $roleassignment = Get-AzSynapseRoleAssignment -WorkspaceName $workspacename |?{$_.ObjectId -eq $profile.id}
    if($roleassignment)
    {
       Write-Host "AAD Users Identified :" -ForegroundColor Green
       Write-Host " "
       Write-Host "    Username                 :" $username
       Write-Host "    Role Assignment Id       :" $roleassignment.RoleAssignmentId
       Write-Host "    Role Definition Id       :" $roleassignment.RoleDefinitionId
       $rolename = GetASynapseRoleDefinition $roleassignment.RoleDefinitionId 
       Write-Host "    Synapse Role             :" $rolename.Name
       Write-Host "    Principal Type           :" $roleassignment.principalType
       Write-Host "    Scope                    :" $roleassignment.Scope
       Write-Host " "
    } 

}

# Get Synapse RBAC Groups
function GetSynapseRBACGroups{
    
    $profile = Get-AzADGroup -DisplayName $username
    $roleassignment = Get-AzSynapseRoleAssignment -WorkspaceName $workspacename |?{$_.ObjectId -eq $profile.id}
    if($roleassignment)
    {
       Write-Host "AAD Groups Identified:" -ForegroundColor Green
       Write-Host " "
       Write-Host "    AAD Group Name           :" $username
       Write-Host "    Role Assignment Id       :" $roleassignment.RoleAssignmentId
       Write-Host "    Role Definition Id       :" $roleassignment.RoleDefinitionId
       $rolename = GetASynapseRoleDefinition $roleassignment.RoleDefinitionId 
       Write-Host "    Synapse Role             :" $rolename.Name
       Write-Host "    Principal Type           :" $roleassignment.principalType
       Write-Host "    Scope                    :" $roleassignment.Scope
       Write-Host " "
    } 

}

# Get Synapse RBAC Service Principals
function GetSynapseRBACSPs{
    
    $profile = Get-AzADServicePrincipal -DisplayName $username
    $roleassignment = Get-AzSynapseRoleAssignment -WorkspaceName $workspacename |?{$_.ObjectId -eq $profile.id}
    if($roleassignment)
    {
       Write-Host "Service Principals Identified:" -ForegroundColor Green
       Write-Host " "
       Write-Host "    Service Principal Name   :" $username
       Write-Host "    Role Assignment Id       :" $roleassignment.RoleAssignmentId
       Write-Host "    Role Definition Id       :" $roleassignment.RoleDefinitionId
       $rolename = GetASynapseRoleDefinition $roleassignment.RoleDefinitionId 
       Write-Host "    Synapse Role             :" $rolename.Name
       Write-Host "    Principal Type           :" $roleassignment.principalType
       Write-Host "    Scope                    :" $roleassignment.Scope
       Write-Host " "
    } 

}

Write-Host "Executing PowerShell Script" -ForegroundColor Green
Write-Host " "
$workspacename = Read-Host "Synapse Workspace Name"
$workspacenameob = Get-AzSynapseWorkspace -WorkspaceName $workspacename -ErrorAction:SilentlyContinue

if($workspacenameob.Name)
    {
        $username = Read-Host "User Name (name@domain) or Service Principal Display Name" 
        Write-Host " "

        if(GetSynapseRBACUsers)
        {
           GetSynapseRBACUsers 
        }

        if(GetSynapseRBACGroups)
        {
            GetSynapseRBACGroups
        }

        if(GetSynapseRBACSPs)
        {
            GetSynapseRBACSPs
        }

    } else
    {
        Write-Host "Sorry, workspace not found" -ForegroundColor Yellow
        Write-Host " "
    }

Write-Host "PowerShell Script Completed" -ForegroundColor Green
Write-Host " "