---
title: JS监听数组push方法
date: 2020-10-29
categories: 前端相关
---


# JS监听数组push方法

```javascript
var arr = [];

var arrayProto = Array.prototype,
    arrayMethods = Object.create(arrayProto),
    newArrProto = [];
['push'].forEach(method => {
    let original = arrayMethods[method];
    newArrProto[method] = function mutator() {
        console.log(arguments[0]);
        return original.apply(this, arguments);
    }
});
arr.__proto__ = newArrProto;

arr.push('111');
arr.push('222');
arr.push('333');
```
