#!/bin/bash
new=$(< /home/zerto/include/exectime.txt)
int=60
if [ "$new" -lt 3 ]; then
        line="*/5 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="5"
elif [ "$new" -gt 2 ] && [ "$new" -lt 7 ]; then
        line="*/10 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="10"
elif [ "$new" -gt 6 ] && [ "$new" -lt 13 ]; then
        line="*/15 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="15"
elif [ "$new" -gt 12 ] && [ "$new" -lt 18 ]; then
        line="*/20 * * * * /usr/bin/pwsh /home/zerto/zplanner/workers/vm-getio.ps1"
	int="20"
elif [ "$new" -gt 17 ] && [ "$new" -lt 28 ]; then
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

#schedule the vminfo task
line="@daily /usr/bin/pwsh /home/zerto/zplanner/workers/vm-vminfo.ps1"
(crontab -u zerto -l; echo "$line" ) | crontab -u zerto -

#print new cron
crontab -l
