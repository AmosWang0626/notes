---
title: 框架相关 Nacos Config 注意事项
date: 2020-02-17
categories: 框架相关
tags:
- spring-cloud
- nacos-config
---

# Nacos Config 注意事项
- [Document](https://nacos.io/zh-cn/docs/quick-start-spring-cloud.html)

## Nacos配置相关
- 配置需要放在`bootstrap.yml`或者`bootstrap.properties`中
- 服务地址配置 `spring.cloud.nacos.config.server-addr=127.0.0.1:8848`
- 配置文件数据格式 `spring.cloud.nacos.config.file-extension=yaml`

## dataId格式说明
`${prefix}-${spring.profile.active}.${file-extension}`
- prefix 默认为 spring.application.name 的值，也可以通过配置项 spring.cloud.nacos.config.prefix来配置。
- spring.profile.active 即为当前环境对应的 profile，详情可以参考 Spring Boot文档。 
    > 注意：当 spring.profile.active 为空时，对应的连接符 - 也将不存在，dataId 的拼接格式变成 ${prefix}.${file-extension}
- file-exetension 为配置内容的数据格式，可以通过配置项 spring.cloud.nacos.config.file-extension 来配置。
    > 目前只支持 properties 和 yaml 类型。

## 服务端新建配置
- 新建配置要加后缀`. properties`或者`.yaml`
    - 反例（未加后缀）：`mall-gateway-dev` `mall-gateway-pro` 
    - 正例：`mall-gateway-dev.yaml` `mall-gateway-pro.yaml` 
    - 正例：`mall-gateway-dev.properties` `mall-gateway-pro.properties`
- 配置文件格式：`yaml`，属性与值之间要加空格
    - 反例（未加空格）：`email:pro@amos.wang`
    - 正例：`email: pro@amos.wang`