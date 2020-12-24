---
title: Sharding-JDBC 初探
date: 2020-12-24
categories: 框架相关
tags:
- sharding-jdbc
---

# Sharding-JDBC 初探

> 结合项目体验一把，虽然大部分业务场景是用不到的，但是提前踩踩坑、熟悉熟悉套路，还是有必要的。

## 一、概览

1. spring-boot 版本 2.4.0

2. 短链接项目 [short-url](https://github.com/AmosWang0626/short-url)
   > 不同于官方提供的demo，以 order、order_item 这样的业务，根据 user_id (整数类型) 分库，order_id (整数类型) 分表；
   >
   > short-url 项目很简单，只有一个表 dev_short_url，根据短链接字段url分库，根据主键ID分表。

3. 依赖

   ```xml
   <!-- spring-boot-starter -->
   <dependency>
       <groupId>org.apache.shardingsphere</groupId>
       <artifactId>shardingsphere-jdbc-core-spring-boot-starter</artifactId>
       <version>5.0.0-alpha</version>
   </dependency>
   ```

4. 友情提示

   遇到错误不要第一时间去百度（大概率搜不到），翻翻官方文档，仔细琢磨下配置，看看报错的位置，翻下源码。

   例如，配置 ds_0，启动项目会报错，统一改成 ds-0 就好了，可能是新版 spring boot 的规则更严格了。

## 二、配置文件

### 1. 数据源 datasource

- 定义分库名字（标示） `spring.shardingsphere.datasource.names=ds-0,ds-1`
  > 注意下用法，后边都是这样用的
  >
  > `spring.shardingsphere.datasource.ds-0.jdbc-url`

- 公共配置 `spring.shardingsphere.datasource.common`

```properties
# sharding-jdbc datasource
spring.shardingsphere.datasource.names=ds-0,ds-1
spring.shardingsphere.datasource.common.type=com.zaxxer.hikari.HikariDataSource
spring.shardingsphere.datasource.common.driver-class-name=com.mysql.cj.jdbc.Driver
spring.shardingsphere.datasource.common.username=root
spring.shardingsphere.datasource.common.password=ENC(6YKavYkUMuJtySAlihNSd3zBfz0GwtmMAIq/VrAq3YyuW9vgMpwBH5eRIc6VMSyY)
spring.shardingsphere.datasource.ds-0.jdbc-url=jdbc:mysql://192.168.1.188:3306/short-url0?serverTimezone=UTC&useSSL=false&useUnicode=true&characterEncoding=UTF-8
spring.shardingsphere.datasource.ds-1.jdbc-url=jdbc:mysql://192.168.1.188:3306/short-url1?serverTimezone=UTC&useSSL=false&useUnicode=true&characterEncoding=UTF-8
```

### 2. 分库分表规则 rules

> [中文官方文档-数据分片](https://shardingsphere.apache.org/document/current/cn/user-manual/shardingsphere-jdbc/configuration/spring-boot-starter/sharding/)

```properties
# 分表规则
spring.shardingsphere.rules.sharding.tables.dev_short_url.actual-data-nodes=ds-$->{0..1}.dev_short_url_$->{0..1}

# 1.1 默认分库策略（根据url分库，定义分库算法名字 url-hash，具体算法见下边配置 2.1）
spring.shardingsphere.rules.sharding.default-database-strategy.standard.sharding-column=url
spring.shardingsphere.rules.sharding.default-database-strategy.standard.sharding-algorithm-name=url-hash

# 1.2 分表策略（根据id分表，定义分表算法名字 id-hash，具体算法见下边配置 2.2）
spring.shardingsphere.rules.sharding.tables.dev_short_url.table-strategy.standard.sharding-column=id
spring.shardingsphere.rules.sharding.tables.dev_short_url.table-strategy.standard.sharding-algorithm-name=id-hash

# 1.3 分表-分布式序列策略（具体算法见下边配置 2.3）
spring.shardingsphere.rules.sharding.tables.dev_short_url.key-generate-strategy.column=id
spring.shardingsphere.rules.sharding.tables.dev_short_url.key-generate-strategy.key-generator-name=snowflake

# 2.1 分库算法
spring.shardingsphere.rules.sharding.sharding-algorithms.url-hash.type=HASH_MOD
spring.shardingsphere.rules.sharding.sharding-algorithms.url-hash.props.sharding-count=2

# 2.2 分表算法
spring.shardingsphere.rules.sharding.sharding-algorithms.id-hash.type=HASH_MOD
spring.shardingsphere.rules.sharding.sharding-algorithms.id-hash.props.sharding-count=2

# 2.3 分布式序列算法
spring.shardingsphere.rules.sharding.key-generators.snowflake.type=SNOWFLAKE
spring.shardingsphere.rules.sharding.key-generators.snowflake.props.worker-id=123
```

#### 用过的两个算法

> [中文官方文档-分片算法](https://shardingsphere.apache.org/document/current/cn/user-manual/shardingsphere-jdbc/configuration/built-in-algorithm/sharding/)

- INLINE（标准分片算法-行表达式）

```properties
spring.shardingsphere.rules.sharding.sharding-algorithms.id-inline.type=INLINE
spring.shardingsphere.rules.sharding.sharding-algorithms.id-inline.props.algorithm-expression=dev_short_url_$->{id % 2}
```

- HASH_MOD（自动分片算法-哈希取模分片算法）

```properties
spring.shardingsphere.rules.sharding.sharding-algorithms.id-hash.type=HASH_MOD
spring.shardingsphere.rules.sharding.sharding-algorithms.id-hash.props.sharding-count=2
```

## 参考

- [中文官方文档](https://shardingsphere.apache.org/document/current/cn/overview/)
- [sharding-spring-boot-jpa-example](https://gitee.com/AmosWang/shardingsphere/tree/master/examples/shardingsphere-jdbc-example/sharding-example/sharding-spring-boot-jpa-example)
- 方志朋 [分库分表之 Sharding-JDBC 中间件，看这篇真的够了!](https://mp.weixin.qq.com/s/-JwIS3MmNFl0b2rEQLcZSg)
