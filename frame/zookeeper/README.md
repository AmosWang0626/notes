---
title: Zookeeper 学习
date: 2020-03-22
---

# Zookeeper 学习
> 系统地学习下，更好地理解 Dubbo + ZK，Kafka + ZK 等等

## 文件系统 + 通知机制
> 是一种基于观察者模式的分布式服务管理框架，他负责存储和管理大家都关心的数据，然后接受观察者的注册，
一旦这些数据的状态发生变化，Zookeeper就将负责通知已经在Zookeeper上注册的那些观察者做出相应的
反应，从而实现集群中类似Master/Slave管理模式

## 基础须知
> 它是个类文件系统，每个`znode`目录节点都可以正常地增加、删除，不一样的是`znode`可以保存数据。
>
> 默认每个`znode`只能保存1MB数据。如需扩展 `zkEnv.sh` 后边加上 `-Djute.maxbuffer=10240000`。

## 为什么这么受欢迎
> Zookeeper提供了一套很好的分布式集群管理的机制，就是它这种基于层次型的目录树的数据结构，并对树中
的节点进行有效管理，从而可以设计出多种多样的分布式的数据管理模型，作为分布式系统的沟通调度桥梁。

## 四种类型的 `znode`

1. `PERSISTENT` 持久化目录节点
  > 客户端与zookeeper断开连接后，该节点依旧存在

2. `PERSISTENT_SEQUENTIAL` 持久化顺序编号目录节点
  > 客户端与zookeeper断开连接后，该节点依旧存在，只是Zookeeper给该节点名称进行顺序编号

3. `EPHEMERAL` 临时目录节点
  > 客户端与zookeeper断开连接后，该节点被删除

4. `EPHEMERAL_SEQUENTIAL` 临时顺序编号目录节点
  > 客户端与zookeeper断开连接后，该节点被删除，只是Zookeeper给该节点名称进行顺序编号

## 启动
- x86下的Docker
  - `docker run -d -p 2181:2181 --restart=always --name zk zookeeper`
- arm下的Docker（树莓派）
  - `docker run -d -p 2181:2181 --restart=always --name zk charlesyan/rpi-zookeeper`

## `znode` 常用命令 crud
### 增加
- 创建 `create -s -e path data`
  - 反例：`create /amos/hello "this is data"` 失败原因：`amos`节点不存在
  - 正例：`create /amos "this is data"`
  - 正例：`create /amos/hello "hello amos~~"`

### 删除
- 删除 `delete path`
  > 如果节点含有子节点，会报错 `Node not empty: ***`
  - `delete /amos`
- 级联删除 `rmr path`
  > 乍一看，有点不安全，直接带子节点都干掉了
  - `rmr /amos`

### 修改
- 修改 `set path`
  - `set /amos "你好呀"`

### 查询
- `get path`
  - `get /amos`

- `stat path`
  - `stat /amos`
    > 首先科普下 Zxid，对应下边的 `cZxid/mZxid/pZxid`，简单说就是 ZooKeeper 的事务id
    >
    > ZooKeeper状态的每一次改变, 都对应着一个递增的`Transaction id`, 该`id`称为`Zxid` 
    >
    > ZooKeeper 版本 3.4.9
  - cZxid = 创建者的ZooKeeper的事务id
  - ctime = 创建时间
  - mZxid = 修改者的ZooKeeper的事务id
  - mtime = 更新时间
  - pZxid = 和子节点有关，与最新创建的子节点cZxid相对应（网上很多说法都是错的）
  - cversion = 子节点的版本，创建子节点+1
  - dataVersion = 当前节点数据版本
  - aclVersion = 当前节点acl版本号（acl节点被修改次数，每修改一次值+1）
  - ephemeralOwner = 临时节点标示，当前节点如果是临时节点，则存储的创建者的会话id（sessionId）
  - dataLength = 当前节点数据长度
  - numChildren = 当前节点子节点个数

- `ls path`
  - `ls /amos`

- `ls2 path`
  > `ls2 = ls + stat`
  - `ls2 /amos`

## `znode` 配额设置
> 支持设置 -n节点数（包括自己） 和 -b字节数
>
> 注意：超出配额不会导致新增或修改失败，只是会在 ZK 的日志中打印警告
- 增 `setquota -n|-b val path`
  - `setquota -n 2 /amos`
  - `setquota -b 64 /amos`
- 删 `delquota [-n|-b] path`
  - `delquota -n /amos`
  - `delquota -b /amos`
  - 删掉了吗？
    - `ls /zookeeper/quota`
    - 没删掉？`delquota /amos`
- 改 （不支持修改，只能删了重建）
- 查 `listquota path`
  - `listquota /amos`

## 代码走起
> [github](https://github.com/AmosWang0626/chaos/tree/master/chaos-frame/src/main/java/cn/amos/frame/zookeeper)
- [SimpleZk] 简单新增节点、获取节点
- [OneWatchZk] 监听数据变化（只监听一次）
- [MoreWatchZk] 监听数据变化（每次变化都监听）
- [ChildWatchZk] 监听子节点变化
