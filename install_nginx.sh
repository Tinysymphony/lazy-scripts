#!/bin/bash

clear
echo "======Tiny Nginx Installation======"
echo "= Author: WyTiny"
echo "= Blog: www.wytiny.me"
echo "==================================="
echo ""

function clean_tmp_files() {
    rm -f *.tar.gz
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

function install_zlib() {
    cd /tmp
    wget http://zlib.net/zlib-"${zlib_version}".tar.gz
    if [ $? -ne 0 ]
    then
        die "cannot download the zlib of ${zlib_version} version"
    fi
    tar -zxvf zlib*.tar.gz
    cd zlib-"${zlib_version}"
    ./configure && make && make install
}

function install_pcre() {
    cd /tmp
    wget http://jaist.dl.sourceforge.net/project/pcre/pcre/"${pcre_version}"/pcre-"${pcre_version}".tar.gz
    if [ $? -ne 0 ]
    then
        die "cannot download the pcre of ${pcre_version} version"
    fi
    tar -zxvf pcre*.tar.gz
    cd pcre-"${pcre_version}"
    ./configure && make && make install
}

function install_nginx() {
    cd /tmp
    wget http://nginx.org/download/nginx-"${nginx_version}".tar.gz
    if [ $? -ne 0 ]
    then
        die "cannot download the nginx of ${nginx_version} version"
    fi
    tar -zxvf nginx*.tar.gz
    cd nginx-"${nginx_version}"
    mkdir -p /etc/nginx
    ./configure --with-pcre=../pcre-"${pcre_version}" --with-zlib=../zlib-"${zlib_version}" --conf-path="${conf_path}" --prefix="${install_path}"
    make && make install
}

function sh_initialize() {
#update & upgrade packages
apt-get update
apt-get upgrade --force-yes
apt-get install -y --force-yes gcc g++ ruby make npm git libtool build-essential htop zip

mkdir -p /tmp && cd /tmp
}

# >>>>>>>>>> START <<<<<<<<<<<
check_root
sh_initialize
echo "input the nginx version(default: 1.8.0):"
read nginx_version
if [[ ${nginx_version} == "" ]]
then
    nginx_version="1.8.0"
fi

echo "input the pcre version(default: 8.36):"
read pcre_version
if [[ ${pcre_version} == "" ]]
then
    pcre_version="8.36"
fi

echo "input the zlib version(default: 1.2.8):"
read zlib_version
if [[ ${zlib_version} == "" ]]
then
    zlib_version="1.2.8"
fi

echo "input the nginx install path(default: /usr/local/nginx):"
read install_path
if [[ ${install_path} == "" ]]
then
    install_path="/usr/local/nginx"
fi

echo "input the nginx-conf path(default: /etc/nginx/nginx.conf):"
read conf_path
if [[ ${conf_path} == "" ]]
then
    conf_path="/etc/nginx/nginx.conf"
fi

install_zlib

install_pcre

install_nginx

clean_tmp_files

echo "alias nginx-start='${install_path}/sbin/nginx'" >> ~/.bashrc
source ~/.bashrc

echo "======================================"
echo "Nginx installation is finished."
echo "version: ${nginx_version}"
echo "install_path: ${install_path}"
echo "conf_path: ${conf_path}"
echo "You can start by command 'nginx-start'"
echo "======================================"
echo ""

# >>>>>>>>>> START <<<<<<<<<<<
