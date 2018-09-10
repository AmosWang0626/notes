# Maven 学习笔记（2017.6.21）

----------
## 修复 Eclipse 可能出现的报错
    Eclipse Java JRE 配置[缺省值 VM]

    -Dmaven.multiModuleProjectDirectory=$M2_HOME

----------
## Maven 目录结构
    src
        main
            java
            resources
        test
            java
            resources

----------
## Maven 常用命令解析
- mvn -v **查看maven版本**
- mvn compile **编译**
- mvn test **测试**
- mvn package **打包**
- mvn clean **删除target**
- mvn install **安装到本地代码仓库**
- mvn deploy **上传到私有服务器代码仓库**

----------

## Maven 使用archetype创建项目：

### 1.archetype:generate
	命令：	mvn archetype:generate
    		………………
    		Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): 981:【此处回车】
    		Choose org.apache.maven.archetypes:maven-archetype-quickstart version:
    		1: 1.0-alpha-1
    		2: 1.0-alpha-2
    		3: 1.0-alpha-3
    		4: 1.0-alpha-4
    		5: 1.0
    		6: 1.1
    		Choose a number: 6: 【此处输入6】
    		………………
    		Define value for property 'groupId': 【此处输入com.amos.maven01】
    		Define value for property 'artifactId': 【此处输入maven01-service】
    		Define value for property 'version' 1.0-SNAPSHOT: : 【此处输入1.0.00SNAPSHOT】
    		Define value for property 'package' com.amos.maven01: : 【此处输入com.amos.mavendemo01】
    		Confirm properties configuration:
    		groupId: com.amos.maven01
    		artifactId: maven01-service
    		version: 1.0.0
    		package: com.amos.mavendemo01
    		 Y: : 【此处输入y】
### 2. archetype:generate 拼接参数
    	-DgroupId=组织名(公司网址的反写+项目名)
    	-DartifactId=项目名-模块名
    	-Dversion=版本号
    	-Dpackage=代码所存放的包名
    
    命令：
         mvn archetype:generate	-DgroupId=com.amos.maven -DartifactId=maven-service -Dversion=1.0.0SNAPSHOT -Dpackage=com.amos.service
    
    	………………
    	Choose a number or apply filter (format: [groupId:]artifactId, case sensitive contains): 981:【此处回车】
    	Choose org.apache.maven.archetypes:maven-archetype-quickstart version:
    	1: 1.0-alpha-1
    	2: 1.0-alpha-2
    	3: 1.0-alpha-3
    	4: 1.0-alpha-4
    	5: 1.0
    	6: 1.1
    	Choose a number: 6: 【此处输入6】
    	[INFO] Using property: groupId = com.amos.maven
    	[INFO] Using property: artifactId = maven-service
    	[INFO] Using property: version = 1.0.0SNAPSHOT
    	[INFO] Using property: package = com.amos.service
    	Confirm properties configuration:
    	groupId: com.amos.maven
    	artifactId: maven-service
    	version: 1.0.0SNAPSHOT
    	package: com.amos.service
    	 Y: : 【此处输入y】

----------
## Maven 命令详解

 1. mvn compile

    【命令执行完毕后创建一个target文件，并且把Java文件编译成class文件，
   
    注意：compile不是complier，也不是complie】

 2. mvn package

    【对项目进行打包，执行完毕后， 会在target文件夹下面生成jar包：***.jar】

 3. java -cp target/maven-service-1.0.0.jar com.amos.service.App

    【此时一般是测试的，不出错的话会输出hello world!注意：jar包一定要带上.jar】
    
    integration-test 处理package以便需要时可以部署到集成测试环境；
    
    verify 
    检验package是否有效并且达到质量标准；
    
    install
    安装package到本地仓库，方便本地其它项目使用；
    
    deploy 部署，拷贝最终的package到远程仓库和替他开发这或项目共享，在集成或发布环境完成。

----------
## 总结 · Maven 命令创建项目五步走：
    
1. mvn archetype:generate -DgroupId=com.amos.maven -DartifactId=eBeyDemo -Dversion=1.0.0SNAPSHOT -Dpackage=com.amos.ebuy
    
2. mvn compile
    
3. mvn test
    
4. mvn package
    
5. java -cp target/eBeyDemo-1.0.0SNAPSHOT.jar  com.amos.ebuy.App

----------
## 详解 Maven 核心文件：pom.xml

> pom：Project Object Model (项目对象模型)

    示例：
    <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
      【POM 的版本号，现在都是 4.0.0 的，必须得有，但不需要修改】

      <modelVersion>4.0.0</modelVersion>

      【以下三个合起来就是该 Maven 构件的坐标，
        这个坐标在 Maven 仓库中对应唯一的 Maven 构件】

      <groupId>com.amos.maven</groupId>组织名
      <artifactId>eBeyDemo</artifactId>构件名
      <version>1.0.0SNAPSHOT</version>版本号
    
      【表示该项目的打包方式，war表示打包为 war 格式，
        默认为jar，表示打包为 jar 格式】

      <packaging>jar</packaging>
    
      【表示该项目的名称与 URL 地址，意义不大，可以省略】
      <name>eBeyDemo</name>
      <url>http://maven.apache.org</url>
    
      【<properties>配置信息（一般定义常量，例如版本号）
	  常量：<junit.version>3.8.1</junit.version>
	  调用：${junit.version}】

      <properties>
        <junit.version>3.8.1</junit.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
      </properties>
    
      【定义该项目的依赖关系，其中每一个 dependency 对应一个 Maven 构建，Maven坐标唯一标识。
	加载时会依次加载，先在本地查找，找不到到Maven中央仓库找，再找不到就会报错。
        最下边有<scope>属性，表示作用域（后边会详解）】

      <dependencies>
        <dependency>
          <groupId>junit</groupId>
          <artifactId>junit</artifactId>
          <version>3.8.1</version>
          <scope>test</scope>
        </dependency>
      </dependencies>
    
      【build：表示与构建相关的配置，一般是引入插件】

    	<build>
    		<!-- 插件列表 -->
    		<plugins>
    		    <plugin>
    			<!-- 插件也是通过坐标唯一标识的,可以在下边网址中搜索 -->
    			<!-- http://mvnrepository.com/ -->
    			<groupId>org.apache.maven.plugins</groupId>
    			<artifactId>maven-source-plugin</artifactId>
    			<version>3.0.1</version>
    		    </plugin>
    		    <!-- 也可以定义java的jdk版本 -->
		    <plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<version>3.6.1</version>
			<configuration>
				<source>1.8</source>
				<target>1.8</target>
			</configuration>
		    </plugin>
    		</plugins>
    	</build>
    
        <!-- 继承（后边会详解） -->
        <parent></parent>
    
        <!-- 聚合（后边会详解） -->
        <modules>
            <moudle></moudle>
        </modules>
    
    </project>

