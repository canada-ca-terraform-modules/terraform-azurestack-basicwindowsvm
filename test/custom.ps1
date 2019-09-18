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

    #Add RDP listening ports if needed
        netsh.exe interface portproxy add v4tov4 listenport=443 connectport=3389 connectaddress=127.0.0.1 
        netsh.exe advfirewall firewall add rule name="Open Port 443" dir=in action=allow protocol=TCP localport=443
}
