#!/bin/bash

clear
echo "======Tiny Nginx Installation======"
echo "= Author: WyTiny"
echo "= Blog: www.wytiny.me"
echo "==================================="
echo ""

function clean_tmp_files() {
rm *.tar.gz
rm -rf pcre* zlib* nginx*
}

function die {
    echo "ERROR: $1" > /dev/null 1>&2
    clean_tmp_files
    exit 1
}

function check_root {
    if [ $(/usr/bin/id -u) != "0" ]
    then
        die 'Please run the script by root user'
    fi
}

function download_packages() {
wget http://zlib.net/zlib-"${zlib_version}".tar.gz
if [ $? -ne 0 ]
then
    die "cannot download the zlib of ${zlib_version} version"
fi

wget http://jaist.dl.sourceforge.net/project/pcre/pcre/"${pcre_version}"/pcre-"${pcre_version}".tar.gz
if [ $? -ne 0 ]
then
    die "cannot download the pcre of ${pcre_version} version"
fi

wget http://nginx.org/download/nginx-"${nginx_version}".tar.gz
if [ $? -ne 0 ]
then
    die "cannot download the nginx of ${nginx_version} version"
fi

}

function sh_initialize() {
#update & upgrade packages
apt-get update
apt-get upgrade
apt-get install -y gcc g++ ruby make npm git libtool build-essential htop zip

mkdir -p /tmp && cd /tmp
}

function make_configure() {
cd /tmp/zlib-"${zlib_version}"
./configure && make && make install

cd /tmp/pcre-"${pcre_version}"
./configure && make && make install

cd /tmp/nginx-"${nginx_version}".tar.gz
mkdir -p /etc/nginx
./configure --with-pcre=../pcre-"${pcre_version}" --with-zlib=../zlib-"${zlib_version}" --conf-path="${conf_path}"
make && make install
}
# >>>>>>>>>> START <<<<<<<<<<<

check_root
sh_initialize
echo "input the nginx version(default: 1.8.0):"
read nginx_version
if [[ ${nginx_version} == "" ]]
then
    ${nginx_version}="1.8.0"
fi

echo "input the pcre version(default: 8.36):"
read pcre_version
if [[ ${pcre_version} == "" ]]
then
    ${pcre_version}="8.36"
fi

echo "input the zlib version(default: 1.2.8):"
read zlib_version
if [[ ${zlib_version} == "" ]]
then
    ${zlib_version}="1.2.8"
fi

echo "input the nginx-conf path(default: /etc/nginx/nginx.conf):"
read conf_path
if [[ ${conf_path} == "" ]]
then
    ${conf_path}=/etc/nginx/nginx.conf
fi

download_packages
tar -zxf *.tar.gz

make_configure

clean_tmp_files

echo "installatin is finished."
