# Vue学习

## 1.安装node.js
node.js的安装：下载msi文件，傻瓜式安装

### 安装参考教程：
- Node.js安装及环境配置之Windows篇
  > http://www.jianshu.com/p/03a76b2e7e00
- vue+webpack构建项目
  > http://www.cnblogs.com/leijing0607/p/6386615.html
- 一步步构造自己的vue2.0+webpack环境
  > http://www.cnblogs.com/wj204/p/6031435.html


## 2.安装淘宝镜像
* npm install -g cnpm --registry=https://registry.npm.taobao.org 

### 解决异常
某镜像下载不下来，例如 js-beautify-1.7.0，干脆找到下载地址(github),然后放到本地仓库
> https://github.com/beautify-web/js-beautify/tree/v1.7.0


## 3.安装vue-cli
* cnpm install -g vue-cli
* 安装完成后, 输入vue，就可看见系统已识别该命令


## 4.创建个项目
官方实例如下：
```
# 全局安装 vue-cli
$ npm install --global vue-cli
# 创建一个基于 webpack 模板的新项目
$ vue init webpack my-project
# 安装依赖，走你
$ cd my-project
$ npm install
$ npm run dev
```
### Windows小技巧
* 查看当前目录下文件 tree
* 查看当前目录下全部文件 tree /f
* 保存当前显示的目录结构 tree >hello.txt  || tree /f >hello.txt


## 5.npm 更新
package.json 引用的有些可能是不安全的，github也会做出提示，定期更新依赖的文件也是很必要的

* 安装更新工具: npm install -g npm-check-updates
* 检查更新: ncu
* 当前项目依赖更新: ncu -u
* 所有项目依赖更新: ncu -a

