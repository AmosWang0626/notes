---
title: Spring 源码编译
date: 2020-03-24
categories: 框架相关
tags:
- spring
---

# Spring 源码编译
> 参考子路大佬视频 [spring5.1源码编译与常见的一些问题](https://www.bilibili.com/video/BV1XJ41117tT)

## 1. IDEA 配置 Gradle
![IDEA 配置 Gradle](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.1.idea-2019.3.png)

## 2. 默认项目中缺少 Cglib 的 jar，如下操作会自动引入
![引入 Cglib Jar](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.2.gradle.core-build.png)

## 3. 构建 `spring-context`
![构建 spring-context](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.3.context.run-test.png)

## 4. 构建 `spring-context` 成功
![构建 spring-context 成功](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.4.context.run-test.succ.png)

## 5. 构建完成，创建一个自己的 `module`
![自定义 module](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.5.new-moudle.png)

## 6. 自定义 `module` 引入 `spring-context` 依赖
![引入 spring-context 依赖](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.6.new-moudle.rely.png)

## 7. 写点测试方法测试下吧
> 注意：如果引入 `@ComponentScan` 不成功，重复第 3 步试试；还不行的话，重启IDEA，刷新 Gradle
![测试 module](https://gitee.com/AmosWang/resource/raw/master/image/spring/compile/spring-compile.7.new-moudle.test.png)

[附 single-test 源码](https://gitee.com/AmosWang/spring-framework/tree/amos-5.1.x/single-test)