#!/usr/bin/pwsh

# get latest monitored VMs and sort into csv files
/usr/bin/php /home/zerto/zplanner/loaders/tocsv.php

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
