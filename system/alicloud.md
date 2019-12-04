---
title: 系统相关 阿里云服务器
date: 2019-01-01
categories: system
tags:
- 系统相关
- 阿里云
---

## 阿里云服务器ssh过一段时间就断开连接

```
vim /etc/ssh/sshd_config

找到下面两行
#ClientAliveInterval 0
#ClientAliveCountMax 3

去掉注释，改成
ClientAliveInterval 30
ClientAliveCountMax 86400

这两行的意思分别是

1、客户端每隔多少秒向服务发送一个心跳数据
2、客户端多少秒没有相应，服务器自动断掉连接

重启sshd服务

service sshd restart
```

## 使用Navicat连接阿里云数据库，长时间无操作，继续操作，断开连接
> 右键连接 > 编辑连接 > 高级 > 勾选保持连接间隔(秒) 设置相应的时间【例如：1800(30分钟)】

## 在线升级Linux
> 可参考system下nginx.md

## 升级系统内核
```
yum -y update(所有都升级和改变)
升级所有包、系统版本和内核，改变软件设置和系统设置
yum -y upgrade(不变内核和设置,升级包和系统版本)
升级所有包、系统版本，不改变内核、软件和系统设置
```

## [阿里云-Redis服务安全加固](https://help.aliyun.com/knowledge_detail/37447.html)

