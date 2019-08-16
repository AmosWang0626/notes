## 批量更新
```
<update id="batchUpdateErrorList">
    INSERT INTO `sip_session_phone` (ID, TALK_TIME, TALE_END_TIME)
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
