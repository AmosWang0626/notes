# Linux
> Linux shell ftp 工具，推荐使用 SecureCRT SecureFX

## SecureCRT SecureFX 使用技巧
- 批量导入服务器
  - 先决文件：https://www.vandyke.com/support/tips/importsessions.html
  - 创建一个.csv文件,写上对应服务器信息,如下
    ```
    protocol,username,folder,session_name,hostname
    SSH2,root,hello,pro-hello,127.0.0.1
    ```
## uname 查看系统信息
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

## df 查看磁盘使用情况
- 字节形式：df -l
- GB形式：df -h

## 查看端口状态
- lsof -i:80

## nginx 添加白名单IP脚本
```
#!/bin/bash

# 变量赋值
ip=$1

# read -p "请输入新的IP：" ip

echo "$ip" | egrep --color '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
if [ $? -ne 0 ]; then
  echo "你输入ip地址不符和要求";
  exit 0;
fi

# 获取当前文件行数
column=$(wc -l < /etc/nginx/block_ip.txt);

# 向当前最后一行处（也即倒数第二行）插入数据：sed -i "*i allow $ip;" /etc/nginx/block_ip.txt
# 语法：*i 就是在第五行插入行
#       allow $ip; 要插入的内容
sed -i "${column}i allow $ip;" /etc/nginx/block_ip.txt;

echo "add success";

nginx -s reload;

exit 0;

```
