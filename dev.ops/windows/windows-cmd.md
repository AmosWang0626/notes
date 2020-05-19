---
title: 系统相关 Windows 命令
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---


# cmd
### 电脑配置相关
- 管理电脑用户
  - netplwiz
  - lusrmgr.msc（更专业）
- 查看端口
  - netstat -ano|findstr "8080"
  - taskkill -pid 7848（进程号） -f（强制）

### 目录相关
* 查看当前目录下文件 dir
* 查看当前目录目录结构 tree
* 查看当前目录结构以及全部文件 tree /f
* 保存当前显示的目录结构 tree >hello.txt  || tree /f >hello.txt

### 常用命令
- notepad