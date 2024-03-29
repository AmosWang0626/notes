---
title: 系统相关 Linux 文件系统
date: 2019-02-21
categories: 系统相关
tags:
- 系统相关
- docker
- 精选文章
---

# Linux 文件系统

## 看下服务器的文件系统

### 1. `df -T -h`

```shell
[root@VM-16-11-centos ~]# df -T -h
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  1.9G     0  1.9G   0% /dev
tmpfs          tmpfs     1.9G   24K  1.9G   1% /dev/shm
tmpfs          tmpfs     1.9G  832K  1.9G   1% /run
tmpfs          tmpfs     1.9G     0  1.9G   0% /sys/fs/cgroup
/dev/vda1      ext4       59G  9.0G   48G  16% /
overlay        overlay    59G  9.0G   48G  16% /var/lib/docker/overlay2/c71d4aaa1ad56fcd6cddb3194a01d7b2321048c96ae7173d3d6818d3cc98b18d/merged
overlay        overlay    59G  9.0G   48G  16% /var/lib/docker/overlay2/a84f2916e02a2ed5c3346f34a870c63a969e9dc68bc2d1b7ca4be142af86644a/merged
tmpfs          tmpfs     378M     0  378M   0% /run/user/0
overlay        overlay    59G  9.0G   48G  16% /var/lib/docker/overlay2/cce7e3b27ad5ce15c4ffef20201afbc0357614a5165d1c17b58a03690f1c9086/merged
overlay        overlay    59G  9.0G   48G  16% /var/lib/docker/overlay2/ba85761fc7985418aac3c4478d300cfcd8e5c0e0d4dc794692a2a0e33255bb2a/merged
overlay        overlay    59G  9.0G   48G  16% /var/lib/docker/overlay2/f88f5ce04eb347929e7c57e883614bc8d3ed260530bc49026c1a353a4874b399/merged
```

### 2. `cat /etc/fstab`

```shell
[root@VM-16-11-centos ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Tue Nov 26 02:11:36 2019
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
UUID=659e6f89-71fa-463d-842e-ccdf2c06e0fe /                       ext4    defaults        1 1
```

## 内存文件系统 tmpfs

- tmpfs 是 Linux/Unix 系统上的一种基于内存的文件系统。 tmpfs 可以使用您的内存 或 swap 分区来存储文件。在 Redhat/CentOS 等 linux 发行版中默认大小为物理内存的一半。
- tmpfs 既可以使用物理内存，也可以使用交换分区，因为 tmpfs 使用的是“虚拟内存”。 Linux 内核的虚拟内存同时来源于物理内存和交换分区，主要由内核中的 VM 子系统进行调度，进行内存页和 SWAP 的换入和换出操作，tmpfs 自己并不知道这些页面是在交换分区还是在物理内存中。
- 如果你想使用 tmpfs ，那么最简单的办法就是直接将文件存放在 /dev/shm 下，虽然这并不是推荐的方案，因为 /dev/shm 是给共享内存分配的，共享内存是进程间通信的一种方式。

## 堆叠文件系统 overlay
> 目前 docker 默认的文件系统为 overlay2
>
> 可以通过 `docker info | grep "Storage Driver"` 查看

### 启动一个容器看看

![df -h](https://gitee.com/AmosWang/resource/raw/master/image/linux-df.png )

- 以 Docker 私有仓库 registry 镜像为例
  - `docker search registry`

- 每运行一个 docker 容器，就会对应一个 overlay
  - `docker run -d -p 5000:5000 --name registry registry`

- 如上图，registry 启动后的容器
  - `bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7`

- 使用 mount 查看已挂载的文件系统

```shell
$ mount |grep overlay2
overlay on /var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/merged
type overlay (rw,relatime,
lowerdir=/var/lib/docker/overlay2/l/QBDC3JTO6OJCKBGECABICLCGQA:/var/lib/docker/overlay2/l/YPDPWIL42CORMMVBBPDPSWLEF4:/var/lib/docker/overlay2/l/TRWDRE65Z2R7EZ6RZMDZYXXWAV:/var/lib/docker/overla2/l/LFP3RV3DQMHSDYUIQZO6XI6GUA:/var/lib/docker/overlay2/l/CTA7FIGTQQGU6AFA2HS665N47Y:/var/lib/docker/overlay2/l/2UREITCJ5P36FBPLQQTCLY6Z55,
upperdir=/var/lib/dockeroverlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/diff,workdir=/var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/work)
```

### 文件系统分析

1.两个的关键词：lowerdir、upperdir

  - 堆叠文件系统，顾名思义，有层次地堆叠在意思
  - 在merged目录下，用户会无感知地看到 upperdir、lowerdir...（可能含多个）目录下的内容
  - merged = upperdir + lowerdir... (同名文件选高层次文件)
  - 当 upperdir、lowerdir...目录文件有冲突时，会根据层次关系选择性屏蔽，当然lowerdir也有层次关系

2.一探究竟

![一探究竟](https://gitee.com/AmosWang/resource/raw/master/image/linux-df-overlay.png )

  - `cd /var/lib/docker/overlay2/bfb72e399ad50db625cea381e56dd4550cf15173e7360bb135d4539a11285fe7/`
  - lower：用来存储只读的信息，为了节省空间，用硬链接实现
    - 软链接：`lrwxrwxrwx` “ l ” 开头，类似快捷方式
    - 硬链接：`-rw-r--r--` “ - ” 开头，类似复制，但又能保持和源文件同步
  - diff：用来记录删除和修改的文件，而 merged 里能看到所有文件
  - merged：容器运行时存在， 能看到容器中所有的文件
