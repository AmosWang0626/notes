---
title: 编写可维护的JavaScript
date: 2020-08-08
categories: 前端相关
tags:
- JavaScript
---


# 编写可维护的JavaScript

> 忍无可忍，必须改变，去写看着舒服的代码，而非云云。。。

## 第1章 基本的格式化

1. 缩进层级

2. 语句结尾（加分号）

3. 行的长度、换行

4. 空行（大段逻辑前边加空行）

   代码看起来应当像一系列可读的段落，而不是一大段揉在一起的连续文本。

5. 命名（驼峰命名）

   计算机科学只存在两个难题：缓存失效和命名。

6. 变量和函数

   - 变量名：驼峰命名，命名的前缀应该为名词；

   - 函数名：驼峰命名，函数名前缀应当为动词。

     | 动词 | 含义                 |
     | ---- | -------------------- |
     | can  | 函数返回一个布尔值   |
     | has  | 函数返回一个布尔值   |
     | is   | 函数返回一个布尔值   |
     | get  | 函数返回一个非布尔值 |
     | set  | 函数用来保存一个值   |

   - 命名尽可能短，抓住要点，尽量在变量名中体现出值的数据类型。

     - count、length、size；name、title、message

   - 避免使用没有意义的命名，foo、bar、tmp之类

7. 常量（大写字母 + 下换线分隔）

8. 构造函数

9. 原始变量（字符串、数字、布尔值、null、undefined）

10. 字符串（单引号和双引号没啥区别，但你的代码应从头到尾只保持一种风格）

    多行字符串要用`+`分隔

11. 数字（只有一种数字类型——不区分整数、浮点数）

12. null（用来初始化变量、相当于一个占位符）

    - 不要用null来检测是否传入了某个参数
    - 不要用null来检测一个未初始化的变量

13. undefined

    - 没有初始化的变量，初始值为 undefined
    - 未声明的变量，当然也是 undefined
    - 将变量初始值赋值为 null 表明了这个变量的意图，它最终很可能赋
      值为对象。typeof运算符运算null的类型时返回“object”，这样就可以和
      undefined区分开了。

14. 直接声明对象

    ```js
    // 不好的写法
    var book = new Object();
    book.title = "Maintainable JavaScript";
    book.author = "Nicholas C. Zakas";
    
    // 好的写法
    var book = {
    title: "Maintainable JavaScript",
    author: "Nicholas C. Zakas"
    };
    ```

15. 直接声明数组

    ```js
    // 不好的写法
    var colors = new Array("red", "green", "blue");
    var numbers = new Array(1, 2, 3, 4);
    
    // 好的做法
    var colors = [ "red", "green", "blue" ];
    var numbers = [ 1, 2, 3, 4 ];
    ```

    

## 第2章 注释

1. 单行注释

   示例：`// 手机号脱敏`

   - 注释前加空行。

     独占一行的注释，用来解释下一行代码。这行注释之前总是有一个
     空行，且缩进层级和下一行代码保持一致

   - 行尾注释加缩进，不要超过单行最大字符数限制。

     在代码行的尾部的注释。代码结束到注释之间至少有一个缩进。注
     释（包括之前的代码部分）不应当超过单行最大字符数限制，如果
     超过了，就将这条注释放置于当前代码行的上方

   - 被注释掉的大段代码（很多编辑器都可以批量注释掉多行代码）

   ```js
   if (condition) {
       // 如果代码执行到这里，则表明通过了所有安全性检查
       allowed();
   }
   // 不好的写法：注释之前没有空行
   if (condition) {
       // 如果代码执行到这里，则表明通过了所有安全性检查
       allowed();
   }
   // 不好的写法：错误的缩进
   if (condition) {
   // 如果代码执行到这里，则表明通过了所有安全性检查
   	allowed();
   }
   // 好的写法
   var result = something + somethingElse; // somethingElse不应当取值为null
   
   // 不好的写法：代码和注释之间没有间隔
   var result = something + somethingElse;// somethingElse不应当取值为null
   
   // 好的写法
   // if (condition) {
   // doSomething();
   // thenDoSomethingElse();
   // }
   
   // 不好的写法：这里应当用多行注释
   // 接下来的这段代码非常难，那么，让我详细解释一下
   // 这段代码的作用是首先判断条件是否为真
   // 只有为真时才会执行。这里的条件是通过
   // 多个函数计算出来的，在整个会话生命周期内
   // 这个值是可以被修改的
   if (condition) {
       // 如果代码执行到这里，则表明通过了所有安全性检查
       allowed();
   }
   ```

