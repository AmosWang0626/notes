---
title: Linux
date: 2019-12-01
categories: 系统相关
tags:
- 系统相关
- 精选文章
---

# Linux

## 未整理内容

```
1. 搜索历史命令：Ctrl + R (reverse: 反/逆)
2. 创建软链接：ln -s /xxx/xxx /usr/local/bin/xxx
2.1 目录创建软链接：ln -s /opt/java/jdk1.8.0_261/bin/ jdk8bin
2.2 删除软链接（切记末尾不能带斜线）：rm -r jdk8bin
3. 添加执行权限：chmod -x hello.sh
4. ZIP排除文件夹：zip -r jetty-bak20191230.zip jetty-8080 -x "jetty-8080/logs/*" "jetty-8080/webapps/*"
5. yum repolist 列出已经配置的所有可用仓库
   yum repolist enabled | grep docker
6. 显示当前的各种用户进程限制 ulimit -a
sync; echo 3 > /proc/sys/vm/drop_caches 
echo 3 > /proc/sys/vm/
7. 权限lrwxrwxrwx
r 4 w 2 x 1
l: d目录 l软链接 -文件 b可随机存取装置 c串行端口设备(键鼠等)
8. vim骚操作
:set nu 显示行号
:set ff=unix 设置编码
dd 删除当前行
```

---

## 修改系统登录及欢迎信息

`sudo vim /etc/motd`

![vim_etc_motd](https://gitee.com/AmosWang/resource/raw/master/image/linux/vim_etc_motd.png)

---

## 查看磁盘使用情况

- df
    - 以字节展示：df -l
    - 可读性展示：df -h

- du
    - 可读性展示（单位1024）：du -h
    - 可读性展示（单位1000）：du -H
    - 查看当前目录大小：du -hd0 /home/
    - 查看当前目录及子目录大小：du -hd1 /home/boot/

---

## 定时任务cron

```
# test cron 每分钟执行一次
* * * * * echo "do rm -rf lu*.tmp $(date +\%Y-\%m-\%d~\%H:\%M:\%S)" >> /tmp/rm-tmp-job.txt
```

```
# this is rm liberoffice generate lu*.tmp job
0 4 */5 * * echo "$(date +\%Y-\%m-\%d~\%H:\%M:\%S) do rm -rf /tmp/lu*.tmp" >> /tmp/rm-tmp-job.txt
0 4 */5 * * rm -rf /tmp/lu*.tmp
```

---

## Linux修改系统时间

修改服务器时间：`date -s "2019/10/31 23:57:00"`
改回当前时间[NTP服务器(上海)]：`ntpdate -u ntp.api.bz`

---

## ls

> （显示非隐藏文件的文件名，按文件名进行排序）

- `ls -a`显示全部的文件，包括隐藏文件，以`.`开头的文件
- `ls -A`显示全部文件，包括隐藏文件，但是不包括`.`和`..`开头的文件
- `ls -l`列出长字符串，包含文件的权限、属性等信息
- `ls -t`按文件时间排序
- `ls -S`按文件大小排序。
- `ls -alth`查看当前的详细信息
- `ls | wc -w`查看该目录下有多少个文件（wc -l 按照 line 统计数量；wc -w 按照 word 统计数量）

---

## scp

- `scp /home/boot.zip root@192.168.1.129:/home/`

---

## Secure(CRT/FX)使用技巧

> Linux shell ftp 工具，推荐使用 SecureCRT SecureFX

- 批量导入服务器
    - 先决文件：https://www.vandyke.com/support/tips/importsessions.html
    - 创建一个.csv文件,写上对应服务器信息,如下
      ```
      protocol,username,folder,session_name,hostname
      SSH2,root,hello,pro-hello,127.0.0.1
      ```

[回到顶部](#Linux)
