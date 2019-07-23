
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
