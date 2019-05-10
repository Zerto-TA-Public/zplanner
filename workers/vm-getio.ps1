#!/usr/bin/pwsh

# start stopwatch for auto scheduling
$stopwatch = [system.diagnostics.stopwatch]::startNew();

$exectimefile = "/home/zerto/include/exectime.txt"
$datetimefile = "/home/zerto/include/datetime.txt"
$lockfile = "/home/zerto/data/getio.pid"
$lockstatus = 0
While ($lockstatus -ne 1)
{
	If (Test-Path $lockfile)
	{
	    echo “Lock file found!”
	    $pidlist = Get-content $lockfile
	    If (!$pidlist)
	    {
		$PID | Out-File $lockfile
		$lockstatus = 1
	    }
	    $currentproclist = Get-Process | ? { $_.id -match $pidlist }
	    If ($currentproclist)
	    {
		echo “lockfile in use by other process!”
		exit
	    }
	    Else
	    {
		Remove-Item $lockfile -Force
		$PID | Out-File $lockfile
		$lockstatus = 1
	    }
	}
	Else
	{
	    $PID | Out-File $lockfile
	    $lockstatus = 1
	}
}


# get latest monitored VMs and sort into csv files
/usr/bin/php /home/zerto/zplanner/loaders/tocsv.php

#generate datetime for this run
$datetime = [DateTime]::UtcNow | get-date -Format "yyyy-MM-dd HH:mm:ss"
$datetime | Out-File $datetimefile

#start getio workers
start-job -Name GetIO0 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio0.ps1}
start-job -Name GetIO1 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio1.ps1}
start-job -Name GetIO2 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio2.ps1}
start-job -Name GetIO3 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio3.ps1}
start-job -Name GetIO4 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio4.ps1}
start-job -Name GetIO5 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio5.ps1}
start-job -Name GetIO6 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio6.ps1}
start-job -Name GetIO7 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio7.ps1}
start-job -Name GetIO8 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio8.ps1}
start-job -Name GetIO9 -ScriptBlock {pwsh /home/zerto/zplanner/workers/getio/vm-getio9.ps1}


# wait for all jobs to complete before exiting session
Get-Job | Wait-Job

/usr/bin/php /home/zerto/zplanner/loaders/throughput.php

# stop stopwatch and update exectime file
$stopwatch.stop();

$exectime = ([math]::Round($stopwatch.elapsed.totalminutes))

$exectime | Out-File $exectimefile

/bin/bash /home/zerto/zplanner/workers/updatecron.sh

## End of Main Part
#———————————————————————————————–
#remove the lockfile
Remove-Item $lockfile –Force

