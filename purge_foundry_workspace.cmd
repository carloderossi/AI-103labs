@echo off
setlocal enabledelayedexpansion

@title Delete Foundry Workspace

echo Loading Azure Service Principal environment variables...
@call .\local\setEnv.cmd

echo Logging in as service principal...
@call az login --service-principal --username "%ARM_CLIENT_ID%" --password "%ARM_CLIENT_SECRET%" --tenant "%ARM_TENANT_ID%"

@call az account set --subscription "%ARM_SUBSCRIPTION_ID%"

set rgName=cdr-lab03-rg
set accountName=cdr-lab03-proj-resource
set location=swedencentral
set projectName=cdr-lab03-proj

@echo.
echo Deleting Cognitive Services account "%accountName%"...

@call az cognitiveservices account project delete --name "%accountName%" --resource-group "%rgName%" --project-name "%projectName%" 

@call az cognitiveservices account delete --name "%accountName%" --resource-group "%rgName%" 

@echo.
echo Waiting for deletion to complete...

:waitDelete
for /f "tokens=*" %%i in ('az cognitiveservices account show --name "%accountName%" --resource-group "%rgName%" --query "provisioningState" --output tsv 2^>nul') do set state=%%i

if "%state%"=="" (
    echo Deleted.
) else (
    echo Still deleting... state=%state%
    timeout /t 5 >nul
    goto waitDelete
)

@echo.
::echo Purging soft-deleted keyvault...
::@call az keyvault purge --name cdr-foundry-kv --location "%location%" --subscription "%ARM_SUBSCRIPTION_ID%"

@echo.
echo Purging soft-deleted account...

@call az cognitiveservices account purge --name "%accountName%" --resource-group "%rgName%" --location "%location%" --subscription "%ARM_SUBSCRIPTION_ID%"

@echo.
echo Waiting for purge to complete...

:waitPurge
for /f "tokens=*" %%i in ('az cognitiveservices account list-deleted --location "%location%" --query "[?name=='%accountName%']" --output tsv 2^>nul') do set deleted=%%i

if "%deleted%"=="" (
    echo Purged.
) else (
    echo Still purging...
    timeout /t 5 >nul
    goto waitPurge
)

@echo.
echo Deleting resource group "%rgName%"...

@call az group delete --name "%rgName%" --yes --no-wait

@echo.
echo Waiting for resource group deletion...

:waitRG
for /f "tokens=*" %%i in ('az group exists --name "%rgName%"') do set exists=%%i

if "%exists%"=="false" (
    echo Resource group deleted.
) else (
    echo Still deleting resource group...
    timeout /t 5 >nul
    goto waitRG
)

@echo.
echo All resources deleted and purged.

pause