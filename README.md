# Microsoft365DSC

This module allows organizations to automate the deployment,
configuration, reporting and monitoring of Microsoft 365 Tenants via PowerShell
Desired State Configuration. The compiled configuration needs to be
executed from an agent's Local Configuration Manager (LCM) (machine
or container) which can communicate back remotely to Microsoft 365 via
remote API calls (therefore requires internet connectivity)

For information on how to get started, additional documentation or
additional resources, please navigate to the official web site at
[Microsoft365DSC.com](http://Microsoft365DSC.com) and check out the
official YouTube channel
[Microsoft365DSC](https://www.youtube.com/channel/UCveScabVT6pxzqYgGRu17iw).

## Branches

### master

[![codecov](https://codecov.io/gh/Microsoft/Microsoft365DSC/branch/master/graph/badge.svg)](https://codecov.io/gh/Microsoft/Microsoft365DSC)

This is the branch containing the latest release. No contributions should be made directly to this branch.

### dev

[![Code Coverage](https://github.com/microsoft/Microsoft365DSC/actions/workflows/CodeCoverage.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/CodeCoverage.yml)

[![AzureCloud - Full-Circle - EXO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20EXO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20EXO.yml)

[![AzureCloud - Full-Circle - O365](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20O365.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20O365.yml)

[![AzureCloud - Full-Circle - OD](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20OD.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20OD.yml)

[![AzureCloud - Full-Circle - PP](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20PP.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20PP.yml)

[![AzureCloud - Full-Circle - SC](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SC.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SC.yml)

[![AzureCloud - Full-Circle - SPO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SPO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20SPO.yml)

[![AzureCloud - Full-Circle - TEAMS](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20TEAMS.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/AzureCloud%20-%20Full-Circle%20-%20TEAMS.yml)

[![Global - Integration - AAD](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20AAD.yml)

[![Global - Integration - EXO](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20EXO.yml)

[![Global - Integration - INTUNE](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Global%20-%20Integration%20-%20INTUNE.yml)

[![Unit Tests](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml/badge.svg)](https://github.com/microsoft/Microsoft365DSC/actions/workflows/Unit%20Tests.yml)

Contributors are encouraged to propose their contributions as pull requests to this development branch.
This branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).



## 📥 Clone This Repository

### **Windows**
```Powershell
cd C:\
git clone https://github.com/<your-username>/Microsoft365DSC.git
```

Linux
```Bash
cd ~
git clone https://github.com/<your-username>/Microsoft365DSC.git
```

## Install Required PowerShell Modules (Windows & Linux)


## Install All Dependancies
```
Install-PackageProvider -Name NuGet -Force
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module Microsoft.Graph.Authentication `
    -RequiredVersion 2.28.0 `
    -Scope CurrentUser `
    -Force -AllowClobber

Install-Module ReverseDSC -Scope CurrentUser -Force -AllowClobber

Import-Module ReverseDSC -Force
# Graph v2.28.0 (brings Identity.DirectoryManagement, Users, Groups, Applications, etc.)
Install-Module Microsoft.Graph -RequiredVersion 2.28.0 -Scope CurrentUser -Force -AllowClobber

# Graph Beta v2.28.0 (brings Microsoft.Graph.Beta.Search, Beta.Identity.DirectoryManagement, etc.)
Install-Module Microsoft.Graph.Beta -RequiredVersion 2.28.0 -Scope CurrentUser -Force -AllowClobber

# Exchange Online
Install-Module ExchangeOnlineManagement -RequiredVersion 3.9.0 -Scope CurrentUser -Force -AllowClobber

# Cloud login helper (Get-MSCloudLoginConnectionProfile, etc.)
Install-Module MSCloudLoginAssistant -RequiredVersion 1.1.56 -Scope CurrentUser -Force -AllowClobber

# ReverseDSC (for Save-Credentials and related helpers)
Install-Module ReverseDSC -Scope CurrentUser -Force -AllowClobber

Update-M365DSCDependencies -Scope AllUsers -Force

```
## Import the module
```
# Path to the module’s .psd1 file inside the repo
$repoRoot   = "C:\Microsoft365DSC"                 # change if you cloned elsewhere
$moduleRoot = Join-Path $repoRoot "Modules\Microsoft365DSC"
$moduleFile = Join-Path $moduleRoot "Microsoft365DSC.psd1"

Import-Module $moduleFile -Force
Import-Module ReverseDSC -Force
Import-Module MSCloudLoginAssistant -Force


```
## Check it's loaded
```
Get-Module Microsoft365DSC
```
## Add Custom Resource folder under DSCResources folder - Follow the naming convention 
### Create .psm1 and schema.mof files inside this folder
## Export Resources
```
# Get credentials
$cred = Get-Credential
Export-M365DSCConfiguration ` 
    -Credential $cred `
    -Components@("#add names of resources you need to export") ` 
    -Mode Full `
    -Path "#add here the output path" ` 
    -FileName "#add here the desired name of the output ps1 file"
```
