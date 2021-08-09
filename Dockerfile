FROM centos:centos7

# Install repo for latest git
COPY wandisco-git.repo /etc/yum.repos.d/wandisco-git.repo
RUN rpm --import http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco

# Install some basics
RUN yum install -y sudo wget vim git

# Install dependencies to build python
RUN yum install -y gcc openssl-devel bzip2-devel libffi-devel zlib-devel make

# Download and extract Python 3.7 source
WORKDIR /tmp
RUN wget https://www.python.org/ftp/python/3.7.11/Python-3.7.11.tgz
RUN tar xzvf Python-3.7.11.tgz

# Compile and install python
WORKDIR ./Python-3.7.11
RUN ./configure --with-ensurepip=install
RUN make -j 8
RUN make altinstall

# Remove python source
WORKDIR /tmp
RUN rm -rf Python-3.7.11 Python-3.7.11.tgz

# Install SSH
RUN yum install -y openssh-server

# Generate host keys
RUN ssh-keygen -A

# Permit root login
RUN sed -i "s/#PermitRootLogin/PermitRootLogin/g" /etc/ssh/sshd_config

# Expose ssh port
EXPOSE 22

# Expose http and https ports
EXPOSE 80 443

# Set root password
ENV password=password123
RUN echo "$password" | passwd root --stdin

# Start as machine container
CMD /usr/sbin/init
