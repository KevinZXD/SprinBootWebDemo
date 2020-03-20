# SprinBootWebDemo


## 服务器部署
   (yf机房)
    （阿里云)

## 目录结构
    server.sh 负责程序的启动和停止
        ./server.sh start
        ./server.sh stop

    monitor.sh 提供给crontab调用，负责服务的故障重启
    demo-0.0.1-SNAPSHOT.jar 项目包
    # 配置文件目录
    conf/
        # 主配置文件
        application.properties
        # 开发环境配置文件
        application-dev.properties
        # 线上服务配置文件
        application-prod.properties
    # 日志文件
    logs/
        # 普通日志文件
        log.log
        # qps日志文件, 记录服务的处理速度以及错误数
        qps.log

## 部署方式
    1. mvn -DskipTests=true package
        target/目录先会出现打包好的 demo-0.0.1-SNAPSHOT.jar 文件
    2. 建立conf目录，并将源码下： /src/java/resources/*.properties 拷贝到conf/中
    3. 建立logs目录

    老的监控方式
        将server.sh、monitor.sh拷贝到demo-0.0.1-SNAPSHOT.jar所在的目录
        在当前目录下执行: ./server.sh start  启动服务
        进程监控：crontab：*/5 * * * * sh (monitor.sh文件的绝对路径)

    systemctl监控
        在目录/usr/bin/systemd/system/下新建文件: kafka-hbase.service
        文件内容：
            	[Unit]
            	Description=demo Java Service

            	[Service]
            	Restart=always
            	RestartSec=3
            	WorkingDirectory=/data1/demo
            	ExecStart=/usr/java/jdk1.8.0_131/bin/java  \
            	        -ms4096m \
            	        -mx10240m \
            	        -Xmn2048m \
            	        -XX:MaxPermSize=2048m \
            	        -jar /data1/demo/demo-0.0.1-SNAPSHOT.jar
            	KillSignal=SIGINT
            	Type=simple

            	[Install]
            	WantedBy=multi-user.target
        启动服务:
            systemctl start demo

        查看日志：
            journalctl -u demo -f

## 项目简单介绍
    1. 该项目基于Spring boot框架构建
    2. 运行模式采用了多线程的模式，线程各自持有到kafka集群和hbase集群的连接，因此服务会建立多个到不同集群的连接
