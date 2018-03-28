#!/bin/bash

sudo apt update
sudo apt install urlview build-essentials git libgnutls-dev libcurl4-gnutls-dev gnutls-bin autoconf libncursesw5-dev libssl-dev libsasl2-dev libtokyocabinet-dev links libssl-dev libsasl2-dev xsltproc

cd /tmp#
git clone https://github.com/neomutt/neomutt
cd neomutt
./configure --disable-doc --ssl --gnutls --sasl --disable-nls
make
sudo make install
