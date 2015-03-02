FROM ubuntu:12.04
MAINTAINER Uned Technolegau Iaith <techiaith@bangor.ac.uk>

RUN apt-get update && apt-get install -q -y \
	unzip \
	make \
	g++ \
	wget \
	git \
	mercurial \
	bzip2 \
	autotools-dev \
	automake \
	libtool \
	zlib1g-dev \
	libbz2-dev \
	libboost-all-dev \
	libxmlrpc-core-c3-dev \
	libxmlrpc-c3-dev
ENV LANGUAGE cy_GB.UTF-8
ENV LANG cy_GB.UTF-8
ENV LC_ALL cy_GB.UTF-8 
RUN locale-gen cy_GB.UTF-8
RUN dpkg-reconfigure locales

RUN mkdir -p /home/moses
WORKDIR /home/moses
RUN mkdir moses-smt
RUN mkdir moses-models

COPY mtdk/mt_download_engine.sh /home/moses/moses-smt/mt_download_engine.sh 
COPY server.py /home/moses/moses-smt/server.py
COPY docker-moses.py /home/moses/moses-smt/moses.py

# lawrlwytho snapshot RELEASE-1.0 moses
RUN wget https://github.com/moses-smt/mosesdecoder/archive/RELEASE-1.0.zip
RUN unzip RELEASE-1.0.zip
RUN rm RELEASE-1.0.zip
RUN mv mosesdecoder-RELEASE-1.0 mosesdecoder

RUN wget http://giza-pp.googlecode.com/files/giza-pp-v1.0.7.tar.gz 
RUN tar zxvf giza-pp-v1.0.7.tar.gz
RUN cd giza-pp && make && cd ..
RUN mkdir external-bin-dir
RUN cp giza-pp/GIZA++-v2/GIZA++ external-bin-dir
RUN cp giza-pp/GIZA++-v2/snt2cooc.out external-bin-dir
RUN cp giza-pp/mkcls-v2/mkcls external-bin-dir
RUN wget "http://downloads.sourceforge.net/project/irstlm/irstlm/irstlm-5.70/irstlm-5.70.04.tgz?r=&ts=1342430877&use_mirror=kent"
RUN mv irstlm-5.70.04.tgz\?r\=\&ts\=1342430877\&use_mirror\=kent irstlm-5.70.04.tgz
RUN tar zxvf irstlm-5.70.04.tgz

WORKDIR /home/moses/irstlm-5.70.04

RUN /bin/bash -c "source regenerate-makefiles.sh"
RUN ./configure -prefix=/home/moses/irstlm
RUN make
RUN make install

# Adeiladu mosesdecoder
ENV IRSTLM /home/moses/irstlm
WORKDIR /home/moses/mosesdecoder
RUN ./bjam -a --with-irstlm=/home/moses/irstlm --serial --with-xmlrpc-c=/usr/

WORKDIR /home/moses/moses-smt

EXPOSE 8008
EXPOSE 8080

ENTRYPOINT ["python", "moses.py"]

