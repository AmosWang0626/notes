---
title: Spring 源码——Bean是什么时候放进单例池的呢？
date: 2020-04-16
categories: 框架相关
tags:
- spring
---

# Spring Bean是什么时候放进单例池的呢？
> 看源码知道单例池就是一个 Map<beanName, object> `DefaultSingletonBeanRegistry#singletonObjects`

## 不知道 singletonObjects 到底是什么时候将对象 put 进去的？

### 1、断点设置个条件，只拦截 beanName为 a的 Bean
![断点设置个条件](https://gitee.com/AmosWang/resource/raw/master/image/spring/debug/debug-condition.png)

### 2、一叶知秋，一图便知 “对象进单例池调用链”
![一叶知秋，一图知debug](https://gitee.com/AmosWang/resource/raw/master/image/spring/debug/debug-breakpoint.png)

