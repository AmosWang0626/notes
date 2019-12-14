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

- Filesystem（文末做详细探究）
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



## Filesystem

### tmpfs

- tmpfs 是 Linux/Unix 系统上的一种基于内存的文件系统。 tmpfs 可以使用您的内存 或 swap 分区来存储文件。在 Redhat/CentOS 等 linux 发行版中默认大小为物理内存的一半。
- tmpfs 既可以使用物理内存，也可以使用交换分区，因为 tmpfs 使用的是“虚拟内存”。 Linux 内核的虚拟内存同时来源于物理内存和交换分区，主要由内核中的 VM 子系统进行调度，进行内存页和 SWAP 的换入和换出操作，tmpfs 自己并不知道这些页面是在交换分区还是在物理内存中。
- 如果你想使用 tmpfs ，那么最简单的办法就是直接将文件存放在 /dev/shm 下，虽然这并不是推荐的方案，因为 /dev/shm 是给共享内存分配的，共享内存是进程间通信的一种方式。

### overlay

- 堆叠文件系统（还拿上图为例）

  ![df -h](https://gitee.com/AmosWang/resource/raw/master/image/linux-df.png )

- 每启动一个 docker 容器，就会对应一个 overlay

- 以 docker 私有仓库 registry 镜像容器为例 `bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7`

```shell
[root@amos merged]# mount |grep overlay
overlay on /var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/merged type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay2/l/QBDC3JTO6OJCKBGECABICLCGQA:/var/lib/docker/overlay2/l/YPDPWIL42CORMMVBBPDPSWLEF4:/var/lib/docker/overlay2/l/TRWDRE65Z2R7EZ6RZMDZYXXWAV:/var/lib/docker/overla2/l/LFP3RV3DQMHSDYUIQZO6XI6GUA:/var/lib/docker/overlay2/l/CTA7FIGTQQGU6AFA2HS665N47Y:/var/lib/docker/overlay2/l/2UREITCJ5P36FBPLQQTCLY6Z55,upperdir=/var/lib/dockeroverlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/diff,workdir=/var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/work)
```

- 可以看到对应高亮的关键词：lowerdir、upperdir

  - 在merged目录下，用户会无感知地看到 upperdir、lowerdir...（可能含多个）目录下的内容
  - merged = upperdir + lowerdir... (同名文件选高层次文件)
  - 当 upperdir、lowerdir...目录文件有冲突时，会根据层次关系选择性屏蔽，当然lowerdir也有层次关系

  ![一探究竟](https://gitee.com/AmosWang/resource/raw/master/image/linux-df-overlay.png )

- 一探究竟

  - `cd /var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/`
  - lower：用来存储只读的信息，为了节省空间，用硬链接实现
    - 软链接：`lrwxrwxrwx` “ l ” 开头，类似快捷方式
    - 硬链接：`-rw-r--r--` “ - ” 开头，类似复制，但又能保持和源文件同步
  - diff：用来记录删除和修改的文件，而 merged 里能看到所有文件
  - merged：容器运行时存在， 能看到容器中所有的文件
