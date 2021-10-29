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

## 1、安装 Hexo

> 需要安装 Node.js 环境

- https://hexo.io/
- https://github.com/hexojs/hexo

```shell
npm install hexo-cli -g
hexo init blog
cd blog
npm install
hexo server
```

## 2、安装喜欢的 Theme

- 这里边选择比较多 [hexo-themes](https://hexo.io/themes/)

### 示例，安装 hexo-theme-fluid 主题

> 推荐使用 Hexo 5.0.0+
>
> https://github.com/fluid-dev/hexo-theme-fluid

1. 安装主题

   ```shell
   npm install --save hexo-theme-fluid
   ```

   然后在博客目录下创建 _config.fluid.yml，将主题的 _config.yml 内容复制进去。


2. 指定主题(如下修改 Hexo 博客目录中的 _config.yml)

   ```yaml
   theme: fluid # 指定主题
   language: zh-CN # 指定语言，会影响主题显示的语言，按需修改
   ```

## 3、将自己写作的内容放到指定目录

将自己写的文章放到博客目录中的 `./source/_posts` 目录里边。

我习惯，直接把自己整理的文档 [github notes](https://github.com/AmosWang0626/notes) 直接放进去即可。

然后，可以重启下项目，看看能否正常访问。

```shell
hexo clean # 清理下之前生成的html
hexo g # 生成html
hexo server # 启动hexo服务，默认会绑定4000端口
```

