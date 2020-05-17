---
title: 数据结构学习
date: 2018-01-01
---

# 数据结构
> Data Structure

## 1、数据、数据元素、数据项、数据对象
![image](https://gitee.com/AmosWang/resource/raw/master/image/ds/ds-component.png)
- 数据对象 --- 相同性质数据元素的集合
- 数据项 --- 组成数据元素的不可分割的最小单位

## 2、数据结构概念
> 数据结构是相互之间存在一种或多种持久关系的数据元素的集合。
1. 逻辑结构
  - 集合结构（属于同一集合，别无其他关系）学生 ---> 班级
  - 线性结构（一对一的次序关系）线性表、栈、队列、字符串、数组、广义表
  - 树结构（一对多的层次关系）【非线性结构】
  - 图结构或网状结构（多对多的网状关系）【非线性结构】
2. 存储结构
  - 顺序存储结构
  - 链式存储结构

## 3、算法
1. 五大特性
(1) 有穷性 (2) 确定性 (3) 可行性 (4) 输入 (5) 输出

2. 算法优劣
(1) 正确性 (2) 可读性 (3) 健壮性 (4) 高效性

3. 时间复杂度 [T(n)，O表示数量级]
> 特殊符号 ∞→º¹²³ⁿ
- 三层 for 循环，求 n 阶矩阵乘积
`f(n) = 2n³ + 3n² + 2n + 1`
`lim(n→∞) f(n)/n³ = lim(n→∞) (2n³ + 3n² + 2n + 1) / n³ = 2`
`n→∞`时，`f(n)`和`n³`之比为一个不为0的常数，即f(n)和n³同阶
数量级（Order Of Magnitude） `T(n) = O(f(n)) = O(n³)`
数学符号`O`严格定义：`T(n)`和`f(n)`是在正整数集合上的两个函数 `T(n) = O(f(n))`
表示存在正的常数`C`和`n0`，使得 `n >= n0` 时都满足 `O <= T(n) <= Cf(n)`

# 树相关
- TODO XXX
