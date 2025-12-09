function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity
    )

    Write-Verbose -Message "Checking Exchange Online settings"

    try {
        # Connect to Exchange Online
        if ($Credential) {
            Connect-ExchangeOnline -Credential $Credential -ShowBanner:$false
            Write-Verbose -Message "Connected Successfully"
        }
        else {
            Connect-ExchangeOnline -ShowBanner:$false
        }

   

        
    	$alerts = Get-ProtectionAlert

    	$results = @()
    	foreach ($a in $alerts) {
        	$results += @{
            		Name                = $a.Name
            		Credential          = $Credential
            		Category            = $a.Category
            		Severity            = $a.Severity
            		Disabled            = $a.Disabled
            		NotifyUser          = $a.NotifyUser
            		NotificationEnabled = $a.NotificationEnabled
            		Ensure              = 'Present'
        	}
    	}

    	return $results

    }
    catch {
        Write-Verbose -Message "Error accessing: $($_.Exception.Message)"
        return @{
            IsSingleInstance = 'Yes'
            Config           = $null
            Ensure           = 'Absent'
        }
    }
}

function Set-TargetResource {
    [CmdletBinding()]
    param (
       
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.Object]
        $Config
    )

    throw "This DSC resource is read-only. It verifies access and configuration."
}

function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
       

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.String]
        $CertificatePath,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $CertificatePassword,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.Object]
        $Config
    )

    $currentValues = Get-TargetResource @PSBoundParameters
    
    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $currentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"
    
    return ($currentValues.Ensure -eq 'Present')
}

function Export-TargetResource {
    [CmdletBinding()]
    [OutputType([System.String])]
    param(
        [Parameter()]
        [System.Management.Automation.PSCredential] $Credential
    )

    # Connect and get all alerts
    $alerts = Get-TargetResource -Credential $Credential

    $dscContent = ""

    foreach ($alert in $alerts) {
        # Start DSC block using the alert name as the key
        $block = "EXOAdminNotification `"$($alert.Name)`"`n{`n"

        foreach ($key in $alert.Keys) {
            # Skip Name as it's already used in the block header
            if ($key -eq "Name") { continue }

            $value = $alert[$key]

            # Format values properly
            if ($value -is [System.Array]) {
                if ($value.Count -eq 0) {
                    $value = "@()"
                } else {
                    $value = "@(" + ($value | ForEach-Object { "`"$_`"" } -join ", ") + ")"
                }
            } elseif ($value -is [string]) {
                $value = '"' + $value + '"'
            } elseif ($value -is [boolean]) {
                $value = if ($value) { '$true' } else { '$false' }
            } elseif ($null -eq $value) {
                $value = '$null'
            }

            $block += "    $key = $value`n"
        }

        $block += "}`n`n"
        $dscContent += $block
    }

    # Output all DSC blocks as a string
    return $dscContent
}

Export-ModuleMember -Function *-TargetResource
