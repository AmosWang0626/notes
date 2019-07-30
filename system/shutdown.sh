#!/bin/bash

time=$(date "+%Y%m%d-%H%M")
location=`pwd`


#备份对应的日志文件
zip -r -q -o ${location}/logs/${time}-stdout.zip ${location}/logs/stdout.log 
zip -r -q -o ${location}/logs/${time}-gc.zip ${location}/logs/gc.log

#kill 进程
kill -9 `ps -ef|grep java|grep ${location}|awk '{print $2}'`

#检查进程是否关闭正常
var=`ps -ef|grep java|grep ${location}|awk '{print $2}'`
if [ $var ]
then
	echo 'process closure exception!'
else
	echo 'shutdown ok!'
fi

