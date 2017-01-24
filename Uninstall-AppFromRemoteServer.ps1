# Given a named VM (remote server), tear it down, as though APP had never been installed.
# Because it is not possible to do an automated uninstall of APP, the automation
# in this script consists of
# 1. Delete the various services (automated)
# 2. Manual deletion of APP from the remote server (Programs and Features)
# 3. Delete IIS, folders, etc. (automated)
# 4. Drop all databases with the passed prefix
# Enhancements required:
# 1. Automated uninstallation of APP

$remoteServer = "remotish.box.com"
$userName = "family\dennis"

if ($creds -eq $null) {
    $creds = Get-Credential -UserName $userName -Message "Enter password"
}

set-item wsman:\localhost\Client\TrustedHosts *.box.com -Force

$session = New-PSSession -ComputerName $remoteServer -Credential $creds

Invoke-Command -Session $session -ScriptBlock {
    $dbPrefix = "prod_"
    $dbServer = "remotish.box.com"

    Import-Module sqlps
    $server = New-Object Microsoft.SqlServer.Management.Smo.Server($dbServer)
    $dbSet = "Sales","Invoices","Accounts"
    $dbSet.Count
    $dbCount = 0 
    $dbSet | % {
        $currentDatabase = $dbPrefix + $dbSet[$dbCount]
        $currentDatabase
        $server.Databases[$currentDatabase]
        $server.Databases[$currentDatabase].Drop()
        $dbCount++
        $dbCount
    }
}

Invoke-Command -Session $session -ScriptBlock {
    sc.exe stop "APP TaskRunner"
    sc.exe stop "APP TaskPostActions"
    sleep 1
    sc.exe delete "APP TaskRunner"
    sc.exe delete "APP TaskPostActions"
}

Write-Host "Before continuing, go to [$remoteServer] and delete APP via Programs and Features" -BackgroundColor White -ForegroundColor Black
Read-Host "Hit return when APP has been removed from the remote server"


Invoke-Command -Session $session -ScriptBlock {
   Remove-WebApplication -Name APP -Site "Default Web Site" -Verbose
   sleep 2
   Remove-WebApplication -Name SecondaryAPP -Site "Default Web Site" -Verbose

   Remove-Item -Path "C:\ProgramData\Invoicing" -Recurse -Force
   Remove-Item -Path "C:\Program Files\Invoicing" -Recurse -Force
   Remove-Item -Path "C:\Program Files (x86)\Invoicing" -Recurse -Force
}

Remove-PSSession -Session $session

