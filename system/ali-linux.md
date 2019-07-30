## 阿里云服务器ssh过一段时间就断开连接

```
vim /etc/ssh/sshd_config

找到下面两行
#ClientAliveInterval 0
#ClientAliveCountMax 3

去掉注释，改成
ClientAliveInterval 30
ClientAliveCountMax 86400

这两行的意思分别是

1、客户端每隔多少秒向服务发送一个心跳数据
2、客户端多少秒没有相应，服务器自动断掉连接

重启sshd服务

service sshd restart
```
