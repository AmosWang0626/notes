---
title: 框架相关 spring
date: 2019-01-01
categories: 框架相关
tags:
- spring
---


## 1、IOC和DI
> IOC是一个宽泛的概念，IOC包括依赖查找和依赖注入。
　　依赖查找：JDNL，就是配置文件
　　依赖注入：DI

　　首先想说说IoC（Inversion of Control，控制反转），这是spring的核心，贯穿始终。    控制的什么被反转了？就是：获得依赖对象的方式反转了。

　　所谓IoC，对于spring框架来说，就是由spring来负责控制对象的生命周期和对象间的关系。这是什么意思呢，举个简单的例子，我们如何找工作呢？我们通常会去找中介，中介那里有很多工作资源，我们告诉中介要找的工作的类型等等细节，中介会想办法给我们找到。这个过程是复杂深奥的，我们必须自己设计和面对每个环节。传统的程序开发也是如此，在一个对象中，如果要使用另外的对象，就必须得到它（自己new一个，或者从JNDI中查询一个），使用完之后还要将对象销毁（比如Connection等），对象始终会和其他的接口或类藕合起来。

　　那么IoC是如何做的呢？有点像通过婚介找女朋友，在我和女朋友之间引入了一个第三者：婚姻介绍所。婚介管理了很多男男女女的资料，我可以向婚介提出一个列表，告诉它我想找个什么样的女朋友，长相、身高、胖瘦之类的，然后婚介就会按照我们的要求，提供一个MM，我们只需要去和她谈恋爱、结婚就行了。简单明了，如果婚介给我们的人选不符合要求，我们就会抛出异常。整个过程不再由我自己控制，而是有婚介这样一个类似容器的机构来控制。Spring所倡导的开发方式就是如此，所有的类都会在spring容器中登记，告诉spring你是个什么东西，你需要什么东西，然后spring会在系统运行到适当的时候，把你要的东西主动给你，同时也把你交给其他需要你的东西。所有的类的创建、销毁都由spring来控制，也就是说控制对象生存周期的不再是引用它的对象，而是spring。对于某个具体的对象而言，以前是它控制其他对象，现在是所有对象都被spring控制，所以这叫控制反转。

　　IoC的一个重点是在系统运行中，动态的向某个对象提供它所需要的其他对象。这一点是通过DI（Dependency Injection，依赖注入）来实现的。比如对象A需要操作数据库，以前我们总是要在A中自己编写代码来获得一个Connection对象，有了spring我们就只需要告诉spring，A中需要一个Connection，至于这个Connection怎么构造，何时构造，A不需要知道。在系统运行时，spring会在适当的时候制造一个Connection，然后像打针一样，注射到A当中，这样就完成了对各个对象之间关系的控制。A需要依赖Connection才能正常运行，而这个Connection是由spring注入到A中的，依赖注入的名字就这么来的。那么DI是如何实现的呢？

　　Java1.3之后一个重要特征是反射（reflection），它允许程序在运行的时候动态的生成对象、执行对象的方法、改变对象的属性，spring就是通过反射来实现注入的。关于反射的相关资料请查阅java doc。

----------


## 2.导入相关的jar包，Spring各jar包详解
> 除了spring.jar 文件，Spring 还包括有其它21 个独立的jar 包，各自包含着对应的Spring组件，用户可以根据自己的需要来选择组合自己的jar包，而不必引入整个spring.jar的所有类文件。

### 1.spring-aop
这个jar文件包含在应用中使用Spring 的AOP特性时所需的类和源码级元数据支持。
使用基于AOP 的Spring特性，如声明型事务管理（Declarative Transaction Management），也要在应用里包含这个jar包。
外部依赖spring-core， (spring-beans，AOP Alliance， CGLIB，Commons Attributes)。
 
关于org.springframework.asm,Spring独立的asm程序, Spring2.5.6的时候需要asmJar包，3.0开始提供他自己独立的asmJar。

### 2.spring-aspects.jar
提供对AspectJ的支持，以便可以方便的将面向方面的功能集成进IDE中，比如Eclipse AJDT。
外部依赖。

