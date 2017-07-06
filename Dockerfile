FROM centos

MAINTAINER DevOps

RUN yum -y install initscripts && yum clean all
RUN yum install vim -y && yum install wget -y && yum install net-tools -y && yum install java-1.7.0-openjdk-devel -y && yum install screen -y && yum install elinks -y && yum install zip unzip -y && yum install gcc -y && yum install telnet -y && yum install git -y && yum install mlocate -y && yum install memcached -y && updatedb 

RUN mkdir -p /usr/local/elasticsearch && mkdir -p /root/.ssh && mkdir -p /root/restart_script

ADD hkweb /usr/local/projects/hkweb
ADD tomcat_web /usr/local/projects/tomcat_web
ADD edge /usr/local/projects/edge
ADD Deploy_Restart_All.sh /root/restart_script/Deploy_Restart_All.sh
ADD Restart_All.sh /root/restart_script/Restart_All.sh

ADD id_rsa /root/.ssh/id_rsa 
ADD id_rsa.pub /root/.ssh/id_rsa.pub
ADD config /root/.ssh/config
RUN chown -R root:root /root/.ssh
RUN chmod 400  /root/.ssh/id_rsa.pub
RUN chmod 400 /root/.ssh/id_rsa 
RUN chmod 400 /root/.ssh/config
RUN chown -R root:root /usr/local/projects/edge
ADD wildfly.conf /etc/default/wildfly.conf
RUN chmod +x /etc/default/wildfly.conf
RUN chown -R root:root /usr/local/projects
RUN chmod +x /root/restart_script/Deploy_Restart_All.sh
RUN chmod +x /root/restart_script/Restart_All.sh

RUN wget http://192.168.70.254/pub/ISOnREPO/repo/elasticsearch/data.tar.gz -P /root/ && tar -xvzf /root/data.tar.gz -C /root/ && rm -rf /root/data.tar.gz && mv /root/data /usr/local/elasticsearch/

RUN wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.4.3.noarch.rpm && rpm -Uivh elasticsearch-1.4.3.noarch.rpm && rm -f elasticsearch-1.4.3.noarch.rpm

RUN wget http://192.168.70.254/pub/ISOnREPO/repo/elasticsearch/elasticsearch.yml && mv /elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

RUN wget https://archive.apache.org/dist/ant/binaries/apache-ant-1.8.0-bin.tar.gz && tar -xvzf apache-ant-1.8.0-bin.tar.gz && rm -f apache-ant-1.8.0-bin.tar.gz && mv apache-ant-1.8.0 /usr/local/

RUN wget https://services.gradle.org/distributions/gradle-2.10-all.zip && unzip gradle-2.10-all.zip && rm -f gradle-2.10-all.zip && mv gradle-2.10 /usr/local/

RUN wget https://nodejs.org/dist/v0.10.35/node-v0.10.35-linux-x64.tar.gz && tar -xvzf node-v0.10.35-linux-x64.tar.gz && rm -f node-v0.10.35-linux-x64.tar.gz && mv node-v0.10.35-linux-x64 node-v0.10.35 && mv node-v0.10.35 /usr/local

RUN wget http://192.168.70.254/pub/ISOnREPO/wildfly.tar.gz -P /root/ && tar -xvzf /root/wildfly.tar.gz -C /root/ && rm -rf /root/wildfly.tar.gz && mv /root/wildfly /usr/local/ && cp /usr/local/wildfly/bin/init.d/wildfly-init-redhat.sh /etc/init.d/wildfly

RUN chown -R root:root /usr/local/wildfly
RUN chown -R root:root /usr/local/elasticsearch
#RUN wget http://192.168.70.254/pub/ISOnREPO/hkart_docker/Deploy_Restart_All.sh -P /root/restart_script
#RUN wget http://192.168.70.254/pub/ISOnREPO/hkart_docker/Restart_All.sh -P /root/restart_script
ENV GRADLE_HOME=/usr/local/gradle-2.10
ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0
ENV ANT_HOME=/usr/local/apache-ant-1.8.0
ENV PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:$ANT_HOME/bin:$JAVA_HOME/bin:/usr/local/node-v0.10.35/bin:$GRADLE_HOME/bin

RUN npm install -g grunt-cli

#ENTRYPOINT service elasticsearch start && bash

