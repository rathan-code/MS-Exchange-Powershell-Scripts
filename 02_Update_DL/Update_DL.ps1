# Import ExchangeOnline module
Import-Module ExchangeOnlineManagement

##$AppId = "<your_appId>"
##$CertificateThumbprint = "<your_Certificate_thumbprint>"
##$Organization = "<your_organization_domain>"

try{
    # Connect to Exchange Online
    Connect-ExchangeOnline -CertificateThumbPrint $CertificateThumbprint -AppID $AppId -Organization $Organization

    $errors = @()
    $membersAdded = @()
    $membersNotAdded = @()
    $membersRemoved = @()
    $membersNotRemoved = @()
    $status = 0

    # Extract Owners and Members
    $AddMembers = $addMembers -split ','
    $RemoveMembers = $removeMembers -split ','

    # Check if the Distribution List already exists
    $existingDL = Get-DistributionGroup -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue

    if ($existingDL) {

        # Get group members

        $GroupMembers = Get-DistributionGroupMember -Identity $PrimarySmtpAddress -ResultSize Unlimited

        # Add Members to the Distribution List if any are provided

        if($addMembers){
            foreach ($member in $AddMembers) {
                try {
                    # Check if user not exist in the group
                
                    if (-not ($GroupMembers.PrimarySmtpAddress -contains $member)) {   
                        Add-DistributionGroupMember -Identity $PrimarySmtpAddress -Member $member -ErrorAction stop
                    }
                    $membersAdded += $member
            
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error adding $member $($_.Exception.Message)"
                    $errors += $errorMessage
                    $membersNotAdded += $member 
                }
            }
        }

        # Remove Members from the Distribution List if any are provided
        if($removeMembers){
            foreach ($member in $RemoveMembers) {
                try {
                    # Check if user exists in the group

                    if ($GroupMembers.PrimarySmtpAddress -contains $member) {   
                        Remove-DistributionGroupMember -Identity $PrimarySmtpAddress -Member $member -Confirm:$false  -ErrorAction stop
                    }
                    $membersRemoved += $member
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error removing $member $($_.Exception.Message)"
                    $errors += $errorMessage
                    $membersNotRemoved += $member 
                }
            }
        }

        $result = @{
            ErrorMessage = $errors
            Status = $status
            AddedMembersCount = $membersAdded.Count
            RemovedMembersCount = $membersRemoved.Count
            MembersAdded = $membersAdded
            MembersNotAdded = $membersNotAdded
            MembersRemoved = $membersRemoved
            MembersNotRemoved = $membersNotRemoved
        }

    }
    else{  

        $result = @{
            ErrorMessage = "Distribution List with email $PrimarySmtpAddress doesn't exists. No action taken."
            Status = 2      
            AddedMembersCount = 0
            RemovedMembersCount = 0
            MembersAdded = @()
            MembersNotAdded = @()
            MembersRemoved = @()
            MembersNotRemoved = @()
        }
 
    }

    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress)   
}catch{
    $result = @{
        ErrorMessage = "Error executing script. No action taken. $($_.Exception.Message)"
        Status = 1      
        AddedMembersCount = 0
        RemovedMembersCount = 0
        MembersAdded = @()
        MembersNotAdded = @()
        MembersRemoved = @()
        MembersNotRemoved = @()
    }
    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress)   

}
