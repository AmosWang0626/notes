---
title: Java 高效并发
date: 2020-05-16
categories: Java
---

# Java 高效并发
> 学习是一个发散的过程，层层递进，连贯起来，如故事一样。

---
# 一、并发有什么用？

并发处理的广泛应用是使得 Amdahl 定律代替摩尔定律成为计算机性能发展源动力的根本原因，也是人类“压榨”计算机运算能力的最有力武器。——引自《深入理解Java虚拟机》

**摩尔定律：**摩尔定律是指IC上可容纳的晶体管数目，约每隔18个月便会增加一倍，性能也将提升一倍。由英特尔名誉董事长戈登·摩尔1965年提出。**但是，时间是无穷的，IC上可容纳的晶体管数目也是有极限的。**

**Amdahl 定律：**在一个系统中，并行化和串行化的比重，描述了多处理器系统能获得的运算加速能力。**对于串行化的任务，计算机处理器再多也无用；对于可并行的任务，处理器越多，自然是越快的。**

并发充分利用CPU资源，降低系统响应时间，提升系统吞吐量。

---
# 二、Java 内存模型（JMM）
> Java Memory Model，JMM。用它来屏蔽各种硬件和操作系统的内存访问差异，以实现让Java程序在各种平台下都能达到一致的内存访问效果。在此之前，主流程序语言（如C和C++等）直接使用物理硬件和操作系统的内存模型。

## 2.1 回顾计算机内存模型

内存与处理器速度的矛盾，是引入高速缓存的重要原因。

高速缓存工作原理：将运算需要使用到的数据复制到缓存中，让运算能够快速进行，当运算结束后再从缓存同步回内存之中，这样处理器就无需等待缓慢的内存读写了。

每个处理器都有自己的高速缓存，而它们又共享同一个主内存，当同时操作同一块主内存区域时，以谁的数据为准呢？缓存一致性问题闪亮登场。

缓存一致性问题解决方案：

- 总线加锁。早期CPU多为此方案，一个线程处理，其他线程阻塞，问题就是效率低下；
- 缓存一致性协议。处理器访问缓存时需遵循对应协议，最出名的就是 Intel 的 MESI 了。

