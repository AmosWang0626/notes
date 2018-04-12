# 常用关键字

## 匹配数据相关：REGEXP 
- CONSUME_DATE 一般格式：2018-03-04 | 2018-03-12 | 2018-03-31
- 要想匹配数据：SELECT * FROM	consurme_order WHERE CONSUME_DATE REGEXP '2018-03';

# MyBatis

## Mapper
### 查询条件为List
```sql
<if test="search.memberIds != null">
  AND MEMBER_ID IN (<foreach collection="search.memberIds" item="item" separator=",">#{item}</foreach>)
</if>
```