----------
## Maven 远程仓库地址

### 首先到Maven安装路径中的以下路径

    E:\allocation_resource\apache-maven-3.5.0\lib\maven-model-builder-3.5.0.jar

### 打开压缩包,到压缩包中的以下路径

    maven-model-builder-3.5.0.jar\org\apache\maven\model

### 打开目录最下边的pom-4.0.0.xml文件

    pom-4.0.0.xml也就是maven的超级pom
    也就是我们的pom.xml中固定行中所指
    <modelVersion>4.0.0</modelVersion>

    pom-4.0.0.xml中的url就是目标
        https://repo.maven.apache.org/maven2

----------
## Maven <scope> 六种值，范围解析：
    
    <dependencies>
        <dependency>
         	<groupId>junit</groupId>
         	<artifactId>junit</artifactId>
         	<version>3.8.1</version>
          	<scope>test</scope>
        </dependency>
    </dependencies>
                
### 依赖三个范围：编译 测试 运行，六种值：

 - compile:默认的，编译、测试、运行都有效
 - provided:编译、测试有效
 - runtime(运行):测试和运行时有效
 - test:仅测试有效
 - system:编译、测试有效（与本机系统相关联，移植性差）
 - import:表示继承过来的依赖

----------
## Maven 当依赖发生冲突时，会遵循下边两个原则：
- 1. 短路径优先
- 2. 优先声明优先

    <!-- 依赖管理者 -->
    <dependencyManagement>
        <dependency>	……	</dependency>
    </dependencyManagement>
    
    <!-- 当依赖发生冲突时，会遵循下边两个原则-->
	一、多重继承，使用类型相同但版本不同jar，短路径优先。
		如果 A 继承自 B，B 继承自 C，C 为根， B 中引入hello2.0.jar，
		C 中引入 hello2.4.jar，那么 A 中的jar就会是 hello2.0.jar
    
    二、优先声明优先
		如果 A 继承自 B 和 C， B 中引入 hello2.0.jar，C 中引入 hello2.4.jar，在<dependency>引入jar的时候，先引入 C , 再引入 B，那么 A中的jar就会是 hello2.4.jar

----------
## Maven 依赖管理

> 我们知道，maven的依赖关系是有传递性的。如：A-->B，B-->C。
> 但有时候，项目A可能不是必需依赖C，因此需要在项目A中排除对C的依赖。 在maven的依赖管理中，有两种方式可以对依赖关系进行:
> 可选依赖 Optional Dependencies，以及依赖排除DependencExclusions

    <project........>
	    <!-- A依赖B，排除B的依赖C -->
            <groupId>com.amos.maven</groupId>
            <artifactId>BuyDemo-A</artifactId>
            <version>1.0.0SNAPSHOT</version>
    
            <dependencies>
                <dependency>

                  <groupId>com.amos.maven</groupId>
                  <artifactId>BuyDemo-B</artifactId>
                  <version>1.0.0SNAPSHOT</version>
    
                  <!-- 设置依赖是否可选 -->
                  <optional>true</optional>
    
                  <!-- 排除依赖传递列表，
                  也就是排除依赖中引用的依赖 -->
                  <executions>
                    <execution>
                        <groupId>com.amos.maven</groupId>
                        <artifactId>BuyDemo-C</artifactId>
                    </execution>
                  </executions>
    
                </dependency>
            </dependencies>
    
    <project>
    

----------
## 聚合与继承
	一、聚合，使用modules--module(当一个项目聚合了其他多个时，当前这个执行mvn clean install，
		 以下三个项目会依次执行install命令)
		<modules>
			<module>../maven01-service</module>
			<module>../maven01-moudle</module>
			<module>../maven01-action</module>
		</modules>

    二、继承，使用dependencyManagement/parent
    
    	以下作为本Maven项目中所有构件的父类
    	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
           	http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    		<modelVersion>4.0.0</modelVersion>
    		<groupId>com.amos.maven</groupId>
    		<artifactId>eBeyDemo</artifactId>
    		<version>1.0.0SNAPSHOT</version>
    		<packaging>pom</packaging>
    
    		<properties>
    			<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    			<junit.version>3.8.1</junit.version>
    		</properties>
        </project>
    
    	上边是父类，下边的maven构件继承自父类，用<parent>标签
        <parent>
              <groupId>com.amos.maven</groupId>
              <artifactId>eBeyDemo</artifactId>
              <version>1.0.0SNAPSHOT</version>
        <parent>
    
        <dependencies>
            <dependency>
         		<groupId>junit</groupId>
         	 	<artifactId>junit</artifactId>
         	</dependency>
        </dependencies>

----------


## 查看项目中引入的jar
    mvn dependency:list







