FROM ubuntu:20.04

ENV TZ=Europe/Moscow
ARG RANGER_VERSION=2.4.0
ARG DEBIAN_FRONTEND=noninteractive
ARG RANGER_USER=ranger
ARG RANGER_USER_PASS="{{ ranger_local_pass }}"
ARG HADOOP_VERSION=3.1.3

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV RANGER_PARENT_DIR=/opt/apache-ranger
ENV RANGER_HOME=${RANGER_PARENT_DIR}/ranger-current-usersync
ENV RANGER_CONF_DIR_USERSYNC=/etc/ranger/usersync/conf
ENV HADOOP_HOME=/opt/hadoop-default-current
ENV HADOOP_CONF_DIR=/etc/hadoop-default

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
    mkdir ${RANGER_PARENT_DIR} &&  \
    useradd -m -s /bin/bash $RANGER_USER && echo "$RANGER_USER:$RANGER_USER_PASS" | chpasswd && \
    mkdir -p ${HADOOP_CONF_DIR} && \
    cd ${RANGER_PARENT_DIR} && \
    wget https://apache-hadoop.ru/git/ranger-${RANGER_VERSION}-usersync.tar.gz && \
    tar -xzf ranger-${RANGER_VERSION}-usersync.tar.gz &&  \
    rm -rf ranger-${RANGER_VERSION}-usersync.tar.gz &&  \
    chmod 0777 ${RANGER_PARENT_DIR}/ranger-${RANGER_VERSION}-usersync/install.properties && \
    ln -s ${RANGER_PARENT_DIR}/ranger-${RANGER_VERSION}-usersync ${RANGER_HOME} && \
    mkdir -p ${RANGER_HOME}/jisql/lib && \
    cd ${RANGER_HOME}/lib && \
    wget  https://jdbc.postgresql.org/download/postgresql-42.7.0.jar && \
    mv ${RANGER_HOME}/lib/postgresql-42.2.12.jar ${RANGER_HOME}/lib/postgresql.jar && \
    mkdir -p ${RANGER_CONF_DIR_USERSYNC}/cert && \
    ln -sf ${RANGER_CONF_DIR_USERSYNC} ${RANGER_HOME}/conf && \
    mkdir -p ${RANGER_HOME}/logs

WORKDIR ${RANGER_HOME}

COPY setup.sh ${RANGER_HOME}
COPY docker-entrypoint.sh ${RANGER_HOME}
COPY core-site.xml ${HADOOP_CONF_DIR}

RUN chmod +x ${RANGER_HOME}/docker-entrypoint.sh && \
    chmod +x ${RANGER_HOME}/setup.sh && \
    chown -R $RANGER_USER: ${RANGER_PARENT_DIR}

#USER ranger

EXPOSE 5151


ENTRYPOINT ${RANGER_HOME}/docker-entrypoint.sh
