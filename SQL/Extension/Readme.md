# Azure Synapse SQL Extension

The Azure Synapse SQL Extension contain a collection of User Defined Functions (UDFs) and Views that extend the capabilities of Azure Synapse SQL. 

## Schemas
The Azure Synapse SQL Extension will install the `microsoft` schema to your Synapse SQL pool. 

## Functions
The Azure Synapse SQL Extension will install a collection of functions to your Synapse SQL pool. These functions extend the SQL capabilties by providing support for ANSI or Teradata functions. To see the complete list of functions, visit the [Functions Readme](functions/readme.md)

## Views
The Azure Synapse SQL Extension will install a collection of vies to your Synapse SQL pool. These views extend the SQL monitoring capabilities by providing deeper insight into the configuration and execution of the Synapse SQL pool. To see the complete list of views, visit the [Views Readme](views/readme.md)

## Installation
1. Download the latest release of the *Azure Synapse SQL Extension* toolkit
2. From a command prompt, execute the `deploy.bat` file providing the following details:
   - *server_name*: The name of the Azure Synapse SQL server.
   - *database_name*: The name of the Azure Synapse SQL server.
   - *user_name*: The user name to connect with.
   - *password*: The password to connect with. 

### Deployment Example
`
.\deploy.bat demo.database.windows.net SampleDW sa very_secure_password
`