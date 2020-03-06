---
title: Java 设计模式
date: 2020-03-02
categories: 设计模式
tags:
- 设计模式
---

# 设计模式
> 设计模式, 代码的孙子兵法
>
> 黑色三月 >>> 学习·祭奠·不凡 ```2019.3```
>
> 又是三月 >>> 学习·巩固·提高 ```2020.3```

---
## 一、原则
1. 单一职责原则
    > 就一个类而言，应该仅有一个引起它变化的原因。
2. 开闭原则
    > 软件实体（类、模块、函数等等）应该可以扩展，但是不可以修改。
3. 依赖倒置原则
    > 要针对接口编程，不要对实现编程。
    1. 高层模块不应该依赖低层模块，两个都应该依赖抽象；
    2. 抽象不应该依赖细节，细节应该依赖抽象。
4. 里式替换原则
    > 子类型必须能够替换掉他们的父类型。
5. 接口隔离原则
    > 细化接口，但要适中，不大不小方为最佳实践。
    1. 客户端不应该依赖它不需要的接口；
    2. 类间的依赖关系应该建立在最小的接口上。
6. 迪米特原则
    > 如果两个类不必彼此直接通信，那么这两个类就不应当发生直接的相互作用。
      如果其中一个类需要调用另一个类的某一个方法的话，可以通过第三者转发这个调用。

### 原则总结 [参考:设计模式图册](https://mp.weixin.qq.com/s/xQLBvFJrMDTF8551oFxLnA)
- 用抽象构建框架，用实现扩展细节；
- 单一职责原则告诉我们实现类要职责单一；
- 里氏替换原则告诉我们不要破坏继承体系；
- 依赖倒置原则告诉我们要面向接口编程；
- 接口隔离原则告诉我们在设计接口的时候要精简单一；
- 迪米特法则告诉我们要降低耦合；
- 而开闭原则是总纲，他告诉我们要对扩展开放，对修改关闭。

---
## 二、分类
### 2.1 [创建型模式](https://github.com/AmosWang0626/chaos/tree/master/chaos-design/src/main/java/com/amos/design/creation)
> 5 个
1. 建造者(Builder)
2. 工厂方法(Factory Method)
3. 抽象工厂(Abstract Factory)
4. 原型(Prototype)
5. 单例(Singleton)

### 2.2 [结构型模式](https://github.com/AmosWang0626/chaos/tree/master/chaos-design/src/main/java/com/amos/design/structure)
> 7 个
1. 适配器(Adapter)
2. 桥接(Bridge Pattern)
3. 组合(Composite)
4. 装饰者(Decorator)
5. 外观(Facade)
6. 享元(Flyweight)
7. 代理(Proxy)

### 2.3 [行为型模式](https://github.com/AmosWang0626/chaos/tree/master/chaos-design/src/main/java/com/amos/design/behavior)
> 11 个
1. 责任链(Chain)
2. 命令(Command)
3. 解释器(Interpreter)
4. 迭代器(Iterator)
5. 中介者(Mediator)
6. 备忘录(Memo)
7. 观察者(Observer)
8. 状态(State)
9. 策略(Strategy)
10. 模板方法(Template Method)
11. 访问者(Visitor)

## 三、设计模式总结
> 创建型模式(5个)；结构型模式(7个)；行为型模式(11个)

### 3.1 创建型模式(5个)
1. 建造者(Builder)
    > 将一个复杂对象的构建与它的表示分离，使得同样的构建过程可以创建不同的标示。
    - 以烙饼为例，步骤是类似的，可以抽象出来。【制作面饼、加入调料、锅里加油、油热放饼、烙好出锅】
    - 两个实现类，实现烙饼抽象类。【葱油饼、锅盔、油洛馍】
    - 一个操作类，烙饼师傅，告诉师傅要烙什么饼，师傅按步骤烙饼。
2. 工厂方法(Factory Method)
    > 定义一个用于创建对象的接口，让子类决定实例哪一个类。工厂方法使一个类的实例化延迟到子类。
    - 加减乘除运算，简单工厂时，需要告诉工厂（+ - * /），工厂内部判断后，执行对应运算；
      如果要增加运算，需要修改原工厂内部逻辑，违反了开闭原则。
    - 工厂方法时，由客户端决定实例化哪一个工厂执行运算；
      如果要加功能，原先工厂不用修改，增加工厂，修改客户端即可。
3. 抽象工厂(Abstract Factory)
    > 提供一个创建一系列相关或相互依赖对象的接口，而无需指定它们具体的类。
    - 一个抽象数据库工厂，提供用户管理和数据管理功能。
    - MySQL、Oracle都实现了这个工厂；并且分别实现了用户管理和数据管理。
    - 客户端拿到一个工厂，就可以操作两个具体工厂（用户管理、数据管理）
4. 原型(Prototype)
    > 用原型实例指定创建对象的种类，并且通过拷贝这种原型创建新的对象。
    - 有一个原型，就像小时候，家里做鞋时的鞋样。
    - 根据原型创建出一个新的对象，根据原型的复杂程度，有的不能完全克隆clone，需要进一步处理。【浅复制、深复制】
