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
    $membersList = @()
    $nonMembersList = @()
    $status = 0

    # Extract Owners and Members
    $ManagedBy = $managedBy -split ','
    $Members = $members -split ','

    # Check if the Distribution List already exists
    $existingDL = Get-DistributionGroup -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue

    if ($existingDL) {
   
        $result = @{
            ErrorMessage = "Distribution List with email $PrimarySmtpAddress already exists. No action taken."
            Status = 2
            MembersCount = 0
            Members = @()
            NonMembers = @()
            Id = ''
        }
        # Return as JSON
        Write-Output ($result | ConvertTo-Json -Compress)
        exit
    }

    # Create the Distribution List with owners
    $DL = New-DistributionGroup -Name $Name -PrimarySmtpAddress $PrimarySmtpAddress -Type "Distribution" -Notes $Description -ManagedBy $ManagedBy 

    if($DL){
        # Add Members to the Distribution List if any are provided

        if($members){
            foreach ($member in $Members) {
                try {
                    Add-DistributionGroupMember -Identity $PrimarySmtpAddress -Member $member -ErrorAction stop
                    $membersList += $member
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error processing $member $($_.Exception.Message)"
                    $errors += $errorMessage
                    $nonMembersList += $member 
                }
            }
        }

        $result = @{
            ErrorMessage = $errors
            Status = $status
            MembersCount = $membersList.Count
            Members = $membersList
            NonMembers = $nonMembersList
            Id = $DL.Guid
        }

        # Write result to output
        Write-Output ($result | ConvertTo-Json -Compress)
    }else{
        $result = @{
            ErrorMessage = "Distribution List creation failed. No action taken."
            Status = 1
            MembersCount = 0
            Members = @()
            NonMembers = @()
            Id = ''
        }
        # Return as JSON
        Write-Output ($result | ConvertTo-Json -Compress)
    }
}catch{
    #Write-Output "Distribution List creation failed. No action taken."
    $result = @{
        ErrorMessage = "Distribution List creation failed: $($_.Exception.Message)"
        Status = 1
        MembersCount = 0
        Members = @()
        NonMembers = @()
        Id = ''
    }
    # Return as JSON
    Write-Output ($result | ConvertTo-Json -Compress)
    exit
}
