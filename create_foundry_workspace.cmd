@echo off
setlocal enabledelayedexpansion
@ title Bicep Foundry Workspace

REM ------------------------------------------------------------
REM 1. Load Terraform service principal credentials
REM ------------------------------------------------------------
@call .\local\setEnv.cmd

set rgName=cdr-lab03-rg

@echo.
@echo tenant: "%ARM_TENANT_ID%" 
@echo subscription: "%ARM_SUBSCRIPTION_ID%"
@echo username: "%ARM_CLIENT_ID%"

REM ------------------------------------------------------------
REM 2. Login to Azure using the service principal
REM ------------------------------------------------------------
echo Logging in as service principal...
@call az login --service-principal --username "%ARM_CLIENT_ID%" --password "%ARM_CLIENT_SECRET%" --tenant "%ARM_TENANT_ID%"

REM Set subscription
@call az account set --subscription "%ARM_SUBSCRIPTION_ID%"

@echo.
REM ------------------------------------------------------------
REM 3. Create the resource group
REM ------------------------------------------------------------
echo Creating resource group...
@call az group create --name %rgName% --location swedencentral

@echo.
REM ------------------------------------------------------------
REM 4. Deploy the Foundry resources (resource-group scope)
REM ------------------------------------------------------------
echo Deploying Foundry resources...
@call az deployment group create --resource-group %rgName% --template-file infra/main.bicep --parameters infra/foundry.parameters.json --query "properties.outputs.apiKey.value" -o tsv > src/labs/api.key

@echo.
echo Deployment complete.

@echo.
:: echo getting the KeyVault Key:
:: @call az keyvault secret show --vault-name cdr-foundry-kv --name ai-api-key --query value -o tsv 
:: >> ai_api_key.txt

pause