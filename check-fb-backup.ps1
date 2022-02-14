
Function Check-backup{
<#
	.NOTES
	===========================================================================
	 Original Created by:  Martin Kellner
	 Created / Modifed by: Martin Kellner
	  Date:                Feb 14, 2022
	===========================================================================
	.SYNOPSIS
		This function will check to see if your VCSA Backups was run successfull.
		
	.DESCRIPTION
		This function will check to see if your VCSA Backups was run successfull.
	.EXAMPLE
		PS C:\> check-filebased_backup -vc 192.168.1.1 -user "adminsitrator@vsphere.local" -password "VMw@re123"
	

#>
param ([Parameter(Mandatory = $true)]
        [string]$vc, 
       [Parameter(Mandatory = $true)]
        [string]$user,
        [Parameter(Mandatory = $true)]
        [string]$password
        )

	
begin { 
        Connect-CisServer -Server $vc -User $user -Password $password
        }

process {
    $BackupAPI = Get-CisService 'com.vmware.appliance.recovery.backup.job'
    $BackupID = $BackupAPI.list()
	$id = $BackupID[0]
	#$BackupAPI.get("$id") | Select-Object id, progress, state
    $BackupStatus = $BackupAPI.get("$id") | Select-Object id,state 
    $backupdate =  ($BackupStatus.id).substring(0,8)
    
    
    if ($backupdate -gt (get-date -Format yyyyMMdd)-2-And $backupstatus.state -eq "SUCCEEDED")
     {
        Write-host "Info: The last backup was succedssful on vCenter "$vc -ForegroundColor green
     }
    else {
          write-host "Warning: The last backup failed on vCenter "$vc -ForegroundColor red 
         } 
     }

end {
    Disconnect-CisServer -Server $vc -Confirm:$false
}
}





