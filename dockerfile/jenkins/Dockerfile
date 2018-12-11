FROM jenkins/jenkins:lts

USER root

RUN apt update && \
    apt install -y git wget python-pip openssh-client curl apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
    apt-get update && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt update && \
    apt  -y install docker-ce && \
    apt  update && \
    pip install logdna ansible && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
COPY casa.lan.CA.pem $JAVA_HOME/jre/lib/security
RUN cd $JAVA_HOME/jre/lib/security \
    && keytool -keystore cacerts -storepass changeit -noprompt -trustcacerts -importcert -alias casa.lan -file casa.lan.CA.pem
COPY casa.lan.CA.pem /usr/local/share/ca-certificates/casa.lan.CA.crt
RUN update-ca-certificates
#RUN dpkg-reconfigure ca-certificates

USER jenkins
