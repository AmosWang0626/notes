#! /bin/sh


# 日志文件夹不存在则创建
if [ ! -d "/home/boot/logs" ]; then
  mkdir /home/boot/logs
fi


# 启动服务前先判断之前服务是否完全停止
location=`pwd`
var=`ps -ef|grep java|grep ${location}|awk '{print $2}'`

if [ $var ]
then

  echo 'please shutdown first!'

else

  nohup java -server \
  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/boot/logs \
  -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC \
  -Xloggc:/home/boot/logs/gc.log \
  -jar /home/boot/boot.jar >/home/boot/logs/stdout.log &

  echo 'start ok!'

fi
