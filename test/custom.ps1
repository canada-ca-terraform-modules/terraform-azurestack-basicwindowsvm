param(
    [Parameter(Mandatory = $false)][string]$rdpPort = "3389"
)

<#function writeToLog {
param ([string]$message)
$scriptPath = "."
$deploylogfile = "$scriptPath\deploymentlog.log"
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"whhooo Went to test function $message $temptime" | out-file $deploylogfile -Append
}#>

Process {
    $scriptPath = "."
    $deploylogfile = "$scriptPath\deploymentlog.log"
    if ($PSScriptRoot) {
        $scriptPath = $PSScriptRoot
    }
    else {
        $scriptPath = Split-Path -parent $MyInvocation.MyCommand.Definition
    }

    #Add RDP listening ports on 443
    netsh.exe interface portproxy add v4tov4 listenport=443 connectport=3389 connectaddress=127.0.0.1 
    netsh.exe advfirewall firewall add rule name="Open Port 443" dir=in action=allow protocol=TCP localport=443

    #Install stuff

    $temptime = Get-Date -f yyyy-MM-dd--HH:mm:ss
    "Starting deployment script - $temptime" | Out-File $deploylogfile
    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    . choco.exe feature enable -n=allowGlobalConfirmation
    . choco.exe install git.install
    . choco.exe install vscode
    . choco.exe install googlechrome
    . choco.exe install azure-cli
    
<#
    # The following is needed for powershell az module
    . choco.exe upgrade dotnet4.7.2
    
    #install Powershell AZ module
    Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force
    Install-Module -Name Az -AllowClobber -Scope AllUsers
    Import-Module Az

    #enable azure alias
    Enable-AzureRmAlias -Scope LocalMachine
#>

    #setting the time zone to eastern
    & "$env:windir\system32\tzutil.exe" /s "Eastern Standard Time"

    #disable IE enhache Security
    $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" 
    $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" 
    Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 
    Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 
    Stop-Process -Name Explorer

    #adding a VSC shortcut on the public desktop
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut("c:\Users\Public\Desktop\Visual Studio Code.lnk")
    $Shortcut.TargetPath = "C:\Program Files\Microsoft VS Code\Code.exe"
    $Shortcut.Arguments = '"C:\Azure\accelerators_accelerateurs-azure"'
    $Shortcut.Save()

    #disable server manager at login time
    Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose

    $temptime = Get-Date -f yyyy-MM-dd--HH:mm:ss
    "Ending deployment script - $temptime" | Out-File $deploylogfile -Append
}