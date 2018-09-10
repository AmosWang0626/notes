# Zookeeper 分布式之中流砥柱

    docker search zookeeper
    
    docker pull zookeeper
    
    docker run --name amos-zookeeper --restart always -d zookeeper
    
    docker exec -it amos-zookeeper bash

## docker run [参数]

    docker run --link 已运行的容器名:自定义的别名
    注意: --link已过时
    
    docker run --rm
        容器退出时就能够自动清理容器内部的文件系统
    
### 使用 network 替代 --link
    1.创建网络
    docker network create amos-net
    
    2.查看网络
    docker network ls
    docker network inspect amos-net
    
    3.该net下运行zookeeper
    docker run --name amos-zookeeper --restart always -d --network amos-net --network-alias amos-zookeeper-net zookeeper

    4.移除网络
    docker network rm amos-net
    
    5.连接zookeeper zkCli.sh
    docker exec -it amos-zookeeper zkCli.sh


