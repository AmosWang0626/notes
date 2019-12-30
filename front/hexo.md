---
title: Hexo 使用指北
date: 2019-11-24
tags:
- hexo
---

# Hexo

## 原理

- hexo 相当于一个小服务器，不需要后端支持，你把文章 *.md 文件放到 hexo 指定目录中，文章就能访问了。
- 评论相关的，可以集成第三方插件，有很多优秀的不需要后端支持的插件。
- 搞一个博客，三步即可：
  - 初始化一个 hexo 小服务；
  - 选一个 hexo 主题；
  - 把 *.md 文章放进去。
- 通常要想外网访问，两种办法：
  - 直接暴露 hexo 服务端口；
  - 通过 nginx 把 hexo 服务暴露出去。

## 安装

- 官网很详细，有时候官网访问不了，可以访问其 github

  - [hexo]( https://hexo.io/ )
  - [hexo github]( https://github.com/hexojs/hexo )

- 班门弄斧下，Linux 上安装时需要安装 node.js，参下文

  ```shell
  npm install hexo-cli -g
  hexo init blog
  cd blog
  npm install
  hexo server
  ```

- Linux 服务器要装 node.js

  - node.js 二进制文件

    `wget -c https://nodejs.org/dist/v12.13.1/node-v12.13.1-linux-x64.tar.xz`

  - 解压 *.xz 文件，需要先转 tar，再解压

    - `yum search xz`
    - `yum install xz.x86_64`
    - `xz -d node-v12.13.1-linux-x64.tar.xz ``
    - ``tar -xvf node-v12.13.1-linux-x64.tar`

  - 创建软链接，命令行下直接访问

    - `ln -s /opt/hexo/node-v12.13.1-linux-x64/bin/node /usr/local/bin/node`
    - `ln -s /opt/hexo/node-v12.13.1-linux-x64/bin/npm /usr/local/bin/npm`

  - `npm install hexo-cli -g`

  - ...

## 重点呦 选一个漂亮的主题
- [hexo-themes](https://hexo.io/themes/)
- 自认为好看的

## 添加标签和归档
- add categories
- add tags
- article add title、category and tag
- [参考文章](https://www.jianshu.com/p/e17711e44e00)
