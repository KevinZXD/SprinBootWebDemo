#! /bin/sh

pro=$(ps -ef | grep kafka-hbase-0.0.1-SNAPSHOT  | grep -v grep )
if [ "$pro" != "" ]
then
    echo "Application is running, do nothing"
else
    date +"%F %T restart demo"
    sh server.sh start
fi
