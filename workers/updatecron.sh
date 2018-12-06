#!/bin/bash
typeset -i new=$(< /home/zerto/include/exectime.txt)
new=$new*2
int=60
if [ "$new" -lt 5 ]; then
        line="*/5 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="5"
elif [ "$new" -gt 2 ] && [ "$new" -lt 10 ]; then
        line="*/10 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="10"
elif [ "$new" -gt 9 ] && [ "$new" -lt 15 ]; then
        line="*/15 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="15"
elif [ "$new" -gt 14 ] && [ "$new" -lt 20 ]; then
        line="*/20 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="20"
elif [ "$new" -gt 19 ] && [ "$new" -lt 30 ]; then
        line="*/30 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="30"
else
        line="0 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="60"
fi

#clear old cron
crontab -r

#write new getio schedule
(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

# edit interval file
echo $int > /home/zerto/include/interval.txt

#schedule the the other tasks that are daily jobs
line="@daily /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1"
(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

line="@daily /usr/bin/find /home/zerto/logs -mtime +7 -type f -delete"
(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

line="@daily /usr/bin/pwsh /home/zerto/zplanner/modules/nightlyupdate.ps1"
(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

#print new cron
crontab -l
