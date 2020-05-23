---
title: Docker Jenkins
date: 2018-01-01
categories: Docker
tags:
- docker
---

# Docker Jenkins
> docker-compose 便捷启动


## Linux
```yaml
version: '3'
services:
  jenkins:
    image: jenkinsci/blueocean
    restart: always
    container_name: jenkins
    ports:
      - '8080:8080'
    volumes:
      - './jenkins-data:/var/jenkins_home'
      - '/var/run/docker.sock:/var/run/docker.sock'

```

## Windows
```yaml
version: '3'
services:
  jenkins:
    image: jenkinsci/blueocean
    restart: always
    container_name: jenkins
    ports:
      - '8080:8080'
#    volumes:
#      - './jenkins-data:/var/jenkins_home'

```