###### Definitions #######

# Define the virtual machine names to be created
$server = ('server-3')

# Define virtual machine path
$VM_Location = "C:\temp\vm"

# Define disk path
$Disk_Location = "c:\temp\vhdx"

# Define the amount of startup memory
$Startup_Memory = 2048MB

# Define the disk size
$Disk_Size = 20GB

# Set switch name for network connection
$Switch = 'Default Switch'

# Set installation media path
$InstallMedia = 'C:\Install_Media\SW_DVD9_Win_Server_STD_CORE_2019_64Bit_English_DC_STD_MLF_X21-96581.ISO'

#####################################################################################################################################################

# Create the virtual machine
New-VM -Name $server -MemoryStartupBytes $Startup_Memory -Generation 2 -NewVHDPath "$Disk_Location\$server.vhdx" -NewVHDSizeBytes $Disk_Size -Path "$VM_Location\$server" -SwitchName $Switch

# Add SCSI controller to the virtual machine for installation media
Add-VMScsiController -VMName $server

# Attach the installation media to the virtual machine
Add-VMDvdDrive -VMName $server -ControllerNumber 1 -ControllerLocation 0 -Path $InstallMedia

# Define the virtual machine DVD drive
$DVDDrive = Get-VMDvdDrive -VMName $server

# Configure virtual machine first boot device to the attached media
Set-VMFirmware -VMName $server -FirstBootDevice $DVDDrive
