FROM centos7-systemd:latest

# Install repo for latest git
COPY wandisco-git.repo /etc/yum.repos.d/wandisco-git.repo
RUN rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco

# Install some basics
RUN yum install -y sudo wget vim git

# Install dependencies to build python
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel make

# Download and extract Python 2.7 source
WORKDIR /tmp
RUN wget https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz
RUN tar xzvf Python-2.7.16.tgz

# Compile and install python
WORKDIR ./Python-2.7.16
RUN ./configure --with-ensurepip=install
RUN make -j 8
RUN make install

# Remove python source
WORKDIR /tmp
RUN rm -rf Python-2.7.16 Python-2.7.16.tgz

# Change workdir back to /root
WORKDIR /root
