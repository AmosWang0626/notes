# 常用关键字

## 匹配数据相关：REGEXP 
- CONSUME_DATE 一般格式：2018-03-04 | 2018-03-12 | 2018-03-31
- 要想匹配数据：SELECT * FROM	consurme_order WHERE CONSUME_DATE REGEXP '2018-03';
- REGEXP 不区分大小写
  - 要想区分大小写用：REGEXP BINARY
  - select 'hello' REGEXP 'HelLo';
  - select 'hello' REGEXP BINARY 'HelLo';

## 拼接concat(...)
- select concat('姓名:',"AAA",',手机:', "13066668888");
  - 姓名:AAA,手机:13066668888

# MyBatis

## Mapper
### 查询条件为List
```xml
<if test="search.memberIds != null">
  AND MEMBER_ID IN (<foreach collection="search.memberIds" item="item" separator=",">#{item}</foreach>)
</if>
```
### 查询条件含特殊字符
```xml
"," "=" "?" "||" "or" "&&" "and" "|" "bor" "^" "xor" "&" "band"
"==" "eq" "!=" "neq" "<" "lt"">" "gt" "<=" "lte" ">=" "gte" "in"
"not" "<<" "shl" ">>" "shr" ">>>" "ushr" "+" "-" "*" "/" "%" "."
"(""instanceof"  "[" "]" <![CDATA[ <= ]]>
```
---
```
<if test="search.count != null">AND COUNT <![CDATA[ <= ]]> #{search.count}</if>
```
```
<if test="id!=null &amp;&amp; id!=''"></if>
```
