---
title: Docker 搭建私有仓库
date: 2019-12-25
categories: Docker
tags:
- docker
---

# Docker 搭建私有仓库

## 1、pull 官方镜像 registry

- `docker pull registry`

## 2、run registry

- `docker run -d -p 5000:5000 -v /opt/data/docker:/var/lib/registry --name dockerhub registry`

- `docker inspect dockerhub` 查看镜像信息解释 -v 如下

- -v 挂载 宿主机目录 到 容器目录

  - /opt/data/docker（宿主机目录）：/var/lib/registry（容器内目录）

  ```json
  "Mounts": [
    {
    "Type": "bind",
    "Source": "/opt/data/docker",
    "Destination": "/var/lib/registry",
    "Mode": "",
    "RW": true,
    "Propagation": "rprivate"
    }
  ],
  ```
  - 验证是否挂载上了
    - 对比下宿主机`/opt/data/docker`目录 和 容器`/var/lib/registry`目录
    - 进入容器`docker exec -it dockerhub sh`

## 3、push 镜像到 registry 仓库

- 和网上方法一样，pull 个 busybox 到本地，因为它小，仅 1.22MB
  - `docker pull busybox`
- 给刚下载的 busybox 打一个新的标签，等于制作一个镜像
  - `docker tag busybox:latest dockerhub.amos.wang/busybox`
- 将新做的镜像 push 到刚创建的 registry 仓库
  - `docker push dockerhub.amos.wang/busybox`

## 4、pull 新上传的镜像

- 先删除刚制作的镜像
  - `docker rmi dockerhub.amos.wang/busybox`
- `docker images`验证下是否删除掉了
- pull 新上传的镜像
  - `docker pull dockerhub.amos.wang/busybox`

## 5、dockerhub.amos.wang 是什么

- https 域名，配置 nginx 映射至宿主机 5000 端口

  ```nginx
  server {
      listen       443 ssl;
      listen       [::]:443 ssl;
      server_name  dockerhub.amos.wang;
  
      ssl_certificate         /etc/nginx/cert/dockerhub.pem;
      ssl_certificate_key     /etc/nginx/cert/dockerhub.key;
      ssl_session_cache       shared:SSL:1m;
      ssl_session_timeout     10m;
      ssl_ciphers             HIGH:!aNULL:!MD5;
      ssl_prefer_server_ciphers       on;
  
      # Load configuration files for the default server block.
      include /etc/nginx/default.d/*.conf;
  
      location / {
          proxy_pass   http://127.0.0.1:5000/;
          index  index.html index.htm;
      }
  
  }
  ```