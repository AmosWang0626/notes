# Linux

## 目录
0. [查看磁盘使用情况 df、du](#1dfdu)
0. [查看系统信息 uname](#2uname)
0. [神器 lsof](#3lsof)
0. [定时任务 corn](#4cron)
0. [连接工具 SecureCRT SecureFX](#5securecrtfx)


## 1、查看磁盘使用情况df、du
- df
  - 以字节展示：df -l
  - 可读性展示：df -h

- du
  - 可读性展示（单位1024）：du -h
  - 可读性展示（单位1000）：du -H
  - 查看当前目录大小：du -hd0 /home/
  - 查看当前目录及子目录大小：du -hd1 /home/boot/

## 2、uname查看系统信息 
- 全部信息: uname -a
  - `Linux dudu 3.10.0-514.26.2.el7.x86_64 #1 SMP Tue Jul 4 15:04:05 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux`
- 硬件平台: uname -i
  - `x86_64`
- 机器硬件（CPU）名: uname -m
  - `x86_64`
- 节点名称: uname -n
  - `dudu`
- 操作系统: uname -o
  - `GNU/Linux`
- 系统处理器的体系结构: uname -p
  - `x86_64`
- 操作系统的发行版号 uname -r
  - `3.10.0-514.26.2.el7.x86_64`
- 系统名: uname -s
  - `Linux`
- 内核版本: uname -v
  - `#1 SMP Tue Jul 4 15:04:05 UTC 2017`

## 3、lsof命令的使用

1.列出所有打开的文件:
- lsof
- 备注: 如果不加任何参数，就会打开所有被打开的文件，输出内容非常多
 
2.查看谁正在使用某个文件
- lsof /filepath/file

3.递归查看某个目录的文件信息
- lsof +D /filepath/filepath2/
- 备注: 使用了+D，对应目录下的所有子目录和文件都会被列出

4.不使用+D选项，遍历查看某个目录的所有文件信息 的方法
- lsof | grep '/filepath/filepath2/'

5.列出某个用户打开的文件信息
- lsof -u username
- 备注: -u 选项，u其实是user的缩写
- 查看所有用户 vim /etc/group

6.列出某个程序所打开的文件信息
- lsof -c mysql
- 备注: -c 选项将会列出所有以mysql开头的程序的文件，其实你也可以写成lsof | grep mysql,但是第一种方法明显比第二种方法要少打几个字符了

7.列出多个程序多打开的文件信息
- lsof -c mysql -c apache

8.列出某个用户以及某个程序所打开的文件信息
- lsof -u test -c mysql

9.列出除了某个用户外的被打开的文件信息
- lsof   -u ^root
- 备注：^这个符号在用户名之前，将会把是root用户打开的进程不让显示

10.通过某个进程号显示该进行打开的文件
- lsof -p 1

11.列出多个进程号对应的文件信息
- lsof -p 123,456,789

12.列出除了某个进程号，其他进程号所打开的文件信息
- lsof -p ^1

13.列出所有的网络连接
- lsof -i

14.列出所有tcp 网络连接信息
- lsof -i tcp

15.列出所有udp网络连接信息
- lsof -i udp

16.***列出谁在使用某个端口（重点）***
- lsof -i:3306

17.列出谁在使用某个特定类型的端口
- 特定的udp端口
  - lsof -i udp:55
- 特定的tcp端口
  - lsof -i tcp:80

18.列出某个用户的所有活跃的网络端口
- lsof -a -u test -i

19.列出所有网络文件系统
- lsof -N

20.域名socket文件
- lsof -u

21.某个用户组所打开的文件信息
- lsof -g 5555

22.根据文件描述列出对应的文件信息
- lsof -d description(like 2)

23.根据文件描述范围列出文件信息
- lsof -d 2-3
 

## 4、定时任务cron
```
# test cron 每分钟执行一次
* * * * * echo "do rm -rf lu*.tmp $(date +\%Y-\%m-\%d~\%H:\%M:\%S)" >> /tmp/rm-tmp-job.txt
```
```
# this is rm liberoffice generate lu*.tmp job
0 4 */5 * * echo "$(date +\%Y-\%m-\%d~\%H:\%M:\%S) do rm -rf /tmp/lu*.tmp" >> /tmp/rm-tmp-job.txt
0 4 */5 * * rm -rf /tmp/lu*.tmp
```


## 5、Secure(CRT/FX)使用技巧
> Linux shell ftp 工具，推荐使用 SecureCRT SecureFX
- 批量导入服务器
  - 先决文件：https://www.vandyke.com/support/tips/importsessions.html
  - 创建一个.csv文件,写上对应服务器信息,如下
    ```
    protocol,username,folder,session_name,hostname
    SSH2,root,hello,pro-hello,127.0.0.1
    ```
