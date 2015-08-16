#!/bin/bash

kill `pidof postgres`
sleep 2s

nohup postgres -D /data/pg_cluster/node_data --datanode > /wytiny/log/node.log 2>&1 dev/null &
nohup postgres -D /data/pg_cluster/coordinator --datanode > /wytiny/log/coordinator.log 2>&1 dev/null &

psql -d postgres -p 7000 -f pg_register.sql
sleep 1s
psql -d postgres -p 7002 -f pg_register.sql
sleep 1s

