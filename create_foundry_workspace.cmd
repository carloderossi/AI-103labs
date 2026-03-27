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
echo Assign Contributor role to standard browser user
@call az role assignment create --assignee "722cad5f-ee0a-49ed-a1f6-f2dbca9e860c" --role "Contributor" --scope "/subscriptions/d1b6798c-2525-4e55-9959-8dbd1223b45b/resourceGroups/cdr-lab03-rg"
::@call az role assignment create --assignee "722cad5f-ee0a-49ed-a1f6-f2dbca9e860c" --role "Contributor" --scope "/subscriptions/d1b6798c-2525-4e55-9959-8dbd1223b45b/resourceGroups/cdr-lab03-rg/providers/Microsoft.Foundry/projects/cdr-lab03-proj"
@call az role assignment create --assignee "722cad5f-ee0a-49ed-a1f6-f2dbca9e860c" --role "Azure AI Owner" --scope "/subscriptions/d1b6798c-2525-4e55-9959-8dbd1223b45b/resourceGroups/cdr-lab03-rg/providers/Microsoft.CognitiveServices/accounts/cdr-lab03-proj-resource/projects/cdr-lab03-proj"

@echo.
echo Deployment complete.

@echo.
:: echo getting the KeyVault Key:
:: @call az keyvault secret show --vault-name cdr-foundry-kv --name ai-api-key --query value -o tsv 
:: >> ai_api_key.txt

pause