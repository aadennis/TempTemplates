# Given a named VM (remote server), truncate all entries in the MyDb.MyTable
# table.

$remoteServer = "localhost" #"remotish.box.com"
$userName = "mah-pc\mahuser"

if ($creds -eq $null) {
    $creds = Get-Credential -UserName $userName -Message "Enter password"
}

#set-item wsman:\localhost\Client\TrustedHosts *.box.com -Force
set-item wsman:\localhost\Client\TrustedHosts localhost -Force

$session = New-PSSession -ComputerName $remoteServer -Credential $creds

Invoke-Command -Session $session -ScriptBlock {

    $dbPrefix = "Sales_"
    $dbServer = $remoteServer

    Import-Module sqlps
    $server = New-Object Microsoft.SqlServer.Management.Smo.Server($dbServer)
    $database = "CustomerNotes"

    $currentDatabase = $dbPrefix + $database
    $db = $server.Databases.Item($currentDatabase)
    $db.ExecuteNonQuery("delete from MyTable")
}

Remove-PSSession -Session $session

