# Troubleshooting Guide for ADF to Synapse Migration Tool

### PowerShell Modules Version
Make sure you  have the PowerShell modules

- PowerShell Get: 2.2.5
- Az.Resources: 3.3.0
- Az.Accounts: 2.2.6
- Az.Synapse: 0.8.0

To get the version for your PowerShell modules

```PowerShell
Get-InstalledModule
Get-InstalledModule -Name "Az.Accounts" 
```

### Troubleshooting steps
As you troubleshoot the issues, make sure you have done the following checklist.

1.	First and foremost please do the following:
    - Run the following command in the terminal window and send me your script.log file:
    - .\importADFtoSynapseTool.ps1 -ConfigFile appsettings.json *> script.log – make sure you use interactive login at the command prompt
    - Please also send me your subscription id that you are trying to login to  and the subscription name.
    - I want to be able to compare your script.log files to my script.log file and see if anything stands out to me.
1.	Make sure you are running in PowerShell 7
1.	Make sure you have the latest Modules installed: 
    - PowerShell Get: 2.2.5
    - Az.Resources: 3.3.0
    - Az.Accounts: 2.2.6
    - Az.Synapse: 0.8.0
1. 	Make sure you’ve downloaded the latest version of the code
    - [Migration tool](https://dev.azure.com/adfcustomersuccess/_git/ADF%20Migration%20to%20Synapse?path=%2FimportADFtoSynapseTool.ps1)
    - [Migration Utils code being used in the tool](https://dev.azure.com/adfcustomersuccess/_git/ADF%20Migration%20to%20Synapse?path=%2FUtils.ps1)
1.	Check and see if you can login in with a fresh PowerShell 7 Terminal Instance with the following command        
    -    Connect-AzAccount
    - Or Connect-AzAccount -Subscription <Your Sub ID>
    - Make sure you have fully logged out of all browsers. If you c
    - Make sure at the login pop up window that you  try to use another account and force the window to use another account.
    - Once you logged in with Connect-AzAccount run the Get-AzContext and see if you can bring back a context.
1. Check and see if you can login on a different machine.
    - If you need to create a VM in Azure please do so, RTP onto the machine and install all the necessary modules and see if you get the same results.
1. Check and see if you get a different result with Azure CLI commands
```PowerShell
    #Login interactively and set a subscription to be the current active subscription
    az login 

    #Login with username and password
    az login -u node.agent.ps@YOURDOMAIN.onmicrosoft.com -p YOURPASSWORD

    #Login with Service Principal
    az login --service-principal --username $appID --password $password --tenant $Tenant  

    #You can verify you’ve logged in successfully by listing your Azure subscriptions:
    #see list of subscriptions
    az account list --all

    #To set the default subscription for Azure CLI, use:
    az account set --subscription $SubscriptionName 
    az account set --subscription $SubscriptionID
```
