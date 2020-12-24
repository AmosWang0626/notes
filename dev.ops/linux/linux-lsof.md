---
title: Linux lsof 神器
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---


# Linux 神器 lsof

### 1. 列出所有打开的文件

`lsof`

- 如果不加任何参数，就会打开所有被打开的文件，输出内容非常多

### 2. 查看谁正在使用某个文件

`lsof /filepath/file`

### 3. 递归查看某个目录的文件信息

`lsof +D /filepath/filepath2/`

- 使用了`+D`，对应目录下的所有子目录和文件都会被列出

### 4. 不使用+D选项，遍历查看某个目录的所有文件信息 的方法

`lsof | grep '/filepath/filepath2/'`

### 5. 列出某个用户打开的文件信息

`lsof -u username`

- -u 选项，u其实是user的缩写 查看所有用户 `vim /etc/group`

### 6. 列出某个程序所打开的文件信息

`lsof -c mysql`

- -c 选项将会列出所有以mysql开头的程序的文件，其实你也可以写成`lsof | grep mysql`,但是第一种方法明显比第二种方法要少打几个字符了

### 7. 列出多个程序多打开的文件信息

`lsof -c mysql -c apache`

### 8. 列出某个用户以及某个程序所打开的文件信息

`lsof -u test -c mysql`

### 9. 列出除了某个用户外的被打开的文件信息

`lsof -u ^root`
`^`这个符号在用户名之前，将会把是root用户打开的进程不让显示

### 10. 通过某个进程号显示该进行打开的文件

`lsof -p 1`

### 11. 列出多个进程号对应的文件信息

`lsof -p 123,456,789`

### 12. 列出除了某个进程号，其他进程号所打开的文件信息

`lsof -p ^1`

### 13. 列出所有的网络连接

`lsof -i`

### 14. 列出所有tcp 网络连接信息

`lsof -i tcp`

### 15. 列出所有udp网络连接信息

`lsof -i udp`

### 16. ***列出谁在使用某个端口（重点）***

`lsof -i:3306`

### 17. 列出谁在使用某个特定类型的端口

- 特定的udp端口 `lsof -i udp:55`
- 特定的tcp端口 `lsof -i tcp:80`

### 18. 列出某个用户的所有活跃的网络端口

`lsof -a -u test -i`

### 19. 列出所有网络文件系统

`lsof -N`

### 20. 域名socket文件

`lsof -u`

### 21. 某个用户组所打开的文件信息

`lsof -g 5555`

### 22. 根据文件描述列出对应的文件信息

`lsof -d description(like 2)`

### 23. 根据文件描述范围列出文件信息

`lsof -d 2-3`
 