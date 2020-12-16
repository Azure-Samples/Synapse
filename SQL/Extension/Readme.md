# Azure Synapse SQL Extension

The Azure Synapse SQL Extension contain a collection of User Defined Functions (UDFs) and Views that extend the capabilities of Azure Synapse SQL.

## Schemas

The Azure Synapse SQL Extension will install the `microsoft` schema to your Synapse SQL pool.

## Functions

The Azure Synapse SQL Extension will install a collection of functions to your Synapse SQL pool. These functions extend the SQL capabilties by providing support for ANSI or Teradata functions. To see the complete list of functions, visit the [Functions Readme](functions/Readme.md)

## Views

The Azure Synapse SQL Extension will install a collection of vies to your Synapse SQL pool. These views extend the SQL monitoring capabilities by providing deeper insight into the configuration and execution of the Synapse SQL pool. To see the complete list of views, visit the [Views Readme](views/Readme.md)

## Installation

1. Download the latest release of the *Azure Synapse SQL Extension* toolkit
2. From a command prompt, execute the `deploy.bat` file providing the following details:
   - *server_name*: The name of the Azure Synapse SQL server.
   - *database_name*: The name of the Azure Synapse SQL server.
   - *user_name*: The user name to connect with.
   - *password*: The password to connect with.

### Deployment Example

`
.\deploy.bat demo.database.windows.net DemoDW cloudsa very_secure_password
`

### Clean up Example

`
.\clean.bat demo.database.windows.net DemoDW cloudsa very_secure_password
`
## Version History

### December 15, 2020
What's new:
- [Function]: The `microsoft.date_trunc` script installs a function that emulates the `DATE_TRUNC(date_part, expression)` IBM Netezza function.
- [Function]: The `microsoft.firstdayofmonth` script installs a function that returns the first day of the specified month as DATETIME2.
- [Function]: The `microsoft.firstdayofquarter` script installs a function that returns the first day of the specified quarter as DATETIME2.
- [Function]: The `microsoft.firstdayofyear` script installs a function that returns the first day of the specified year as DATETIME2.
- [Schema]: Added the `dbc` schema to support the `dbc.databases` and `dbc.tables` views.

### December 7, 2020
What's new:
- [Function]: The `microsoft.random` script installs a function that emulates the `RANDOM(expression, expression)` Teradata function.

### December 1, 2020
What's new:
- [Function]: The `microsoft.to_char` script installs a function that emulates the `TO_CHAR(expression, format)` Teradata function.

### November 12th, 2020
What's new:

- [Function]: The `microsoft.getbit` script installs a function that emulates the `TD_SYSFNLIB.GETBIT(argument, bit)` Teradata function.

### September 2nd, 2020
What's new:

- [Function]: The `microsoft.btrim` script installs a function that emulates the `TRIM(BOTH 'trim_characters' FROM expression)` Teradata function.
- [Function]: The `microsoft.ltrim` script installs a function that emulates the `TRIM(LEADING 'trim_characters' FROM expression)` Teradata function.
- [Function]: The `microsoft.rtrim` script installs a function that emulates the `TRIM(TRAILING 'trim_characters' FROM expression)` Teradata function.

### August 4th, 2020
The initial public release of the Azure Synapse SQL Extension toolkit.