#!/bin/bash

# Encounter with the problem : 502 parent proxy unreachable
# A temporary script to download and install mongodb on Ubuntu

clear
echo "======Tiny Nginx Installation======"
echo "= Author: WyTiny"
echo "= Blog: www.wytiny.me"
echo "==================================="
echo ""

echo "Input the mongodb version ( default:3.0.5 ) : "
read version

if [ $(/usr/bin/id -u) != "0" ]
then
    echo 'Please run the script by root user'
    exit 1
fi  

if [[ ${version} == "" ]]
then
    version="3.0.5"
fi

mkdir ~/tmp_mongo_install && cd ~/tmp_mongo_install

wget http://repo.mongodb.org/apt/ubuntu/dists/precise/mongodb-org/3.0/multiverse/binary-amd64/mongodb_org_server_"${version}"_amd64.deb
if [ $? -ne 0 ]
then
    echo "Cannot download mongodb server ${version} version, Please check the version or just install the default one."
    exit 1
fi

wget http://repo.mongodb.org/apt/ubuntu/dists/precise/mongodb-org/3.0/multiverse/binary-amd64/mongodb_org_tools_"${version}"_amd64.deb
if [ $? -ne 0 ]
then
    echo "Cannot download mongodb tools ${version} version, Please check the version or just install the default one."
    exit 1
fi

wget http://repo.mongodb.org/apt/ubuntu/dists/precise/mongodb-org/3.0/multiverse/binary-amd64/mongodb_org_mongos_"${version}"_amd64.deb
if [ $? -ne 0 ]
then
    echo "Cannot download mongodb mongos ${version} version, Please check the version or just install the default one."
    exit 1
fi

wget http://repo.mongodb.org/apt/ubuntu/dists/precise/mongodb-org/3.0/multiverse/binary-amd64/mongodb_org_shell_"${version}"_amd64.deb
if [ $? -ne 0 ]
then
    echo "Cannot download mongodb shell ${version} version, Please check the version or just install the default one."
    exit 1
fi

wget http://repo.mongodb.org/apt/ubuntu/dists/precise/mongodb-org/3.0/multiverse/binary-amd64/mongodb_org_"${version}"_amd64.deb
if [ $? -ne 0 ]
then
    echo "Cannot download mongodb ${version} version, Please check the version or just install the default one."
    exit 1
fi

dpkg -i mongo*.deb

if [ $? -eq 0 ]
then
    echo "Mongodb is installed. "
else
    echo "Mongodb is not successfully installed. Please check the network or try apt method. "
fi

rm -rf ~/tmp_mongo_install