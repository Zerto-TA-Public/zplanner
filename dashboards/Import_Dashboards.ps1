#!/usr/bin/pwsh

$GrafanaServer = "localhost"
$JSONFilePath = "/home/zerto/zplanner/dashboards/"
$GrafanaPort = "3000"
$username = "admin"
$password = "Zertodata1!"

$BaseURL = "http://" + $GrafanaServer + ":"+$GrafanaPort
$AuthInfo = ("{0}:{1}" -f $username,$password)
$AuthInfo = [System.Text.Encoding]::UTF8.GetBytes($AuthInfo)
$AuthInfo = [System.Convert]::ToBase64String($AuthInfo)
$Headers = @{Authorization=("Basic {0}" -f $AuthInfo);"accept"="application/json"}
$TypeJSON = "application/json"

$JSONDashboards = get-childitem -file -Path $JSONFilePath -name *.json

foreach($JSONDashboard in $JSONDashboards)
{
    $JSON = Get-Content ($Jsonfilepath+$JSONDashboard)
    $JSON2 = $JSON | ConvertFrom-Json | ConvertTo-Json -Depth 100

    $JSONMain =
    "{
    ""dashboard"":$JSON2,
    ""overwrite"": true,
    ""inputs"": [		
       {		
         ""name"": ""DS_VM-STATS"",		
         ""type"": ""datasource"",		
         ""pluginId"": ""mysql"",		
         ""value"": ""vm-stats""		
       }		
     ]
    }"

    $URL = $BaseURL +"/api/dashboards/import"
    Invoke-WebRequest -Uri $URL -Headers $Headers -Method Post -Body $JSONMain -ContentType $TypeJSON
}