### 3.spring-beans.jar
这个jar 文件是所有应用都要用到的，它包含访问配置文件、创建和管理bean 以及进行Inversion ofControl / Dependency Injection（IoC/DI）操作相关的所有类。如果应用只需基本的IoC/DI 支持，引入spring-core.jar 及spring-beans.jar 文件就可以了。
外部依赖spring-core，(CGLIB)。
 
### 4.spring-context.jar
这个jar 文件为Spring 核心提供了大量扩展。可以找到使用Spring ApplicationContext特性时所需的全部类，JDNI 所需的全部类，instrumentation组件以及校验Validation 方面的相关类。
外部依赖spring-beans, (spring-aop)。
 
### 5.spring-context-support.jar
包含支持缓存Cache（ehcache）、JCA、JMX、 邮件服务（Java Mail、COS Mail）、任务计划Scheduling（Timer、Quartz）方面的类。
以前的版本中应该是这个：spring-support.jar这个jar 文件包含支持UI模版（Velocity，FreeMarker，JasperReports），邮件服务，脚本服务(JRuby)，缓存Cache（EHCache），任务计划Scheduling（uartz）方面的类。
外部依赖spring-context, (spring-jdbc, Velocity,FreeMarker, JasperReports, BSH, Groovy,JRuby, Quartz, EHCache)
 
### 6.spring-core.jar
这个jar 文件包含Spring 框架基本的核心工具类。Spring 其它组件要都要使用到这个包里的类，是其它组件的基本核心，当然你也可以在自己的应用系统中使用这些工具类。
外部依赖Commons Logging，(Log4J)。
 
### 7.spring-expression  
Spring表达式语言。
 
### 8.spring-instrument 
Spring3.0对服务器的代理接口。
 
### 9. spring-instrument-tomcat 
Spring3.0对Tomcat的连接池的集成。
 
### 10.spring-jdbc.jar
这个jar 文件包含对Spring 对JDBC 数据访问进行封装的所有类。
外部依赖spring-beans，spring-dao。
 
### 11.spring-jms.jar
这个jar包提供了对JMS 1.0.2/1.1的支持类。
外部依赖spring-beans，spring-dao，JMS API。

此外，还有下面这些没用过的，以spring-j*开头的包：
    spring-jmx.jar
        这个jar包提供了对JMX 1.0/1.2的支持类。外部依赖spring-beans，spring-aop， JMX API。
    spring-jca.jar
        对JCA 1.0的支持。外部依赖spring-beans，spring-dao， JCA API。
    spring-jdo.jar
        对JDO 1.0/2.0的支持。外部依赖spring-jdbc， JDO API， (spring-web)。
    spring-jpa.jar
        对JPA 1.0的支持。外部依赖spring-jdbc， JPA API， (spring-web)。
 
### 12.spring-messaging
 spring-messaging模块为集成messaging api和消息协议提供支持
参考 http://www.cnblogs.com/davidwang456/p/4446796.html

### 13. spring-orm 
包含Spring对DAO特性集进行了扩展，使其支持iBATIS、JDO、OJB、TopLink，  因为hibernate已经独立成包了，现在不包含在这个包里了。这个jar文件里大部分的类都要依赖spring-dao.jar里的类，用这个包时你需要同时包含spring-dao.jar包。
 
### 14. spring-oxm  
Spring 对Object/XMl的映射支持,可以让Java与XML之间来回切换。
 
### 15.spring-test
对Junit等测试框架的简单封装。
 
### 16.spring-tx
以前是在这里org.springframework.transaction
为JDBC、Hibernate、JDO、JPA、Beans等提供的一致的声明式和编程式事务管理支持。
 
### 17.spring-web.jar
这个jar 文件包含Web 应用开发时，用到Spring 框架时所需的核心类，包括自动载入Web ApplicationContext 特性的类、Struts 与JSF 集成类、文件上传的支持类、Filter 类和大量工具辅助类。
外部依赖spring-context, Servlet API, (JSP API, JSTL,Commons FileUpload, COS)。

org.springframework.web.portlet  
SpringMVC的增强。
org.springframework.web.servlet  
对J2EE6.0的Servlet3.0的支持。
org.springframework.web.struts 
Struts框架支持，可以更方便更容易的集成Struts框架。
 
