---
title: Docker Install Software
date: 2019-02-28
categories: Docker
tags:
- docker
- nginx
- redis
- jenkins
---


# Docker 安装软件
- Nginx
- Redis
- Jenkins

## Docker Nginx
> docker install Nginx

- 首先查找Nginx镜像
  - docker search nginx

- pull获得我们要运行的Nginx
  - docker pull nginx
  - 报错了 Get XXX: unauthorized: incorrect username or password，不要紧，docker退出登录，使用用户名加密码登录，不能是邮箱加密码哟。

- 查看当前docker里边运行的容器
  - docker images

- 后台运行Nginx, -d 后台运行容器，并返回容器ID
  - docker run -d nginx

- 运行之后，查看一下
  - docker ps -a

- 查看docker内部信息
  - docker exec -it 容器别名 bash

- 查看Nginx的位置
  - which nginx
  - whereis nginx

- 停止Nginx
  - docker stop 容器名字或者id

### Dockerfile
```dockerfile
FROM nginx
COPY dist/ /usr/share/nginx/html/
COPY /conf.d/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```
- expose 暴露端口为镜像暴露端口，可配置多个

## docker build -t amos-ui:1.0 .
- -t 是指定镜像名字（:版本）
- . 表示Dockerfile在当前目录

## docker run -d -p 80:80 --name aui amos-ui:1.0

----------

## Docker Redis
> docker install Redis

- docker search redis
- docker pull redis
- docker run -d -p 6379:6379 --name docker-redis redis
- 未设置auth，直接连接即可，也可继续设置auth
- docker exec -it docker-redis redis-cli
- config set requirepass root
- auth root
- config get requirepass

## Docker Jenkins
> docker install jenkins

- docker search jenkins
- docker pull jenkins/jenkins:lts
- run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home --name my_jenkins jenkins/jenkins:lts
- volumes（数据卷，简写 -v）用于保存持久化数据
  - docker volume ls
  - docker inspect jenkins_home
  - cd /var/lib/docker/volumes/jenkins_home/
- 查看日志（-f 跟踪实时日志）
  - docker logs -f my_jenkins

----------
