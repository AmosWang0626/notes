---
title: JVM CPU飙高问题排查
date: 2020-03-07
categories: Java
tags:
- CPU飙高
- JVM
---

# CPU飙高问题排查
> 项目稳定运行，但难免会有些操作引发CPU飙高，怎么处理呢？
>
> 附源码：模拟CPU飙高，while(true)

## 道路千万条，开车第一条
> 不要慌，不要慌，不要慌
1. `jps` 查看进程ID
    - `jps` 或者 `jps -l`
    - eg. 拿到进程ID `795`
2. `top` 查看进程实时监控，拿到CPU飙高的线程ID（）
    - `top -Hp 795`
    - eg. 拿到CPU飙高的线程ID `841`
3. 将上一步线程ID转换为十六进制
    - `printf "%x\n" 841`
    - eg. 拿到十六进制线程ID `349`
4. `jstack` 堆栈跟踪工具
    - `jstack 795|grep 349 -A 30`
    - 报错 `well-known file is not secure` 对应PID的启动用户不是当前用户

## 图片演示
- 获取异常服务进程ID
    > ![获取异常服务进程ID](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-jps.png)

- 模拟CPU飙高
    > ![模拟CPU飙高](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-range.png)

- 找到CPU飙高线程
    > ![找到CPU飙高线程](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-top.png)

- 进程ID转16进制，打印当前异常堆栈快照
    > ![进程ID转16进制，打印当前异常堆栈快照](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-hex-jstack.png)

- GC情况-Java8（已使用空间占总空间的百分比）
    > ![GC情况-主要关注已使用空间占总空间的百分比](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-jstat.png)
    - S0：幸存者空间0
    - S1：幸存者空间1
    - E：伊甸园
    - O：老年代
    - M：元空间
    - CCS：压缩的类空间
    - YGC：Young GC次数
    - YGCT：Young GC时间
    - FGC：Full GC次数
    - FGCT：Full GC时间
    - GCT：GC 总时间

- SED查看文件指定行
    > ![SED查看文件指定行](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-log-sed.png)


## JVM监控工具准备
- 服务器端之前安装的jdk可能不带jps、jstack...之类的工具
    - 可以输个`jps`测试下
    - 也可以find搜索下，`find / -name jstack`
    - 如果没有，可以对应安装下
        - `yum search java-1.8`
        - 认准`java-*-devel`
        - `yum install java-1.8.0-openjdk-devel.x86_64`

## VIM 显示/关闭行号
- 显示行号 `:set nu`
- 取消行号 `:set nonu`

## JVM模拟CPU飙高源码
![页面详情](https://gitee.com/AmosWang/resource/raw/master/image/jvm/jvm-test-range.png)

### 1、Java源码
```java
/**
 * DESCRIPTION: JvmTestController
 *
 * @author <a href="mailto:amos.wang@xiaoi.com">amos.wang</a>
 * @date 3/6/2020
 */
@RestController
@RequestMapping("jvm")
public class JvmController {

    private boolean closeFlag = true;


    @GetMapping
    public ModelAndView index() {
        return new ModelAndView("index");
    }

    @GetMapping("jump")
    public String jump() {
        closeFlag = !closeFlag;
        return "循环状态 ？" + (closeFlag ? "关闭" : "打开");
    }

    @GetMapping("range")
    public String range() {
        while (true) {
            if (closeFlag) {
                break;
            }
            if (System.currentTimeMillis() % 1000 == 0) {
                System.out.println(Thread.currentThread());
            }
        }
        System.out.println("\n\n");
        return "已退出循环";
    }

}
```

### 2、原生HTML、GET请求
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>jvm test</title>
    <style>
        .btn {
            font-size: 18px;
            padding: 6px;
            height: 300%;
        }

        .ipt {
            height: 25px;
        }

        .fs14 {
            font-size: 14px;
        }
    </style>
    <script>
        function openClick() {
            // init
            document.getElementById("openMessage").innerText = "循环执行中";
            let xhr = new XMLHttpRequest();
            xhr.open("get", "jvm/range");
            xhr.send(null);
            xhr.onload = function () {
                document.getElementById("openMessage").innerText = xhr.responseText
            };
            xhr.onerror = function () {
                alert("error: " + xhr.status)
            };
        }

        function jumpClick() {
            let xhr = new XMLHttpRequest();
            xhr.open("get", "jvm/jump");
            xhr.send(null);
            xhr.onload = function () {
                document.getElementById("jumpMessage").innerText = xhr.responseText
            };
            xhr.onerror = function () {
                alert("error: " + xhr.status)
            };
        }
    </script>
</head>
<body>
<h1>JVM TEST</h1>
<button id="jump" class="btn" onclick="jumpClick()">改变循环状态</button>
<span class="fs14">默认关闭</span>
<h3 id="jumpMessage"></h3>
<br>
<button id="open" class="btn" onclick="openClick()">执行循环</button>
<h3 id="openMessage"></h3>
</body>
</html>
```
