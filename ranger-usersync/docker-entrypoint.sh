#!/bin/bash
set -xe

./setup.sh && \
rm -rf /opt/apache-ranger/ranger-current-usersync/conf/core-site.xml && cp /etc/hadoop-default/core-site.xml /opt/apache-ranger/ranger-current-usersync/conf/core-site.xml
/opt/apache-ranger/ranger-current-usersync/ranger-usersync-services.sh start && \
tail -f /opt/apache-ranger/ranger-current-usersync/logs/usersync-*.log
