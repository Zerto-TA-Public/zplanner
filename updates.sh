#!/bin/bash

# Rev 1.0 Create Log Directory
mkdir -p /home/zerto/logs

# Rev 1.1 Create log cleanup job and run the throughput table script retro actively
if (crontab -l | grep logs) then
        echo Log cleanup already installed
else
        echo Installing log cleanup job
        line="@daily /usr/bin/find /home/zerto/logs -mtime +7 -type f -delete"
        (crontab -u zerto -l; echo "$line") | crontab -u zerto -
fi
/usr/bin/pwsh /home/zerto/zplanner/dashboards/Import_Dashboards.ps1

/usr/bin/php /home/zerto/zplanner/loaders/throughputtable.php

# Rev 1.2 Add nightly update scripts
if (crontab -l | grep nightly) then
        echo Nightly Update job already installed
else
        echo Installing nightly update  job
        line="@daily /bin/bash /home/zerto/modules/nightlyupdate.sh"
        (crontab -u zerto -l; echo "$line") | crontab -u zerto -
fi

