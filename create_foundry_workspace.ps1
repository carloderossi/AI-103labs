# Bicep Foundry Workspace
# ------------------------------------------------------------
# 1. Load Bicep/Terraform IaC service principal credentials
# ------------------------------------------------------------

. .\local\setEnv.ps1

Import-Module -Name .\infra\login -Verbose
login   # az connect login function

$rgName = "cdr-lab03-rg"

Write-Host ""
Write-Host "tenant: $env:ARM_TENANT_ID"
Write-Host "subscription: $env:ARM_SUBSCRIPTION_ID"
Write-Host "username: $env:ARM_CLIENT_ID"

# ------------------------------------------------------------
# 2. Login to Azure using the service principal
# ------------------------------------------------------------
Write-Host "Logging in as service principal..."

az login --service-principal --username $env:ARM_CLIENT_ID --password $env:ARM_CLIENT_SECRET --tenant $env:ARM_TENANT_ID | Out-Null

az account set --subscription $env:ARM_SUBSCRIPTION_ID

Write-Host ""
# ------------------------------------------------------------
# 3. Create the resource group
# ------------------------------------------------------------
Write-Host "Creating resource group..."

az group create `
    --name $rgName `
    --location swedencentral | Out-Null

Write-Host ""
# ------------------------------------------------------------
# 4. Deploy the Foundry resources (resource-group scope)
# ------------------------------------------------------------
Write-Host "Deploying Foundry resources..."

$apiKey = az deployment group create `
    --resource-group $rgName `
    --template-file "infra/main.bicep" `
    --parameters "infra/foundry.parameters.json" `
    --query "properties.outputs.apiKey.value" `
    -o tsv

# Ensure output directory exists
$apiKeyPath = "src/labs/api.key"
$apiKey | Out-File -FilePath $apiKeyPath -Encoding ascii -Force

Write-Host ""

az role assignment create --assignee 722cad5f-ee0a-49ed-a1f6-f2dbca9e860c --role "Contributor" --scope /subscriptions/d1b6798c-2525-4e55-9959-8dbd1223b45b/resourceGroups/cdr-lab03-rg
az role assignment create --assignee 722cad5f-ee0a-49ed-a1f6-f2dbca9e860c --role "Azure AI Owner" --scope /subscriptions/d1b6798c-2525-4e55-9959-8dbd1223b45b/resourceGroups/cdr-lab03-rg/providers/Microsoft.CognitiveServices/accounts/cdr-lab03-proj-resource/projects/cdr-lab03-proj

Write-Host "Deployment complete."