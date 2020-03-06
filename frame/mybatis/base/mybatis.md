---
title: 框架相关 mybatis
date: 2019-01-01
categories: 框架相关
tags:
- mybatis
---

# MyBatis （2017.5.16）

> MyBatis 主要是处理数据的持久化操作的一个轻量级框架，相对于Hibernate而言。

----------
## 实现数据持久化操作主要有两点：

    1. 底层配置文件
    
    2. *Mapper.xml
    
    3. Dao层接口 ***Dao.java
    
    4. Util类 DBAccess.java 向外部输出SQLSession
    
    5. 控制层

----------

## MyBatis 关键字
```
"," "=" "?" "||" "or" "&&" "and" "|" "bor" "^" "xor" "&" "band"
"==" "eq" "!=" "neq" "<" "lt"">" "gt" "<=" "lte" ">=" "gte" "in"
"not" "<<" "shl" ">>" "shr" ">>>" "ushr" "+" "-" "*" "/" "%" "."
"(""instanceof"  "[" "]" <![CDATA[ <= ]]>
```

## 1. 底层配置文件 Configuration.xml

```
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
    PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>

	<typeAliases>
		<typeAlias alias="product" type="com.amos.pojo.Product" />
	</typeAliases>

	<environments default="development">
		<environment id="development">
			<transactionManager type="JDBC">
				<property name="" value="" />
			</transactionManager>
			<dataSource type="UNPOOLED">
				<property name="driver" value="com.mysql.jdbc.Driver" />
				<property name="url"
					value="jdbc:mysql://127.0.0.1:3306/my_ssm?useUnicode=true&amp;characterEncoding=UTF-8" />
				<property name="username" value="root" />
				<property name="password" value="root" />
			</dataSource>
		</environment>
	</environments>

	<mappers>
		<mapper resource="com/amos/resources/ProductMapper.xml" />
	</mappers>

</configuration>
```


简介：

<`typeAliases`> 为sql映射文件中的类型指定别名，在下边的mapper中能用到

<`plugins`> 插件

<`environments`> 连接数据库的一些配置

<`mappers`> 也就是下边要说的，所有的mapper都要在这里注册

----------


