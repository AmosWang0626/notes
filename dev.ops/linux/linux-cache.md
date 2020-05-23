---
title: 系统相关 Linux 缓存清理
date: 2020-05-21
categories: 系统相关
tags:
- 系统相关
---


# Linux 缓存清理
> 偶然想到，文章正确的顺序是什么。解决问题的办法放最后，前边一堆铺垫吊胃口？那就反过来吧，正如`有余力则学文`。

## 一、缓存释放办法
1. 清理`page_cache`（page_cache是硬盘和内存之间的缓存）:
   - `sync && echo 3 > /proc/sys/vm/drop_caches`

2. 清理可回收的`slab`对象（包括目录缓存、文件缓存）:
   - `sync && echo 2 > /proc/sys/vm/drop_caches`

3. 清理`slab`对象和`page_cache`:
   - `sync && echo 1 > /proc/sys/vm/drop_caches`

4. [内核官方文档](https://www.kernel.org/doc/Documentation/sysctl/vm.txt)
    ```text
    To free pagecache:
    echo 1 > /proc/sys/vm/drop_caches
    To free reclaimable slab objects (includes dentries and inodes):
    echo 2 > /proc/sys/vm/drop_caches
    To free slab objects and pagecache:
    echo 3 > /proc/sys/vm/drop_caches
    ```
    - inode 是表示文件的数据结构（下文详细介绍）
    - dentries 是表示目录的数据结构

## 二、缓存产生原因
缓存的原理类同：热点数据，首次访问，读写磁盘，然后缓存起来；下次访问，从缓存中拿。

## 三、free命令详解
> free显示系统中空闲和使用的物理内存和交换内存的总量，以及内核使用的缓冲区和缓存。
>
> 这些信息是通过解析 `/proc/meminfo` 来收集展示:

* total (总内存)
  > 对应 `/proc/meminfo` 中的 `MemTotal + SwapTotal`

* used (已使用内存 = `total - free - buffers - cache`)

* free (空闲内存)
  > 对应 `/proc/meminfo` 中的 `MemFree + SwapFree`

* shared (主要是tmpfs使用的内存)
  > 对应 `/proc/meminfo` 中的 `Shmem`, 在内核 2.6.32 中可用，如果不可用则显示为 `0`

* buffers (内核缓冲区使用的内存)
  > 对应 `/proc/meminfo` 中的 `Buffers`

* cache (page cache 和 slabs 使用的内存 )
  > 对应 `/proc/meminfo` 中的 `Cached` + `Slab`

* buff/cache (`buffers + cache`)

* available (估算的可用内存)
  > 估算的启动一个新应用程序可以使用的内存，与缓存或空闲字段提供的数据不同，该字段考虑了page cache，而且由于某些缓存正在使用，并非所有可回收的内存 slabs 都将被回收。
  >
  > 对应 `/proc/meminfo` 中的 `MemAvailable`, 在内核3.14上可用, 在内核2.6.27+上仿真, 否则与`free`相同

## 四、inode详解

### 是什么呢
文件存储在硬盘上，硬盘存储最小单位为扇区（sector，512Byte = 0.5KB）

文件数据存储在块中，块是文件存取的最小单位，由多个扇区组成，最常见的是4KB（block = 8 * sector）

数据存起来了，很显然，我们还必须找到一个地方储存文件的“元信息”，比如文件的创建者、文件的创建日期、文件的大小等等。

这种储存文件元信息的区域就叫做inode，中文译名为"索引节点"。每一个文件都有对应的inode，里面包含了与该文件有关的一些信息。

### 眼见为实

Unix/Linux 系统内部不使用文件名，而使用 inode编号 来识别文件。对于系统来说，文件名只是 inode编号 便于识别的别称或者绰号。

也就是说，文件名能推导出 inode编号（file_name > inode_no），一般无法从 inode编号 得知文件名。

```shell script
ls -i
1184913 containerd  1056775 data  1052744 hexo  1180274 nginx
```

inode编号的妙用：删除特殊文件名的文件
- `ll -i`
- `find . -inum 1057011 -exec rm {} \;`

  ```shell script
  # echo hi > hello.txt
  # ll -i
  total 1
  1057011 -rw-r--r-- 1 root root    3 May 23 17:04 hello.txt
  # find . -inum 1057011 -exec rm {} \;
  # ll
  total 0
  ```

### inodes耗尽？
inode 一般是128字节或256字节。

通常不会耗尽，但是当创建特别多小文件时（文件大小 < inode大小）。


## 参考文章
- [再谈slab](https://zhuanlan.zhihu.com/p/61457076)
- [Linux系统inodes资源耗尽问题](https://blog.csdn.net/T146lLa128XX0x/article/details/97198537)
- [Linux的inode的理解](https://blog.csdn.net/xuz0917/article/details/79473562)
- [Linux内存分析与清理](https://www.jianshu.com/p/774551e6b3ba)

