$file_results = Get-Content -Path '/etc/passwd'
$sys_users = @()
$std_users = @()


for ($i=0; $i -lt $file_results.Length; $i++)
    {

        $tmp_usr = $file_results[$i].Split(":")
        $user = New-Object PSObject
        $user |Add-Member Username $tmp_usr[0]
        #$user |Add-Member Password $tmp_usr[1]
        $user |Add-Member User_ID $tmp_usr[2]
        $user |Add-Member Group_ID $tmp_usr[3]
        $user |Add-Member Comment $tmp_usr[4]
        $user |Add-Member Home_Directory $tmp_usr[5]
        $user |Add-Member User_Shell $tmp_usr[6]


        $uID = $user.User_ID -as [int]
        if ($uID -lt 1000)
            {

                $sys_users += $user

            }
        else 
            {
            
                $std_users += $user
        
            }
            
    }

Write-Host " "
Write-Host "System Users:"
$sys_users |Format-Table -AutoSize
Write-Host " "
Write-Host " "
Write-Host "Standard Users:"
$std_users |Format-Table -AutoSize
