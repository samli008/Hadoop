# Dockerfile
FROM c7:mfs
MAINTAINER liyang
ADD jdk-8u261-linux-x64.rpm.tar /root/
RUN rpm -ivh /root/jdk-8u261-linux-x64.rpm
RUN rm -f /root/anaconda-ks.cfg
RUN rm -f /root/mfs.sh
RUN rm -f /root/jdk-8u261-linux-x64.rpm
ADD hadoop-2.9.2.tar.gz /root/
RUN echo 'export JAVA_HOME=/usr/java/jdk1.8.0_261-amd64' >> /etc/profile
RUN echo 'export HADOOP_HOME=/root/hadoop-2.9.2' >> /etc/profile
RUN echo 'export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /etc/profile

# create docker images with Dockerfile
docker build -t hadoop .

# create docker network with bridge
docker network create li --subnet=192.168.10.0/24

# create container with docker images
docker run -d --network li --ip 192.168.10.11 -h n11 --name n11 --privileged=true hadoop
