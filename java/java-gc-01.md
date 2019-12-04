---
title: Java GC 学习实践(上)
date: 2019-11-04
categories: java
tags:
- java
- gc
- jvm
---

> 参考《深入理解Java虚拟机》

# 目录（Java GC 学习实践）
1. 浅谈基础
  - 1.1 运行时数据区(Java 1.8)
  - 1.2 垃圾收集算法
  - 1.3 垃圾收集器
2. 解析 GC 日志
3. [JVM 监控工具](https://my.oschina.net/AmosWang/blog/3126060#h1_2)
4. [Linux 监控相关](https://my.oschina.net/AmosWang/blog/3126060#h1_3)

# 一、浅谈基础

## 1. 运行时数据区
![Java 1.8内存模型](https://oscimg.oschina.net/oscnet/b30e04a131a09aa938757def60ff5954bfc.jpg)

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

## 2. 垃圾收集算法

- 对象在否？引用计数算法、可达性分析算法
  - 可达性分析
    > 通过一系列的称为 GC Roots 的对象作为起点, 然后向下搜索; 搜索所走过的路径称为引用链/Reference Chain, 当一个对象到 GC Roots 没有任何引用链相连时, 即该对象不可达, 也就说明此对象是不可用的, 如下图: Object5、6、7 虽然互有关联, 但它们到GC Roots是不可达的,因此也会被判定为可回收的对象:
s
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

## 3. 垃圾收集器

### 3.1 新生代收集器 Serial
- 【单线程】历史悠久，新生代收集器，复制算法；
- GC时要STW，直到GC完成（你妈妈在打扫卫生，你一边乱扔纸屑，所以必须STW，你得老老实实坐着）；
- Client 模式下默认的新生代收集器（与其他单线程收集器相比，简单高效）。
### 3.2 新生代收集器 ParNew
- 【并行多线程】新生代收集器，复制算法，Serial收集器的多线程版本；
- 单CPU下，不会比Serial好；甚至双CPU都不能100%超越Serial；
- Server模式下首选新生代收集器，重要原因是，他能和CMS（真正意义上的并发收集器）配合工作。
### 3.3 新生代收集器 Parallel Scavenge
- 【Throughput】吞吐量优先
- 【并行多线程】新生代收集器，复制算法；
- 关注点不一样，目标为可控的吞吐量（Throughput），其他的关注点是尽可能缩短GC STW时间；
- 吞吐量 = 运行用户代码时间 / （运行用户代码时间 + GC时间）
### 3.4 老年代收集器 Serial Old
- 【单线程】老年代收集器，标记 - 整理算法；
- 主要用户Client 模式下虚拟机；Server模式下，1. JDK1.6以前与PS搭配使用；2. CMC收集器后背预案。
### 3.5 老年代收集器 Parallel Old
- 【Throughput】吞吐量优先
- 【并行多线程】老年代收集器，标记 - 整理算法；
- jdk1.6以前，如果选了PS，就不能选CMS了，只能选Serial Old；
- 吞吐量优先第一组合。
### 3.6 老年代收集器 CMS
- 【并发多线程】老年代收集器，基于标记 - 清除（初始 & 并发 & 重新 标记，并发清除）；
- 关注点不一样，目标为可控的吞吐量（Throughput），其他的关注点是尽可能缩短GC STW时间；
- 并发低停顿；缺点：CPU资源非常敏感、无法处理浮动垃圾、基于标记清除多碎片。
### 3.7 G1收集器
- 有点多，暂缓。。。

# 二、解析GC日志

## 1. 完整GC日志

```java
2019-11-04T16:05:43.267+0800: 147.981: [GC (Allocation Failure) [PSYoungGen: 150496K->5938K(147456K)] 198958K->57548K(202752K), 0.0304547 secs] [Times: user=0.05 sys=0.00, real=0.03 secs]
Heap after GC invocations=39 (full 3):
PSYoungGen      total 147456K, used 5938K [0x00000000f6700000, 0x0000000100000000, 0x0000000100000000)
eden space 141312K, 0% used [0x00000000f6700000,0x00000000f6700000,0x00000000ff100000)
from space 6144K, 96% used [0x00000000ffa00000,0x00000000fffcc8f8,0x0000000100000000)
to   space 7680K, 0% used [0x00000000ff100000,0x00000000ff100000,0x00000000ff880000)
ParOldGen       total 55296K, used 51610K [0x00000000e3400000, 0x00000000e6a00000, 0x00000000f6700000)
object space 55296K, 93% used [0x00000000e3400000,0x00000000e6666870,0x00000000e6a00000)
Metaspace       used 80445K, capacity 83414K, committed 83584K, reserved 1122304K
class space    used 10018K, capacity 10577K, committed 10624K, reserved 1048576K
}
{Heap before GC invocations=40 (full 4):
PSYoungGen      total 147456K, used 5938K [0x00000000f6700000, 0x0000000100000000, 0x0000000100000000)
eden space 141312K, 0% used [0x00000000f6700000,0x00000000f6700000,0x00000000ff100000)
from space 6144K, 96% used [0x00000000ffa00000,0x00000000fffcc8f8,0x0000000100000000)
to   space 7680K, 0% used [0x00000000ff100000,0x00000000ff100000,0x00000000ff880000)
ParOldGen       total 55296K, used 51610K [0x00000000e3400000, 0x00000000e6a00000, 0x00000000f6700000)
object space 55296K, 93% used [0x00000000e3400000,0x00000000e6666870,0x00000000e6a00000)
Metaspace       used 80445K, capacity 83414K, committed 83584K, reserved 1122304K
class space    used 10018K, capacity 10577K, committed 10624K, reserved 1048576K

=====================分割线==========================
2019-11-04T16:05:43.298+0800: 148.011: [Full GC (Ergonomics) [PSYoungGen: 5938K->0K(147456K)] [ParOldGen: 51610K->48605K(83968K)] 57548K->48605K(231424K), [Metaspace: 80445K->80445K(1122304K)], 0.3256949 secs] [Times: user=0.55 sys=0.00, real=0.32 secs]
=====================。。。==========================
```

## 2. 提取主要内容

```java
2019-11-04T16:05:43.267+0800: 147.981: [GC (Allocation Failure) [PSYoungGen: 150496K->5938K(147456K)] 198958K->57548K(202752K), 0.0304547 secs] [Times: user=0.05 sys=0.00, real=0.03 secs]
```

```java
2019-11-04T16:05:43.298+0800: 148.011: [Full GC (Ergonomics) [PSYoungGen: 5938K->0K(147456K)] [ParOldGen: 51610K->48605K(83968K)] 57548K->48605K(231424K), [Metaspace: 80445K->80445K(1122304K)], 0.3256949 secs] [Times: user=0.55 sys=0.00, real=0.32 secs]
```

## 3. 分析日志

- `147.981` 和 `148.011`: JVM启动以来经过的秒数

- `GC` 和 `Full GC`: 表示垃圾收集停顿类型。注意：不是用来区分新生代还是老年代的
  - `GC (Allocation Failure)` Allocation Failure 指分配失败，也即空间不足；
  - `Full GC (Ergonomics)` Ergonomics 可以理解为自适应，表示自动的调节STW时间和吞吐量之间的平衡；
  - `Full GC (System)` 调用 `System.gc()` 触发的GC。

- `[PSYoungGen: 150496K->5938K(147456K)]`
  - PSYoungGen，PS表示Parallel Scavenge收集器
  - DefNew（Default New Generation），也即使用Serial收集器

- `[ParOldGen: 51610K->48605K(83968K)]`
  - ParOldGen，ParOld表示Parallel Old收集器，吞吐量优先

- `[XXXXXX: 150496K->5938K(147456K)]`
  - `150496K->5938K(147456K)` GC前该内存区域已使用容量 -> GC后该内存区域已使用容量(该内存区域总容量)

- `198958K->57548K(202752K)` GC前Java堆已使用容量 -> GC后Java堆已使用容量(Java堆总容量)

- `0.0304547 secs` GC耗时合计(secs秒)

- `[Times: user=0.05 sys=0.00, real=0.03 secs]` 用户态CPU耗时、内核态CPU耗时和墙钟时间
  - CPU时间与墙钟时间区别：墙钟时间包括各种非运算等待耗时，例如等待磁盘、线程阻塞；
  - 当多CPU或者多核的话，多线程会叠加这些CPU时间，所以user或sys超过real是完全正常的。


# 代码示例

## code01.StackOverflowError

```java
public class StackOverflowMain {

    public static void main(String[] args) {
        // will throw java.lang.StackOverflowError
        Test test = new Test();
        try {
            test.increment();
        } catch (StackOverflowError e) {
            System.out.println("sof error, this count is " + test.count);
            e.printStackTrace();
        }
    }

    static class Test {
        private static int count;
        void increment() {
            count++;
            increment();
        }
    }

}
```

## code02.OOM-heap

```java
public class OOMMain {

    private static String STR = "string";

    /**
     * -verbose:gc -XX:+HeapDumpOnOutOfMemoryError
     * -XX:HeapDumpPath=C:\\Users\\User\\Desktop\\gc
     * will throw oom by Java heap space
     */
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        while (true) {
            list.add(STR += STR);
        }
    }

}
```

## code03.OOM-metaspace

```java
public class OOMByCglibMain {

    /**
     * -verbose:gc -XX:+HeapDumpOnOutOfMemoryError
     * -XX:HeapDumpPath=C:\\Users\\User\\Desktop\\gc
     * -XX:MetaspaceSize=9m -XX:MaxMetaspaceSize=9m
     * will throw oom by Metaspace
     */
    public static void main(String[] args) {
        ClassLoadingMXBean loadingBean = ManagementFactory.getClassLoadingMXBean();
        while (true) {
            Enhancer enhancer = new Enhancer();
            enhancer.setSuperclass(OOMByCglibMain.class);
            enhancer.setCallbackTypes(new Class[]{Dispatcher.class, MethodInterceptor.class});
            enhancer.setCallbackFilter(new CallbackFilter() {
                @Override
                public int accept(Method method) {
                    return 1;
                }

                @Override
                public boolean equals(Object obj) {
                    return super.equals(obj);
                }
            });

            Class clazz = enhancer.createClass();
            System.out.println(clazz.getName());
            //显示数量信息（共加载过的类型数目，当前还有效的类型数目，已经被卸载的类型数目）
            System.out.println("total: " + loadingBean.getTotalLoadedClassCount());
            System.out.println("active: " + loadingBean.getLoadedClassCount());
            System.out.println("unloaded: " + loadingBean.getUnloadedClassCount());
        }

    }

}
```

