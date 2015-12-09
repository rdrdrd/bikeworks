#!/usr/bin/env bash
# 2015-12-04
#
# Install Motion packages for Raspberry Pi

sudo apt-get install -y libjpeg62 \
libjpeg62-dev \
libavformat53 \
libavformat-dev \
libavcodec53 \
libavcodec-dev \
libavutil51 \
libavutil-dev \
libc6-dev \
zlib1g-dev \
libmysqlclient-dev \
libpq5 \
libpq-dev

cd $HOME/Desktop
wget https://dropbox.com/s/xdfcxm5hu71s97d/motion-mmal.tar.gz
tar zxf motion-mmal.tar.gz
sudo mv motion /usr/bin/motion
sudo mv motion-mmalcam.conf /etc/motion.conf
sudo chown root:root /usr/bin/motion