## 2. *Mapper.xml --> ProductMapper.xml

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
    "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.amos.dao.ProductDao">

	<resultMap type="product" id="ProductResult">
		<id column="ID" jdbcType="INTEGER" property="id" />
		<result column="NAME" jdbcType="VARCHAR" property="name" />
		<result column="DESCRIPTION" jdbcType="VARCHAR" property="description" />
		<result column="PRICE" jdbcType="VARCHAR" property="price" />
	</resultMap>

	<insert id="addOne" parameterType="product">
		INSERT INTO PRODUCT
		(NAME,DESCRIPTION,PRICE)
		VALUES(#{name},#{description},#{price})
	</insert>

	<insert id="addBatch" parameterType="java.util.List">
		INSERT INTO PRODUCT (NAME,DESCRIPTION,PRICE) VALUES
		<foreach collection="list" item="product" separator=",">
			(#{product.name},#{product.description},
			#{product.price})
		</foreach>
	</insert>

	<delete id="deleteOne" parameterType="int">
		DELETE FROM
		PRODUCT WHERE
		ID=#{_parameter}
	</delete>

	<delete id="deleteBatch" parameterType="java.util.List">
		DELETE FROM PRODUCT WHERE ID IN(
		<foreach collection="list" item="item" separator=",">
			#{item}
		</foreach>
		)
	</delete>

	<update id="updateProductById" parameterType="product">
		UPDATE PRODUCT
		<set>
			<if test="name!=null and !&quot;&quot;.equals(name.trim())">
				NAME=#{name},
			</if>
			<if test="description!=null and !&quot;&quot;.equals(description.trim())">
				DESCRIPTION=#{description},
			</if>
			<if test="price!=null and !&quot;&quot;.equals(price.trim())">
				PRICE=#{price},
			</if>
		</set>
		WHERE ID=#{id}
	</update>

	<select id="getProductCount" resultType="int">
		SELECT count(*) FROM
		PRODUCT order by ID
	</select>

	<select id="getProductById" parameterType="int" resultType="product">
		SELECT
		ID,NAME,DESCRIPTION,PRICE FROM PRODUCT
		<where>ID=#{id}</where>
	</select>

	<select id="getProductAll" resultMap="ProductResult">
		SELECT
		ID,NAME,DESCRIPTION,PRICE FROM PRODUCT
	</select>

</mapper>
```

注意resultMap与resultType，当是多条数据的时候用前者;

有参时用parameterType;

<`resultMap`> 这个是避免数据库表中字段与实体类字段不一样

<`result` column="COMMAND" jdbcType="VARCHAR" property="command" />
每一个result对应一个实体的属性，也对应这数据库表中的一个属性

增删改查操作
    <`insert`>增加，批量增加，或者单条
    <`select`>查询，查询全部，或者单条
    <`update`>更新，单条更新
    <`delete`>删除，批量删除，或者单条
    <`where`> 省略了where关键字，会自动删除多余的and
    <`set`> 省略set关键字，会自动删除多余的","
    <`if` test=""> 这个里边写法类似于java中的写法
        command!=null and !"";.equals(command.trim())
    <`foreach` collection="list" item="product" separator=",">
    
	collection：对应传递过来的参数list
	item：对应list中的每一个单项，起的一个别名
	separator：批量增加或者删除是增补","

----------
## 3.获取数据库连接 DBAccess.java
```
// 使用MyBatis时获取数据库连接
public class DBAccess {

	public static SqlSession getSqlSession() {

		SqlSession sqlSession = null;

		try {
			Reader reader = Resources.getResourceAsReader("com/amos/resources/Configuration.xml");
			SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(reader);

			// 通过SqlSessionFactory打开一个SqlSession
			sqlSession = sqlSessionFactory.openSession();
		} catch (IOException e) {
			System.out.println("创建SqlSession失败!");
			e.printStackTrace();
		}

		return sqlSession;
	}

}
```
# log4j 打印日志（2017.5.20）

******************************
```
一、注意root，所有的日志
    log4j.rootLogger=DEBUG, stdout

二、输出日志样式
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout

三、输出日志自定义样式
    log4j.appender.stdout.layout.ConversionPattern=%d [%t] %-5p....... 

四、DEBUG INFO WARN ERROR
    等级依次增高，越来越严格

五、%d [%t] %-5p [%c] - %m%n
   %d{HH:mm:ss} %-5p [%F\:%L] -- %m%n

六、特殊包个性化日志（root范围太广，所以下边也就是自定义样式不影响原生自带样式）
log4j.logger.org.apache=INFO

七、Log4J采用类似C语言中的printf函数的打印格式格式化日志信息，打印参数如下：
    # [] - 这些符号会原样输出
    # %m 输出代码中指定的消息，也就是输出自定义的信息
    # %p 输出优先级，即DEBUG,INFO,WARN,ERROR,FATAL 
    # %r 输出自应用启动到输出该log信息耗费的毫秒数 
    # %c 输出所属的类目,通常就是所在类的全名 
    # %t 输出产生该日志事件的线程名 
    # %n 输出一个回车换行符，Windows平台为“\r\n”，Unix平台为“\n” 
    # %d 输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式 
    #    如：%d{yyyy年MM月dd日 HH:mm:ss,SSS}，输出类似：2012年01月05日 22:10:28,921 
    # %l 输出日志事件的发生位置，包括类目名、发生的线程，以及在代码中的行数 
    #    如：Testlog.main(TestLog.java:10) 
    # %F 输出日志消息产生时所在的文件名称 
    # %L 输出代码中的行号 
    # %x 输出和当前线程相关联的NDC(嵌套诊断环境),像java servlets多客户多线程的应用中 
    # %% 输出一个"%"字符 
    # 
    # 可以在%与模式字符之间加上修饰符来控制其最小宽度、最大宽度、和文本的对齐方式。如： 
    #  %5p: 输出category名称，最小宽度是5，category<5，默认的情况下右对齐,左边会有空格
    #  %-5p:输出category名称，最小宽度是5，category<5，"-"号指定左对齐,右边会有空格 
    #  %.5p:输出category名称，最大宽度是5，category>5，就会将左边多出的字符截掉，<5不会有空格 
    #  %20.30p:category名称<20补空格，并且右对齐，>30字符，就从左边交远销出的字符截掉 

八、简单输出：

    # Global logging configuration
    log4j.rootLogger=DEBUG,out
    
    # Console output...
    log4j.appender.out=org.apache.log4j.ConsoleAppender
    log4j.appender.out.layout=org.apache.log4j.PatternLayout
    log4j.appender.out.layout.ConversionPattern=%d{HH:mm:ss} %-5p [%F\:%L] -- %m%n
    log4j.logger.org.apache=INFO

```
