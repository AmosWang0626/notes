# 压测工具

## Siege

```shell script
#开始为期1分钟  200并发的请求百度
siege -c 200 -t 1 www.baidu.com
```

### Siege输出结果说明
- Transactions: 总共测试次数
- Availability: 成功次数百分比
- Elapsed time: 总共耗时多少秒
- Data transferred: 总共数据传输
- Response time: 等到响应耗时
- Transaction rate: 平均每秒处理请求数
- Throughput: 吞吐率
- Concurrency: 最高并发
- Successful transactions: 成功的请求数
- Failed transactions: 失败的请求数
