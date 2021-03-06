#!/bin/bash

kill `pidof postgres`
sleep 2s

mkdir -p /data/pg_cluster
mkdir -p $HOME/wytiny/log

#create datanode
nohup postgres -D /data/pg_cluster/node_data --datanode > $HOME/wytiny/log/node.log  &
sleep 2s
#create coordinator
nohup postgres -D /data/pg_cluster/coordinator --datanode > $HOME/wytiny/log/coordinator.log &
sleep 2s

#initialize all of them
psql -d postgres -h 127.0.0.1 -p 7000 -f pg_register.sql
sleep 1s
psql -d postgres -h 127.0.0.1 -p 7002 -f pg_register.sql
sleep 1s

echo "Restarted..."
