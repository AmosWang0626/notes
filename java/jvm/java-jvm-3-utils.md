---
title: Java JVM 监控工具
date: 2019-11-04
categories: Java
tags:
- jvm
---

# Java JVM 监控工具
- jps（JVM Process Status）
  - 虚拟机进程状态工具
  - JVM 版的 ps，显示所有虚拟机进程
  - `jps -l` 
- jstat（JVM Statistics Monitoring Tool）
  - 虚拟机统计信息监视工具
  - jstat [  option vmid [ interval [s|ms] [count] ]  ] 
  - vmid 进程号；interval  执行间隔；count 执行次数；
  - `jstat -gc 20295 250 10`
  - `jstata -options` 会输出所有选项 -gc、-class、-gcutil等等
- jinfo
  - java 配置信息工具，可以看到默认 JVM 配置信息
  - `jinfo -flags 20295`
  - `jinfo -flag NewSize 20295`
- jmap
  - java 内存映射工具
  - 1.用于生成堆转储快照（一般称为 heapdump 或者 heap 文件）
  - 2.查询finalize执行队列，java堆、空间使用率、当前使用收集器等
  - `jmap -dump:live,format=b,file=/home/hello-group/mgr-map.bin 23456`
- jhat
  - jmap生成的文件，可能会很大，几百MB
  - 分析堆转储快照，jhat内置微型http服务器，jhat 对应 dump文件，即可在浏览器访问
  - `jhat xxx.hprof` 然后就可在浏览器访问了 `http://localhost:7000`
  - 不推荐使用，比较麻烦；可使用 VisualVM 等
- jstack
  - Java 堆栈跟踪工具
  - `jstack -l 20295`
  - `jstack 136874 > /home/hello-group/mgr-23456-thread.txt`

## 参考文章

[jstack(查看线程)、jmap(查看内存)和jstat(性能分析)](https://www.cnblogs.com/panxuejun/p/6052315.html)
