---
title: Java 线上问题排查
date: 2019-11-04
categories: Java
tags:
- gc
- jvm
- 精选文章
---

# Java 线上问题排查

## 一、内存监控 free
- `free -h` （`h`也即human，人性化展示）MB、GB之类的
- `free -m` 以MB的方式展示，适合**内存**变化粒度较小时使用
- `free -g` 以GB方式展示，目测不常用

## 二、磁盘监控

### 2.1 df

- `df -h` 人性化展示

![df -h](https://gitee.com/AmosWang/resource/raw/master/image/linux-df.png )

- [Filesystem](https://github.com/AmosWang0626/notes/blob/master/dev.ops/linux/linux-filesystem.md)
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

## 三、进程管理 htop

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

## 四、缓存相关
- `wget https://silenceshell-1255345740.cos.ap-shanghai.myqcloud.com/hcache)`
- `chmod +x hcache`
- `mv hcache /usr/local/bin/`
- `hcache --top 10`

### 参考文章

- [Linux top命令参数及使用方法详解](http://linuxeye.com/command/top.html)

- [htop使用详解](https://www.cnblogs.com/yqsun/p/5396363.html)

