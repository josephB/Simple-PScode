<#
.Synopsis
    Count TCP connections for a specific state
    state in Established, TimeWait, SynSent 
.DESCRIPTION
   <Check Active TCP sessions count>
.PARAMETER <paramName>
   <-w warning -c critical -T state>
.Example
     <check_tcp_sessions.ps1 -w 10 -c 30 -T TimeWait>
.Author
    J. Bonnet


#>

Param(
    [parameter(Mandatory=$true)]
    [alias("w")]
    $warn,
    [parameter(Mandatory=$true)]
    [alias("c")]
    $crit,
    [parameter(Mandatory=$true)]
    [alias("T")]
    $state
    )

# Nagios check vars
$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3


$connections=[net.NetworkInformation.IPGlobalProperties]::GetIPGlobalProperties().GetActiveTcpConnections() 
$Sessionscount=0


foreach($_ in $connections) {
    # write-host $_.LocalEndPoint $_.RemoteEndPoint $_.state
    if ( $_.state -eq $state ) {

        $Sessionscount ++
        }
}


 if ($Sessionscount -ge $crit){
  	Write-Host "CRITICAL - TCP sessions $state : $Sessionscount (crit:$crit) | TCP$state=$Sessionscount;$warn;$crit"
 	exit $returnStateCritical
 } elseif ($Sessionscount -ge $warn) {
 	Write-Host "WARNING - TCP sessions $state : $Sessionscount (warn:$warn) | TCP$state=$Sessionscount;$warn;$crit"
 	exit $returnStateWarning
 } elseif ($Sessionscount -le $warn) {
 	Write-Host "OK - TCP sessions $state : $Sessionscount | TCP$state=$Sessionscount;$warn;$crit"
 	exit $returnStateOK
 } else {
 	Write-Host "UNKNOWN - unable to state TCP active sessions"
	exit $returnStateUnknown
 }