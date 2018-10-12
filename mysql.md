# MySQL Base

## 1. 表名、字段名称大小写
- Oracle 表名、字段名统一要大写；
- MySQL 表名、字段名统一要小写；

## 2.创建索引
> 16 条数据

- 查询：
  - SELECT * FROM `now_address` WHERE MEMBER_ID = 11111 AND `STATUS` = 1;
  - 时间: 0.005s

- 创建多行索引：
  - CREATE INDEX index_address ON `now_address`(`MEMBER_ID` , `STATUS`);

- 查询：
  - SELECT * FROM `now_address` WHERE MEMBER_ID = 11111 AND `STATUS` = 1;
  - 时间：0.001s

## 3.MySQL是表名默认是区分大小写的
```
Linux相关命令：
1、重启mysql
service mysqld restart

2、查找文件
whereis my.cnf
略……
```

## 4.MySQL查看字符集
- SHOW VARIABLES LIKE 'character%';

## 5.厉害的order by ... limit 
- SELECT * FROM `member` ORDER BY UPDATE_TIME DESC LIMIT 3

## 6.判断时间在两时间之间
```
SELECT * FROM `now_address` WHERE
CREATE_TIME > "2017-08-30" AND CREATE_TIME < "2017-09-2";
SELECT
<include refid="columns"/>
FROM
<include refid="tableName"/>
<where>
    <if test="name != null and !''.equals(name)"> NAME = #{name}</if>
    <if test="settleStartTimeForm != null " >
        and  UPDATE_TIME <![CDATA[   >=  ]]> #{settleStartTimeForm}
    </if>
    <if test="settleEndTimeForm != null " >
        and  UPDATE_TIME <![CDATA[   <=  ]]>  #{settleEndTimeForm}
    </if>
</where>
ORDER BY DESC
```

## 7.常用数据库
```
ALTER TABLE wmmm_user.member ADD CHANNEL_ID bigint(20) DEFAULT NULL COMMENT '注册来源渠道号';

ALTER TABLE `wmmm_user`.`now_address` CHANGE COLUMN `UPDATE_TIME` `UPDATE_TIME` DATETIME NULL COMMENT '更新时间' ;

ORDER BY CREATE_TIME DESC LIMIT 1

List<CouponEntity> selectByParam(@Param("list") List<Long> list, @Param("couponTypeId") Long couponTypeId);

update user set password=password('hellozzti!-') where user='root' and host='127.0.0.1';

SELECT * FROM COUPON INNER JOIN COUPON_USER
        ON COUPON.COUPON_ID = COUPON_USER.COUPON_ID
        WHERE COUPON_NO = 'UP20171124103084233841' AND PHONE_NO = '15902182927' AND DELETE_FLAG = 0

SELECT MEMBER_ID, COUNT(MEMBER_ID), CREATE_TIME COUNT_MEMBER FROM contact_person WHERE `STATUS` = 1 GROUP BY MEMBER_ID HAVING COUNT(MEMBER_ID) > 5;

SELECT MEMBER_ID, COUNT(MEMBER_ID), CREATE_TIME COUNT_MEMBER FROM contact_info WHERE `STATUS` = 1 GROUP BY MEMBER_ID HAVING COUNT(MEMBER_ID) > 5;
```

## 8.字段不为空，不是!=null，而是IS NOT NULL

## 9.group by与distinct
