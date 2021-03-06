---
title: Java JVM 基础
date: 2019-11-04
categories: Java
tags:
- jvm
- 精选文章
---

# Java JVM 基础
> 参考《深入理解Java虚拟机》

# 目录
> Java 1.8
1. 运行时数据区
2. 垃圾收集算法
3. 垃圾收集器

## 一、运行时数据区
![Java 1.8内存模型](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-memory-partition.png)

### 1.1 程序计数器
- （Program Counter Register）【线程隔离】
- 可简单理解为当前线程所执行的字节码行号指示器；
- 如果是java方法，计数器记录指向虚拟机字节码指令地址；如果是native方法，计数器值为undefined；
- 【异常相关】唯一一个没规定OOM的区域。

### 1.2 虚拟机栈
- （VM Stack）【线程隔离】
- 其描述的是Java方法执行的内存模型：【重点】每个方法执行的过程都会创建一个栈帧（Stack Frame）用于存储局部变量表、操作数栈、动态链接、方法出口等信息。方法调用到执行结束，对应着一个栈帧在虚拟机栈中入栈到出栈的过程；
- 【异常相关】如果线程请求的栈深度大于虚拟机所允许的深度，将抛出StackOverflowError异常。方法每次调用都会创建一个栈帧，然后栈帧压栈，总不能无限压栈吧（初看没看懂，搜了下，发现也有人没看懂，心里平衡点）；
- 【异常相关】大部分虚拟机栈都可以动态扩展，如果扩展时无法申请到足够的内存，就会OOM。
- 代码示例，见文末 code01.StackOverflowError
### 1.3 本地方法栈
- （Native Method Stack）【线程隔离】
- 与虚拟机栈的区别是，虚拟机栈执行java方法（字节码）服务；本非方法栈则为native方法服务；
- 【异常相关】StackOverflowError、OOM。
### 1.4 堆
- （Heap）【线程共享】
- GC堆（垃圾堆），是垃圾收集器管理的主要区域；
- java1.8之后【年轻代、老年代】。
- 代码示例，见文末 code02.OOM-heap
### 1.5 元数据区
- （Metaspace）【线程共享】
- jvm config example: `-XX:MetaspaceSize=8m -XX:MaxMetaspaceSize=50m`
- 元数据区取代了永久代，本质上都是方法区的实现，用来存放虚拟机加载的类信息、常量、静态变量、JIT编译后的代码。
- 代码示例，见文末 code03.OOM-metaspace

## 二、垃圾收集算法

- 对象在否？引用计数算法、可达性分析算法
  - 可达性分析
    > 通过一系列的称为 GC Roots 的对象作为起点, 然后向下搜索; 搜索所走过的路径称为引用链/Reference Chain, 
    当一个对象到 GC Roots 没有任何引用链相连时, 即该对象不可达, 也就说明此对象是不可用的, 因此也会被判定为可回收的对象。
  - 在java中可做GC Roots的对象包括：
    - 方法区: 类静态属性引用的对象;
    - 方法区: 常量引用的对象;
    - 虚拟机栈(本地变量表)中引用的对象.
    - 本地方法栈JNI(Native方法)中引用的对象。

  - 即使在可达性分析算法中不可达的对象,VM也并不是马上对其回收,至少还要经历两次标记过程: 
    - 第一次是在可达性分析后发现没有与GC Roots相连接的引用链
    - 第二次是GC对在F-Queue执行队列中的对象进行的小规模标记(对象需要覆盖finalize()方法且没被调用过)

- 标记-清除算法（先标记，再清除，清除后空间不连续，产生大量内存碎片）

- 复制算法
  - 年轻代：Eden : Survivor = 1:8，会有10%的内存“闲置”；
  - 每次GC后，存活的对象都会放在剩余的10%内存中，也就是To Survivor；
  - 当然，如果剩余的10%内存不够用呢，就需要依赖老年代进行分配担保。

- 标记-整理算法
  - 如果对象存活率较高，那么复制算法就不好用了；
  - 标记-清除算法之后，将所有存活的对象都向一端移动，然后清理掉边界以外的内存。

