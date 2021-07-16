FROM ubuntu : bionic
WORKDIR /root/

RUN apt-get update -y \
    && apt-get install -y vim net-tools curl zip telnet unzip wget openssh-server --no-install-recommends\
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#ssh creation  
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    mkdir -p /var/run/sshd

# Docker Installation
#https://docs.docker.com/install/linux/docker-ce/centos/
RUN apt-get update -y \
    && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common --no-install-recommends\
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" \
    && apt-get install -y docker-ce=5:18.09.0~3-0~ubuntu-bionic docker-ce-cli=5:18.09.0~3-0~ubuntu-bionic containerd.io --no-install-recommends\
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#openJDK installation, maven, git, openssl
RUN apt-get update && apt-get install -y openjdk-8-jdk maven git openssl --no-install-recommends\
    && apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

#ssh-keygen
RUN ssh-keygen -t rsa -N '' -f id_rsa
RUN cat >> /root/authorized_keys -t /root/id_rsa.pub
RUN cd /root
RUN mkdir .ssh && \
mv id_rsa .ssh && \
mv id_rsa.pub .ssh && \
mv authorized_keys .ssh

USER root

# Standard SSH port
EXPOSE 22 

# Default command
CMD ["/usr/sbin/sshd", "-D"]
	