---
title: 框架相关 Spring Cloud
date: 2019-01-01
categories: 框架相关
tags:
- spring-cloud
---

# Spring Cloud


# Spring Cloud 版本说明

| 版本号|版本说明|版本用途|
|---|---|---|
| BUILD      | 开发版   | 开发团队内部使用              |
| GA         | 稳定版   | 基本上可以用了，还有些bug      |
| PRE(M1,M2) | 里程碑版  | GA修复版                   |
| RC         | 候选发布版 | 发行前观察期，高级bug修复     |
| SR         | 正式发布版 | SR1、SR2等等，修复大bug或优化 |

## Spring依赖版本总览
[Spring依赖版本总览](https://start.spring.io/actuator/info)

## Nacos
### nacos 安装
yum 安装jdk，设置环境变量 `JAVA_HOME`
- `JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk-1.8.0.222.b10-1.el7_7.x86_64`
- `export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL JAVA_HOME`

### nacos 启动
- 默认为集群启动
- 单节点启动 `./startup.sh -m standalone`
