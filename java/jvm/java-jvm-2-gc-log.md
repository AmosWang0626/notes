---
title: Java JVM GC Log
date: 2019-11-04
categories: Java
tags:
- gc
- jvm
---

# Java JVM GC日志

## 1. 完整GC日志

```
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

```
2019-11-04T16:05:43.267+0800: 147.981: [GC (Allocation Failure) [PSYoungGen: 150496K->5938K(147456K)] 198958K->57548K(202752K), 0.0304547 secs] [Times: user=0.05 sys=0.00, real=0.03 secs]
```

```
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


# 栈溢出 与 OOM 代码示例

## 1.栈溢出

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

## 2.堆区 OOM 

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

## 3.元空间 OOM

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
