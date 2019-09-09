# 数据库增删改查
## 目录
- [增](#insert)
- [改](#update)
- [查](#select)
- [删](#delete)
- [注意](#notice)


## 新增、批量新增insert
- insert into select
```sql
INSERT INTO order_desc (member_id, apply_no, content)
SELECT member_id, apply_no, content FROM order_desc2 WHERE APPLY_TYPE = 'MOBILE' GROUP BY content ORDER BY COUNT(content) DESC;
```

## 修改、批量修改update
- 单条更新
```sql
update table_name set username = null, age = null where id = '1433233'
```

- 批量更新 
```xml
<update id="batchUpdateErrorList">
  INSERT INTO `amos_phone` (ID, TALK_TIME, TALE_END_TIME)
  VALUES
  <foreach collection="list" item="item" separator=",">
      (#{item.id},#{item.talkTime},#{item.taleEndTime})
  </foreach>
  ON DUPLICATE KEY UPDATE TALK_TIME=values(TALK_TIME), TALE_END_TIME=values(TALE_END_TIME)
</update>
  ```

## 查询select
1. 日期
```sql
AND DATE_FORMAT(BEGIN_TIME, '%Y-%m-%d') <= '2019-08-01' AND DATE_FORMAT(END_TIME, '%Y-%m-%d') >= '2019-08-31'
```
```xml
<!-- MyBatis Mapper XML -->
<where>
    <if test="name != null and name != ''">AND NAME = #{name}</if>
    <if test="beginTime != null">AND CREATE_TIME <![CDATA[ >= ]]> #{beginTime}</if>
    <if test="endTime != null">AND CREATE_TIME <![CDATA[ <= ]]> #{endTime}</if>
</where>
```

2. 分组字段合并
```sql
SELECT
phone.ID,
phone.`NAME`,
GROUP_CONCAT(business.`NAME`) BUSINESS_NAMES
FROM `amos_phone` phone
LEFT JOIN `amos_business` business ON phone.BUSINESS_ID REGEXP business.ID
WHERE phone.ID = '528a926949f1a8a0bb67234f7c837fac'
GROUP BY phone.ID
```

3. SQL HAVING
```sql
SELECT MEMBER_ID, COUNT(MEMBER_ID) FROM contact_info GROUP BY MEMBER_ID HAVING COUNT(MEMBER_ID) > 5;
```

4. SQL OR
```sql
-- 看两个等价sql
select * from user where condition1 or condition2 and condition3;
select * from user where condition1 or (condition2 and condition3);
-- 故可以得出结论：and级别高于or, 清晰起见建议使用2
```

8. 分页相关
```mysql
SELECT * FROM `amos_user` ORDER BY ID DESC LIMIT 0, 10;
```
```tsql
-- 查询前10条
SELECT TOP 10 * FROM amos_user;

-- 分页查询20条数据 [index: 20 to 40]

-- 分页 by WHERE
SELECT amos_user.*
FROM amos_user, (SELECT TOP 40 row_number () OVER (ORDER BY CREATE_TIME) n, id FROM amos_user) temp_user
WHERE amos_user.id = temp_user.id AND temp_user.n > 20

-- 分页 by JOIN
SELECT amos_user.*
FROM amos_user
INNER JOIN (SELECT TOP 40 row_number () OVER (ORDER BY username) n, id FROM amos_user) temp_user 
ON amos_user.id = temp_user.id AND temp_user.n > 20;
```


## 删除delete


## 注意notice
- 字段不为空，是 IS NOT NULL，而非 != null