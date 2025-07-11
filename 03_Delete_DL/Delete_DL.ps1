# Import ExchangeOnline module
Import-Module ExchangeOnlineManagement

# Exchange connection details
##$AppId = "<your_appId>"
##$CertificateThumbprint = "<your_Certificate_thumbprint>"
##$Organization = "<your_organization_domain>"

try {
    # Connect to Exchange Online
    Connect-ExchangeOnline -CertificateThumbPrint $CertificateThumbprint -AppID $AppId -Organization $Organization

    # Check if the Distribution List exists
    $existingDL = Get-DistributionGroup -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue

    if (-not $existingDL) {
        $result = @{
            ErrorMessage = "Distribution List '$PrimarySmtpAddress' not found. No action taken."
            Status = 2
        }
        Write-Output ($result | ConvertTo-Json -Compress)
        exit
    }
    
    # Try to delete the DL

    Remove-DistributionGroup -Identity $PrimarySmtpAddress -Confirm:$false -ErrorAction Stop
    
    # Final result object
    $result = @{
        ErrorMessage = ''
        Status = 0
    }

    # Output the result as JSON
    Write-Output ($result | ConvertTo-Json -Compress)

} catch {
    
    # Final result object
    $result = @{
        ErrorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error deleting '$PrimarySmtpAddress': $($_.Exception.Message)"
        Status = 1
    }

    # Output the result as JSON
    Write-Output ($result | ConvertTo-Json -Compress)
}


