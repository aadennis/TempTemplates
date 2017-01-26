# Create a share on the remote server, and grant all permissions on it
# to the Administrators group.
# It assumes the underlying folder exists

$remoteServer = "remotish.box.com"
$userName = "family\dennis"

if ($creds -eq $null) {
    $creds = Get-Credential -UserName $userName -Message "Enter password"
}

set-item wsman:\localhost\Client\TrustedHosts *.box.com -Force
$session = New-PSSession -ComputerName $remoteServer -Credential $creds

Invoke-Command -Session $session -ScriptBlock {
    $share = [WMICLASS]"Win32_Share"
    $share | Get-Member
    if (!(Get-WmiObject Win32_Share -Filter "name='NameofShare'")) {
        $share.Create("c:\NameofShare","NameOfShare",0)
    }
    Grant-SmbShareAccess -Name "NameOfShare" -AccountName "Administrators" -AccessRight Full
}

Remove-PSSession -Session $session

