#!/bin/bash

mkdir -p /tmp/rom
cd /tmp/rom

up(){
	curl --upload-file $1 https://transfer.sh/$(basename $1); echo
	# 14 days, 10 GB limit
}

up out/target/product/mojito/*.zip && up out/target/product/mojito/*.img
ccache -s

cd /tmp

com () 
{ 
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

time com ccache 1 # Compression level 1, its enough

mkdir -p ~/.config/rclone
echo "$rclone_config" > ~/.config/rclone/rclone.conf
time rclone copy ccache.tar.gz dblenk:ccache -P