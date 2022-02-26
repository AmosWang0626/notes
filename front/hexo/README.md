---
title: Hexo 使用指北
date: 2018-01-01
tags:
- hexo
---

# Hexo

## 原理

Hexo是什么？

Hexo 是一个快速、简洁且高效的博客框架。Hexo 使用 Markdown（或其他渲染引擎）解析文章，在几秒内，即可利用靓丽的主题生成静态网页。

简单说，就是会把 Markdown 解析生成 html。

通过 `hexo server` 启动后，默认会绑定 4000 端口，此时，既能对外提供服务。

当我们想搭一套博客的时候，大致需要三步

- 安装 Hexo
- 安装喜欢的 Theme
- 将自己写作的内容放到指定目录

## 1、安装 Node.js
先说下，不推荐使用 yum 安装，因为版本比较老（v10.24.0），再通过 npm 安装 hexo 启动的时候，会出现ES6之类的语法不支持。

已经安装了？卸载 yum remove nodejs

```shell
# 安装 node.js
wget https://npmmirror.com/mirrors/node/v16.14.0/node-v16.14.0-linux-x64.tar.xz

# 解压1
xz -d node-v16.14.0-linux-x64.tar.xz

# 解压2
tar -xvf node-v16.14.0-linux-x64.tar

# 将 nodejs 可执行文件路径放入 ~/.profile
echo 'PATH="$PATH:/opt/nodejs/node-v16.14.0-linux-x64/bin"' >> ~/.profile

source ~/.profile

# v16.14.0
node -v
```

### source后关闭终端失效

```shell
vim ./.bashrc
```

```shell
# self config
if [ -f ~/.profile ]; then
        source ~/.profile
fi
```

## 2、安装 Hexo

- https://hexo.io/
- https://github.com/hexojs/hexo

```shell
# 安装 hexo
npm install hexo

# 将 hexo 可执行文件路径放入 ~/.profile
echo 'PATH="$PATH:/opt/nodejs/node-v16.14.0-linux-x64/node_modules/.bin"' >> ~/.profile

source ~/.profile
```

## 3、初始化 Hexo Blog 项目

```shell
hexo init blog

cd blog

hexo server
```

## 4、安装喜欢的 Theme

- 这里边选择比较多 [hexo-themes](https://hexo.io/themes/)

### 示例，安装 hexo-theme-fluid 主题

> 推荐使用 Hexo 5.0.0+
>
> https://github.com/fluid-dev/hexo-theme-fluid

#### 1. 安装主题

   ```shell
   npm install --save hexo-theme-fluid
   ```

   然后在博客目录下创建 _config.fluid.yml，将主题的 _config.yml 内容复制进去。


#### 2. 指定主题(如下修改 Hexo 博客目录中的 _config.yml)

   ```yaml
   theme: fluid # 指定主题
   language: zh-CN # 指定语言，会影响主题显示的语言，按需修改
   ```

#### 3、将自己写作的内容放到指定目录

将自己写的文章放到博客目录中的 `./source/_posts` 目录里边。

我习惯，直接把自己整理的文档 [github notes](https://github.com/AmosWang0626/notes) 直接放进去即可。

然后，可以重启下项目，看看能否正常访问。

```shell
# 清理下之前生成的html
hexo clean

# 生成html
hexo g

# 启动hexo服务，默认会绑定4000端口
hexo server 
```

试试吧～ http://localhost:4000/