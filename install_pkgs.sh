#!/usr/bin/env bash

# install chinadns
wget https://github.com/shadowsocks/ChinaDNS/releases/download/1.3.2/chinadns-1.3.2.tar.gz
tar -xvf chinadns-1.3.2.tar.gz 
cd chinadns-1.3.2/
./configure
make
make install
cd ../
rm -rf chinadns-1.3.2*

# prepare compile environment
export ENV LIBSODIUM_VER=1.0.13
wget https://download.libsodium.org/libsodium/releases/libsodium-${LIBSODIUM_VER}.tar.gz
tar xvf libsodium-${LIBSODIUM_VER}.tar.gz
cd libsodium-${LIBSODIUM_VER}
./configure --prefix=/usr  
make  
make install
ldconfig  
cd ../  
rm -rf libsodium-*

export MBEDTLS_VER=2.6.0
wget https://tls.mbed.org/download/mbedtls-${MBEDTLS_VER}-gpl.tgz
tar xvf mbedtls-${MBEDTLS_VER}-gpl.tgz
cd mbedtls-${MBEDTLS_VER}
make SHARED=1 CFLAGS=-fPIC
make DESTDIR=/usr install
ldconfig  
cd ../  
rm -rf mbedtls-*

# install  shadowsocks
git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
./autogen.sh
./configure  
make  
make install
cd ../  
rm -rf shadowsocks-libev

# install shadowsocksR
git clone https://github.com/shadowsocksr-backup/shadowsocksr-libev.git
cd shadowsocksr-libev
./autogen.sh
./configure --prefix=/usr/local/ssr-libev
make
make install
cd ../  
rm -rf shadowsocksr-libev 
cd /usr/local/ssr-libev/bin
mv ss-redir ssr-redir
mv ss-local ssr-local
ln -sf ssr-local ssr-tunnel
mv ssr-* /usr/local/bin/
rm -rf /usr/local/ssr-libev
cd $1

# install ss-redir
git clone https://github.com/zfl9/ss-tproxy.git 
cd ss-tproxy 
cp -af ss-tproxy /usr/local/bin/
cp -af ss-switch /usr/local/bin/
chown root:root /usr/local/bin/ss-tproxy /usr/local/bin/ss-switch
chmod +x /usr/local/bin/ss-tproxy /usr/local/bin/ss-switch
mkdir -m 0755 -p /etc/tproxy
cp -af pdnsd.conf /etc/tproxy/
cp -af chnroute.txt /etc/tproxy/
cp -af chnroute.ipset /etc/tproxy/
cp -af ss-tproxy.conf /etc/tproxy/
chown -R root:root /etc/tproxy
chmod 0644 /etc/tproxy/* 
cd ../  
rm -rf  ss-tproxy

ss-tproxy flush_dnsche
ss-tproxy update_chnip