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
