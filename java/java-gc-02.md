---
title: Java GC 学习实践(下)
date: 2019-11-04
categories: Java
tags:
- gc
- jvm
---

> 接着上篇，本篇重点在于项目运行监控
>
> [Java GC 学习实践（上）](https://my.oschina.net/AmosWang/blog/3125881 "Java GC 学习实践（上）")

# Java GC 学习实践（下）
1. [浅谈基础](https://my.oschina.net/AmosWang/blog/3125881#h1_2)
2. [解析 GC 日志](https://my.oschina.net/AmosWang/blog/3125881#h1_18)
3. JVM 监控工具
4. Linux 监控相关

# 三、JVM 监控工具

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
- jhat
  - jmap生成的文件，可能会很大，几百MB
  - 分析堆转储快照，jhat内置微型http服务器，jhat 对应 dump文件，即可在浏览器访问
  - `jhat xxx.hprof` 然后就可在浏览器访问了 `http://localhost:7000`
  - 不推荐使用，比较麻烦；可使用 VisualVM 等
- jstack
  - Java 堆栈跟踪工具
  - `jstack -l 20295`

# 四、Linux 监控相关

## 1. 内存监控

### 1.1 free

- `free -h` （`h`也即human，人性化展示）MB、GB之类的
- `free -m` 以MB的方式展示，适合**内存**变化粒度较小时使用
- `free -g` 以GB方式展示，目测不常用

## 2. 磁盘监控

### 2.1 df

- `df -h` 人性化展示

![df -h](https://gitee.com/AmosWang/resource/raw/master/image/linux-df.png )

- [Filesystem](../system/linux-filesystem.md)
  - tmpfs：Linux/Unix 系统上的一种基于内存的文件系统
  - devtmpfs：负责设备文件创建的管理工作，缩短开机时间
  - overlay：堆叠文件系统，Docker 使用overlay来构建和管理镜像与容器的磁盘结构
- used：使用掉的硬盘空间
- available：剩下的磁盘空间大小
- use%：磁盘使用率
- mounted on：磁盘挂载的目录所在（挂载点）

### 2.2 du

![du](https://gitee.com/AmosWang/resource/raw/master/image/linux-du.png )

- `du -xxx [option: PATH]` PATH 表示指定文件夹（默认为当前文件夹）
- `du -ah /opt/xxx` 显示全部文件夹、子文件夹、文件大小
- `du -sh /opt/xxx` 显示文件夹大小
- `du -Sh /opt/xxx` 显示文件夹、子文件夹大小

## 3. 进程管理

### 3.1 htop

- 较 `top` 功能强大些，**交互式**动态监控页面，如果没安装 `yum install htop`

- htop 进入后，如有不清楚的，`F1` 会进入help页面

  ![htop help](https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-f1.png)

  ---

- 找了三张图类比下（1 vCPU, 2GB内存；2 vCPU, 2GB内存；16核 CPU,64GB内存）

  ![1CPU, 2GB内存](https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-info-1.png )

  ---

  ![2CPU, 2GB内存](https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-info-2.png )

  ---

  ![2CPU, 2GB内存](https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-info-3.png )

  ---

- 左上：

  - CPU、内存、交换分区的使用情况；

- 右上：

  - Tasks为进程总数，当前运行的进程数；
  - Load average为系统1分钟，5分钟，10分钟的平均负载情况；
  - Uptime为系统运行的时间；

- 下边：

  - PID：进程的标识号
  - USER：运行此进程的用户
  - PRI：进程的优先级
  - NI：nice值。负值表示高优先级，正值表示低优先级，默认的为0
  - VIRT：进程占用的虚拟内存值
  - RES：进程占用的物理内存值
  - SHR：进程占用的共享内存值
  - S：进程的运行状况，R表示正在运行、S表示休眠，等待唤醒、Z表示僵死状态
  - %CPU：该进程占用的CPU使用率
  - %MEM：该进程占用的物理内存和总内存的百分比
  - TIME+：该进程启动后占用的总的CPU时间
  - COMMAND：进程启动的启动命令名称

### 参考文章

- [Linux top命令参数及使用方法详解](http://linuxeye.com/command/top.html)

- [htop使用详解](https://www.cnblogs.com/yqsun/p/5396363.html)

