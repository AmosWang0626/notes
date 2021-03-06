---
title: Linux inode 详解
date: 2019-01-01
categories: 系统相关
tags:
- 系统相关
---

# Linux inode 详解

> 命令行下中文名文件、或者乱码文件怎么删，你知道吗？

## 1. 是什么

文件存储在硬盘上，硬盘存储最小单位为扇区（1 sector = 512Byte = 0.5KB）。

文件数据存储在块中，块是文件存取的最小单位（1 block = 8 * sector = 4KB），由8扇区组成。

数据存起来了，很显然，我们还必须找到一个地方储存文件的“元信息”，比如文件的创建者、文件的创建日期、文件的大小等等。

这种储存文件元信息的区域就叫做inode，中文译名为“索引节点”。每一个文件都有对应的inode，里面包含了与该文件有关的一些信息。

## 2. 眼见为实

Unix/Linux 系统内部不使用文件名，而使用 `inode编号`（下文简称inode） 来识别文件。对于系统来说，文件名只是 inode 便于识别的别称或者绰号。

也就是说，文件名能推导出 inode（file_name > inode_no），一般无法从 inode 得知文件名。

- 查出来 `ls -i`
  > `1184913 containerd  1056775 data  1052744 hexo  1180274 nginx`

- 查看指定文件或文件夹inode信息 `stat xxx`

- 深入理解一哈

    - 移动文件、修改文件名，inode 是不会变的。

    - 硬链接：多个文件名指向同一个 inode，文件只有一个，所以修改任意一个都会影响所有。删除一个文件名，不会影响其他文件名访问文件。

    - 软链接：多个软链接 inode 是不一样的，软链接指向真实文件本身，软链接依赖真实文件存在，真实文件删了，软链接就失效了。

## 3. inode编号的妙用：删除特殊文件名的文件

- 查出来 `ll -i`
  > `1057011 -rw-r--r-- 1 root root    3 May 23 17:04 hello.txt`

- 执行删除 `find . -inum 1057011 -exec rm {} \;`

## 4. inodes耗尽？

查看硬盘inode使用情况 `df -i`

inode 一般是128字节或256字节。

通常不会耗尽，但是当创建特别多小文件时（文件大小 < inode大小）。