- 分代收集算法
  - 典型就是分为新生代和老年代
  - 新生代，存活率低，就使用复制算法
  - 老年代，存活率高，并且没有额外的空间做担保，所以使用“标记-清除”或者“标记-整理”算法

## 三、垃圾收集器

### 3.1 新生代收集器 Serial [jdk 1.3]
- 【单线程】历史悠久，新生代收集器，复制算法；
- GC时要STW，直到GC完成（你妈妈在打扫卫生，你一边乱扔纸屑，所以必须STW，你得老老实实坐着）；
- Client 模式下默认的新生代收集器（与其他单线程收集器相比，简单高效）。

### 3.2 新生代收集器 ParNew
- 【并行多线程】新生代收集器，复制算法，Serial收集器的多线程版本；
- 单CPU下，不会比Serial好；甚至双CPU都不能100%超越Serial；
- Server模式下首选新生代收集器，重要原因是，他能和CMS（真正意义上的并发收集器）配合工作。

### 3.3 新生代收集器 Parallel Scavenge [jdk 1.4]
- 【Throughput】吞吐量优先
- 【并行多线程】新生代收集器，复制算法；
- 关注点不一样，目标为可控的吞吐量（Throughput），其他的关注点是尽可能缩短GC STW时间；
- 吞吐量 = 运行用户代码时间 / （运行用户代码时间 + GC时间）

### 3.4 老年代收集器 Serial Old [jdk 1.5]
- 【单线程】老年代收集器，标记 - 整理算法；
- 主要用户Client 模式下虚拟机；Server模式下，1. JDK1.6以前与PS搭配使用；2. CMC收集器后备方案。

### 3.5 老年代收集器 Parallel Old [jdk 1.6]
- 【Throughput】吞吐量优先
- 【并行多线程】老年代收集器，标记 - 整理算法；
- jdk1.6以前，如果选了PS，就不能选CMS了，只能选Serial Old；
- 吞吐量优先第一组合。

### 3.6 老年代收集器 CMS [jdk 1.5]
- 【并发多线程】老年代收集器，基于标记 - 清除（初始 & 并发 & 重新 标记，并发清除）；
- 关注点不一样，目标为可控的吞吐量（Throughput），其他的关注点是尽可能缩短GC STW时间；
- 并发低停顿；缺点：CPU资源非常敏感、无法处理浮动垃圾、基于标记清除多碎片。

### 3.7 G1收集器 [jdk 1.6预览版, 1.7第一版, 1.8全功能完成, 1.9作为默认GC ]
- 【并行与并发】新生代+老年代收集器，整体基于标记 - 整理，局部（两个Region之间）基于复制算法；
- 消除新生代和老年代的物理隔离，将堆区划分为许多相同大小的Region单元；
- 使用Region划分内存空间，以及具有优先级的区域回收方式，保证了G1收集器在有限的时间内获取尽可能高的收集效率。

### 垃圾收集器总结
- 新生代收集器
  - Serial 单线程 [复制算法]
  - ParNew 并行多线程 [复制算法]
  - Parallel Scavenge 并行多线程 吞吐量优先 [复制算法]

- 老年代收集器
  - Serial Old 单线程 [标记-整理算法]
  - Parallel Old 并行多线程 吞吐量优先 [标记-整理算法]
  - CMS 并发多线程 [基于标记-清除]（内存碎片多）真正意义上的并发收集器

- 全区域收集器 —— G1收集器 并发多线程 [复制算法 / 标记-整理算法]
  - 全区域回收，替代CMS。同样用卡表处理跨代指针，但设计比CMS更加复杂，牺牲部分内存；
  - 当然，小内存服务器上现在的CMS还是比较适合的，当然随着HotSpot的开发者对G1的不断优化，这个内存的要求可能会更小点；
  - 在大内存应用上G1则大多能发挥其优势，这个优劣势的Java堆容量平衡点通常在6GB至8GB之间。

![垃圾收集器总结](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-gc-choose.png)

![jdk 1.6、1.7、1.8](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jdk1.6-8.png)
