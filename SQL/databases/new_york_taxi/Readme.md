# New York Taxi database
[The New York City Taxi & Limousine Commission](https://www1.nyc.gov/site/tlc/index.page) released a dataset covering historical taxi trips from 2009 to present. The *New York Taxi database* models the data released within [Azure Synapse SQL](http://azure.com/synapse).

## How to deploy
Follow the steps below to deploy the *New York Taxi database* to your Azure Synapse SQL instance.

1. Clone the Azure Synapse Samples repository

`git clone https://github.com/Azure-Samples/Synapse.git`

2. Open a **Command Prompt** and navigate to the local copy of the repository

3. Navigate to the **SQL\databases\new_york_taxi** directory

4. Run the **deploy.bat** file supplying the required input


### Deploy.bat example
`
deploy.bat myserver.database.windows.net demo_dw clouds super_secure_password
`