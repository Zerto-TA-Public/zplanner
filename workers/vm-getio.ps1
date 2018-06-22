#!/usr/bin/pwsh

# get latest monitored VMs and sort into csv files
/usr/bin/php /home/zerto/zplanner/loaders/tocsv.php

#start getio workers
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio0.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio1.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio2.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio3.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio4.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio5.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio6.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio7.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio8.ps1"
start-job -FilePath "/home/zerto/zplanner/workers/getio/vm-getio9.ps1"
