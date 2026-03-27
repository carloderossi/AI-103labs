function Login {  
    Write-Host "Connecting..." -ForegroundColor Yellow
    az login `
        --service-principal `
        --username $env:ARM_CLIENT_ID `
        --password $env:ARM_CLIENT_SECRET `
        --tenant $env:ARM_TENANT_ID | Out-Null

    Write-Host "Log-In successfully completed." -ForegroundColor Green        
    az account set --subscription $env:ARM_SUBSCRIPTION_ID

    Write-Host "Subscription configured." -ForegroundColor Cyan
}
