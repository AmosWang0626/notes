---
title: Linux 查看系统信息
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---

# Linux 查看系统信息

### 查看系统信息

`uname -a`

### 操作系统版本信息

- `cat /proc/version`

### CPU信息

- `lscpu`

### CPU核心数，型号

- `cat /proc/cpuinfo`

### 内核版本详细信息

> LSB(Linux Standard Base) 此命令适用于所有的Linux发行版本

- `lsb_release -a`

  ```
  LSB Version:    :core-4.1-amd64:core-4.1-noarch
  Distributor ID: CentOS
  Description:    CentOS Linux release 7.7.1908 (Core)
  Release:        7.7.1908
  Codename:       Core
  ```

### Linux当前操作系统发行版信息

- `cat /etc/redhat-release`

### 内存大小

- `cat /proc/meminfo |grep MemTotal`

### 带宽，网卡数

- `ifconfig` 或者 `ethtool eth0`

---

## uname 详解

### 全部信息: `uname -a`

- `Linux dudu 3.10.0-514.26.2.el7.x86_64 #1 SMP Tue Jul 4 15:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux`

### 硬件平台: `uname -i`

- `x86_64`

### 机器硬件（CPU）名: `uname -m`

- `x86_64`

### 节点名称: `uname -n`

- `dudu`

### 操作系统: `uname -o`

- `GNU/Linux`

### 系统处理器的体系结构: `uname -p`

- `x86_64`

### 操作系统的发行版号 `uname -r`

- `3.10.0-514.26.2.el7.x86_64`

### 系统名: `uname -s`

- `Linux`

### 内核版本: `uname -v`

- `#1 SMP Tue Jul 4 15:04:05 UTC 2017`

---