---
title: Java 设计模式
date: 2018-11-11
categories: java
tags:
- java
- 设计模式
---

# 设计模式
> 黑色三月 >>> 学习·祭奠·不凡 ```2019.3```

## 1 代理模式
职责明确：真实对象只关注核心逻辑，代理对象去调用核心逻辑；
间接保护了真实对象；拓展性强。

### 1.1 静态代理
运行时已确定代理关系了；

### 1.2 jdk动态代理
运行阶段才指定代理关系；
Proxy.newProxyInstance(ClassLoader, Interfaces, InvocationHandler);

### 1.3 cglib动态代理
运行阶段才指定代理关系；
```
Enhancer enhancer = new Enhancer();
// 代理核心 callback
enhancer.setCallback(***);

// 有参构造创建对象
enhancer.setSuperclass(RealDriver.class);
RealDriver driver = (RealDriver) enhancer.create(new Class[]{String.class}, new Object[]{"刘易斯·汉密尔顿"});

// 无参构造创建对象
// enhancer.setSuperclass(VirtualDriver.class);
// VirtualDriver driver = (VirtualDriver) enhancer.create();
```

### 1.4 正向代理、反向代理
- TODO 待完善