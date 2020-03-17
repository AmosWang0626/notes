---
title: Docker 项目部署注意事项
date: 2020-03-17
categories: Docker
tags:
- docker
---

# Docker 项目部署注意事项

## Dockerfile

- 容器时区错误
```dockerfile
RUN echo "Asia/Shanghai" > /etc/timezone
```

- 设置 JVM 启动参数
```dockerfile
ENTRYPOINT ["java", "-Xmx512M", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=/log/manager/", "-XX:+PrintGCDetails", "-XX:+PrintGCDateStamps", "-XX:+PrintHeapAtGC", "-Xloggc:/log/manager/gc.log", "-cp", "app:app/lib/*", "com.eastrobot.kbs.KbasePsrtApplication"]
```

- `ENTRYPOINT []` 里的参数要用双引号逗号隔开，不可写在一起
- 执行命令时，不会自动创建文件夹，故没有的文件要提前创建（创建方式如下）
- 以上命令等价于
    ```shell script
    java -Xmx512M -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/log/manager/ -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintHeapAtGC -Xloggc:/log/manager/gc.log -cp app:app/lib/* com.eastrobot.kbs.KbasePsrtApplication
    ```

- 给容器创建文件夹
```dockerfile
RUN mkdir --parents /log/manager/
```

## Docker 项目启动相关

- 日志有报错
  - `When netty_transport_native_epoll_x86_64 cannot be found, stacktrace is logged`
  - 忽略即可，具体可参照[netty/issues/7319](https://github.com/netty/netty/issues/7319)

- 常用命令（示例，后续会用到docker-compose或者k8s）
  - `docker run -d -p 8088:8088 --name manager kbs/manager`
  - `docker logs manager -f --tail 200`
  - `docker exec -it manager sh`
  - `docker inspect manager`
  - `docker stop manager & docker rm manager`

