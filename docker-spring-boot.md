# docker + spring boot
> maven | gradle

## Dockerfile
```
FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAR_FILE
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
```

## By maven
```xml
<properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
    <java.version>1.8</java.version>
    <skipTests>true</skipTests>
    <docker.image.prefix>amos</docker.image.prefix>
</properties>

<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>


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
                <repository>${docker.image.prefix}/${project.artifactId}</repository>
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
```
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

