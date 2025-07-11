# Import ExchangeOnline module
Import-Module ExchangeOnlineManagement

##$AppId = "<your_appId>"
##$CertificateThumbprint = "<your_Certificate_thumbprint>"
##$Organization = "<your_organization_domain>"
try{
    Connect-ExchangeOnline -CertificateThumbPrint $CertificateThumbprint -AppID $AppId -Organization $Organization

    $errors = @()
    $sendAsAddedList = @()
    $fullAccessAddedList = @()
    $sendAsNotAddedList = @()
    $fullAccessNotAddedList = @()
    $status = 0

    # Extract FullAccess and SendAs list
    $FullAccessList = $fullAccessList -split ','
    $SendAsList = $sendAsList -split ','

    # Check if the Shared Mailbox  already exists
    $mailbox = Get-Mailbox -Identity $PrimarySmtpAddress -ErrorAction SilentlyContinue

    if ($mailbox) {
   
        $result = @{
            ErrorMessage = "Shared Mailbox with email $PrimarySmtpAddress already exists. No action taken."
            Status = 2
            SendAsCount = 0
            FullAccessCount = 0
            SendAsAddedList = @()
            SendAsNotAddedList = @()
            FullAccessAddedList = @()
            FullAccessNotAddedList = @()
            Id = ''
        }
        # Return as JSON
        Write-Output ($result | ConvertTo-Json -Compress)
        exit
    }

    # Create the Shared Mailbox
    $newMailbox = New-Mailbox -Shared -Name $Name -Alias $Alias -PrimarySmtpAddress $PrimarySmtpAddress 

    if($newMailbox){
        # Grant Full Access

        if($fullAccessList){
            foreach ($user in $FullAccessList) {
                try {
                    Add-MailboxPermission -Identity $PrimarySmtpAddress -User $user -AccessRights FullAccess -InheritanceType All -AutoMapping $true
                    $fullAccessAddedList += $user
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error processing $user $($_.Exception.Message)"
                    $errors += $errorMessage
                    $fullAccessNotAddedList += $user 
                }
            }
        }

        # Grant SendAs permissions

        if($sendAsList){
            foreach ($user in $SendAsList) {
                try {
                    Add-RecipientPermission -Identity $PrimarySmtpAddress -Trustee $user -AccessRights SendAs -Confirm:$false
                    $sendAsAddedList += $user
                } catch {
                    $status = 1
                    $errorMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Error processing $user $($_.Exception.Message)"
                    $errors += $errorMessage
                    $sendAsNotAddedList += $user 
                }
            }
        }
        $result = @{
            ErrorMessage = $errors
            Status = $status
            SendAsCount = $sendAsAddedList.Count
            FullAccessCount = $fullAccessAddedList.Count
            SendAsAddedList = $sendAsAddedList
            SendAsNotAddedList = $sendAsNotAddedList
            FullAccessAddedList = $fullAccessAddedList
            FullAccessNotAddedList = $fullAccessNotAddedList
            Id = $newMailbox.Guid
        }

        # Write result to output
        Write-Output ($result | ConvertTo-Json -Compress)
    }else{
        $result = @{
        ErrorMessage = "Shared Mailbox creation falied. No action taken."
        Status = 1
        SendAsCount = 0
        FullAccessCount = 0
        SendAsAddedList = @()
        SendAsNotAddedList = @()
        FullAccessAddedList = @()
        FullAccessNotAddedList = @()
        Id = ''
    }
    # Return as JSON
    Write-Output ($result | ConvertTo-Json -Compress)
    }
    
}catch{
    
    $result = @{
        ErrorMessage = "Shared Mailbox creation falied. No action taken. $($_.Exception.Message)"
        Status = 1
        SendAsCount = 0
        FullAccessCount = 0
        SendAsAddedList = @()
        SendAsNotAddedList = @()
        FullAccessAddedList = @()
        FullAccessNotAddedList = @()
        Id = ''
    }
    # Return as JSON
    Write-Output ($result | ConvertTo-Json -Compress)
    exit
}


