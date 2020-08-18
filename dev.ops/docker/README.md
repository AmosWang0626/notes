---
title: Docker
date: 2019-02-21
categories: Docker
tags:
- docker
- 精选文章
---


# Docker 学习笔记
>  镜像与容器的关系

| Java | Docker |
|------|--------|
| 类    | 镜像     |
| 对象   | 容器     |

## Docker基本操作

### 1.查询镜像
> docker search [OPTIONS] TERM
- TERM是必须的，表示镜像的名字
- 示例 `docker search nginx`

### 2.查看电脑上安装的镜像
> docker images [OPTIONS] [REPOSITORY[:TAG]]
- 两个属性不是必需的
- 示例 `docker images`
- 示例 `docker images --filter "dangling=true"`

### 3.拉取一个镜像
> docker pull [OPTIONS] NAME[:TAG]
- NAME是必须的，表示拉去镜像的名字
- 示例 `docker pull nginx`

### 4.运行容器
> docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
- -d 后台运行容器，并返回容器ID；
- -P 随机分配端口 (P大写)
- -p **:** 指定端口 (p小写)
- -i 以交互模式运行容器，通常与 -t 同时使用；
- -t 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
- --name nginx-amos 为容器指定一个名称；
- 示例 `docker run -d -p 80:80 --name nginx nginx`

### 5.列出容器
> docker ps [OPTIONS]
- -a 显示所有的容器，包括未运行的
- -q 静默模式，只显示容器编号
- -s 显示总的文件大小
- 示例 `docker ps -a`

### 6.停止容器
> docker stop [OPTIONS] CONTAINER [CONTAINER...]
- CONTAINER
	- CONTAINER ID：容器ID
	- NAMES：容器名称
- 示例 `docker stop nginx`

### 7.删除容器
> docker rm [OPTIONS] CONTAINER [CONTAINER...]
- -f 通过SIGKILL信号强制删除一个运行中的容器
- -l 移除容器间的网络连接，而非容器本身
- -v 删除与容器关联的卷
- 示例 `docker rm nginx`

### 8.删除镜像
> docker rmi [OPTIONS] IMAGE [IMAGE...]
- -f 强制删除
- 示例 `docker rmi nginx:latest`
- 手动删除悬空镜像
- `docker rmi $(docker images -f "dangling=true" -q)`
- 手动删除悬空镜像(简便方式)
- `docker image prune`

### 9.查看镜像/容器详情
- 查看镜像/容器详情
- `docker inspect nginx`
- 清空虚悬镜像
- `docker image prune`

### 10.交互模式
> docker exec --help
- -i 以交互模式运行容器
- -t 为容器重新分配一个伪输入终端
- bash 是进入终端的命令(Linux系统)，另外因为Nginx运行在Linux之上
- docker exec -it 容器ID/别名 bash
- 示例 `docker exec -it nginx bash`
- 示例 `docker exec -it java sh`
- 注意: bash不一定能用，可以多试几个 sh bash /bin/sh 等

### 11.docker system 系统级命令
> docker命令的核心（虽然不是特别常用）
- `docker system df` 显示docker磁盘使用情况
- `docker system df -v` 显示空间使用的详细信息
- `docker system info` 显示系统信息
- `docker system prune` 自动清理
  - 已停止的容器
  - 未被任何容器使用的卷
  - 未被任何容器所关联的网络
  - 所有悬空的镜像
- `docker system prune -a` 清除所有未被使用的镜像和悬空镜像
- `docker system prune -f` 无提示，强制删除

### 12.docker * prune 非系统级清理
- `docker image prune` 删除悬空的镜像
- `docker container prune` 删除无用的容器
> 默认会清理掉所有处于stopped状态的容器
  - 筛选 --filter 
  - 清除所有24小时外创建的容器 `docker container prune --filter "until=24h"`
- `docker volume prune` 删除无用的卷
- `docker network prune` 删除无用的网络

### 100.其他
- *:latest 字面意思是最新的 未必

---

## Windows Docker 修改镜像存放位置
- 控制面板->管理工具->Hyper-V 管理器->虚拟机右键设置
- 将默认 `C:\Users\Public\Documents\Hyper-V\Virtual hard disks\MobyLinuxVM.vhdx` 的文件拷贝到想要改变的路径

---

## Docker 网络通讯
> 网络类型
- Bridge: Bridge有独立的Namespace，这就涉及到端口映射
- Host: 使容器与主机使用同一块网卡

### Bridge 第一种方式
> -p **:** 指定端口 p小写
```shell script
# Bridge[桥接网络的方式]启动容器
docker run -d -p 8080:80 nginx

# 查看端口的状态
netstat -na|grep 8080

# 然后就可以在本机的浏览器中访问Nginx了
localhost:8080
```

### Bridge 第二种方式
> -P 随机分配端口 P大写
```shell script
# Bridge[桥接网络的方式]启动容器
docker run -d -P nginx

# 会看到随机端口已启动
0.0.0.0:32769->80/tcp...........

# 查看端口状态
netstat -na|grep 32769

# 本机的浏览器中访问Nginx
localhost:32769
```

---
