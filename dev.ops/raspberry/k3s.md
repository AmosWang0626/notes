---
title: 树莓派安装官方k3s（重点是彩蛋）
date: 2020-06-13
categories: 树莓派
tags:
- 树莓派
- k8s
---

# 树莓派安装[官方k3s](https://k3s.io/)
> 树莓派上安装 kubernetes，大多都选择使用k3s吧，小巧，随时随地最新版k8s，追新不等待，香~~~

## 一行命令
> 官网短短一行命令，就难倒了我们？是的，除非你能访问Google。这。。。还好有彩蛋，怼Ta不能吃亏。

`curl -sfL https://get.k3s.io | sh -`


## 这就是彩蛋
> 树莓派上装的是linux系统，windows上科学上网工具太多了，linux上却凤毛麟角。
>
> 那就让树莓派用windows代理后的网络吧。

### 一、局域网共享代理网络
1. 配置科学上网软件 `允许来自局域网的连接`

2. 获取当前Windows系统IP `ipconfig`

3. 获取科学上网软件的代理端口
    - 3.1 任务管理器拿到进程ID
      > `任务管理器` >> `详细信息` >> `PID`

    - 3.2 根据进程ID拿到监听端口
      > `netstat -ano|findstr "xxx"`

### 二、修改树莓派配置
> 亲测，在`~/.bashrc`里添加`xxx_proxy`不行

1. 添加环境变量 `vim /etc/environment`
    ```shell script
    export http_proxy="http://192.168.1.108:1080"
    export https_proxy="http://192.168.1.108:1080"
    export ftp_proxy="http://192.168.1.108:1080"
    export no_proxy="localhost,127.0.0.1"
    ```

2. 应用环境变量 `visudo`
    > 添加一行如下命令，env_keep，顾名思义，保持这个环境变量，防止用户切换导致环境变量丢失。

    `Defaults        env_keep+="http_proxy https_proxy ftp_proxy no_proxy"`

    保存三连：`Ctrl + X`、`Y`、`Enter`

3. 重启树莓派

### 三、测试代理是否OK
`curl -I https://www.google.com`

200就OK了

### 四、其他
> 当然第一步也可以用作为其他设备共享网络。

只需设备与电脑连在同一个wifi，或者在同一个局域网内。

在设备的wifi配置里，设置手动代理，指向电脑的IP、端口即可感受科学上网的奥miao~~~