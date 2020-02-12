---
title: 上手 Swagger3.0.0,增加支持 WebFlux
date: 2020-02-12
categories: Java
---

# 上手 Swagger3.0.0,增加支持 WebFlux
> 截至今天(2020年2月12日) swagger 3.X 尚未正式发布，项目需要，先用快照版

## 相关源码
- WebMvc，可参考 [mall-user模块](https://github.com/AmosWang0626/mall/tree/master/mall-user)
- WebFlux，可参考 [mall-gateway模块](https://github.com/AmosWang0626/mall/tree/master/mall-gateway)

## 一、添加 Swagger 3.X 仓库地址
1. 修改本机 maven 配置
    - Windows `C:\Users\User\.m2\setting.xml`
    - Mac `maven_home\conf\setting.xml`
    ```xml
    <mirror>
        <id>oss-snapshot</id>
        <name>OSS Snapshot</name>
        <url>http://oss.jfrog.org/oss-snapshot-local</url>
        <mirrorOf>*</mirrorOf>    
    </mirror>
    ```

2. pom 里添加仓库配置

    ```xml
    <repository>
       <id>oss-snapshot</id>
       <name>OSS Snapshot</name>
       <url>http://oss.jfrog.org/oss-snapshot-local</url>
       <snapshots>
           <enabled>true</enabled>
       </snapshots>
    </repository>
    ```

## 二、WebFlux 相关依赖
- 较之前用的WebMVC版本，增加一个依赖：springfox-spring-webflux
- [Swagger配置-SwaggerConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-gateway/src/main/java/com/mall/gateway/config/SwaggerConfig.java)
- [Swagger配置-WebMvcConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-gateway/src/main/java/com/mall/gateway/config/WebFluxConfig.java)

```xml
<dependencies>
    <dependency>
         <groupId>io.springfox</groupId>
         <artifactId>springfox-swagger-ui</artifactId>
         <version>3.0.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>3.0.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-spring-webflux</artifactId>
        <version>3.0.0-SNAPSHOT</version>
    </dependency>
</dependencies>
```


## 三、WebMVC 相关依赖

- 说两个注意点：
    - 一个项目里边，不要用多个版本的Swagger，也即都用 3.X
        > 我刚开始就犯了个错误，mall项目里边，准备gateway模块用3.X，其他模块用
        2.9，然后报了一堆错，例如spring-core-plugin版本冲突之类的，解决无果，浪费时间。
    - WebMVC 也要增加一个Maven依赖：springfox-spring-webmvc
        > 3.X以前，WebMVC下两个依赖就够了；升级3.X之后，swagger总是报错，提示有类找不到。
        看了好久，忽然想到，WebFlux 用了三个依赖，WebMVC应该也要用三个依赖，想法是对的。
- [Swagger配置-SwaggerConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-user/src/main/java/com/mall/user/config/SwaggerConfig.java)
- [Swagger配置-WebMvcConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-user/src/main/java/com/mall/user/config/WebMvcConfig.java)

```xml
<dependencies>
    <dependency>
         <groupId>io.springfox</groupId>
         <artifactId>springfox-swagger-ui</artifactId>
         <version>3.0.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>3.0.0-SNAPSHOT</version>
    </dependency>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-spring-webmvc</artifactId>
        <version>3.0.0-SNAPSHOT</version>
    </dependency>
</dependencies>
```

# 结语
> 初次使用 Swagger3.X，如有不当之处，还请不吝赐教