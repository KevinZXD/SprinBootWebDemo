#!/bin/sh

# 打包项目
mvn -DskipTests=true package

mkdir release
cp target/demo-0.0.1-SNAPSHOT.jar release/
cp server.sh release/
cp monitor.sh release/

cd release
mkdir conf
mkdir logs

#cp ../src/main/resources/* conf/

tar -zcf demo.tar *

echo "Build successed, tar file is: demo.tar"
