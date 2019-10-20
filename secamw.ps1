### Configure 2nd physical hard disk

# Initialize disk
Get-Disk | Where-Object PartitionStyle -eq 'raw' | Initialize-Disk -PartitionStyle GPT

# Create a new partition
New-Partition -DiskNumber 1 -UseMaximumSize

# Set the partition drive letter
Set-Partition -DiskNumber 1 -PartitionNumber 2 -NewDriveLetter F

# Format the partition with NTFS
Format-Volume -DriveLetter F -FileSystem NTFS

### Create TSR Administrative user

# Add TSRAdmin user
New-LocalUser -Name "TSRAdmin" -FullName "TSRAdmin" -AccountNeverExpires -PasswordNeverExpires -Description "TSR Administrative account"

# Add TSRAdmin user to Administrators group
Add-LocalGroupMember -Group "Administrators" -Member "TSRAdmin"

### Rename computer and join domain ---- No Restart ----

# Get user input for new computer name
$new_host = Read-Host -Prompt "Enter the new computer name: "

# Join the domain using the new name and place computer into proper OU but DO NOT restart computer
Add-Computer -DomainName LDSCHURCH -OUPath "OU=Milestone,OU=Other Operations,OU=Win2012,OU=DataCenterSystems,DC=ldschurch,DC=org" -Credential (Get-Credential) -NewName $new_host -Options JoinWithNewName,AccountCreate

### Retrieve and run customization script

# Create c:\Tools\Autosetup directory
New-Item -ItemType "directory" -Path "c:\Tools\AutoSetup"

# Download the script package
Invoke-WebRequest -Uri "http://w13388/wininstall/winconfig/winconfig.zip" -OutFile "c:\Tools\Autosetup\winconfig.zip"

# Unzip the script package
Expand-Archive -Path "c:\tools\autosetup\winconfig.zip" -DestinationPath "c:\tools\autosetup" -ErrorAction Stop -WarningAction Stop

# Run the configuration script
Invoke-Expression "c:\tools\autosetup\winconfig.ps1"

### Restart the computer

# Restart the Computer
Restart-Computer
