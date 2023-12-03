FROM ubuntu:20.04

ENV TZ=Europe/Moscow
ARG RANGER_VERSION=2.4.0
ARG DEBIAN_FRONTEND=noninteractive
ARG RANGER_USER=ranger
ARG RANGER_USER_PASS="{{ ranger_local_pass }}"
ARG HADOOP_VERSION=3.1.3

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV RANGER_HOME=/opt/apache-ranger/ranger-current-admin
ENV HADOOP_HOME=/opt/hadoop-default-current
ENV RANGER_HADOOP_CONF_DIR=/etc/hadoop-default

RUN apt update -y && \
    apt install -y  \
    openjdk-8-jdk  \
    tzdata \
    jq  \
    jsvc  \
    wget  \
    python  \
    python3.9  \
    net-tools  \
    unzip  \
    bc \
    mc \
    vim \
    curl \
    apt-transport-https \
    gnupg \
    ldap-utils \
    lsb-release && \
    rm -rf /var/lib/apt/lists/* && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    mkdir /opt/apache-ranger &&  \
    useradd -m -s /bin/bash $RANGER_USER && echo "$RANGER_USER:$RANGER_USER_PASS" | chpasswd && \
    mkdir -p /etc/hadoop-default && \
    cd /opt/apache-ranger && \
    wget https://apache-hadoop.ru/git/ranger-${RANGER_VERSION}-usersync.tar.gz && \
    tar -xzf ranger-${RANGER_VERSION}-usersync.tar.gz &&  \
    rm -rf ranger-${RANGER_VERSION}-usersync.tar.gz &&  \
    chmod 0777 /opt/apache-ranger/ranger-${RANGER_VERSION}-usersync/install.properties && \
    ln -s /opt/apache-ranger/ranger-${RANGER_VERSION}-usersync /opt/apache-ranger/ranger-current-usersync && \
    mkdir -p /opt/apache-ranger/ranger-current-usersync/jisql/lib && \
    cd /opt/apache-ranger/ranger-current-usersync/lib && \
    wget  https://jdbc.postgresql.org/download/postgresql-42.7.0.jar && \
    mv /opt/apache-ranger/ranger-current-usersync/lib/postgresql-42.2.12.jar /opt/apache-ranger/ranger-current-usersync/lib/postgresql.jar && \
    mkdir -p /etc/ranger/usersync/conf/cert && \
    ln -sf /etc/ranger/usersync/conf /opt/apache-ranger/ranger-current-usersync/conf && \
    mkdir -p /opt/apache-ranger/ranger-current-usersync/logs

WORKDIR /opt/apache-ranger/ranger-current-usersync

COPY setup.sh /opt/apache-ranger/ranger-current-usersync
COPY docker-entrypoint.sh /opt/apache-ranger/ranger-current-usersync
COPY core-site.xml /etc/hadoop-default

RUN chmod +x /opt/apache-ranger/ranger-current-usersync/docker-entrypoint.sh && \
    chmod +x /opt/apache-ranger/ranger-current-usersync/setup.sh && \
    chown -R $RANGER_USER: /opt/apache-ranger

#USER ranger

EXPOSE 5151


ENTRYPOINT /opt/apache-ranger/ranger-current-usersync/docker-entrypoint.sh
