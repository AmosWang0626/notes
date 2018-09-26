# Docker 学习笔记
>  镜像与容器的关系
> - 类  and 对象
> - 镜像 and 容器

## Docker基本操作

### 一、查询镜像：
> docker search [OPTIONS] TERM
- TERM是必须的，表示镜像的名字

### 二、查看电脑上安装的镜像：
> docker images [OPTIONS] [REPOSITORY[:TAG]]
- 两个属性不是必需的

### 三、拉取一个镜像
> docker pull [OPTIONS] NAME[:TAG]
- NAME是必须的，表示拉去镜像的名字

### 四、运行容器
> docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
- -d 后台运行容器，并返回容器ID；
- -i 以交互模式运行容器，通常与 -t 同时使用；
- -t 为容器重新分配一个伪输入终端，通常与 -i 同时使用；
- --name nginx-amos 为容器指定一个名称；
- -p **:** 指定端口 (p小写)
- -P 随机分配端口 (P大写)

### 五、停止容器
> docker stop [OPTIONS] CONTAINER [CONTAINER...]
- CONTAINER
	- CONTAINER ID：容器ID
	- NAMES：容器名称

### 六、列出容器
> docker ps [OPTIONS]
- -a 显示所有的容器，包括未运行的
- -q 静默模式，只显示容器编号
- -s 显示总的文件大小

### 七、删除容器
> docker rm [OPTIONS] CONTAINER [CONTAINER...]
- -f 通过SIGKILL信号强制删除一个运行中的容器
- -l 移除容器间的网络连接，而非容器本身
- -v -v 删除与容器关联的卷

### 八、删除镜像
> docker rmi [OPTIONS] IMAGE [IMAGE...]
- -f 强制删除
- docker rmi mysql/mysql-server:latest

### 九、拉取一个镜像


### 十、拉取一个镜像

----------

## Docker 网络通讯
> 网络类型：
> - Bridge: Bridge有独立的Namespace，这就涉及到端口映射
> - Host: 使容器与主机使用同一块网卡

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
## Windows Docker安装 ~ 修改镜像存放位置
    https://blog.csdn.net/stemq/article/details/5315093
    
    控制面板->管理工具->Hyper-V 管理器->虚拟机右键设置
    
    将默认C:\Users\Public\Documents\Hyper-V\Virtual hard disks\MobyLinuxVM.vhdx的文件拷贝到想要改变的路径

----------

# Docker 运行 Nginx服务器
> docker run --help
> 1. 持久化容器
> 2. 前台挂起 & 后台运行
> 3. 进入Nginx内部

- 首先查找Nginx镜像
    - docker search nginx

- pull获得我们要运行的Nginx
    - docker pull nginx
    - 报错了 Get XXX: unauthorized: incorrect username or password，不要紧，docker退出登录，使用用户名加密码登录，不能是邮箱加密码哟。

- 查看当前docker里边运行的容器
    - docker images

- 后台运行Nginx, -d 后台运行容器，并返回容器ID
    - docker run -d nginx

- 运行之后，查看一下
    - docker ps -a

- 查看docker内部信息
> docker exec --help
> - -i 以交互模式运行容器
> - -t 为容器重新分配一个伪输入终端
> - bash 是进入终端的命令(Linux系统)，另外因为Nginx运行在Linux之上
> - docker exec -it 容器别名 bash

- 查看Nginx的位置
    which nginx
    whereis nginx

- 停止Nginx
    docker stop 容器名字或者id

----------

## 其他

- *:latest 字面意思是最新的 未必

----------

### Docker MySQL

- docker pull mysql/mysql-server:8.0
- docker run -d -p 3306:3306 --name mysql666 -e MYSQL_ROOT_PASSWORD=123456 mysql/mysql-server:8.0
- netstat -aon|findstr "3306"
- docker exec -it mysql666 mysql -uroot -p
- docker exec -it mysql666 mysql -uroot -p123456
- ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';
- docker exec -it mysql666 bash【bash访问】
- mysql666 【启动、重启、停止】
  - docker start mysql666
  - docker restart mysql666
  - docker stop mysql666



