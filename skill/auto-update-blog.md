---
title: 自动更新博客
date: 2020-05-23
categories: 我的想法
tags:
- docker
- Webhooks
---

# 自动更新博客

> 技术栈：Git、Github WebHook、JSch、Docker、Hexo

## 初衷

我的想法很简单，实现起来也不难。今晚上线。。。

博客是用`Hexo`搭得，刚好就用上了之前的笔记项目，里边都是`.md`文件。

之前新写的文章，都需要登上服务器，到`Hexo`服务下边，`git pull`，挺麻烦得。

昨天早上看到码云有个`Gitee Jenkins Plugin`的方案，通过`WebHook` 触发 `Jenkins` 进行自动化持续集成。就去`Github`翻了一遍，果然，项目设置里也有个`WebHook` ，就它啦，开搞。

## 基本思路

我们在`WebHooks`里边配置一个 URL，`WebHooks` 监听到代码提交时，会触发指定 URL。

我们要做的就是，起个服务，暴露一个 URL，收到请求后，去执行指定脚本即可，以此达到自动更新博客的目的。

本想用 `golang` 写呢，想到网络编程、Web接口调用不太熟，`golang + docker`也不熟，就放弃了，下个版本试试吧。

## 项目地址

- Github地址：https://Github.com/AmosWang0626/auto

  Java 项目，Spring Boot，WebFlux，Docker，调用脚本使用 JSch，代码很简单。

- Docker镜像：`amos0626/auto`

- Docker Hub地址：https://hub.docker.com/r/amos0626/auto

## 直接使用

1. 创建一个 `docker-compose.yml`

   ```
    version: '3.5'
    services:
      auto:
        image: amos0626/auto
        container_name: auto
        ports:
          - '8080:8080'
        volumes:
          - './logs:/root/logs'
        environment:
          - JSCH_HOST=127.0.0.1
          - JSCH_USERNAME=root
          - JSCH_PASSWORD=root
          - COMMAND=./update.sh
   ```

2. 自定义参数

   | 名字          | 备注             | 默认值    |
   | ------------- | ---------------- | --------- |
   | JSCH_HOST     | 服务器 IP / 域名 | 127.0.0.1 |
   | JSCH_PORT     | SSH 端口         | 22        |
   | JSCH_USERNAME | 用户名           | root      |
   | JSCH_PASSWORD | 密码             | root      |
   | COMMAND       | 要执行的命令     | 无        |

3. 测试一哈

   ```
   POST http://localhost:8080/pull
   Content-Type: application/json
   
   {
    "ref": "1433233"
   }
   ```

## 效果图

![github-webhooks](https://gitee.com/AmosWang/resource/raw/master/image/github/github-webhooks.png)

![github-webhooks-detail](https://gitee.com/AmosWang/resource/raw/master/image/github/github-webhooks-detail.png)