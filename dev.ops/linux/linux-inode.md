---
title: Linux inode详解
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---


# inode详解

> 命令行下中文名文件、或者乱码文件怎么删，你知道吗？

## 是什么呢

文件存储在硬盘上，硬盘存储最小单位为扇区（sector，512Byte = 0.5KB）

文件数据存储在块中，块是文件存取的最小单位，由多个扇区组成，最常见的是4KB（block = 8 * sector）

数据存起来了，很显然，我们还必须找到一个地方储存文件的“元信息”，比如文件的创建者、文件的创建日期、文件的大小等等。

这种储存文件元信息的区域就叫做inode，中文译名为"索引节点"。每一个文件都有对应的inode，里面包含了与该文件有关的一些信息。

## 眼见为实

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

## inodes耗尽？

inode 一般是128字节或256字节。

通常不会耗尽，但是当创建特别多小文件时（文件大小 < inode大小）。