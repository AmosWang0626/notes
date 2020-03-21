---
title: 树莓派 4B 安装 CentOS 7.7
date: 2020-03-21
categories: 树莓派
tags:
- 树莓派
---

# 树莓派 4B 安装 CentOS 7.7
> 树莓派原系统用着不是很顺手，那就换个顺手的吧~
>
> 躬身入局，直面挑战

## 1. CentOS 7.7 镜像
- [阿里云镜像](https://mirrors.aliyun.com/centos-altarch/7.7.1908/isos/armhfp/)
- 重点说两个，亲身入坑
    - 1 `CentOS-Userland-7-armv7hl-RaspberryPI-Minimal-1908-sda.raw.xz`
    - 2 `CentOS-Userland-7-armv7hl-RaspberryPI-Minimal-4-1908-sda.raw.xz`
    - 咋一看，没啥区别，下边的多了个 `-4`
    - 直接说了，树莓派4B用 2，带`-4`的那个。

## 2. 制作镜像
- 格式化工具 SDCardFormatter：`SDCardFormatterv5_WinEN`
- 镜像写入TF卡balenaEtcher：`balenaEtcher-Portable-1.5.45`

## 3. 网线连上树莓派
- `arp -a` 找到IP
- ping通再 ssh 连接
- 账号密码：root centos

## 4. 树莓派连接 wifi
- 查看附近wifi `nmcli d wifi`
- 连接wifi `nmcli d wifi connect amos.wang password @Qwert123`
- 查看连接状态 `nmcli d  show wlan0`

## 5. 设置固定 IP
- 经过上一步，可以看下配置文件了 `/etc/sysconfig/network-scripts/ifcfg-amos.wang`
- ![静态IP](https://gitee.com/AmosWang/resource/raw/master/image/raspberry-network-static.png)

## 6. 扩展内存卡剩余空间
- `/usr/bin/rootfs-expand`
- 测试 `df -h`

## 7. 安装 Docker
- 卸载旧版本
```shell script
sudo yum remove docker docker-common docker-selinux docker-engine
```

- 安装依赖
```shell script
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```

- 设置镜像仓库
```shell script
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

- 安装 Docker
```shell script
sudo yum install docker
```

- 启动 Docker
```shell script
service docker start
```

- 设置开机自启动
```shell script
sudo systemctl enable docker
```

- 配置镜像加速器
  - `vim /etc/docker/daemon.json`
  - 加入如下内容
      ```json
      {
        "registry-mirrors": ["https://ug1g4lsw.mirror.aliyuncs.com"]
      }
      ```
  - 应用配置 `sudo systemctl daemon-reload`
  - 重启Docker `sudo systemctl restart docker`
  - 检查配置是否生效 `docker info`

- 拉个镜像试试
  - `docker pull nginx`
  - what xxx ? 
    > Get https://registry-1.docker.io/v2/: x509: certificate has expired or is not yet valid
    - 检查下机器时间 `date`
    - 修改机器时间 `ntpdate cn.pool.ntp.org`
    - 如果找不到`ntpdate`命令 `yum install ntpdate.armv7hl`

- 好了，可以愉快滴玩耍了~~~

## 8. 安装 htop
> 适用于 `yum install htop` 找不到 htop 的情况
- 官网下载安装包，或者下边链接
    - [htop-2.2.0.tar.gz](https://github.com/AmosWang0626/notes/blob/master/dev.ops/raspberry/htop-2.2.0.tar.gz)
- 安装先决 `yum install -y gcc gcc-c++ ncurses-devel`
- `tar -zxvf htop-2.2.0.tar.gz`
- `cd htop-2.2.0`
- `./configure`
- 执行了上一步才能 make 哟 `make && make install`
- 测试下吧 `htop`
