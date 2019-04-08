FROM ubuntu:18.04
ARG branch=master

RUN apt-get update && apt-get install -y libcurl4-openssl-dev && apt-get install -y libusb-1.0-0-dev && apt-get install -y git && apt-get install sudo -y

RUN git clone -b $branch https://github.com/EOSIO/eos.git --recursive \
    && cd eos && echo "$branch:$(git rev-parse HEAD)" > /etc/eosio-version \
    && cd scripts && ./eosio_build.sh -y && ./eosio_install.sh -y

# Get g++ for compiling, wget to download Boost, git to clone source code repo,
# and make to automate program compilation with Makefile provided
RUN apt-get update \
  && apt-get install -y g++ \
                        make \
                        wget
                        
RUN wget https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2
RUN tar --bzip2 -xf boost_1_67_0.tar.bz2
RUN cd boost_1_67_0 && ./bootstrap.sh && ./b2 install

RUN apt-get install -y lcov && apt-get install -y llvm

RUN wget https://cmake.org/files/v3.13/cmake-3.13.4.tar.gz
RUN tar -zxvf cmake-3.13.4.tar.gz
RUN cd cmake-3.13.4 && ./bootstrap && make && make install
RUN cmake --version
RUN ln -s /opt/cmake-3.13.4/bin/* /usr/local/bin

RUN wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.4.1/eosio.cdt-1.4.1.x86_64.deb
RUN apt-get install -y ./eosio.cdt-1.4.1.x86_64.deb

RUN apt-get install -y dos2unix