5. 单例(Singleton)
    > 保证一个类仅有一个实例，并提供一个访问它的全局访问点。
    - 系统中有的对象一个就够了，此时就用到了单例模式。Spring中单例模式就用的非常到位。
    - 在高并发环境中，更要保证对象的唯一性。此时又有【饿汉模式、懒汉模式】

### 3.2 结构型模式(7个)
1. 适配器(Adapter)
    > 将一个类的接口转换成客户希望的另一个接口。Adapter模式使得原本由于接口不兼容而不能一起工作的那些类可以一起工作。
    - 现有两个不兼容的类，Micro-B，Type-C，它们都实现了充电和传输数据功能；
    - 抽象出充电和传输数据接口；创建两个适配器类，分别实现Micro-B和Type-C的功能；
    - 好处：在不改变原有类的情况下，使得两个不兼容的类一起工作。
2. 桥接(Bridge Pattern)
    > 将抽象部分与它的实现部分分离，使它们都可以独立变化。
    - 比较好地诠释了聚合和合成的关心；【聚合，弱引用，大雁和雁群的关系；合成，强引用，大雁和翅膀的关系】
    - 有两个品牌的手机，小米和华为，它们的名字是必须的，需要不同手机自己实现，属于合成关系；
    - 它们的运行内存、存储容量则可以聚合进去，在不改变手机类的情况下，可赋予不同的内存和存储容量。
3. 组合(Composite)
    > 将对象组合成树形结构以表示‘部分-整体’的层次结构。组合模式使得用户对单个对象和组合对象的使用具有一致性。
    - 总公司有自己的人力资源部、财务部、子公司；子公司也有人力资源部、财务部、子公司，怎么设计呢？
    - 抽象一个公司类，提供新增、删除、显示详情、职责功能；
    - 公司、部门等等都实现抽象公司；只不过部门（叶子节点）下边不能再添加子公司了。
    - 你可能会觉得部门实现抽象公司不太合理，此时又分为透明方式(实现抽象公司)和安全方式(部门额外处理，此时需要增加抽象或者双层抽象)。
    - 最后，再理解下这句话，将对象组合成树形结构以表示‘部分-整体’的层次结构。
4. 装饰者(Decorator)
    > 动态地给一个对象添加一些额外的职责，就增加功能来说，装饰模式比生成子类更为灵活。
    - 【奶油蛋糕】66.0 加蜡烛5.0 加水果8.0 加餐具5.0	总价：84.0
    - 【水果蛋糕】66.0 加水果8.0 加餐具5.0	总价：79.0
5. 外观(Facade)
    > 为子系统中的一组接口提供一个一致的界面，此模式定义了一个高层接口，这个接口使得这一子系统更加容易使用。
    - 虚构场景：发短信功能，电信、移动、联通都有独立实现；
    - 现在，我想给一组手机号发短信，我也不知道具体要调用哪个运营商；
    - 这里为发短信提供一个一致的界面（高层接口），你把把手机号、短信内容给我，
      我的实现类里去判断运营商，实现发短信功能。
6. 享元(Flyweight)
    > 运用共享技术有效地支持大量细粒度的对象。
    - 拿网站模板复用为例，有两种，通用模板，私有模板，如果是通用模板，
      里边只是一些参数变化，整体没变，那就可以把参数抽象出来，其他内容复用。
    - 体现了一种共享理念，不重复造轮子。
    - 就像Integer的[-128, 127]，不管哪里用，都是同一个对象，一组单例的感觉。
7. 代理(Proxy)
    > 为其他对象提供一种代理以控制对这个对象的访问。
    - 静态代理[正向]：以送花为例（慎用），Boy想给Girl送花，Boy不好意思，给Proxy说，让Proxy把花给Girl；
    - 动态代理[正向]：不用给我真实的.class类，给我类的名字即可，通过动态代理即可访问该类，拓展性强；
    - 正向代理和反向代理区别：
        - 正向代理是客户端的代理，反向代理是服务端的代理；
        - 正向代理隐藏真实客户端，反向代理隐藏真实服务端。

### 3.3 行为型模式(11个)
1. 责任链(Chain)
    > 使多个对象都有机会处理请求，从而避免请求的发送者和接收者之间的耦合关系。将这个对象连成一条链，并沿着这条链传递该请求，直到有一个对象处理它为止。
    - 产品研发中心，来了个需求，实习生能解决，则实习生解决；实习生不能搞定，初级研发解决，初级不行则高级，高级不行（不，高级能行）。
2. 命令(Command)
    > 将一个请求封装为一个对象，从而使你可用不同的请求对客户进行参数化；对请求排队或记录请求日志，以及支持可撤销的操作。
    - 路边的烧烤摊，如果单纯靠烤串师傅的记忆，记住所有顾客要的烤串，是很难的；
    - 命令模式，抽象出了命令类、传入顾客信息。烤羊肉、烤牛肉实现命令类。
    - 顾客来了，服务员接待顾客，将顾客信息传给烤串师傅，并下达烤串命令，师傅烤好了主动通知顾客。
