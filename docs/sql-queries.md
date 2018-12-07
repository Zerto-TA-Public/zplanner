# Helpful SQL queries

Below are some SQL Queries that are helpful for advanced planning, but are not currently part of the zPlanner Grafana GUI

## Create a table with Average write KB/s as well as total Provisioned Storage in GB for each VM

~~~~sql
CREATE Table PerVMWriteAvg AS
SELECT
    z.vm,
    AVG(z.sumKB) as AverageWriteKBps,
    y.cap as TotalProvisionedGB
FROM
    (
        SELECT `datestamp`, SUM(KBWriteAvg) as sumKB, `vm` FROM stats GROUP BY `datestamp`, `VM`
    ) z
    INNER JOIN
    (
        SELECT VM, MAX(cap) as cap FROM (SELECT `VM`,`datestamp`, SUM(CapacityGB) as cap FROM stats GROUP BY `VM`,`datestamp`) s GROUP BY VM
    ) y
    ON z.vm = y.vm
GROUP By VM
~~~~
