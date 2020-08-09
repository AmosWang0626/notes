---
title: Hexo 挂掉自动重启
date: 2020-08-09
tags:
- hexo
---

# Hexo 挂掉自动重启

## 1. npm 安装 pm2
`npm install pm2 -g`

## 2. 编写重启脚本
```js
var exec = require('child_process').exec;
var cmd = 'cd /opt/hexo/hexoui && nohup hexo s &';

exec(cmd, function (error, stdout, stderr) {
    // 建议打印如下日志,便于排查问题
    if (stdout) {
        console.log('stdout: ' + stdout);
    }
    if (stderr) {
        console.log('stderr: ' + stderr);
    }

    if (error) {
        console.info('start error!', error);
        process.exit(0);
    } else {
        console.info('start hexo-js success!')
    }
});
```

## 3. 用 pm2 执行如上脚本
> 找不到 pm2 命令？进入 node 安装目录下的 bin 目录

`pm2 start /app/hexo/hexo-auto.js`

`pm2 logs`

`pm2 list`