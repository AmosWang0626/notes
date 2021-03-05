---
title: 面试突击 HashMap 篇
date: 2021-03-05
categories: 面试突击
hide: true
tags:
- 面试突击
---

# 面试突击 HashMap 篇

```java
public class HashMap<K, V> extends AbstractMap<K, V>
        implements Map<K, V>, Cloneable, Serializable {

    /* 默认容量 16 */
    static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16

    /* 最大容量 2^30  */
    static final int MAXIMUM_CAPACITY = 1 << 30;

    /* 负载因子 */
    static final float DEFAULT_LOAD_FACTOR = 0.75f;

    /* 树化阈值（链表 > 红黑树） */
    static final int TREEIFY_THRESHOLD = 8;

    /* 取消树化阈值（红黑树 > 链表） */
    static final int UNTREEIFY_THRESHOLD = 6;

    /* 如果总容量小于 64，链表是不会转为红黑树的 */
    static final int MIN_TREEIFY_CAPACITY = 64;

    /**
     * hash 方法
     */
    static final int hash(Object key) {
        int h;
        // 先将hashCode右移16位，再通过异或运算，让hash值的低16位保持高低16位的特征
        return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
    }

}
```

