# Dockerfile
FROM c7:mfs
MAINTAINER liyang
ADD jdk-8u261-linux-x64.rpm /root/
RUN rpm -ivh /root/jdk-8u261-linux-x64.rpm
RUN yum -y install which
RUN rm -f /root/anaconda-ks.cfg
RUN rm -f /root/mfs.sh
RUN rm -f /root/jdk-8u261-linux-x64.rpm
ADD hadoop-2.9.2.tar /root/
RUN echo 'export JAVA_HOME=/usr/java/jdk1.8.0_261-amd64' >> /etc/profile
RUN echo 'export HADOOP_HOME=/root/hadoop-2.9.2' >> /etc/profile
RUN echo 'export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /etc/profile
RUN mkdir /hadoop

# create docker images with Dockerfile
docker build -t hadoop .

# create docker network with bridge
docker network create li --subnet=192.168.10.0/24

# create container with docker images
docker run -d -p 50070:50070 -v /hadoop:/hadoop --network li --ip 192.168.10.11 -h n11 --name n11 --privileged=true hadoop

# create hdfs cluster with docker images
hosts="--add-host n11:192.168.10.11 --add-host n12:192.168.10.12 --add-host n13:192.168.10.13"

mkdir /hadoop{1..3}

docker run -d -p 50070:50070 -v /hadoop1:/hadoop --network li --ip 192.168.10.11 -h n11 --name n11 $hosts --privileged=true hadoop
docker run -d -v /hadoop2:/hadoop --network li --ip 192.168.10.12 -h n12 --name n12 $hosts --privileged=true hadoop
docker run -d -v /hadoop3:/hadoop --network li --ip 192.168.10.13 -h n13 --name n13 $hosts --privileged=true hadoop
