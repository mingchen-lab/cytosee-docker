FROM ubuntu:16.04
MAINTAINER Yincong Zhou 'yczhou@zju.edu.cn'
COPY ./sources.list /etc/apt/
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y apt-utils dialog python-software-properties apt-transport-https software-properties-common \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && add-apt-repository -y 'deb [arch=amd64,i386] https://mirrors.ustc.edu.cn/CRAN/bin/linux/ubuntu xenial/' \
    && apt-get  update \
    && apt-get install -y wget r-base less sudo supervisor \
                       libcurl4-openssl-dev libssh2-1-dev libssl-dev libcgal-dev libglu1-mesa-dev libglu1-mesa-dev \
                       libcairo2-dev  libxt-dev gdebi-core  pandoc pandoc-citeproc libxml2-dev git


## add FIt-SNE
ADD http://www.fftw.org/fftw-3.3.8.tar.gz ./
RUN tar  -xzf fftw-3.3.8.tar.gz
RUN cd ./fftw-3.3.8 && ./configure  && make && make install \
    &&  cd ../ \
    && git clone https://github.com/KlugerLab/FIt-SNE.git \
    && cd ./FIt-SNE \
    && g++ -std=c++11 -O3  src/sptree.cpp src/tsne.cpp src/nbodyfft.cpp  -o bin/fast_tsne -pthread -lfftw3 -lm \
    && cp ./bin/fast_tsne /usr/local/bin/

    
COPY ./packages.R .


RUN Rscript packages.R \
    && rm packages.R 


COPY ./*.deb shiny-server.deb
RUN gdebi -n shiny-server.deb \
    && rm -f shiny-server.deb \
    && rm -rf /srv/shiny-server/*
COPY ./cytosee_shiny/* /srv/shiny-server/

# config for locale
RUN apt-get install -y locales locales-all \ 
	&&  apt-get autoremove
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


EXPOSE 3838

COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh 
CMD ["/usr/bin/shiny-server.sh"]
