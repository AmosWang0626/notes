# Zookeeper 分布式之中流砥柱

## 基本命令

- docker search zookeeper
- docker pull zookeeper
- docker run -d --name zoo -p 2181:2181 zookeeper

## 连接zk【使用 network 代替 --link】
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

## docker 命令

- docker run --link 已运行的容器名:自定义的别名
  - 注意: --link 已过时，不建议使用，以及不建议在 docker-compose 中使用

- docker run --rm
  - 容器退出时就能够自动清理容器内部的文件系统

- docker run --network net --network-alias zk-net
  - --network 指定网络
  - --network-alias 定义别名

## zookeeper 命令

1. 显示根目录下、文件： ls / 使用 ls 命令来查看当前 ZooKeeper 中所包含的内容
2. 显示根目录下、文件： ls2 / 查看当前节点数据并能看到更新次数等数据
3. 创建文件，并设置初始内容： create /zk test 创建一个新的 znode节点“ zk ”以及与它关联的字符串
4. 获取文件内容： get /zk 确认 znode 是否包含我们所创建的字符串
5. 修改文件内容： set /zk "zkbak" 对 zk 所关联的字符串进行设置
6. 删除文件： delete /zk 将刚才创建的 znode 删除
7. 退出客户端： quit
8. 帮助命令： help


