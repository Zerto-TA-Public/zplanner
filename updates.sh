#!/bin/bash

# Rev 1.0 Create Log Directory
mkdir -p /home/zerto/logs

# Rev 1.1 Create log cleanup job
if (crontab -l | grep logs) then
        echo Log cleanup already installed
else
        echo Installing log cleanup job
        line="@daily /usr/bin/find /home/zerto/logs -mtime +7 -type f -delete"
        (crontab -u zerto -l; echo "$line") | crontab -u zerto -
fi
