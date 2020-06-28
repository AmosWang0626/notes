---
title: 上手 Swagger3.0.0-SNAPSHOT,增加支持 WebFlux
date: 2020-02-12
categories: Java
---


# 上手 Swagger Webflux（v2.10.5）
> `Swagger [2.10+)` 支持 Webflux。
>
> 之前为了使用支持Webflux的Swagger，使用了快照版3.0.0-SNAPSHOT，从生产来讲还是不安全的。


## 一、Webflux
1. 引入依赖

    ```xml
    <properties>
        <swagger.version>2.10.5</swagger.version>
    </properties>
    ```
    
    ```xml
    <dependencies>
        <dependency>
             <groupId>io.springfox</groupId>
             <artifactId>springfox-swagger-ui</artifactId>
             <version>${swagger.version}</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>${swagger.version}</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-spring-webflux</artifactId>
            <version>${swagger.version}</version>
        </dependency>
    </dependencies>
    ```

2. 添加注解

    `@EnableSwagger2WebFlux`

3. 配置文件

    - [Swagger配置-SwaggerConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-gateway/src/main/java/com/mall/gateway/config/SwaggerConfig.java)
    - [Swagger配置-WebFluxConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-gateway/src/main/java/com/mall/gateway/config/WebFluxConfig.java)


## 二、WebMVC

1. 引入依赖

    ```xml
    <properties>
        <swagger.version>2.10.5</swagger.version>
    </properties>
    ```
    
    ```xml
    <dependencies>
        <dependency>
             <groupId>io.springfox</groupId>
             <artifactId>springfox-swagger-ui</artifactId>
             <version>${swagger.version}</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-swagger2</artifactId>
            <version>${swagger.version}</version>
        </dependency>
        <dependency>
            <groupId>io.springfox</groupId>
            <artifactId>springfox-spring-webmvc</artifactId>
            <version>${swagger.version}</version>
        </dependency>
    </dependencies>
    ```

2. 添加注解

    `@EnableSwagger2WebMvc`

3. 配置文件

    - [Swagger配置-SwaggerConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-user/src/main/java/com/mall/user/config/SwaggerConfig.java)
    - [Swagger配置-WebMvcConfig.java](https://github.com/AmosWang0626/mall/blob/master/mall-user/src/main/java/com/mall/user/config/WebMvcConfig.java)


## 三、相关源码
- WebMvc，可参考 [mall-user模块](https://github.com/AmosWang0626/mall/tree/master/mall-user)
- Webflux，可参考 [mall-gateway模块](https://github.com/AmosWang0626/mall/tree/master/mall-gateway)
    > 支持聚合 API，也就是 gateway 里边聚合了user、order等子服务的swagger，子服务无需依赖 springfox-swagger-ui，更简洁
