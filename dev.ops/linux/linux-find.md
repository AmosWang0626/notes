---
title: Linux 查找
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---

# Linux 查找

## 1. `which`

> 在$PATH目录下查找文件

- $PATH `(/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin)`
- 一般是用来**搜索命令**用的。主要是**查看命令的完整路径**
- 文件名完全匹配、有后缀名也不行、遍历$PATH、找到一个匹配的文件即退出。

## 2. `whereis`

> 在预定目录下查找文件

- 预定目录可用 `whereis -l`
- 文件名完全匹配、但可有后缀名、遍历包含$PATH的多个目录、找出所有匹配文件
- 和which类似，只是多了源代码文件和手册文件搜索。

## 3. `locate`

> 在数据库中查找目录或文件，速度超快

- 需要安装 `yum install mlocate`
  
- 安装完需要先刷新数据库 `updatedb`

  ```shell
  $ locate /etc/*network
  /etc/rc.d/init.d/network
  /etc/rc.d/rc0.d/K90network
  /etc/rc.d/rc2.d/S10network
  /etc/selinux/targeted/active/modules/100/sysnetwork
  /etc/selinux/targeted/tmp/modules/100/sysnetwork
  /etc/sysconfig/network
  $ locate /etc/*S*network
  /etc/rc.d/rc2.d/S10network
  ```

## 4. `find`

> 非常强大，只是要扫描磁盘，速度会慢些

- 完全匹配，支持模糊查询，只找文件（可加 `-type d` 找目录）

  ```shell
  $ find -name boot*.*
  ./boot-2019.zip
  $ find / -name boot*.*
  /home/boot-2019.zip
  $ find /opt/hexo/hexoui/ -type d -name docker
  /opt/hexo/hexoui/source/_posts/notes/docker
  $ find /opt/hexo/hexoui/ -name java-*.md  
  /opt/hexo/hexoui/source/_posts/notes/java/java-gc-01.md
  /opt/hexo/hexoui/source/_posts/notes/java/java-gc-02.md
  ```
