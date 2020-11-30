---
title: pm2 
date: 2020-11-17
categories: 前端相关
tags:
- Node.js
---

# pm2

## 是什么？
[github.com/Unitech/pm2](https://github.com/Unitech/pm2)

具有内置负载均衡的的Node.js应用进程管理器。

## 做什么？
使用hexo时，hexo进程总会无辜挂掉（可能是服务器内存不够），所以就需要一个能监控hexo挂掉，就自动重启的小工具。

## 增删查

- 增

```sh
$ pm2 start --name hexo /opt/hexo/auto-start-hexo.js
```

- 删

```sh
$ delete|del <name|id|namespace|script|all|json|stdin...>
```

- 查询

```sh
$ pm2 list|ls|l|ps|status
$ pm2 logs
$ pm2 monit
$ pm2 describe <id|app_name>

$ pm2 stop     <app_name|namespace|id|'all'|json_conf>
$ pm2 restart  <app_name|namespace|id|'all'|json_conf>
$ pm2 delete   <app_name|namespace|id|'all'|json_conf>
```

## 其他 (自动启动hexo脚本)

```javascript
var exec = require('child_process').exec;
var cmd = 'cd /opt/hexo/hexoui && nohup hexo s &';

exec(cmd, function(error, stdout, stderr) {

  if(stdout){
      console.log('stdout: ' + stdout);
  }
  if(stderr){
      console.log('stderr: ' + stderr);
  }

  if(error) {
    console.info('start error!', error);
    process.exit(0);
  } else {
    console.info('start hexo-js success!')
    // process.exit(0);
  }
});
```