### 18.spring-webmvc.jar
这个jar 文件包含Spring MVC 框架相关的所有类。包括框架的Servlets，Web MVC框架，控制器和视图支持。当然，如果你的应用使用了独立的MVC框架，则无需这个JAR 文件里的任何类。外部依赖spring-web, (spring-support，Tiles，iText，POI)。

3.SpringMVC

要想创建一个SpringMVC项目，首先需要导入spring-webmvc.jar,它里边包含要在web.xml使用的DispatcherServlet的类。还要注意SpringMVC依赖的Apache Commons Logging组件，也就是commons-logging.jar,通常是所有jar的第一个（名字原因，哈哈）。

## 构造器注入
```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans  
           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd">

	<bean id="user" class="pojo.User">

		<!-- 构造器注入 -->
		<constructor-arg name="id" value="1" />
		<constructor-arg name="name" value="杜杜" />
		<constructor-arg name="age" value="17" />
		<constructor-arg name="gender" value="女" />
		<constructor-arg name="address" ref="SimpleAddress" />

	</bean>

	<bean id="SimpleAddress" class="pojo.Address">

		<!-- 构造器注入 -->
		<constructor-arg name="city" value="邓州·河南" />
		<constructor-arg name="lines" value="新华中路" />
		<constructor-arg name="zipCode" value="474171" />

	</bean>

</beans>
```
## get set方法注入

```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans  
           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd">

	<bean id="user" class="pojo.User">

		<!-- 配置依赖关系 控制反转 get/set方法注入 -->
		<property name="id" value="1" />
		<property name="name" value="杜杜" />
		<property name="age" value="17" />
		<property name="gender" value="女" />
		<property name="address" ref="SimpleAddress" />

	</bean>

	<bean id="SimpleAddress" class="pojo.Address">

		<!-- 配置依赖关系 控制反转 get/set方法注入 -->
		<property name="city" value="郑州·河南" />
		<property name="lines" value="中原西路" />
		<property name="zipCode" value="450000" />

	</bean>

</beans>
```

##  Bean 的装配以及生命周期

    <!-- scope(单例singleton/非单例prototype) -->
    <bean id="user" class="com.amos.entity.User" scope="singleton" />

	
三种方式：

1.初始化操作，该方式中的init/destroy对应class中的两个方法名字

	<bean id="user" class="com.amos.entity.User" init-method="init" destroy-method="destroy" />
	
2.对所有的bean有效
```
<beans xmlns="http://www.springframework.org/schema/beans"xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.3.xsd"
default-init-method="init"
default-destroy-method="destory">
   
    <!-- 上边那行你懂得 -->
   
</beans>
```

3.通过实现接口方法初始化以及销毁类
```
	public class User implements InitializingBean,DisposableBean{
		@Override
		public void destroy() throws Exception {
			// TODO Auto-generated method stub
		}

		@Override
		public void afterPropertiesSet() throws Exception {
			// TODO Auto-generated method stub
		}
	}
```
1、三种方式优先级：接口 > bean配置 > 默认全局（如果有前两种之一，默认全局也不会生效）

2、如果三种方式都使用了，则顺序是实现的接口，然后是bean里边的配置，全局的初始化未生效

3、如果beans里边的默认全局配置配置过了，但是在bean里边没有默认全局配置的方法，也不会报错

4、但是如果bean里边的配置了，class里边没有实现，则报错

- 1、这个没有关闭的方法
```
public class SpringUtil {

	// 简单单例模式
	private static ApplicationContext context = new ClassPathXmlApplicationContext("com/amos/resource/spring-ioc.xml");

	@SuppressWarnings("unchecked")
	public static <T extends Object> T getBean(String beanId) {

		return (T) context.getBean(beanId);
	}

	public static <T extends Object> T getBean(Class<T> clazz) {

		return context.getBean(clazz);
	}

}
```

