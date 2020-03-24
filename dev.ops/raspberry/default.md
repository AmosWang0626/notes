---
title: 树莓派4B原系统初始化
date: 2020-03-19
categories: 树莓派
tags:
- 树莓派
---

# 树莓派4B原系统初始化
1. 在`TF`卡`boot`根目录中新建`SSH`（注意：空文件、并且没有后缀）
    > [适合没屏幕]，这种方式我用4B操作了几遍，不太好使，但也值得一试
    >
    > 如果不行，就连个显示屏，默认直接就登录进去了，然后下边三种方式任选其一，经测试均可以

2. 执行命令：`sudo /etc/init.d/ssh start`
    > 最简单

3. 桌面左上角，点击那个树莓
    > 界面上操作，最直观
    - 首选项 >>> `Raspberry Pi Configuration` >>> `Interface`
    - 设置 `SSH` 为 `Enable`

4. 执行命令：`sudo raspi-config`
    > 相对麻烦点，好处是一览 raspi-config
    - 选择 `5  Interfacing Options`
    - 再选择 `SSH`，选择`是`，`确认`

# 树莓派开启 ll
1. `vi ~/.bashrc` 
2. 放开 `alias ll='ls $LS_OPTIONS -l'`
3. 立即生效 `source ~/.bashrc`

# 树莓派安装Docker
> [树莓派上 Docker 的安装和使用](https://shumeipai.nxez.com/2019/05/20/how-to-install-docker-on-your-raspberry-pi.html)

# 树莓派设置固定IP
> [树莓派怎么设置静态ip](http://m.elecfans.com/article/892341.html)
>
> 设置完应用下 `sudo reboot`

# 树莓派设置Docker仓库
- `cd /etc/docker`
- `vi daemon.json`
    ```json
    {
      "registry-mirrors": ["https://ug1g4lsw.mirror.aliyuncs.com"]
    }
    ```
- `sudo systemctl daemon-reload`
- `sudo systemctl restart docker`
- 看看配置有没有生效 `docker info`
