# Java GC
http://jefferent.iteye.com/blog/1123677

## Java8实践
### GC日志示例1
```
2019-11-02T21:43:44.513+0800: 129010.205: [GC (Allocation Failure) \
[PSYoungGen: 134135K->13659K(133120K)] 187486K->69073K(216576K), 0.0317286 secs] \
[Times: user=0.06 sys=0.00, real=0.04 secs]
```
### GC日志示例2
```
2019-11-01T10:22:59.918+0800: 1765.610: [Full GC (Ergonomics) \
[PSYoungGen: 7010K->0K(145408K)] [ParOldGen: 52384K->43630K(83456K)] 59394K->43630K(228864K), \
[Metaspace: 84184K->83747K(1126400K)], 0.3355045 secs] [Times: user=0.55 sys=0.00, real=0.33 secs] 
Heap after GC invocations=41 (full 4):
 PSYoungGen      total 145408K, used 0K [0x00000000f6700000, 0x0000000100000000, 0x0000000100000000)
  eden space 138240K, 0% used [0x00000000f6700000,0x00000000f6700000,0x00000000fee00000)
  from space 7168K, 0% used [0x00000000fee00000,0x00000000fee00000,0x00000000ff500000)
  to   space 9728K, 0% used [0x00000000ff680000,0x00000000ff680000,0x0000000100000000)
 ParOldGen       total 83456K, used 43630K [0x00000000e3400000, 0x00000000e8580000, 0x00000000f6700000)
  object space 83456K, 52% used [0x00000000e3400000,0x00000000e5e9ba10,0x00000000e8580000)
 Metaspace       used 83747K, capacity 86604K, committed 87552K, reserved 1126400K
  class space    used 10334K, capacity 10848K, committed 11008K, reserved 1048576K
}
{Heap before GC invocations=42 (full 4):
 PSYoungGen      total 145408K, used 138240K [0x00000000f6700000, 0x0000000100000000, 0x0000000100000000)
  eden space 138240K, 100% used [0x00000000f6700000,0x00000000fee00000,0x00000000fee00000)
  from space 7168K, 0% used [0x00000000fee00000,0x00000000fee00000,0x00000000ff500000)
  to   space 9728K, 0% used [0x00000000ff680000,0x00000000ff680000,0x0000000100000000)
 ParOldGen       total 83456K, used 43630K [0x00000000e3400000, 0x00000000e8580000, 0x00000000f6700000)
  object space 83456K, 52% used [0x00000000e3400000,0x00000000e5e9ba10,0x00000000e8580000)
 Metaspace       used 86395K, capacity 89964K, committed 90112K, reserved 1128448K
  class space    used 10571K, capacity 11188K, committed 11264K, reserved 1048576K
```
### 小总结
- Allocation Failure 意思是分配失败，也即触发本次 GC 的原因
- GC：Minor GC（新生代垃圾收集）
- 示例1 `[PSYoungGen: 134135K->13659K(133120K)] 187486K->69073K(216576K), 0.0317286 secs]`
  - PSYoungGen：PS（Parallel Scavenge 垃圾收集器：多线程、并行、采用复制算法）
  - 134135K->13659K GC前后新生代占用空间；Minor GC之后Eden区为空，13659K 就是Survivor占用的空间
  - (133120K) 年轻代总大小
  - 0.0317286 secs 垃圾收集过程所消耗的时间


---

## 虚拟机中的共划分为三个代：
> 年轻代和年老代的划分是对垃圾收集影响比较大的

- 年轻代 Young Generation
- 年老点 Old Generation
- 持久代 Permanent Generation

### 年轻代:
- 所有新生成的对象首先都是放在年轻代的。年轻代的目标就是尽可能快速的收集掉那些生命周期短的对象。
- 年轻代分三个区。一个Eden区，两个Survivor区(一般而言)。
- 大部分对象在Eden区中生成。当Eden区满时，还存活的对象将被复制到Survivor区（两个中的一个），当这个Survivor区满时，此区的存活对象将被复制到另外一个Survivor区，当这个Survivor去也满了的时候，从第一个Survivor区复制过来的并且此时还存活的对象，将被复制“年老区(Tenured)”。
- 需要注意，Survivor的两个区是对称的，没先后关系，所以同一个区中可能同时存在从Eden复制过来对象，和从前一个Survivor复制过来的对象，而复制到年老区的只有从第一个Survivor去过来的对象。而且，Survivor区总有一个是空的。同时，根据程序需要，Survivor区是可以配置为多个的（多于两个），这样可以增加对象在年轻代中的存在时间，减少被放到年老代的可能。

### 年老代:
- 在年轻代中经历了N次垃圾回收后仍然存活的对象，就会被放到年老代中。
- 因此，可以认为年老代中存放的都是一些生命周期较长的对象。

### 持久代:
用于存放静态文件，如今Java类、方法等。
持久代对垃圾回收没有显著影响，但是有些应用可能动态生成或者调用一些class，例如Hibernate等，在这种时候需要设置一个比较大的持久代空间来存放这些运行过程中新增的类。持久代大小通过-XX:MaxPermSize=<N>进行设置。


## 什么情况下触发垃圾回收：
> 由于对象进行了分代处理，因此垃圾回收区域、时间也不一样。GC有两种类型：Scavenge GC和Full GC。

### Scavenge GC
一般情况下，当新对象生成，并且在Eden申请空间失败时，就会触发Scavenge GC，对Eden区域进行GC，清除非存活对象，并且把尚且存活的对象移动到Survivor区。然后整理Survivor的两个区。这种方式的GC是对年轻代的Eden区进行，不会影响到年老代。因为大部分对象都是从Eden区开始的，同时Eden区不会分配的很大，所以Eden区的GC会频繁进行。因而，一般在这里需要使用速度快、效率高的算法，使Eden去能尽快空闲出来。

### Full GC
对整个堆进行整理，包括Young、Tenured和Perm。Full GC因为需要对整个对进行回收，所以比Scavenge GC要慢，因此应该尽可能减少Full GC的次数。在对JVM调优的过程中，很大一部分工作就是对于FullGC的调节。

### 有如下原因可能导致Full GC：

- 年老代（Tenured）被写满
- 持久代（Perm）被写满
- System.gc()被显示调用
- 上一次GC之后Heap的各域分配策略动态变化

## 对象生死判定
> 垃圾回收第一步：生死判定

### 可达性分析
通过一系列的称为 GC Roots 的对象作为起点, 然后向下搜索; 搜索所走过的路径称为引用链/Reference Chain, 当一个对象到 GC Roots 没有任何引用链相连时, 即该对象不可达, 也就说明此对象是不可用的, 如下图: Object5、6、7 虽然互有关联, 但它们到GC Roots是不可达的,因此也会被判定为可回收的对象:

- 在java中可做GC Roots的对象包括：
    - 方法区: 类静态属性引用的对象;
    - 方法区: 常量引用的对象;
    - 虚拟机栈(本地变量表)中引用的对象.
    - 本地方法栈JNI(Native方法)中引用的对象。

- 即使在可达性分析算法中不可达的对象,VM也并不是马上对其回收,至少还要经历两次标记过程: 
    - 第一次是在可达性分析后发现没有与GC Roots相连接的引用链
    - 第二次是GC对在F-Queue执行队列中的对象进行的小规模标记(对象需要覆盖finalize()方法且没被调用过)
