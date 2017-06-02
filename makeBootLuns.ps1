<#
.SYNOPSIS
    Create boot luns
.DESCRIPTION
    Creates bootluns with emc uemcli
.NOTES
    File Name      : makeBootLuns.ps1
    Author         : gajendra d ambi
    Date           : June 2017
    Prerequisite   : PowerShell v4+, uemcli over win7 and upper.
    Copyright      - None
.LINK
    Script posted over: github.com/MrAmbiG/vmware
#>
$csv = "$PSScriptRoot\bootlun.csv"
get-process | select target, user, pass, pool, host | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv

Read-Host "Hit Enter/Return to proceed"

$readCSV = Import-Csv $csv
foreach ($line in $readCSV)
{
$target = $line.target
$user = $line.user
$pass = $line.pass
$lun = $line.host  # lun name is going to be the name of the host
$pool = $line.pool
$hostname = $line.host
$lunname = $lun+'-BOOT'  # add -BOOT to the name of the host = boot lun's name
$description = "Boot lun for "+$hostname  # description for the boot lun
uemcli -d $target -u $user -p $pass /stor/prov/luns/lun create -name $lunname -descr $description -pool STLUnityPool01 -size 10G -thin yes -lunHosts Host_31
}