---
title: SQL 基础增删改查
date: 2019-01-01
categories: 数据库
tags:
- SQL基础
---


# 数据库增删改查
## 目录
- [新增](#新增和批量新增insert)
- [修改](#修改和批量修改update)
- [查询](#查询select)
- [删除](#删除delete)
- [注意](#注意notice)


## 新增和批量新增insert
- insert into select
```sql
INSERT INTO order_desc (member_id, apply_no, content)
SELECT member_id, apply_no, content FROM order_desc2 WHERE APPLY_TYPE = 'MOBILE' GROUP BY content ORDER BY COUNT(content) DESC;
```

## 修改和批量修改update
- 单条更新
```sql
update table_name set username = null, age = null where id = '1433233';
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
    <!-- MyBatis Mapper.xml 大于等于小于 -->
    <where>
        <if test="name != null and name != ''">AND NAME = #{name}</if>
        <if test="beginTime != null">AND CREATE_TIME <![CDATA[ >= ]]> #{beginTime}</if>
        <if test="endTime != null">AND CREATE_TIME <![CDATA[ <= ]]> #{endTime}</if>
    </where>
    ```
    ```mysql
    SELECT COUNT(*), run_time, (run_min * 60 + run_sec)
    FROM(
        SELECT
            APPLY_NO 'apply_no',
            COUNT(*) 'count',
            TIMEDIFF(MAX(CREATE_TIME), MIN(CREATE_TIME)) 'run_time',
            DATE_FORMAT(TIMEDIFF(MAX(CREATE_TIME), MIN(CREATE_TIME)), '%i') 'run_min',
            DATE_FORMAT(TIMEDIFF(MAX(CREATE_TIME), MIN(CREATE_TIME)), '%s') 'run_sec',
            MIN(CREATE_TIME) 'begin',
            MAX(CREATE_TIME) 'end'
        FROM `rule_result`
        GROUP BY APPLY_NO ORDER BY CREATE_TIME DESC
    ) a GROUP BY run_time ORDER BY run_time DESC;
    ```

2. MyBatis Mapper.xml foreach
    ```xml
    <if test="search.memberIds != null">
     AND MEMBER_ID IN (<foreach collection="search.memberIds" item="item" separator=",">#{item}</foreach>)
    </if>
    ```

3. MyBatis if condition
    ```
    "," "=" "?" "||" "or" "&&" "and" "|" "bor" "^" "xor" "&" "band"
    "==" "eq" "!=" "neq" "<" "lt"">" "gt" "<=" "lte" ">=" "gte" "in"
    "not" "<<" "shl" ">>" "shr" ">>>" "ushr" "+" "-" "*" "/" "%" "."
    "(""instanceof"  "[" "]" <![CDATA[ <= ]]>
    ```

4. 分组字段合并
    ```mysql
    SELECT
    phone.ID,
    phone.`NAME`,
    GROUP_CONCAT(business.`NAME`) BUSINESS_NAMES
    FROM `amos_phone` phone
    LEFT JOIN `amos_business` business ON phone.BUSINESS_ID REGEXP business.ID
    WHERE phone.ID = '528a926949f1a8a0bb67234f7c837fac'
    GROUP BY phone.ID;
    ```

5. HAVING
    ```sql
    SELECT MEMBER_ID, COUNT(MEMBER_ID) FROM contact_info GROUP BY MEMBER_ID HAVING COUNT(MEMBER_ID) > 5;
    ```

6. OR
    ```sql
    -- 看两个等价sql
    select * from user where condition1 or condition2 and condition3;
    select * from user where condition1 or (condition2 and condition3);
    -- 故可以得出结论：and级别高于or, 清晰起见建议使用2
    ```

7. CONCAT
    ```mysql
    SELECT CONCAT('姓名：',"张三",'，手机号：', "13066668888") MESSAGE;
    ```    

8. REGEXP
    - REGEXP 默认不区分大小写
      - 能匹配出来，结果为 1 `select 'hello' REGEXP 'HelLo';`
      - 不能匹配出来，结果为 0 `select 'hello' REGEXP BINARY 'HelLo';`
    - REGEXP 匹配多个
      - 数字、A01、A02，结果为 1 `SELECT 'A0' REGEXP '[0-9]|A01|A02' RESULT;`

9. MySQL、SQL Server分页相关
  - MySQL
    ```mysql
    SELECT * FROM `amos_user` ORDER BY ID DESC LIMIT 0, 10;
    ```
  - SQL Server
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

10. COUNT(TYPE = 1 OR NULL) TYPE_COUNT
    ```mysql
    COUNT(TYPE = 1 OR NULL) TYPE_COUNT ... [optional: HAVING TYPE_COUNT > 0]
    ```


## 删除delete


## 注意notice
- 字段不为空，是 IS NOT NULL，而非 != null
---
- 存储过程命名规范
  1. 业务相关以模块代码开头 `order_procedure`
  2. 如果区分全量和增量，在最后加标识 `order_procedure` `order_procedure_full`
  3. 全局使用，以global开头 `global_order_procedure`
- 存储过程内部变量命名规范
  1. 变量（以 V 开头）`V_SCORE`
  2. 游标（以 C 开头）`C_CURSOR`
  3. 内存表（以 M 开头）`M_TABLE`
  4. 临时表（以 T 开头）`T_TABLE`
---
