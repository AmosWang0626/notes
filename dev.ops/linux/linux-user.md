---
title: 系统相关 Linux 创建用户
date: 2019-12-29
categories: 系统相关
tags:
- 系统相关
- Linux
---


# Linux 创建用户

## 1、添加用户 `useradd`

- `-r` 创建系统账号。其中，系统账号默认不会创建用户主文件夹；
- `-d` 指定目录作为用户主文件夹，务必使用绝对路径；
- `-s` 后边接一个 `shell`，默认是 `/bin/bash`；
- 示例：`useradd -m -d /app/amos amos  `（`/app`目录要真实存在）
- 参考文件：
  - 创建用户时，总会有默认配置，以及在该用户主目录有什么文件呢？这些文件从哪来？
  - 查看默认配置：`useradd -D`
  - `SKEL=/etc/skel`用户主文件夹参考基准目录，有些共用的配置可以放在里边。

## 2、删除用户 `userdel`

- `-r`用户主文件夹会一并删掉
- 示例：`userdel -r amos  `

## 3、设置密码 `passwd`

- 管理员设置密码，一般不校验密码格式，会给出提示但不强制；
- 普通用户设置密码，密码格式必须符合要求；
- 注意，出现 `Retype`才证明你的密码格式被接受了；
- 锁定用户密码：`passwd -l amos  `
- 解锁用户密码：`passwd -u amos`
- 查看密码信息：`passwd -S amos`
  - `amos PS 2019-12-29 0 99999 7 -1 (Password set, SHA512 crypt.)`
  - `2019-12-29`密码新建时间
  - `0`最小天数，`99999`更改天数，`7`警告天数，`-1`密码不会失效

## 4、测试一下

- `echo hello > hello.txt`
- `ls -l` 看下输出：`-rw-rw-r-- 1 amos amos 11 Dec 29 20:43 hello.txt`

