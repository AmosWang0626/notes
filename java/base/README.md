---
title: Java 学习笔记
date: 2018-11-04
categories: Java
---


# Java 学习笔记

## Java移位运算
1. 左移运算符（X2）`<<` num << 1，相当于num乘以2
2. 右移运算符（/2）`>>` num >> 1，相当于num除以2
3. 无符号右移 `>>>` 忽略符号位，空位都以0补齐

## ArrayList和LinkedList的大致区别如下:
1. ArrayList是实现了基于动态数组的数据结构，LinkedList基于链表的数据结构。 
2. 对于随机访问get和set，ArrayList觉得优于LinkedList，因为LinkedList要移动指针。 
3. 对于新增和删除操作add和remove，LinedList比较占优势，因为ArrayList要移动数据。 

## 常见加密算法
1. 对称加密算法主要有：DES、3DES、AES
2. 非对称加密算法主要有：RSA、DSA
3. 散列算法：SHA-1、MD5

## 堆大小设置
> JVM 中最大堆大小有三方面限制：
- 相关操作系统的数据模型（32-bt还是64-bit）限制；
- 系统的可用虚拟内存限制；
- 系统的可用物理内存限制。
    - 32位系统下，一般限制在1.5G~2G；
    - 64为操作系统对内存无限制。

## 辅助信息
JVM提供了大量命令行参数，打印信息，供调试使用。主要有以下一些：

- -XX:+PrintGC
`[GC 118250K->113543K(130112K), 0.0094143 secs]`
`[Full GC 121376K->10414K(130112K), 0.0650971 secs]`

- -XX:+PrintGCDetails
`[GC [DefNew: 8614K->781K(9088K), 0.0123035 secs] 118250K->113543K(130112K), 0.0124633 secs]`
`[GC [DefNew: 8614K->8614K(9088K), 0.0000665 secs][Tenured: 112761K->10414K(121024K), 0.0433488 secs] 121376K->10414K(130112K), 0.0436268 secs]`

- -Xloggc:filename:与上面几个配合使用，把相关日志信息记录到文件以便分析。

## 常见配置汇总
### 堆设置
- -Xms:初始堆大小
- -Xmx:最大堆大小
- -XX:NewSize=n:设置年轻代大小
- -XX:NewRatio=n:设置年轻代和年老代的比值。如:为3，表示年轻代与年老代比值为1：3，年轻代占整个年轻代年老代和的1/4
- -XX:SurvivorRatio=n:年轻代中Eden区与两个Survivor区的比值。注意Survivor区有两个。如：3，表示Eden：Survivor=3：2，一个Survivor区占整个年轻代的1/5
- -XX:MaxPermSize=n:设置持久代大小

### 收集器设置
- -XX:+UseSerialGC:设置串行收集器
- -XX:+UseParallelGC:设置并行收集器
- -XX:+UseParalledlOldGC:设置并行年老代收集器
- -XX:+UseConcMarkSweepGC:设置并发收集器

### 垃圾回收统计信息
- -XX:+PrintGC
- -XX:+PrintGCDetails
- -XX:+PrintGCTimeStamps
- -Xloggc:filename

### 并行收集器设置
- -XX:ParallelGCThreads=n:设置并行收集器收集时使用的CPU数。并行收集线程数；
- -XX:MaxGCPauseMillis=n:设置并行收集最大暂停时间；
- -XX:GCTimeRatio=n:设置垃圾回收时间占程序运行时间的百分比。公式为1/(1+n)。

### 并发收集器设置
- -XX:+CMSIncrementalMode:设置为增量模式。适用于单CPU情况；
- -XX:ParallelGCThreads=n:设置并发收集器年轻代收集方式为并行收集时，使用的CPU数。并行收集线程数。