3. 解释器(Interpreter)
    > 给定一个语言，定义它的文法的一种表示，并定义一个解释器，这个解释器使用该标示来解释语言中的句子。
    - 以计算器为例，传给计算器一个表达式，解释器解析表达式，获取参数，进行计算。
4. 迭代器(Iterator)
    > 提供一种方法顺序访问一个聚合对象中各个元素，而又不暴露该对象的内部表示。
    - 用数组、指针实现一个字符串集合，可将字符串数组加入集合。
    - 实现一个迭代器，遍历集合中的内容，只要集合 hasNext 就可以继续遍历。
5. 中介者(Mediator)
    > 用一个中介对象来封装一系列对象交互。中介者使各对象不需要显式地相互引用，从而使其松耦合，而且可以独立地改变他们之间的交互。
    - 就拿伊朗和美国为例，他俩想整事，但不能直接交流（松耦合），联合国安理会作为中介者，进行双方对话传递。
6. 备忘录(Memo)
    > 在不破坏封装性的前提下，捕获一个对象的内部状态，并在该对象之外保存这个状态。这样以后就可将该对象恢复到原先保存的状态。
    - 游戏中购买道具，购买前先做一个备份，如果买错了，可以通过备份还原回去。
7. 观察者(Observer)
    > 定义了一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。这个主题对象在状态发生变化时，会通知所有观察者对象，使它们能够自动更新自己。
    - 类似订阅通知，订阅一个老板来了的通知，观察者发现老板来了，就通知订阅了该通知的同事。
8. 状态(State)
    > 当一个对象的内在状态改变时允许改变其行为，这个对象看起来像是改变了其类。
    - 创建一个工作提醒的抽象类，根据时间（可变状态），提醒不同的内容。
9. 策略(Strategy)
    > 它定义了算法家族，分别封装起来，让它们之间可以互相替换，此模式让算法的变化，不会影响到使用算法的客户。
    - 理解一下上边那句描述。
    - 排序有很多种方法，冒泡排序、选择排序、插入排序、快速排序等等；
    - 商品打折，有的产品是原价、有的是打折，还有的是满减。
10. 模板方法(Template Method)
    > 定义一个操作中的算法的骨架，而将一些步骤延迟到子类中。模板方法使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。
    - 应该是最简单的设计模式了，定义个抽象类，相当于模板了；子类各自实现即可。
11. 访问者(Visitor)
    > 表示一个作用于某对象结构中的各元素的操作。它使你可以在不改变各元素的类的前提下定义作用于这些元素的新操作。
    - 这个应该是最难的设计模式了，挖掘下应用场景，目测很好用。
    - 适合对象结构明确且有限的抽象。例如，男人、女人；黑、白；上、中、下。
    - 案例中，访问者里边抽象出男人、女人两个方法；实现类，分别实现两者面对成功时和恋爱时的想法。
    - 人的抽象里边，传入访问者；男人、女人两个实现类，分别调用访问者里边的男人、女人方法。
    - 最后，维护一个[人的集合]，给集合里传入不同的访问者（成功时和恋爱时），打印出不同的想法。
    - 网上看到一个案例，顺便实现了，有两种人，研发人员和产品经理；
        - CEO 关注【研发人员】的KPI
        - CEO 关注【产品经理】的KPI和参与的产品数量
        - CTO 关注【研发人员】的代码量
        - CTO 关注【产品经理】的参与的产品数量
    - 说下我的理解：
        - 访问者抽象类里定义了被访问者的抽象，访问者可以独立实现，去看自己关注的东西；
        - 被访问者，要把自己暴露出去，供访问者查看；

## 四、抽象和接口基础

### 4.1 抽象
- 使用抽象类核心问题：抽象类不能实例化
- 主要用作过渡操作，降低代码重复
    ```text
    抽象类主要用作过渡操作，所以使用抽象类进行开发的时候，
    往往都是设计中需要解决类继承问题时带来的代码重复处理。
    ```
- 抽象类不能用final定义
- 抽象类中可以提供构造方法，并且其子类构造必须调用父类构造
- 抽象类可以没抽象方法，其仍不能实例化
- 抽象类中的static方法不受到abstract限制

### 4.2 抽象接口区别
- 在JAVA 1.8出现之后，抽象和接口区别更小了，接口中可以定义default方法和static方法。

| No. | 区别 | 抽象 | 接口 |
| :---: | :--- | :--- | :--- | 
| 1 | 定义 | abstract class ClassName {} | interface ClassName {} |
| 2 | 组成 | 全局常量、抽象方法、普通方法、静态方法、构造、成员变量 | 全局常量、抽象方法、普通方法、静态方法 |
| 3 | 权限 | 各种权限均可 | public |
| 4 | 子类使用 | extends | implements |
| 5 | 两者关系 | 可以实现多个接口 | 可以继承多个接口，但不允许继承抽象类 |
| 6 | 使用 | <br> 共同特征：<br> 1、必须定义子类，不可直接使用 <br> 2、一定要覆写抽象类或接口类中所有的抽象方法 <br> 3、支持向上转型 |