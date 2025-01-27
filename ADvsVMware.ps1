<#

.DESCRIPTION
    Verifies AD computer objects as Active VMware servers

.EXAMPLE
    verify_Serverss()

.NOTE
    See README for more information about this script. 

#>

function verify_servers() {

    $vCenterServer = "vcenter.mycompany.internal";
    $mycreds = Get-Credential;
    $computers = Get-ADComputer -Filter * -Properties * | Select-Object Name,DNSHostName,IPv4Address;
    $orphan_objects = @();
    $verified_objects = @();

    

    if ($null -eq $defaultVIServer) 
        {

        
            try {
                
                Connect-VIServer -Server $vCenterServer -Credential $mycreds -ErrorAction Stop;
        
                }
        
            catch {
        
                    Write-Host "Error connecting to vCenter Server.  Verify that the server is online and reachable on port 443.  Check your credentials.";
                    break;
        
                }
    
        } 

    else
        {

            Write-Host "Already connected to vCenter: " $vCenterServer

        }

    foreach ($computer in $computers)
        {

            $session = Get-VM -Name $computer.Name -ErrorAction SilentlyContinue;

            if ($null -eq $session)
                {

                    $orphan = New-Object PSObject;
                    $orphan | Add-Member Name $computer.Name;
                    $orphan | Add-Member DNSName $computer.DNSHostName;
                    $orphan | Add-Member IPAddress $computer.IPv4Address;
                    $orphan_objects += $orphan;

                }
            
            else 
                {
                
                    $verified = New-Object PSObject;
                    $verified | Add-Member Name $computer.Name;
                    $verified | Add-Member DNSName $computer.DNSHostName;
                    $verified | Add-Member IPAddress $computer.IPv4Address;
                    $verified_objects += $verified;
                
                }

        }
    
    $orphan_objects | Export-CSV -Path 'c:\temp\orphanADComputers.csv';
    $verified_objects | Export-CSV -Path 'c:\temp\verifiedADComputers.csv';

    
    Disconnect-VIServer -Server $vCenterServer -Confirm:$false;
    $mycreds = $null;
 
    }
    
    verify_servers