- 2、这个有关闭的方法
```
public class SpringUtil {

	// 简单单例模式
	private static AbstractApplicationContext context;

	static {
		context = new ClassPathXmlApplicationContext("com/amos/resource/spring-config.xml");
		context.start();
	}

	// 得到上下文信息
	public static ApplicationContext getContext() {

		return context;
	}

	// 根据bean的id得到bean实例
	@SuppressWarnings("unchecked")
	public static <T extends Object> T getBean(String beanId) {

		return (T) context.getBean(beanId);
	}

	// 根据bean的class得到bean实例
	public static <T extends Object> T getBean(Class<T> clazz) {

		return context.getBean(clazz);
	}

	public static void close() {
		context.destroy();
	}

}
```


# Aware

- ApplicationContextAware
- BeanNameAware

Spring 中提供了一些以Aware结尾的接口，
实现Aware接口的bean在被初始化之后，可以获得相应的资源，
通过Aware接口，可以对Spring中相应的一些资源进行操作。
（切记是bean初始化的时候就加载）

1. 配置信息

<bean id="testAware" class="com.amos.test.TestAware" />

2. TestAware类
```
public class TestAware implements ApplicationContextAware, BeanNameAware {

	private String beanName;

	// 先获得bean的名字
	@Override
	public void setBeanName(String name) {

		this.beanName = name;

		System.out.println("TestAware--setBeanName:" + name);
	}

	// 通过名字获得bean,进而获得hashCode
	@Override
	public void setApplicationContext(ApplicationContext context) throws BeansException {

		int code = context.getBean(beanName).hashCode();

		System.out.println("TestAware--setApplicationContext:" + code);
	}

}
```
3. test方法
```
	public static void testBeanNameAware() {
		// 引入并加载配置文件
		int code = SpringUtil.getBean("testAware").hashCode();

		System.out.println("TestMain--getBean:" + code);
	}
```	

自动装配
```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://www.springframework.org/schema/beans  
           http://www.springframework.org/schema/beans/spring-beans-4.3.xsd"
	default-autowire="byType">

	<bean id="userServiceImpl" class="com.amos.service.UserServiceImpl" />

	<bean id="userDaoImpl" class="com.amos.dao.UserDaoImpl" />

</beans>

public class UserServiceImpl implements UserService {

	private UserDaoImpl userDaoImpl;

	public void setUserDaoImpl(UserDaoImpl userDaoImpl) {
		this.userDaoImpl = userDaoImpl;
	}

	@Override
	public void addUser(User user) {
		userDaoImpl.saveUser(user);
	}

}
```

常用的有三种装配方式，一种是byName，一种是byType，最后一种是。

两者都需要实现setUserDaoImpl(UserDaoImpl userDaoImpl){}方法

default-autowire="byName"

它主要是根据名字，也就是根据其中的userDaoImpl，两者匹配才可以
<bean id="userDaoImpl" class="com.amos.dao.UserDaoImpl" />
private UserDaoImpl userDaoImpl;


default-autowire="byType"

它则主要是根据class类型，与id无关，即使删掉也可以
<bean class="com.amos.dao.UserDaoImpl" />

default-autowire="constructor"

	// 有参构造方法
	public UserServiceImpl(UserDaoImpl userDaoImpl) {
		System.out.println("有参构造UserServiceImpl()");
		this.userDaoImpl = userDaoImpl;
	}
它也是主要是根据class类型，与id无关，即使删掉也可以
<bean class="com.amos.dao.UserDaoImpl" />


资源目录

    Resources：针对资源文件的统一接口
    
    ResourcesLoder：Application中自带的获取资源方式
    
    常见的如下四种方式：
    
    classpath:***.xml		项目中配置的路径
    
    file:D:\***.xml			相对于电脑的路径
    
    url:http:\amos.com\spring\***.xml		网上的路径
    
    ***.xml		相对于ApplicationContext配置后的路径


# 注解方式

几个比较有针对性的注解

@Repository		通常用于注解Dao类，即持久层

@Service			通常用于注解Service类，即服务层

@Controller		通常用于注解Controller类，即控制层(MVC)

<context:annotation-config> 和 <context:component-scan>的区别

<context:annotation-config> 是用于激活那些已经在spring容器里注册过的bean。

<context:component-scan>除了具有<context:annotation-config>的功能之外,<context:component-scan>还可以在指定的package下扫描以及注册bean.