![计算机内存模型](https://gitee.com/AmosWang/resource/raw/master/image/jvm/computer-memory-model.png)

- 此处的主内存，对应物理机的 RAM 运行内存，就是常说的8GB、16GB内存；

  - RAM（Random Access Memory）随机存储内存，对应电脑的运行内存，断电会丢失存储的内容；
  - ROM（Read Only Memory）只读内存，对应电脑的硬盘存储。

- 当然，和高速缓存直接通信的是处理器中的寄存器；高速缓存也常分为一级缓存、二级缓存和三级缓存。

- [MESI](https://zh.wikipedia.org/wiki/MESI协议) 多核 CPU 多级缓存一致性协议，共享数据通过 cache line 标记。

  | 状态 | 描述 |
  | :----- | :--- |
  | M 修改 Modified | 缓存行是脏的（*dirty*），与主存的值不同。如果别的 CPU内核要读主存这块数据，该缓存行必须写回（*flush*）主存，变为共享状态(S)。 |
  | E 独享 Exclusive | 缓存行只在当前缓存中，并且是干净的（*clean*），与主存的值相同。当别的缓存读取它时，变为共享状态(S)；当前写数据时，变为修改状态(M)。 |
  | S 共享 Shared    | 缓存行也存在于其它缓存中，并且是干净的。缓存行可以在任意时刻抛弃。 |
  | I 无效 Invalid   | 缓存行是无效的。                         |

## 2.2 主内存与工作内存

通俗地说，工作内存就是线程私有的内存，主内存就是线程共享的内存。

工作方式：

- 线程修改工作内存的数据，因为是线程私有的，直接修改即可；
- 线程修改主内存的数据，线程不能直接修改主内存数据，需要先将主内存数据 Load 到工作内存，修改完，将数据 Save 到主内存，此时就涉及脏读和并发写的问题了。如何保证呢？也就是下文的内容了——加锁。

![Java内存模型](https://gitee.com/AmosWang/resource/raw/master/image/jvm/java-memory-model.png)

对照下图，是不是很熟悉？线程隔离数据区、线程共享数据区。

![Java 运行时数据区](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-runtime-data-area.png)

## 2.3 原子性、可见性与有序性

- **原子性**（*不可分割*）

  - 基本数据类型的访问、读写都是具备原子性的。

    由Java内存模型来直接保证的原子性变量操作包括read、load、assign、use、store和write这六个。

    **注意：**多个原子操作放一起，就不能保证原子性了，例如 i++ 就不是原子操作。

  - synchronized 块之间的操作具备原子性。

    如果应用场景需要一个更大范围的原子性保证（经常会遇到），Java内存模型还提供了 lock 和 unlock 操作来满足这种需求，尽管虚拟机未把 lock 和 unlock 操作直接开放给用户使用，但是却提供了更高层次的字节码指令 monitorenter 和 monitorexit 来隐式地使用这两个操作，也即 synchronized 的底层实现。

- **可见性**（*当一个线程修改了共享变量的值时，其他线程能够立即得知这个修改*）

  Java内存模型是通过在变量修改后将新值同步回主内存，在变量读取前从主内存刷新变量值这种依赖主内存作为传递媒介的方式来实现可见性的。

  - volatile 实现可见性

    volatile 的特殊规则保证了新值能立即同步到主内存，以及每次使用前立即从主内存刷新。

  - synchronized 实现可见性
    对一个变量执行unlock操作之前，必须先把此变量同步回主内存中（执行store、write操作）

  - final 实现可见性

    被final修饰的字段在构造器中一旦被初始化完成，并且构造器没有把“this”的引用传递出去（this引用逃逸是一件很危险的事情，其他线程有可能通过这个引用访问到“初始化了一半”的对象），那么在其他线程中就能看见final字段的值。

- **有序性**（*线程内表现为串行的语义 As-If-Serial*）

  程序代码的执行顺序可能和我们写的代码顺序不一致。因为在同一个线程的方法执行过程中无法感知到这点，这就是Java内存模型中描述的所谓“线程内表现为串行的语义”（Within-Thread As-If-Serial Semantics）。

  - volatile 实现有序性

    volatile 包含了禁止指令重排序的语义。相当于一个内存屏障（Memory Barrier或Memory Fence，指重排序时不能把后面的指令重排序到内存屏障之前的位置），只有一个处理器访问内存时，并不需要内存屏障；但如果有两个或更多处理器访问同一块内存，且其中有一个在观测另一个，就需要内存屏障来保证一致性了。

  - synchronized 实现有序性

    一个变量在同一个时刻只允许一条线程对其进行lock操作，持有同一个锁的两个同步块只能串行地进入。

## 2.4 先行发生原则（happens-before）

Java 天生支持先行发生原则，具体原则如下。如果两个操作之间的关系不在此列，并且无法从下列规则推导出
来，则它们就没有顺序性保障，虚拟机可以对它们随意地进行重排序。

- 程序次序规则（在一个线程内，按照程序代码顺序，书写在前的先行于书写在后的。准确讲，是控制流顺序）
- 管程锁定规则（一个 unlock 操作先行于后边对同一个锁的 lock 操作。后边指时间上的先后顺序）
- volatile 变量规则（对一个变量的写操作先行于后边读操作。后边同样指时间上的先后顺序）
- 线程启动规则（Thread.start() 先行于此线程的每一个动作）
- 线程终止规则（线程中的所有操作都先行于对此线程的终止监测）
- 线程中断规则（Thread.interrupt() 方法的调用先行于中断代码的监测）
- 对象终结规则（一个对象的初始化完成先行于它的 finalize()）
- 传递性（A先行发生于B，B先行发生于C，则可得出操作A先行发生于C的结论）

---
# 三、亲儿子解决方案


## 3.1 大娃 Synchronized
> JDK 1.6 之前为重量级锁；之后为偏向锁，如果竞争激烈，会自动升级。（偏向锁 > 轻量级锁 > 重量级锁）

1. 加锁方式

   - 同步方法
     1. 静态方法
     2. 非静态方法
   - 同步代码块
     1. 对象锁
     2. 类锁（本质上也是对象锁，ClassLoader 加载的类，都有一个 Class 对象）

2. 解决问题

   原子性：同一时间，只允许一个线程持有某个对象锁，保证原子性。

   可见性：锁释放之前，对共享变量的修改，对于随后获取该锁的线程是可见的。

   有序性：持有同一个锁的两个同步块只能串行地进入，保证了有序性。

3. 实现原理

   这两个都是使用管程（Monitor，更常见的是直接将它称为“锁”）来实现的。

   - 同步方法

     方法级的同步是隐式的，无须通过字节码指令来控制，它实现在方法调用和返回操作之中。

     虚拟机可以从方法常量池中的方法表结构中的 ACC_SYNCHRONIZED 访问标志得知一个方法是否被声明为同步方法。如果设置了，执行线程就要求先成功持有管程，然后才能执行方法，最后当方法完成（无论是正常完成还是非正常完成）时释放管程。在方法执行期间，执行线程持有了管程，其他任何线程都无法再获取到同一个管程。如果一个同步方法执行期间抛出了异常，并且在方法内部无法处理此异常，那这个同步方法所持有的管程将在异常抛到同步方法边界之外时自动释放。

   - 同步代码块

     Java虚拟机的指令集中有 monitorenter 和 monitorexit 两条指令来支持 synchronized 关键字的语义，正确实现 synchronized 关键字需要 javac 编译器与 Java虚拟机两者共同协作支持。

     ```java
     void onlyMe(Foo f) {
         synchronized (f) {
             doSomething();
         }
     }
     ```
     ```c
     Method void onlyMe(Foo)
     0 aload_1		// 将对象f入栈
     1 dup			// 复制栈顶元素（即f的引用）
     2 astore_2		// 将栈顶元素存储到局部变量表变量槽 2中
     3 monitorenter	// 以栈定元素（即f）作为锁，开始同步
     4 aload_0		// 将局部变量槽 0（即this指针）的元素入栈
     5 invokevirtual #5	// 调用doSomething()方法
     8 aload_2 		// 将局部变量Slow 2的元素（即f）入栈
     9 monitorexit 	// 退出同步
     10 goto 18 		// 方法正常结束，跳转到18返回
     13 astore_3 	// 从这步开始是异常路径，见下面异常表的Taget 13
     14 aload_2 		// 将局部变量Slow 2的元素（即f）入栈
     15 monitorexit 	// 退出同步
     16 aload_3 		// 将局部变量Slow 3的元素（即异常对象）入栈
     17 athrow 		// 把异常对象重新抛出给onlyMe()方法的调用者
     18 return 		// 方法正常返回
     Exception table:
     FromTo Target Type
     4 10 13 any
     13 16 13 any
     ```

     编译器必须确保无论方法通过何种方式完成，方法中调用过的每条 monitorenter 指令都必须有其对应的 monitorexit 指令，而无论这个方法是正常结束还是异常结束。

## 3.2 二蛋 Volatile

> 轻量级锁

1. 加锁方式

   定义在变量上

2. 解决问题

   可见性：新值能立即同步到主内存，以及每次使用前立即从主内存刷新。

   有序性：禁止指令重排序，重排序时不能把后面的指令重排序到内存屏障之前的位置。

3. 实现原理

    禁止指令重排序，保障新值的可见性。结合 DCL 编译后的源码看一下 ↓↓↓↓↓

    ```java
    public class Singleton {
        private volatile static Singleton instance;
    
        public static Singleton getInstance() {
            if (instance == null) {
                synchronized (Singleton.class) {
                    if (instance == null) {
                        instance = new Singleton();
                    }
                }
            }
            return instance;
        }
    
        public static void main(String[] args) {
            Singleton.getInstance();
        }
    }
    ```

    ```c
    0x01a3de0f: mov $0x3375cdb0,%esi        ;...beb0cd75 33
                                            ; {oop('Singleton')}
    0x01a3de14: mov %eax,0x150(%esi)        ;...89865001 0000
    0x01a3de1a: shr $0x9,%esi               ;...c1ee09
    0x01a3de1d: movb $0x0,0x1104800(%esi)   ;...c6860048 100100
    0x01a3de24: lock addl $0x0,(%esp)       ;...f0830424 00
                                            ;*putstatic instance
                                            ; - Singleton::getInstance@24
    ```

    **关键指令：`lock addl $0x0,(%esp)`**

    这句指令中的`addl $0x0,(%esp)`（把ESP寄存器的值加0）显然是一个空操作，之所以用这个空操作而不是空操作专用指令`nop`，是因为IA32手册规定`lock`前缀不允许配合`nop`指令使用。

    这里的关键在于**`lock`前缀，它的作用是将本处理器的缓存写入了内存，该写入动作也会引起别的处理器或者别的内核缓存无效（Invalidate）**，这种操作相当于对缓存中的变量做了一次前面介绍Java内存模式中所说的`store`和`write`操作。所以通过这样一个空操作，可让前面volatile变量的修改对其他处理器立即可见。

    与此同时，**`lock addl$0x0,(%esp)`指令把修改同步到内存时，意味着所有之前的操作都已经执行完成，这样便形成了“指令重排序无法越过内存屏障”的效果。**

---
# 四、并发基础 CAS 与 AQS

## 4.1 CAS

Compare-and-Swap 或者 Compare-and-Set 简称 CAS。

**CAS操作是原子性的**，CAS指令需要有三个操作数，分别是内存位置（在Java中可以简单地理解为变量的内存地址，用V表示）、旧的预期值（用A表示）和准备设置的新值（用B表示）。CAS指令执行时，当且仅当V符合A时，处理器才会用B更新V的值，否则它就不执行更新。

在 JDK 5之后，Java类库中才开始使用CAS操作，该操作由`sun.misc.Unsafe`类里面的`compareAndSwapInt()`和`compareAndSwapLong()`等几个方法包装提供。`HotSpot`虚拟机在内部对这些方法做了特殊处理，即时编译出来的结果就是一条平台相关的处理器CAS指令，没有方法调用的过程，或者可以认为是无条件内联进去了。不过由于Unsafe类在设计上就不是提供给用户程序调用的类【`Unsafe::getUnsafe()`的代码中限制了只有启动类加载器（`Bootstrap ClassLoader`）加载的Class才能访问它】，因此在`JDK 9`之前只有Java类库可以使用CAS，譬如`J.U.C`包里面的整数原子类，其中的`compareAndSet()`和`getAndIncrement()`等方法都使用了Unsafe类的CAS操作来实现。而如果用户程序也有使用CAS操作的需求，那要么就采用反射手段突破`Unsafe`的访问限制，要么就只能通过Java类库API来间接使用它。直到`JDK 9`之后，Java类库才在`VarHandle`类里开放了面向用户程序使用的`CAS`操作。

[JDK 8 使用 Unsafe.compareAndSwapInt() 示例](https://github.com/AmosWang0626/chaos/blob/master/chaos-advanced/src/main/java/com/amos/advanced/java/UnsafeCasStudy.java)

## 4.2 AQS

基本结构：状态位 state + Node 双向链表；

获取锁：通过 CAS 修改 state（state + 1）；要是没获取到锁，就放进双向链表里边；

释放锁：释放锁，修改 state（state - 1）。当 state = 0，操作队列，解锁队首。

```java
private transient volatile Node head; // 队首
private transient volatile Node tail; // 队尾
private volatile int state; // 状态位

static final class Node {
    volatile int waitStatus; // 等待状态
    volatile Node prev; // 前
    volatile Node next; // 后
    volatile Thread thread; // 当前线程
}
```

## 4.3 ReentrantLock

> 针对的问题，jdk1.6之前，只要加上 synchronized，不管有没有并发，都会加上重量级锁，导致性能低下。
>
> Doug Lea 大神开发了JUC包，给出了加锁第二方案。

[子路老师：JUC AQS ReentrantLock源码分析（一）](https://blog.csdn.net/java_lyvee/article/details/98966684)
> 偷个懒，把子路老师的文章放这了。
>还有一个原因就是子路老师说的，不要会一点技术，还没理解全面，就往博客上写，间接导致了博客泛滥，误人子弟。

## 4.4 其他并发集合

- CountDownLatch 类似计数器，都执行完成时退出。
- Semaphore 类似停车位，有进有出，满需等待。
- CyclicBarrier 类似发令枪，线程都就绪时，并发执行。
- ReentrantReadWriteLock 读写锁。

---
# 五、线程池

### 简单代码
```
// 创建线程工厂,并设置线程名字格式
import com.google.common.util.concurrent.ThreadFactoryBuilder;

ThreadFactory threadFactory = new ThreadFactoryBuilder().setNameFormat("thread-pool-%d").build();

// if (corePoolSize > maximumPoolSize) throw IllegalArgumentException(非法调度Exception)
ExecutorService singleThreadPool = new ThreadPoolExecutor(12, 24,
        0L, TimeUnit.MILLISECONDS,
        new LinkedBlockingQueue<>(1024), threadFactory, new ThreadPoolExecutor.AbortPolicy());

singleThreadPool.execute(() -> System.out.println(Thread.currentThread().getName()));
singleThreadPool.shutdown();
```

### ThreadPoolExecutor 参数详解
> ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, 
>                    long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, 
>                    ThreadFactory threadFactory, RejectedExecutionHandler handler)

- int corePoolSize 核心线程数。
    - 默认情况下核心线程会一直存活，即使处于闲置状态也不会受存keepAliveTime限制。
    - 除非将allowCoreThreadTimeOut设置为true。

- int maximumPoolSize 线程池所能容纳的最大线程数。
    - 超过这个数的线程将被阻塞。
    - 当任务队列为没有设置大小的LinkedBlockingDeque时，这个值无效。

- long keepAliveTime 非核心线程的闲置超时时间，超过这个时间就会被回收。

- TimeUnit unit 指定keepAliveTime的单位，如TimeUnit.SECONDS。
    - 当将allowCoreThreadTimeOut设置为true时对corePoolSize生效。

- BlockingQueue<Runnable> workQueue 线程池中的任务队列。
    - 常用的有三种队列，SynchronousQueue,LinkedBlockingDeque,ArrayBlockingQueue。

- ThreadFactory threadFactory 线程工厂，提供创建新线程的功能。
    - ThreadFactory是一个接口，只有一个方法。

- RejectedExecutionHandler handler 线程池对拒绝任务的处理策略。
    - 在 ThreadPoolExecutor 里面定义了 4 种 handler 策略，分别是:
        1. CallerRunsPolicy ：这个策略重试添加当前的任务，他会自动重复调用 execute() 方法，直到成功。
        2. AbortPolicy ：对拒绝任务抛弃处理，并且抛出异常。
        3. DiscardPolicy ：对拒绝任务直接无声抛弃，没有异常信息。
        4. DiscardOldestPolicy ：对拒绝任务不抛弃，而是抛弃队列里面等待最久的一个线程，然后把拒绝任务加到队列

### corePoolSize maximumPoolSize
- 如果线程数量<=核心线程数量，那么直接启动一个核心线程来执行任务，不会放入队列中。

- 如果线程数量>核心线程数，但<=最大线程数，并且任务队列是LinkedBlockingDeque的时候，超
  过核心线程数量的任务会放在任务队列中排队。

- 如果线程数量>核心线程数，但<=最大线程数，并且任务队列是SynchronousQueue的时候，线程池
  会创建新线程执行任务，这些任务也不会被放在任务队列中。这些线程属于非核心线程，在任务完
  成后，闲置时间达到了超时时间就会被清除。

- 如果线程数量>核心线程数，并且>最大线程数，当任务队列是LinkedBlockingDeque，会将超过
  核心线程的任务放在任务队列中排队。也就是当任务队列是LinkedBlockingDeque并且没有大小
  限制时，线程池的最大线程数设置是无效的，他的线程数最多不会超过核心线程数。

- 如果线程数量>核心线程数，并且>最大线程数，当任务队列是SynchronousQueue的时候，会因为
  线程池拒绝添加任务而抛出异常。


---
# 六、梳理关键词

- 偏向锁、轻量级锁、重量级锁、锁消除、锁升级、公平锁、非公平锁