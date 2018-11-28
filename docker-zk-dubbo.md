# Zookeeper 分布式之中流砥柱

## 一、基本命令

- docker search zookeeper
- docker pull zookeeper
- docker run -d --name zoo -p 2181:2181 zookeeper

## 二、连接 zookeeper
> 使用 network 代替 --link
- 1.创建网络
  - docker network create net

- 2.删除网络
  - docker network rm net

- 3.查看所有网络|查看指定网络详情
  - docker network ls
  - docker network inspect net

- 4.该net下运行zookeeper
  - docker run -d --name zoo --network net --network-alias zk-net zookeeper

- 5.连接zookeeper zkCli.sh
  - docker exec -it zoo zkCli.sh

- 6.查看zookeeper 状态
  - /zookeeper-3.4.13/bin/zkServer.sh {start|start-foreground|stop|restart|status|upgrade|print-cmd}
  - docker exec -it zoo zkServer.sh status

## 三、zookeeper
> 使用 docker-compose 进行集群部署
```yaml
version: '2'
services:
    zoo1:
        image: zookeeper
        restart: always
        container_name: zoo1
        ports:
            - "2181:2181"
        environment:
            ZOO_MY_ID: 1
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888

    zoo2:
        image: zookeeper
        restart: always
        container_name: zoo2
        ports:
            - "2182:2181"
        environment:
            ZOO_MY_ID: 2
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888

    zoo3:
        image: zookeeper
        restart: always
        container_name: zoo3
        ports:
            - "2183:2181"
        environment:
            ZOO_MY_ID: 3
            ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
```
- 使用 docker-compose.yml 启动集群
  - 下边这个是简化版, 启动集群默认找 docker-compose.yml
    - docker-compose -p zk_cluster up -d
    - docker-compose -f docker-compose.yml -p zk_cluster up -d
  - docker ps -a
  - docker stop zoo1 zoo2 zoo3
  - docker rm zoo1 zoo2 zoo3

## 四、dubbo-admin + zookeeper
```yaml
version: '3.5'
services:
  zoo1:
    image: zookeeper
    restart: always
    hostname: zoo1
    container_name: zookeeper_1
    #domainname:
    ports:
      - 2181:2181
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      - dubbo-net

  zoo2:
    image: zookeeper
    restart: always
    hostname: zoo2
    container_name: zookeeper_2
    ports:
      - 2182:2181
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      - dubbo-net

  zoo3:
    image: zookeeper
    restart: always
    hostname: zoo3
    container_name: zookeeper_3
    ports:
      - 2183:2181
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888
    networks:
      - dubbo-net

  dubbo-admin:
    image: chenchuxin/dubbo-admin
    container_name: dubbo
    ports:
      - 8080:8080
    links:
      - zoo1
      - zoo2
      - zoo3
    networks:
      - dubbo-net
    environment:
      - dubbo.registry.address=zookeeper://zoo1:2181|zookeeper://zoo2:2181|zookeeper://zoo3:2181
    depends_on:
      - zoo1
      - zoo2
      - zoo3

networks:
  dubbo-net:
    name: dubbo-net
    driver: bridge
```
- 启动 (注意当前路径下有 docker-compose.yml)
  - docker-compose up -d
- 查看与删除
    - docker ps -a
    - docker network ls
    - docker stop dubbo zookeeper_3 zookeeper_2 zookeeper_1
    - docker rm dubbo zookeeper_3 zookeeper_2 zookeeper_1
    - docker network rm dubbo-net

## 五、docker 命令

- docker run --link 已运行的容器名:自定义的别名
  - 注意: --link 已过时，不建议使用，以及不建议在 docker-compose 中使用

- docker run --rm
  - 容器退出时就能够自动清理容器内部的文件系统

- docker run --network net --network-alias zk-net
  - --network 指定网络
  - --network-alias 定义别名

- docker-compose
  - docker-compose -h|--help
  - docker-compose [-f <arg>...] [options] [COMMAND] [ARGS...]
    - -f, --file FILE            Specify an alternate compose file (default: docker-compose.yml)
    - -p, --project-name NAME    Specify an alternate project name


## 六、zookeeper 须知
> - 端口 2181 由 ZooKeeper 客户端使用，用于连接到 ZooKeeper 服务器;
> - 端口 2888 由对等 ZooKeeper 服务器使用，用于互相通信;
> - 端口 3888 用于领导者选举.

1. 显示根目录下、文件： ls / 使用 ls 命令来查看当前 ZooKeeper 中所包含的内容
2. 显示根目录下、文件： ls2 / 查看当前节点数据并能看到更新次数等数据
3. 创建文件，并设置初始内容： create /zk test 创建一个新的 znode节点“ zk ”以及与它关联的字符串
4. 获取文件内容： get /zk 确认 znode 是否包含我们所创建的字符串
5. 修改文件内容： set /zk "zkbak" 对 zk 所关联的字符串进行设置
6. 删除文件： delete /zk 将刚才创建的 znode 删除
7. 退出客户端： quit
8. 帮助命令： help
