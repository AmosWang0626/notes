# Java 学习笔记

## 1.Java移位
```
java中有三种移位运算符

<<：左移运算符，num << 1,相当于num乘以2

>>：右移运算符，num >> 1,相当于num除以2

>>>：无符号右移，忽略符号位，空位都以0补齐
```
## 2.Date Util
```
private static final ThreadLocal<DateFormat> FORMAT_YEAR_2_SECOND =
	 ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"));
```

## 3.interface
interface中的方法默认为public abstract 的；
变量默认为public static final。

## 4.java 存根 stub
