---
title: Spring 源码——循环依赖
date: 2020-04-14
categories: 框架相关
tags:
- spring
---

# Spring 源码——循环依赖
> Spring 源码学习，一方面提升读源码能力、向大师学习；一方面便于更深入地使用、拓展 Spring。

- 本人呢，还是喜欢把学的记录下来，写的过程，也是加深理解的过程。毕竟你可能只是感觉会了。
- 编译了 Spring 源码，学着就更方便了
    - [spring-framework-5.1 源码学习记录](https://gitee.com/AmosWang/spring-framework/tree/amos-5.1.x/)

## 循环依赖是什么？为什么学循环依赖的源码？
> 循环依赖很常见，众多的业务场景，两块业务相互依赖也是很常见的。
> 如果 Spring 不支持循环依赖，那出现循环依赖场景时，项目就无法启动了——依赖注入死循环。
>（当然，单例情况下，Spring默认是支持循环依赖的，你也可以通过其他方式关闭循环依赖）

- 假设有 A、B、C 三个类，他们之间项目依赖
    - A 依赖 B 和 C
    - B 依赖 A 和 C
    - C 依赖 A 和 B

- 此时你觉得它们的初始化完成顺序是什么样的呢？

- 源码见附录

## 怎么学习呢？当然是看本文了 ^_^
> 路神视频与博客如下
- [B站——2020年最新spring源码解析](https://www.bilibili.com/video/BV1VJ41167Ec)
- [CSDN——子路老师博客](https://me.csdn.net/java_lyvee)

## 简述循环依赖过程
1. `.java` 编译成 `.class` 文件
2. Spring 容器实例化
3. 扫描符合规则的类（比如添加了@Controller、@Service等等注解的类、@Bean注解的方法）
4. 解析这些类（比如拿到这些类的@Scope、@Lazy等等）
5. 拿到了这些解析的信息放哪呢？BeanDefinition（下边简称BD）闪亮登场，实例化BD，写入解析的信息
6. 将BD信息放入Map中缓存起来，Map<beanName, BeanDefinition>
7. 调用bean工厂后置处理器
8. 验证BD，如果是Lazy、ProtoType、Abstract的，就不用执行下边的了。
9. 重点来了，Bean的生命周期 ↓↓↓↓↓↓


## 附录

- `A.java` 如下（`B.java`、`C.java`类似）
```java
@Component
public class A {

	@Resource
	private B b;
	@Resource
	private C c;

	public A() {
		System.out.println("init " + getClass().getName());
	}

	@PostConstruct
	public void callback() {
		System.out.println("\t" + getClass().getSimpleName() + " Init Finish!");
	}

}
```

- 启动类 `SecondApplication.java`
```java
@ComponentScan("com.amos.cr.second")
public class SecondApplication {

	public static void main(String[] args) {
		AnnotationConfigApplicationContext context =
				new AnnotationConfigApplicationContext(SecondApplication.class);
		System.out.println("Spring Bean 默认初始化完成");
	}

}
```

- 运行结果
```text
init com.amos.cr.second.service.A
init com.amos.cr.second.service.B
init com.amos.cr.second.service.C
	C Init Finish!
	B Init Finish!
	A Init Finish!
Spring Bean 默认初始化完成
```