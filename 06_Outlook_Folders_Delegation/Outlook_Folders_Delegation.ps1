#******* Format to access Input Parameters *******
# To use variable, prefix with '$'. eg. $message
# Read more https://docs.servicenow.com/?context=CSHelp:IntegrationHub-PowerShell-Step
# Import ExchangeOnline module
Import-Module ExchangeOnlineManagement

##$AppId = "<your_appId>"
##$CertificateThumbprint = "<your_Certificate_thumbprint>"
##$Organization = "<your_organization_domain>"
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -CertificateThumbPrint $CertificateThumbprint -AppID $AppId -Organization $Organization

function CheckUserExist{
    param (
        [string]$UserPrincipalName
    )

    try {
        $user = Get-User -Identity $UserPrincipalName -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}


try{  
    
    $status = 0

    if($PrimarySmtpAddress -and $DelegateSmtpAddress -and $Folder -and $AccessRight){
        
        if(CheckUserExist $PrimarySmtpAddress -and CheckUserExist $DelegateSmtpAddress){
        
            # Add delegate to the specified folder with specified access right

            $folderPath = "$($PrimarySmtpAddress):\$($Folder)"

            
            $existingPermission = Get-MailboxFolderPermission -Identity $folderPath -User $DelegateSmtpAddress -ErrorAction SilentlyContinue

            if ($existingPermission) {
                $result = @{
                    ErrorMessage = ""
                    Status = 3
                }
                
                 Write-Output ($result | ConvertTo-Json -Compress)
                return
            }
            

            Add-MailboxFolderPermission -Identity $folderPath -User $DelegateSmtpAddress -AccessRights $AccessRight -ErrorAction stop
            
            $result = @{
                ErrorMessage = ""
                Status = 0            
            }
        }else{
            $result = @{
                ErrorMessage = "Primary or Delegate user doesn't exist"
                Status = 2            
            }
        }

    }
    else{  

        $result = @{
            ErrorMessage = "Incomplete information. No action taken."
            Status = 2      
        }
 
    }

    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress) 

}catch{
    $result = @{
        ErrorMessage = "Script execution failed. No action taken. $($_.Exception.Message)"
        Status = 1      
    }
    
    # Return result as JSON

    Write-Output ($result | ConvertTo-Json -Compress)  
}
