#!/bin/sh
set -e # exit on failure

cd $HOME

wget https://github.com/moses-smt/mosesdecoder/archive/RELEASE-1.0.zip
unzip RELEASE-1.0.zip
rm RELEASE-1.0.zip
mv mosesdecoder-RELEASE-1.0 mosesdecoder

wget http://giza-pp.googlecode.com/files/giza-pp-v1.0.7.tar.gz
tar zxvf giza-pp-v1.0.7.tar.gz
cd giza-pp
make
cd ..
mkdir external-bin-dir
cp giza-pp/GIZA++-v2/GIZA++ external-bin-dir
cp giza-pp/GIZA++-v2/snt2cooc.out external-bin-dir
cp giza-pp/mkcls-v2/mkcls external-bin-dir
wget "http://downloads.sourceforge.net/project/irstlm/irstlm/irstlm-5.70/irstlm-5.70.04.tgz?r=&ts=1342430877&use_mirror=kent"
mv irstlm-5.70.04.tgz\?r\=\&ts\=1342430877\&use_mirror\=kent irstlm-5.70.04.tgz
tar zxvf irstlm-5.70.04.tgz
cd irstlm-5.70.04
./regenerate-makefiles.sh
./configure -prefix=$HOME/irstlm
make
make install
export IRSTLM=$HOME/irstlm
cd ..
cd mosesdecoder

./bjam -a --with-irstlm=$HOME/irstlm --serial --with-xmlrpc-c=/usr/

cd ..
mkdir moses-models

cd -
