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
无
```

---

## 系统卡顿三连

- `free -h`

- `df -h`

- `htop 或者 top`

---

## CPU 飙高 JVM 操作

- `jps -lmv` 或者 `top -c`
    - `1423`

- `top -Hp 1423`
    - `1086`

- `printf "%x\n" 1086`
    - `43e`

- `jstack 1423 | grep 43e -C5 --color`

- `jstack 1423 | grep 43e -A 30`

---

## 查看网络状态

- 查看 CLOSE_WAIT
    - `netstat -an|grep CLOSE_WAIT -c`

- 查询等待关闭连接数
    - `netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'`

---

## 僵尸进程kill不掉

- 查找僵尸进程 `ps aux`
  > 看 STAT 那栏，如果是Z，就表示是zombie僵尸进程

- 查看僵尸进程父进程 `ps -ef | grep 僵尸进程ID`
  > 找到父进程ID，干掉父进程即可

---

## 磁盘快满了，找出大文件

- `find / -size +100M | xargs ls -lh`

- 查看当前文件夹下所有文件/目录大小
    - `du -sh *`

---

## vim

- `:set nu` 显示行号
- `:set ff=unix` 设置编码
- `dd` 删除当前行

---

## 软链接

### 1. 创建

`ln -s /xxx/xxx /usr/local/bin/xxx`

### 2. 删除（慎重！！！）

> 切记末尾不能带斜线

`rm -r jdk8bin`

---

## 添加执行权限

`chmod -x hello.sh`

---

## ZIP排除指定文件夹

`zip -r mall_order_bak20191230.zip mall_order -x "mall_order/logs/*" -x "mall_order/DATA/*/data"`

- 多个文件夹用，文件夹要加双引号 `-x "xxx"`

---

## scp

- `scp /home/boot.zip root@192.168.1.129:/home/`

---

## 搜索历史命令

`Ctrl + R`

---

## 查看磁盘使用情况

- df
    - 以字节展示：`df -l`
    - 可读性展示：`df -h`

- du
    - 可读性展示（单位1024）：`du -h`
    - 可读性展示（单位1000）：`du -H`
    - 查看当前目录总大小：`du -sh`
    - 查看当前目录各文件、目录大小：`du -sh *`
    - 查看指定目录大小：`du -hd0 /home/`
    - 查看指定目录及子目录大小：`du -hd1 /home/boot/`

---

## 列出 yum 可用仓库

- `yum repolist`
- `yum repolist enabled | grep docker`

---

## Linux 文件权限

> `lrwxrwxrwx`

- `l`
    - `d` 目录
    - `l` 软链接
    - `-` 文件
    - `b` 可随机存取装置
    - `c` 串行端口设备(键鼠等)
- `r`: 4
- `w`: 2
- `x`: 1

---

## Linux修改系统时间

修改服务器时间：`date -s "2019/10/31 23:57:00"`
改回当前时间[NTP服务器(上海)]：`ntpdate -u ntp.api.bz`

---

## 修改系统登录及欢迎信息

`sudo vim /etc/motd`

![vim_etc_motd](https://gitee.com/AmosWang/resource/raw/master/image/linux/vim_etc_motd.png)

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

## ls

> （显示非隐藏文件的文件名，按文件名进行排序）

- `ls -a` 显示全部的文件，包括隐藏文件，以`.`开头的文件
- `ls -A` 显示全部文件，包括隐藏文件，但是不包括`.`和`..`开头的文件
- `ls -l` 列出长字符串，包含文件的权限、属性等信息
- `ls -t` 按文件时间排序
- `ls -i` 查看inode信息
- `ls -S` 按文件大小排序。
- `ls -alth` 查看当前的详细信息
- `ls | wc -w` 查看该目录下有多少个文件（wc -l 按照 line 统计数量；wc -w 按照 word 统计数量）

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
