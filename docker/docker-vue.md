# Docker build image

## Dockerfile
```
FROM nginx
COPY dist/ /usr/share/nginx/html/
COPY /conf.d/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```
- expose 暴露端口为镜像暴露端口，可配置多个

## docker build -t kbsui:1.0 .
- -t 是指定镜像名字（:版本）
- . 表示Dockerfile在当前目录

## docker run -d -p 80:80 --name kbsui kbsui:1.0
