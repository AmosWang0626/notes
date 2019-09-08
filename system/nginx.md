# nginx

## 一、nginx 添加白名单IP脚本
```
#!/bin/bash

# 变量赋值
ip=$1

# read -p "请输入新的IP：" ip

echo "$ip" | egrep --color '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
if [ $? -ne 0 ]; then
  echo "你输入ip地址不符和要求";
  exit 0;
fi

# 获取当前文件行数
column=$(wc -l < /etc/nginx/block_ip.txt);

# 向当前最后一行处（也即倒数第二行）插入数据：sed -i "*i allow $ip;" /etc/nginx/block_ip.txt
# 语法：*i 就是在第五行插入行
#       allow $ip; 要插入的内容
sed -i "${column}i allow $ip;" /etc/nginx/block_ip.txt;

echo "add success";

nginx -s reload;

exit 0;

```

## 二、nginx 配置

### 1、location 规则解释 
```
location  = / {
  # 精确匹配 / ，主机名后面不能带任何字符串
  [ configuration A ]
}

location  / {
  # 因为所有的地址都以 / 开头，所以这条规则将匹配到所有请求
  # 但是正则和最长字符串会优先匹配
  [ configuration B ]
}

location /documents/ {
  # 匹配任何以 /documents/ 开头的地址，匹配符合以后，还要继续往下搜索
  # 只有后面的正则表达式没有匹配到时，这一条才会采用这一条
  [ configuration C ]
}

location ~ /documents/Abc {
  # 匹配任何以 /documents/Abc 开头的地址，匹配符合以后，还要继续往下搜索
  # 只有后面的正则表达式没有匹配到时，这一条才会采用这一条
  [ configuration CC ]
}

location ^~ /images/ {
  # 匹配任何以 /images/ 开头的地址，匹配符合以后，停止往下搜索正则，采用这一条。
  [ configuration D ]
}

location ~* \.(gif|jpg|jpeg)$ {
  # 匹配所有以 gif,jpg或jpeg 结尾的请求
  # 然而，所有请求 /images/ 下的图片会被 config D 处理，因为 ^~ 到达不了这一条正则
  [ configuration E ]
}

location /images/ {
  # 字符匹配到 /images/，继续往下，会发现 ^~ 存在
  [ configuration F ]
}

location /images/abc {
  # 最长字符匹配到 /images/abc，继续往下，会发现 ^~ 存在
  # F与G的放置顺序是没有关系的
  [ configuration G ]
}

location ~ /images/abc/ {
  # 只有去掉 config D 才有效：先最长匹配 config G 开头的地址，继续往下搜索，匹配到这一条正则，采用
    [ configuration H ]
}

location ~* /js/.*/\.js
```

### 2、实际使用建议
> 所以实际使用中，个人觉得至少有三个匹配规则定义，如下：

#### 2.1 第一个必选规则
> - 直接匹配网站根，通过域名访问网站首页比较频繁，使用这个会加速处理，官网如是说。
> - 这里是直接转发给后端应用服务器了，也可以是一个静态首页

```
location = / {
    proxy_pass http://tomcat:8080/index
}
```

#### 2.2 第二个必选规则
> - 第二个必选规则是处理静态文件请求，这是nginx作为http服务器的强项
> - 有两种配置模式，目录匹配或后缀匹配,任选其一或搭配使用

```
location ^~ /static/ {
    root /webroot/static/;
}
location ~* \.(gif|jpg|jpeg|png|css|js|ico)$ {
    root /webroot/res/;
}
```

#### 2.3 第三个通用规规则
> 第三个规则就是通用规则，用来转发动态请求到后端应用服务器
> 非静态文件请求就默认是动态请求，自己根据实际把握
> 毕竟目前的一些框架的流行，带.php,.jsp后缀的情况很少了

```
location / {
    proxy_pass http://tomcat:8080/
}
```

#### 2.4 实战

##### 2.4.1 一个斜线的问题

```
location /api/ {
    proxy_pass http://localhost:8080;
}

http://10.21.12.88:8080/api/hello
```

```
location /api/ {
    proxy_pass http://localhost:8080/;
}

http://10.21.12.88:8080/hello
```

##### 2.4.2 vue项目页面刷新404
```
if (!-e $request_filename) {
    rewrite ^/(.*) /index.html last;
    break;
}
```
