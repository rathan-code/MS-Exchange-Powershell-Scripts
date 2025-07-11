#******* Format to access Input Parameters *******
# To use variable, prefix with '$'. eg. $message
# Read more https://docs.servicenow.com/?context=CSHelp:IntegrationHub-PowerShell-Step
# Import ExchangeOnline module
Import-Module ExchangeOnlineManagement

##$AppId = "<your_appId>"
##$CertificateThumbprint = "<your_Certificate_thumbprint>"
##$Organization = "<your_organization_domain>"

try{
    Connect-ExchangeOnline -CertificateThumbPrint $CertificateThumbprint -AppID $AppId -Organization $Organization

    $errors = @()
    $ownersAdded = @()
    $ownersNotAdded = @()
    $ownersRemoved = @()
    $ownersNotRemoved = @()
    $status = 0

    # Extract Owners and Members
    $AddOwners = $addOwners -split ','
    $RemoveOwners = $removeOwners -split ','

    # Check if the Distribution List already exists
    $existingDL = Get-DistributionGroup -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue

    if ($existingDL) {

        # Get owners and extract their PrimarySMTPAddress into an array
    
        $dl = Get-DistributionGroup -Identity $PrimarySmtpAddress
        $OwnerSMTPs = $dl.ManagedBy | ForEach-Object { (Get-Recipient $_).PrimarySmtpAddress.ToString() }
        Write-Output $OwnerSMTPs
        
        #$OwnerSMTPs = Get-DistributionGroup -Identity $PrimarySmtpAddress | Get-DistributionGroupOwner

        # Add Owners to the Distribution List if any are provided

        if($addOwners){
            foreach ($Owner in $AddOwners) {
                try {
                    # Check if user not exist in the Owners list
                
                    if (-not ($OwnerSMTPs -contains $Owner)) {   
                        Set-DistributionGroup -Identity $PrimarySmtpAddress -ManagedBy @{Add="$Owner"} -ErrorAction stop
                    }
                    $ownersAdded += $Owner
            
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error adding $Owner $($_.Exception.Message)"
                    $errors += $errorMessage
                    $ownersNotAdded += $Owner 
                }
            }
        }

        # Remove Owners from the Distribution List if any are provided
        if($removeOwners){
            foreach ($Owner in $RemoveOwners) {
                try {
                    # Check if user exists in the group

                    if ($OwnerSMTPs -contains $Owner) {   
                        Set-DistributionGroup -Identity $PrimarySmtpAddress -ManagedBy @{Remove="$Owner"} -ErrorAction stop
                    }
                    $ownersRemoved += $Owner
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error removing $Owner $($_.Exception.Message)"
                    $errors += $errorMessage
                    $ownersNotRemoved += $Owner 
                }
            }
        }

        $result = @{
            ErrorMessage = $errors
            Status = $status
            AddedOwnersCount = $ownersAdded.Count
            RemovedOwnersCount = $ownersRemoved.Count
            OwnersAdded = $ownersAdded
            OwnersNotAdded = $ownersNotAdded
            OwnersRemoved = $ownersRemoved
            OwnersNotRemoved = $ownersNotRemoved
        }

    }
    else{  

        $result = @{
            ErrorMessage = "Distribution List with email $PrimarySmtpAddress doesn't exists. No action taken."
            Status = 2      
            AddedOwnersCount = 0
            RemovedOwnersCount = 0
            OwnersAdded = @()
            OwnersNotAdded = @()
            OwnersRemoved = @()
            OwnersNotRemoved = @()
        }
 
    }

    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress) 

}catch{
    $result = @{
        ErrorMessage = "Script execution failed. No action taken. $($_.Exception.Message)"
        Status = 1      
        AddedOwnersCount = 0
        RemovedOwnersCount = 0
        OwnersAdded = @()
        OwnersNotAdded = @()
        OwnersRemoved = @()
        OwnersNotRemoved = @()
    }
    
    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress)  
}
