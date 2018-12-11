#FROM centos:centos7
FROM afbjorklund/centos-jnlp-slave
MAINTAINER Marcos Gabriel <marcos.silva.gabriel@everis.com>

#
# Ansible and misc tools setup
#
USER root
# Install EPEL
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y yum-utils device-mapper-persistent-data lvm2 java-1.8.0-openjdk-headless kubernetes-ansible.noarch openssh-server git sshpass inotify-tools maven sshpass passwd git wget openopenssh-clients coreutils wget bzip2 unzip xz tar ansible python-pip python-devel && \
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
    yum install docker-ce -y && \
    yum clean all && \
    rm -Rf /var/cache/yum/* 
COPY casa.lan.CA.pem /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust
#Env Docker Jenkins and Ansible 
ENV ANSIBLE=/etc/ansible
ENV LANG=en_US.UTF-8
ENV HOME=/home/jenkins

#Add User Jenkins
#RUN groupadd -g 10000 jenkins
#RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins
#Download Jenkins Slave
ARG VERSION=3.7
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
    && chmod 755 /usr/share/jenkins \
    && chmod 644 /usr/share/jenkins/slave.jar \
    && mkdir /home/jenkins/.ssh
COPY id_rsa.pub /home/jenkins/.ssh/authorized_keys
COPY id_rsa /home/jenkins/.ssh/id_rsa
RUN mkdir /var/run/sshd \
    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
    && chown -R jenkins:jenkins /etc/ansible /home/jenkins \
    && chmod 700 -R /home/jenkins/.ssh
USER jenkins
COPY jenkins-slave /usr/local/bin/jenkins-slave
#RUN chmod 775 /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
