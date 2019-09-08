## 批量更新
```
<update id="batchUpdateErrorList">
    INSERT INTO `amos_phone` (ID, TALK_TIME, TALE_END_TIME)
    VALUES
    <foreach collection="list" item="item" separator=",">
        (#{item.id},#{item.talkTime},#{item.taleEndTime})
    </foreach>
    ON DUPLICATE KEY UPDATE TALK_TIME=values(TALK_TIME), TALE_END_TIME=values(TALE_END_TIME)
</update>
```

## 单条更新
`update table_aaa set c_a = null, c_b = null where c_id = '1234567890'`

## 时间段判断
`AND DATE_FORMAT(BEGIN_TIME, '%Y-%m-%d') <= '2019-08-16' AND DATE_FORMAT(END_TIME, '%Y-%m-%d') >= '2019-08-16'`

## 合并多行结果，注意要分组
```
SELECT
	phone.ID,
	phone.`NAME`,
	GROUP_CONCAT(business.`NAME`) BUSINESS_NAME
FROM
	`amos_phone` phone
LEFT JOIN `amos_business` business ON phone.BUSINESS_ID REGEXP business.ID
WHERE
	phone.ID = '528a926949f1a8a0bb67234f7c837fac'
GROUP BY
	phone.ID
```

## 清空表
truncate table message_issue;
