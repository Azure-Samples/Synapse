<#   
.NOTES     
    Author: Charith Caldera
    LinkedIn: https://www.linkedin.com/in/charith-caldera-52590a10b/
    Email: ccaldera@microsoft.com
    Last Updated: 2022-06-03

.SYNOPSIS   
    Verify the usernames in Synapse RBAC
    
#UPDATES
#> 

Clear-Host

# Map Role Assignment IDs with Roles
function GetASynapseRoleDefinition{
    param($roleid)

    try
    {
        Get-AzSynapseRoleDefinition -id $roleid -WorkspaceName $workspacename -ErrorAction:SilentlyContinue  
    }
    catch
    {
        Write-Host "Error Occured while getting Synapse RBAC Definitions"
    }
    
}

# Get Synapse RBAC Users
function GetSynapseRBACUsers{
    try
    {
        foreach($profile in $profiles)
        {
            $aduser = Get-AzADUser -ObjectId $profile.ObjectId -ErrorAction:SilentlyContinue
            $assignments = $profile |?{$_.ObjectId -eq $aduser.Id}

            foreach ($assignment in $assignments)
            {
                Write-Host "----------------------------------------"
                Write-Host " "
                Write-Host "AAD User Identified:" -ForegroundColor Green
                Write-Host " "
                Write-Host "  User object Found on Object ID" $profile.ObjectId -ForegroundColor Cyan
                Write-Host "    AAD User Name             :" $aduser.DisplayName
                Write-Host "    Role Assignment Id        :" $assignment.RoleAssignmentId
                Write-Host "    Role Definition Id        :" $assignment.RoleDefinitionId
                $rolename = GetASynapseRoleDefinition $assignment.RoleDefinitionId 
                Write-Host "    Synapse Role              :" $rolename.Name
                Write-Host "    Principal Type            :" $assignment.principalType
                Write-Host "    Scope                     :" $assignment.Scope
                Write-Host " "
            }

        }
    }
    catch
    {
        Write-Host "Error Occured while getting Synapse RBAC users"
    }
}

# Get Synapse RBAC Groups
function GetSynapseRBACGroups{
    try
    {
        foreach($profile in $profiles)
        {
            $adgroup = Get-AzADGroup -ObjectId $profile.ObjectId -ErrorAction:SilentlyContinue
            $assignments = $profile |?{$_.ObjectId -eq $adgroup.Id}

            foreach ($assignment in $assignments)
            {
                Write-Host "----------------------------------------"
                Write-Host " "
                Write-Host "AAD Group Identified:" -ForegroundColor Green
                Write-Host " "
                Write-Host "  Group object Found on Object ID" $profile.ObjectId -ForegroundColor Cyan
                Write-Host "    AAD Group Name            :" $adgroup.DisplayName
                Write-Host "    Role Assignment Id        :" $assignment.RoleAssignmentId
                Write-Host "    Role Definition Id        :" $assignment.RoleDefinitionId
                $rolename = GetASynapseRoleDefinition $assignment.RoleDefinitionId 
                Write-Host "    Synapse Role              :" $rolename.Name
                Write-Host "    Principal Type            :" $assignment.principalType
                Write-Host "    Scope                     :" $assignment.Scope
                Write-Host " "
            }

        }
    }
    catch
    {
        Write-Host "Error Occured while getting Synapse RBAC Groups"
    }
}

# Get Synapse RBAC Service Principals
function GetSynapseRBACSPs{
    try
    {
        foreach($profile in $profiles)
        {
            $adsps = Get-AzADServicePrincipal -ObjectId $profile.ObjectId -ErrorAction:SilentlyContinue
            $assignments = $profile |?{$_.ObjectId -eq $adsps.Id}

            foreach ($assignment in $assignments)
            {
                Write-Host "----------------------------------------"
                Write-Host " "
                Write-Host "Service Principal Identified:" -ForegroundColor Green
                Write-Host " "
                Write-Host "  Service Principal Found on Object ID" $profile.ObjectId -ForegroundColor Cyan
                Write-Host "    Service Principal Name    :" $adsps.DisplayName
                Write-Host "    Role Assignment Id        :" $assignment.RoleAssignmentId
                Write-Host "    Role Definition Id        :" $assignment.RoleDefinitionId
                $rolename = GetASynapseRoleDefinition $assignment.RoleDefinitionId 
                Write-Host "    Synapse Role              :" $rolename.Name
                Write-Host "    Principal Type            :" $assignment.principalType
                Write-Host "    Scope                     :" $assignment.Scope
                Write-Host " "
            }

        }
    }
    catch
    {
        Write-Host "Error Occured while getting Synapse RBAC Service Principals"
    }
}


####################################################
# Main

Write-Host "Executing PowerShell Script" -ForegroundColor Green
$workspacename = Read-Host "Synapse Workspace Name"
$workspacenameob = Get-AzSynapseWorkspace -WorkspaceName $workspacename -ErrorAction:SilentlyContinue

if($workspacenameob.Name)
    {
        $profiles = Get-AzSynapseRoleAssignment -WorkspaceName $workspacenameob.Name
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