2. 多行注释

   示例：

   ```js
   /*
    * 另一段注释
    * 这段注释包含两行文本
    */
   ```

   - 多好注释前加空行
   - 每行前有 `*` 星号
   - `*` 星号后加空格
   - 行尾注释不要用多行注释

   ```js
   // 好的写法
   if (condition) {
   
       /*
        * 如果代码执行到这里
        * 说明通过了所有的安全性检测
        */
       allowed();
   }
   
   // 不好的写法：注释之前无空行
   if (condition) {
       /*
        * 如果代码执行到这里
        * 说明通过了所有的安全性检测
        */
       allowed();
   }
   
   // 不好的写法：星号后没有空格
   if (condition) {
       /*
        *如果代码执行到这里
        *说明通过了所有的安全性检测
        */
       allowed();
   }
   
   // 不好的写法：错误的缩进
   if (condition) {
   /*
    * 如果代码执行到这里
    * 说明通过了所有的安全性检测
    */
   	allowed();
   }
   
   // 不好的写法：代码尾部注释不要用多行注释格式
   var result = something + somethingElse; /*somethingElse 不应当取值为null*/
   ```

3. 使用注释

   1. 不要写一眼就知道意思的注释

      `var count = 10; // 初始化count`

   2. 难于理解的代码

   3. 可能被误以为错误的代码

   4. 浏览器特性 hack

4. 文档注释 `/**`

## 第4章 变量、函数和运算符

1. 变量声明

   - 不要使用未声明的变量，即使本行使用下一行声明的变量，增加`js引擎`解析负担

   - 变量声明提前

     ```js
     function doSomethingWithItems(items) {
         for (var i=0, len=items.length; i < len; i++) {
         	doSomething(items[i]);
         }
     }
     
     // 推荐写法
     function doSomethingWithItems(items) {
         var i, len;
         for (i=0, len=items.length; i < len; i++) {
         	doSomething(items[i]);
         }
     }
     ```

   - 推荐：函数顶部使用单`var`语句

     ```js
     function doSomethingWithItems(items) {
         var value = 10,
             result = value + 10,
             i,
             len;
         for (i=0, len=items.length; i < len; i++) {
         	doSomething(items[i]);
         }
     }
     ```

2. 函数声明

   - 不要在函数声明之前调用函数

     ```js
     // 不好的写法
     doSomething();
     function doSomething() {
     	alert("Hello world!");
     }
     
     // 好的写法
     function doSomething() {
     	alert("Hello world!");
     }
     doSomething()
     ```

   - 函数内部的局部函数，应紧接着变量声明之后声明

     ```js
     function doSomethingWithItems(items) {
         var i, len,
             value = 10,
             result = value + 10;
     
         function doSomething(item) {
         	// 代码逻辑
         }
     
         for (i=0, len=items.length; i < len; i++) {
         	doSomething(items[i]);
         }
     }
     ```

   - 函数声明不应该出现在语句块之内

     ```js
     // 不好的写法
     if (condition) {
         function doSomething() {
         	alert("Hi!");
         }
     } else {
         function doSomething() {
             alert("Yo!");
         }
     }
     ```

3. 立即调用的函数

   ```js
   // 不好的写法
   var value = function() {
       // 函数体
       return {
       	message: "Hi"
       }
   }();
   
   // 好的写法
   var value = (function() {
       // 函数体
       return {
       	message: "Hi"
       }
   }());
   ```

4. 天然漏洞`eval()`，避免使用

   `eval()`的参数是字符串，`eval()`会将传入的字符串当做代码执行。

## 第5章 UI层的松耦合

1. 松耦合

   JavaScript、HTML、CSS这三个应该相互独立，避免直接关联

2. 将JavaScript从CSS中抽离

   ```css
   /* 不好的写法 */
   .box {
   	width: expression(document.body.offsetWidth + "px");
   }
   ```

   试想，这里边设置了元素宽度以匹配浏览器的宽度。要是要调整，你能想到关键代码在css里？

3. 将CSS从JavaScript中抽离

4. 将JavaScript从HTML中抽离

   ```html
   <!-- 不好的写法 -->
   <button onclick="doSomething()" id="action-btn">Click Me</button>
   ```

   深耦合，不解释

   ```js
   // jQuery
   $("#action-btn").on("click", doSomething);
   ```

