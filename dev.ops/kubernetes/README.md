---
title: K8S集群实战
date: 2020-05-25
categories: k8s
tags:
- k8s

---


# k8s集群实战

> 看了周玉强老师讲的K8S集群实战，感觉门槛降低了好多，一年前看K8S，真的是好麻烦。

## 1. 环境准备

| 主机名     | IP 地址   | 角色         |
| ---------- | --------- | ------------ |
| k8s-master | 10.0.0.11 | master, node |
| k8s-node1  | 10.0.0.12 | node         |
| k8s-node2  | 10.0.0.13 | node         |

| 主机名     | 安装的服务                                                   |
| ---------- | ------------------------------------------------------------ |
| k8s-master | etcd / api-server / controller-manager / scheduler \| kubelet / kube-proxy / docker |
| k8s-node1  | kubelet / kube-proxy / docker                                |
| k8s-node2  | kubelet / kube-proxy / docker                                |

注：整体为一个`master`节点，三个`node`节点，因为`k8s-master`机器上也有一个`node`节点。

![](https://gitee.com/AmosWang/resource/raw/master/image/k8s/k8s-centos-init.png)

编辑`/etc/hosts`，同时改下其他两台机器

```shell
10.0.0.11 k8s-master
10.0.0.12 k8s-node1
10.0.0.13 k8s-node2
```

- `scp -rp /etc/hosts 10.0.0.12:/etc/hosts`
- `scp -rp /etc/hosts 10.0.0.13:/etc/hosts`

## 2. 安装组件

### 2.1 etcd

1. 安装命令

   `yum install -y etcd`

2. 修改配置 `/etc/etcd/etcd.conf`

   ```shell
   ETCD_LISTEN_CLIENT_URLS="http://0.0.0.0:2379" #6行
   ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.11:2379" #21行
   ```

   小技巧

   - `vim`选中一个单词 `viw`
   - `vim`看第几行 `:set number`

3. 启动并设置开机启动

   - `systemctl start etcd`
   - `systemctl enable etcd`
   - `netstat -nlupt`

4. 测试一下

   - `etcdctl set test/test_key 1433233`
   - `etcdctl get test/test_key`
   - `etcdctl -C http://10.0.0.11:2379 cluster-health`

### 2.2 kubernetes-master

1. 安装命令

   `yum install -y kubernetes-master.x86_64`

2. 修改配置`/etc/kubernetes/apiserver`

   ```shell
   KUBE_API_ADDRESS="--insecure-bind-address=0.0.0.0" #8行
   KUBE_API_PORT="--port=8080" #11行
   KUBELET_PORT="--kubelet-port=10250" #14行
   KUBE_ETCD_SERVERS="--etcd-servers=http://10.0.0.11:2379" #17行
   KUBE_ADMISSION_CONTROL="--admission-control=" #23行 初学者可先去掉所有权限
   ```

3. 修改配置`/etc/kubernetes/config`

   controller-manager scheduler 共用的配置文件

   ```shell
   KUBE_MASTER="--master=http://10.0.0.11:8080" #22行
   ```

4. 启动并设置开机启动

   - `systemctl start kube-apiserver`
   - `systemctl start kube-controller-manager`
   - `systemctl start kube-scheduler`
   - `systemctl enable kube-apiserver`
   - `systemctl enable kube-controller-manager`
   - `systemctl enable kube-scheduler`

5. 测试一下

   - `kubectl get componentstatus` 或者 `kubectl get cs`
   - 正常来说，此时执行是会报错的，安装完 kubernetes-node 再试试

6. 启动失败？

   1. 看启动状态：`systemctl status xxx -l`

      -  -l 表示查看详细信息
      -  看日志看什么，正常输出是INFO，也就是 Ixxx；错误就是 Exxx了

   2. 重启 `systemctl restart xxx`

   3. `Job for kube-apiserver.service failed because the control process exited with error code. See "systemctl status kube-apiserver.service" and "journalctl -xe" for details.`

      检查下端口是否被占用，如果是记得把`apiserver config`相应配置的端口改下

   4. `k8s getsockopt: connection refused`

      关闭防火墙 `systemctl stop firewalld`

      重启 `etcd`、`apiserver`、`kube-controller-manager`、`kube-scheduler`

### 2.3 kubernetes-node
  > 另外两台服务器同理，需要相应配置 `/etc/kubernetes/config 等`，
  > 配置 `etcd`、`master` 的地址

1. 安装命令

   `yum install -y kubernetes-node.x86_64`

2. 卸载Docker

   如果机器上之前安装过`docker`，先安装下试试，如果失败了，就把原有`docker`卸载了。

   因为`k8s`与`docker`搭配的版本有要求，安装`kubernetes-node`会自动安装`docker`，卸载命令如下：

   ```shell
   yum list installed | grep docker
   yum -y remove xxx && yum -y remove xxxx # 依次删除即可
   ```

3. 修改配置

   ```shell
   KUBELET_ADDRESS="--address=10.0.0.11" #5
   KUBELET_PORT="--port=10250" #8
   KUBELET_HOSTNAME="--hostname-override=master" #11
   KUBELET_API_SERVER="--api-servers=http://10.0.0.11:8080" #14
   ```

4. 启动并设置开机启动

   - `systemctl start kubelet`
     - 启动`kubelet`会自动启动`docker`
     - `systemctl status docker`
   - `systemctl start kube-proxy`
   - `systemctl enable kubelt`
   - `systemctl enable kube-proxy`

5. 测试一下

   ```shell
   kubectl get cs # kubectl get componentstatus
   kubectl get nodes
   kubectl --server=0.0.0.0:8080 get cs # 如果上边命令不可以，那么可以试下这个
   kubectl --server=0.0.0.0:8080 get nodes # 同上（目测apiserver配置有问题）
   ```

### 2.4 flannel

1. 安装命令

   `yum install -y flannel`

2. 修改配置`vim /etc/sysconfig/flanneld`

   ```shell
   FLANNEL_ETCD_ENDPOINTS="http://10.0.0.11:2379" #3
   ```

   `etcdctl set /atomic.io/network/config '{ "Network": "172.16.0.0/16" }'`

3. 启动并设置开机启动

   - `systemctl start flanneld`
   - `systemctl enable flanneld`

4. 测试一下

   - 查看网络配置 `ifconfig`

     会发现多了一块网卡，并且`docker`的`ip`和`flannel`的`ip`不是一个网段

   - Docker重启`systemctl restart docker`

   - 再次查看网络配置 `ifconfig`

     会发现`docker`和`flannel`已经在同一个网段了

5. 不同机器上的`node`网络互通

   1. `docker run -it busybox` 然后 ping 下其他服务，会发现不能 ping 通，故进行下列操作。

   2. `iptables -L -n`

      1. -L 列出所有规则
      2. -n 以数字方式展示`ip`
      3. 可以看到 `Chain FORWARD (policy DROP)` 把这里的 DROP 改成 ACCEPT即可
      4. `iptables -P FORWARD ACCEPT`

   3. 将配置加入Docker启动文件中

      ```shell
      systemctl status docker # 找到docker启动文件位置
      which iptables
      vim /usr/lib/systemd/system/docker.service
      # 增加如下配置
      ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT
      # 重新加载配置
      systemctl daemon-reload
      ```

## 3. 创建pod

---

未完待续。。。

- 2020-05-25 23:45
- 2020-05-26 23:19
- 2020-05-27 23:26

# 模板

## 1. 组件安装模板

1. 安装命令
2. 修改配置
3. 启动并设置开机启动
4. 测试一下

## 2. K8S实操模板

1. 实验作用与目标
2. 实践命令
3. 注意事项