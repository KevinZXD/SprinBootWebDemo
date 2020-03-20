#!/bin/sh

#java虚拟机启动参数
JAVA_OPTS="-ms4096m -mx10240m -Xmn2048m -XX:MaxPermSize=2048m"
PID_FILE="./application.pid"

psid=0
checkpid() {
   if [ -e "$PID_FILE" ]; then
      psid=`cat $PID_FILE`
   else
      psid=0
   fi
}

###################################
#(函数)启动程序
#注意: "nohup 某命令 >/dev/null 2>&1 &" 的用法
###################################
start() {
   pro=$(ps -ef | grep demo-0.0.1-SNAPSHOT  | grep -v grep)
   if [ "$pro" != "" ]
   then
      checkpid
      echo "================================"
      echo "warn: application already started! (pid=$psid)"
      echo "================================"
   else
      echo "Starting ..."
      nohup java -jar demo-0.0.1-SNAPSHOT.jar $JAVA_OPTS >> logs/log.log 2>&1 &
      sleep 2
      checkpid
      if [ $psid -ne 0 ]; then
         echo "(pid=$psid) [OK]"
      else
         echo "[Failed]"
      fi
   fi
}

###################################
# 停止程序
###################################
stop() {
   checkpid
   if [ $psid -ne 0 ]; then
       echo "Stopping ..."
       kill -9 $psid
       rm -rf $PID_FILE
   else
       echo "================================"
       echo "warn: application not started! (pid=$psid)"
       echo "================================"
   fi
}

case "$1" in
    'start')
        start
        ;;
    'stop')
        stop
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