<context:component-scan>,还具有自动将带有@component,@service,@Repository等注解的对象注册到spring容器中的功能。

当<context:annotation-config />和 <context:component-scan>同时存在的时候,前者会被忽略。

@Required注解适用于bean属性的setter方法（不常用）
这个注解仅仅表示，受影响的bean属性必须在配置时被填充，通过在bean定义或通过自动装配一个明确的属性值

@Autowired可以通过“传统”的setter方法，也可以用于成员变量或构造器（常用）
默认情况下，如果找不到合适的bean就会抛出异常，当然可以通过下边的方式避免

@Autowired(required=false)
但是，每个类中只能有一个构造器被标记为required=true
此时，@Autowired的必要属性，建议使用@Required注解

对于@Autowired还有自动装配到相应的List<BeanInter>,或者Map<String,BeanInter>.
此时，还可以进行Order排序,这个只对List<BeanInter>有效

Map遍历

for (Map.Entry<String, BeanInter> entry : map.entrySet()) {
		System.out.println(entry.getKey() + "   " + entry.getValue().getClass().getName());
}

    Map.Entry<K,V> 是map集合中的一个Map实体，包括key,value;
    map.entrySer() 的返回值是map的集合。
    map.keySet() 返回的是所有的key集合
    
    Object get(Object key): 获得与关键字key相关的值，并且返回与关键字key相关的对象，
    如果没有在该映像中找到该关键字，则返回null;
    boolean containsKey(Object key): 判断映像中是否存在关键字key;
    boolean containsValue(Object value): 判断映像中是否存在值value;
    int size(): 返回当前映像中映射的数量;
    boolean isEmpty(); 如果Map集合对象不包含任何内容，则返回true，否则返回false;

@Autowired
@Qualifier("beanOne") // 缩小bean查找范围
private BeanInter beanInter;

if (beanInter != null) {
	System.out.println("测试@Qualifier('beanOne'):" + beanInter.getClass().getName());
} else {
	System.out.println("BeanInter beanInter is null!");
}

@Qualifier("beanOne")
当指定的bean范围比较广,对应的有多个实例的时候,
这时就通过@Qualifier来缩小范围,指定更精确的bean。

Spring 加载.properties配置文件

项目的目录结构

AOP

<beans>

	<!-- Spring AOP 中的标签必须按照顺序 -->
	<!-- <aop:config> 可以包含pointcut,advisor,aspect -->

	<bean id="entry" class="com.amos.main.Entry" />

	<bean id="entryService" class="com.amos.main.EntryService" />

	<!-- ..代表当前包下所有的||...代表当钱包下以及子包下所有的 -->
	<aop:config>

		<aop:pointcut expression="execution(* com.amos.main.*Service.*(..))"
			id="entryPointcut" />

		<aop:aspect id="entryAOP" ref="entry">

			<aop:before method="before" pointcut-ref="entryPointcut" />

		</aop:aspect>

	</aop:config>

</beans>


# AOP核心概念

## 1、横切关注点

对哪些方法进行拦截，拦截后怎么处理，这些关注点称之为横切关注点

## 2、切面（aspect）

类是对物体特征的抽象，切面就是对横切关注点的抽象

## 3、连接点（joinpoint）

被拦截到的点，因为Spring只支持方法类型的连接点，所以在Spring中连接点指的就是被拦截到的方法，实际上连接点还可以是字段或者构造器

## 4、切入点（pointcut）

对连接点进行拦截的定义

一组基于正则表达式的表达式,它会选取程序中有我们关注的程序执行点,或者执行点的集合。

## 5、通知（advice）

所谓通知指的就是指拦截到连接点之后要执行的代码，通知分为前置、后置、异常、最终、环绕通知五类

## 6、目标对象

代理的目标对象

## 7、织入（weave）

将切面应用到目标对象并导致代理对象创建的过程

## 8、引入（introduction）

在不修改代码的前提下，引入可以在运行期为类动态地添加一些方法或字段


注意一下，在讲解之前，说明一点：使用Spring AOP，要成功运行起代码，只用Spring提供给开发者的jar包是不够的，请额外上网下载两个jar包：
    1、aopalliance.jar
    2、aspectjweaver.jar






