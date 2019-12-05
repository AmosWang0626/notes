---
title: docker spring boot
date: 2019-03-18
categories: Docker
tags:
- docker
- spring-boot
---


# docker spring boot
> maven | gradle

## Dockerfile
### 方式1
> 直接将 spring boot 打包后的 jar 构建成镜像

```dockerfile
FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

### 方式2
> spring boot 打包后的 jar 解压后, 再取相应文件构建成镜像

- 打包后，自动解压
```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-dependency-plugin</artifactId>
    <executions>
        <execution>
            <id>unpack</id>
            <phase>package</phase>
            <goals>
                <goal>unpack</goal>
            </goals>
            <configuration>
                <artifactItems>
                    <artifactItem>
                        <groupId>${project.groupId}</groupId>
                        <artifactId>${project.artifactId}</artifactId>
                        <version>${project.version}</version>
                    </artifactItem>
                </artifactItems>
            </configuration>
        </execution>
    </executions>
</plugin>
```
- mvn install 时 build 镜像
```xml
<plugin>
    <groupId>com.spotify</groupId>
    <artifactId>dockerfile-maven-plugin</artifactId>
    <version>1.4.9</version>
    <configuration>
        <repository>${docker.image.prefix}/${project.artifactId}</repository>
    </configuration>
    <executions>
        <execution>
            <id>build-image</id>
            <phase>install</phase>
            <goals>
                <goal>build</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```
- dockerfile 配置
```dockerfile
FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
RUN echo "Asia/Shanghai" > /etc/timezone
RUN mkdir --parents /log/kbase-psrt/
ENTRYPOINT ["java", "-Xmx4G", "-XX:+HeapDumpOnOutOfMemoryError", "-XX:HeapDumpPath=/log/kbase-psrt/", "-XX:+PrintGCDetails", "-XX:+PrintGCDateStamps", "-XX:+PrintHeapAtGC", "-Xloggc:/log/kbase-psrt/gc.log", "-cp", "app:app/lib/*", "com.eastrobot.kbs.KbasePsrtApplication"]
```

## By maven
```xml
<build>
    <finalName>greet</finalName>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
        </plugin>
        <plugin>
            <groupId>com.spotify</groupId>
            <artifactId>dockerfile-maven-plugin</artifactId>
            <version>1.3.6</version>
            <configuration>
                <repository>amos/${project.artifactId}</repository>
                <buildArgs>
                    <JAR_FILE>target/${project.build.finalName}.jar</JAR_FILE>
                </buildArgs>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## By gradle
> 据说gradle适配docker比较好，以下配置即可

### build.gradle
```groovy
buildscript {
    ext {
        springBootVersion = '2.0.5.RELEASE'
    }
    repositories {
        // step.5
        // mavenCentral()
        maven {
            url "https://plugins.gradle.org/m2/"
        }
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
        // step.1
        classpath('gradle.plugin.com.palantir.gradle.docker:gradle-docker:0.20.1')
    }
}

apply plugin: 'java'
apply plugin: 'eclipse'
apply plugin: 'org.springframework.boot'
apply plugin: 'io.spring.dependency-management'
// step.2
apply plugin: 'com.palantir.docker'

// step.3
bootJar {
    baseName = 'hello'
    version = '1.0.0'
}

// group = 'com.amos'
group = 'amos'
version = '1.0.0-SNAPSHOT'

sourceCompatibility = 1.8
targetCompatibility = 1.8

repositories {
    mavenCentral()
}

dependencies {
    compile('org.springframework.boot:spring-boot-starter-web')
    compileOnly('org.projectlombok:lombok')
    testCompile('org.springframework.boot:spring-boot-starter-test')
}

// step.4
docker {
    dependsOn build as Task
    name "${project.group}/${bootJar.baseName}:${bootJar.version}"
    files bootJar.archivePath
    buildArgs(['JAR_FILE': "${bootJar.archiveName}"])
}

// gradlew build docker
```

