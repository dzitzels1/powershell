### Configure 2nd physical hard disk

Get-Disk | Where-Object PartitionStyle -eq 'raw' | Initialize-Disk -PartitionStyle GPT
New-Partition -DiskNumber 1 -UseMaximumSize
Set-Partition -DiskNumber 1 -PartitionNumber 2 -NewDriveLetter F
Format-Volume -DriveLetter F -FileSystem NTFS

### Create TSR Administrative user

New-LocalUser -Name "LocalAdmin" -FullName "LocalAdmin" -AccountNeverExpires -PasswordNeverExpires -Description "Local Administrative account"
Add-LocalGroupMember -Group "Administrators" -Member "LocalAdmin"

### Rename computer and join domain ---- No Restart ----

$new_host = Read-Host -Prompt "Enter the new computer name: "
Add-Computer -DomainName MYDOMAIN -OUPath "OU=Cluster,OU=Task,OU=Department,OU=datacenter_site,DC=mydomain,DC=org" -Credential (Get-Credential) -NewName $new_host -Options JoinWithNewName,AccountCreate

### Retrieve and run customization script

New-Item -ItemType "directory" -Path "c:\Tools\AutoSetup"
Invoke-WebRequest -Uri "http://server1/wininstall/winconfig/winconfig.zip" -OutFile "c:\Tools\Autosetup\winconfig.zip"
Expand-Archive -Path "c:\tools\autosetup\winconfig.zip" -DestinationPath "c:\tools\autosetup" -ErrorAction Stop -WarningAction Stop
Invoke-Expression "c:\tools\autosetup\winconfig.ps1"

### Restart the computer

Restart-Computer
