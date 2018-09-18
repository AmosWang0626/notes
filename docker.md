# Docker 学习笔记

## 镜像与容器的关系
类似面向对象中类与对象的关系

|DOCKER|面向对象|
|---|---|
|容器|对象|
|镜像|类|

----------
## Docker run 命令解析
> docker run [OPTIONS] IMAGE [COMMAND] [ARG...]

OPTIONS说明：

    -a stdin
        指定标准输入输出内容类型，可选 STDIN/STDOUT/STDERR 三项；

    -d: 
        后台运行容器，并返回容器ID；

    -i: 
        以交互模式运行容器，通常与 -t 同时使用；

    -t: 
        为容器重新分配一个伪输入终端，通常与 -i 同时使用；

    --name="nginx-lb"
        为容器指定一个名称；

    --dns 8.8.8.8
        指定容器使用的DNS服务器，默认和宿主一致；

    --dns-search example.com
        指定容器DNS搜索域名，默认和宿主一致；

    -h "mars"
        指定容器的hostname；

    -e username="ritchie"
        设置环境变量；

    --env-file=[]
        从指定文件读入环境变量；

    --cpuset="0-2" or --cpuset="0,1,2"
        绑定容器到指定CPU运行；

    -m
        设置容器使用内存最大值；

    --net="bridge"
        指定容器的网络连接类型，支持 bridge/host/none/container: 四种类型；

    --link=[]
        添加链接到另一个容器；

    --expose=[]
        开放一个端口或一组端口；

----------


# 拉取第一个Docker镜像

### 一、拉取镜像：
- docker pull [OPTIONS] NAME[:TAG]
- NAME是必须的，表示拉去镜像的名字

### 二、查看电脑上安装的镜像：
> docker images [OPTIONS] [REPOSITORY[:TAG]]
> 两个属性不是必需的

- 先查看电脑上有的镜像
    docker images
    
- 拉取镜像(拉取的时候只有名字，没有地址，它会先在本地找，
  本地找不到回到docker的仓库去找)
    docker pull hello-world

----------

# 运行我们的第一个镜像

> docker run [OPTIONS] IMAGE[:TAG] [COMMAND] [ARG...]
> IMAGE 是必需的

- docker run hello-world

----------
# 修改镜像存放位置
    https://blog.csdn.net/stemq/article/details/5315093
    
    控制面板->管理工具->Hyper-V 管理器->虚拟机右键设置
    
    将默认C:\Users\Public\Documents\Hyper-V\Virtual hard disks\MobyLinuxVM.vhdx的文件拷贝到想要改变的路径

----------

# Docker 运行 Nginx服务器
// docker run --help
> 1. 持久化容器
> 2. 前台挂起 & 后台运行
> 3. 进入Nginx内部

- 首先查找Nginx
    - docker search nginx

- 首先pull获得我们要运行的Nginx
    - docker pull nginx
    - 报错了 Get XXX: unauthorized: incorrect username or password，不要紧，docker退出登录，使用用户名加密码登录，不能是邮箱加密码哟。

- 查看当前docker里边运行的容器
    - docker images

- 后台运行Nginx, -d 后台运行容器，并返回容器ID
    - docker run -d nginx

- 运行之后，查看一下
    - docker ps -a

- 查看docker内部信息
    // docker exec --help

	-i 以交互模式运行容器
	-t 为容器重新分配一个伪输入终端
	bash 是进入终端的命令(Linux系统)，另外因为Nginx运行在Linux之上

    docker exec -it 容器别名 bash

- 查看Nginx的位置
    which nginx
    whereis nginx

- 停止Nginx
    docker stop 容器名字或者id

----------

## Docker 网络通讯
> 网络类型：
    Bridge: Bridge有独立的Namespace，这就涉及到端口映射
    Host: 使容器与主机使用同一块网卡

### Bridge 第一种方式

> -p **:** 指定端口 p小写

    Bridge[桥接网络的方式]启动容器
    docker run -d -p 8080:80 nginx

    查看端口的状态
    netstat -na|grep 8080

    然后就可以在本机的浏览器中访问Nginx了
    localhost:8080

### Bridge 第二种方式
> -P 随机分配端口 P大写

    Bridge[桥接网络的方式]启动容器
    docker run -d -P nginx
    
    会看到随机端口已启动
    如：0.0.0.0:32769->80/tcp...........

    然后查看端口状态
    netstat -na|grep 32769

    然后就可以在本机的浏览器中访问Nginx了
    localhost:32769

----------

## 其他

- *:latest 字面意思是最新的 未必

----------


### 创建自己的Java web应用

    制作自己的镜像
    
    Dockerfile：告诉Docker我要怎么制作docker镜像，制作镜像的每一步操作是什么
    
    docker build：之后执行Dockerfile中描述的事情
    
    将自己的应用.war放到目录中,ls查看目录中文件
    ls
    
    修改文件名字
    mv jpress-web-newest.war jpress.war
    
    下载Tomcat Docker版本(老地方搜索)
    docker pull hub.c.163.com/library/tomcat:latest
    
    下载完成，查看本地的镜像（335MB）
    docker images
    
    创建Dockerfile文件
    vi Dockerfile


以下是Dockerfile的内容，其中中文注解不算

    ***Dockerfile*****************************************
    // 告诉Docker这里是本镜像的起点
    from hub.c.163.com/library/tomcat
    
    // 所有者
    MAINTAINER amos ***@163.com
    
    // 将自己的应用copy进来
    COPY jpress.war /usr/local/tomcat/webapps
    
    插入i
    保存退出:wq
    
    ***Dockerfile*****************************************

----------
    
    运行制作镜像
    docker build -t jpress:latest .
    
    .所在位置代表目录，.也就是当前目录
    -t 设置该镜像名字，后边跟的就是名字jpress，版本是latest


    运行镜像(-d：后台运行,-p：指定端口号，:8080：Tomcat默认端口号)
    docker run -d -p 8888:8080 jpress
    
    查看运行的进程
    docker ps
    
    查看端口状态
    netstat -na|grep 8888
    
    浏览器测试：
    localhost:8888
    
    访问应用
    localhost:8888/jpress

----------

    运行出一个MySQL
    
    搜索一个
    docker pull hub.c.163.com/library/mysql:latest
    
    先下载
    docker pull hub.c.163.com/library/mysql:latest
    
    后台运行MySQL（-e：后边跟的就是键值对）
    docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=000000 -e MYSQL_DATABASE=jpress hub.c.163.com/library/mysql:latest
    
    查看运行的进程
    docker ps
    
    查看端口状态
    netstat -na|grep 3306
    
    运行jpress项目的的时候，可能会报错
    localhost应该改为本机的IP地址192.168.1.103
    
    用ifconfig能查到，如192.168.1.103
    
    获得web容器id
    docker ps
    
    重启web容器
    docker restart f888

----------


    集装箱、标准化和隔离
    
    镜像、容器和仓库（build ship run）
    
    docker命令 pull,build,run,stop,restart,exec

----------