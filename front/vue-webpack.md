
## 1. 首先需要安装node.js

- node.js的安装：
    - 下载msi文件，傻瓜式安装
    - Node.js安装及环境配置之Windows篇
		http://www.jianshu.com/p/03a76b2e7e00

	- vue+webpack构建项目
		http://www.cnblogs.com/leijing0607/p/6386615.html

	- 一步步构造自己的vue2.0+webpack环境
		http://www.cnblogs.com/wj204/p/6031435.html


- 安装淘宝镜像：

	- npm install -g cnpm
	 --registry=https://registry.npm.taobao.org 

	- cnpm install

	- 如果某镜像下载不下来，直接去下载该文件的源码
    	- 例如：js-beautify-1.7.0
    	- 下载地址(github)
    	 - https://github.com/beautify-web/js-beautify/tree/v1.7.0


- 安装vue-cli
    - cnpm install -g vue-cli
    - 安装完成后		输入vue，就可看见系统已识别该命令


## 2. 安装好了，创建个项目吧

	官方实例如下：

	# 全局安装 vue-cli
	$ npm install --global vue-cli
	# 创建一个基于 webpack 模板的新项目
	$ vue init webpack my-project
	# 安装依赖，走你
	$ cd my-project
	$ npm install
	$ npm run dev

	Windows 查看当前目录下文件 tree
		查看当前目录下全部文件 tree /f
		保存当前显示的目录结构 tree >hello.txt  || tree /f >hello.txt

	创建项目：vue init webpack my-first-vue-project
	
	安装项目：cnpm install
	  (在my-first-vue-project文件夹下)

	运行项目：cnpm run dev