5. 将HTML从JavaScript中抽离

   ```js
   // 不好的写法
   var div = document.getElementById("my-div");
   div.innerHTML = "<h3>Error</h3><p>Invalid e-mail address.</p>";
   ```

   1. 从服务器加载

      `div.innerHTML = xhr.responseText;`

   2. 简单客户端模板

      ```html
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <title>amos</title>
          <script>
              window.onload = function () {
                  var myList = document.getElementById("myList"),
                      templateText = myList.firstChild.nodeValue;
                  alert(templateText)
              }
          </script>
      </head>
      <body>
      <ul id="myList"><!--<li id="item%s"><a href="%s">%s</a></li>-->
          <li><a href="/item/1">First item</a></li>
          <li><a href="/item/2">Second item</a></li>
          <li><a href="/item/3">Third item</a></li>
      </ul>
      </body>
      </html>
      ```

   3. 复杂客户端模板

      ```html
      <script id="templateModal" type="text/html">
      </script>
      ```

6. 避免使用全局变量

   1. 全局变量带来的问题

      1. 命名冲突
      2. 代码的脆弱性
      3. 难以测试

   2. 意外的全局变量（"use strict"; 引入强校验规则）

      不小心省略`var`导致的全局变量bug

      ```js
      function something {
      	var count = 10;
               name = "AmosWang";
      }
      ```

      此时name就会自动创建为全局变量

   3. 单全局变量方式

      命名空间（创建全局对象，作为命名空间，例如 that 之类）

7. 事件处理

   ```js
   // 不好的写法
   function handleClick(event) {
       var popup = document.getElementById("popup");
       popup.style.left = event.clientX + "px";
       popup.style.top = event.clientY + "px";
       popup.className = "reveal";
   }
   // 第7章中的 addListener()
   addListener(element, "click", handleClick);
   ```

   ```js
   // 好的写法 - 拆分应用逻辑
   var MyApplication = {
       handleClick: function(event) {
       	this.showPopup(event);
       },
       showPopup: function(event) {
           var popup = document.getElementById("popup");
           popup.style.left = event.clientX + "px";
           popup.style.top = event.clientY + "px";
           popup.className = "reveal";
       }
   };
   addListener(element, "click", function(event) {
   	MyApplication.handleClick(event);
   });
   ```

   ```js
   // 好的做法 - 不要分发事件对象
   var MyApplication = {
       handleClick: function(event) {
           // 假设事件支持DOM Level2
           event.preventDefault();
           event.stopPropagation();
           // 传入应用逻辑
           this.showPopup(event.clientX, event.clientY);
       },
       showPopup: function(x, y) {
           var popup = document.getElementById("popup");
           popup.style.left = x + "px";
           popup.style.top = y + "px";
           popup.className = "reveal";
       }
   };
   
   addListener(element, "click", function(event) {
   	MyApplication.handleClick(event); // 可以这样做
   });
   ```

8. 避免空比较

   typeof variable 和 typeof(variable)，推荐使用前者

   1. 检测原始值（typeof 或 === !==）

      ```js
      // 检测字符串
      if (typeof name === "string") {
      	anotherName = name.substring(3);
      }
      // 检测数字
      if (typeof count === "number") {
      	updateCount(count);
      }
      // 检测布尔值
      if (typeof found === "boolean" && found) {
      	message("Found!");
      }
      // 检测undefined
      if (typeof MyApp === "undefined") {
          MyApp = {
          // 其他的代码
          };
      }
      
      // 如果你需要检测null，则使用这种方法
      var element = document.getElementById("my-div");
      if (element !== null) {
      	element.className = "found";
      }
      ```

      - 运行typeof null 则返回“object”，这是一种低效的判断null的方法。
      - 如果你需要检测null，则直接使用恒等运算符（===）或非恒等运算符（!==）。

   2. 检测引用值（instanceof）

      ```js
      // 检测日期
      if (value instanceof Date) {
      	console.log(value.getFullYear());
      }
      // 检测正则表达式
      if (value instanceof RegExp) {
          if (value.test(anotherValue)) {
          	console.log("Matches");
          }
      }
      // 检测Error
      if (value instanceof Error) {
      	throw value;
      }
      ```

   3. 检测函数

      ```js
      function myFunc() {}
      // 不好的写法
      console.log(myFunc instanceof Function); // true
      
      // 好的写法
      console.log(typeof myFunc === "function"); // true
      ```

   4. 检测数组

      ```js
      function isArray(value) {
          if (typeof Array.isArray === "function") {
          	return Array.isArray(value);
          } else {
          	return Object.prototype.toString.call(value) === "[object Array]";
          }
      }
      ```

完。。。

