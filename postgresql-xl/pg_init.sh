#! /bin/bash

clear
echo "======Tiny Nginx Installation======"
echo "= Author: WyTiny"
echo "= Blog: www.wytiny.me"
echo "==================================="
echo ""

function die {
    echo "ERROR: $1" > /dev/null 1>&2
    exit 1
}

function check_root {
    if [ $(/usr/bin/id -u) != "0" ]
    then
        die 'Please run the script by root user'
    fi
}

function check_command {
    if [ $? -ne 0 ]
    then
        die $1
    fi
}

function auth_conf {
    echo "host   all all 192.168.1.101/32    trust" >> $1
    echo "host   all all 192.168.1.102/32    trust" >> $1
    echo "host   all all 192.168.1.103/32    trust" >> $1
    echo "host   all all 192.168.1.104/32    trust" >> $1
    echo "host   all all 192.168.1.105/32    trust" >> $1
    echo "host   all all 192.168.1.106/32    trust" >> $1
    echo "host   all all 192.168.1.107/32    trust" >> $1
    echo "host   all all 192.168.1.108/32    trust" >> $1
    echo "host   all all 192.168.1.109/32    trust" >> $1
    echo "host   all all 192.168.1.110/32    trust" >> $1
    echo "host   all all 192.168.1.111/32    trust" >> $1
    echo "host   all all 192.168.1.112/32    trust" >> $1
}

# start

check_root
echo "input target username:"
read user
if [[ ${user} == "" ]]
then
    user="zhang"
fi

echo "input node number:"
read num

rm -rf /data/pg_cluster/

sysctl -w kernel.shmmax=17179869184
sysctl -w kernel.shmall=4194304

dn_path="/data/pg_cluster/node_data"
ds_path="/data/pg_cluster/node_data_standby"
cd_path="/data/pg_cluster/coordinator"
dn_conf=$dn_path"/postgresql.conf"
ds_conf=$ds_path"/postgresql.conf"
cd_conf=$cd_path"/postgresql.conf"
dn_hba=$dn_path"/pg_hba.conf"
ds_hba=$ds_path"/pg_hba.conf"
cd_hba=$cd_path"/pg_hba.conf"

gtm_host="vag-node9"
gtm_port=8000
dn_port=7000
ds_port=7001
cd_port=7002

dn_pooler=30000
ds_pooler=30001
cd_pooler=30002

mkdir -p $dn_path
mkdir -p $ds_path
mkdir -p $cd_path

chown -R $user /data
check_command "invalid username"

su $user -c "initdb -D $dn_path --nodename 'pg_dn'$num"
su $user -c "initdb -D $ds_path --nodename 'pg_ds'$num"
su $user -c "initdb -D $cd_path --nodename 'pg_cd'$num"

su $user -c "kill `pidof postgres`"

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" $dn_conf $ds_conf $cd_conf
sed -i "s/#gtm_host = 'localhost'/gtm_host = $gtm_host/g" $dn_conf $ds_conf $cd_conf
sed -i "s/#gtm_port = 6666/gtm_port = $gtm_port/g" $dn_conf $ds_conf $cd_conf
sed -i "s/#port = 5432/port = $dn_port/g" $dn_conf
sed -i "s/#port = 5432/port = $ds_port/g" $ds_conf
sed -i "s/#port = 5432/port = $cd_port/g" $cd_conf
echo "pooler_port = $dn_pooler" >> $dn_conf
echo "pooler_port = $ds_pooler" >> $ds_conf
echo "pooler_port = $cd_pooler" >> $cd_conf
auth_conf $dn_hba
auth_conf $ds_hba
auth_conf $cd_hba
su $user -c "pg_ctl start -D $dn_path -Z datanode"
sleep 2s
su $user -c "pg_ctl start -D $cd_path -Z coordinator"
sleep 2s
echo "Finished"
