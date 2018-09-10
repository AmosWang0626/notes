## ArrayList和LinkedList的大致区别如下:
1.ArrayList是实现了基于动态数组的数据结构，LinkedList基于链表的数据结构。 
2.对于随机访问get和set，ArrayList觉得优于LinkedList，因为LinkedList要移动指针。 
3.对于新增和删除操作add和remove，LinedList比较占优势，因为ArrayList要移动数据。 

## HashMap
1.初始化size，size一定是2的n次幂

- >>> 无符号右移, 空位补0
- >> 右移 / 2
- << 左移 * 2

目的就是将减一之后的size最高位及其后的所有位转化为1

## 有序集合

## 有序Map

## 线程安全集合

## 线程安全Map