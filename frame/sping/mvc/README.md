---
title: Spring & Hibernate5 事务配置
date: 2020-08-12
categories: 框架相关
tags:
- spring
- hibernate
---

# Spring & Hibernate5 事务配置
> Spring MVC 渐渐远去了，但是遇到问题还是要 KILL 的

## 两种配置方式
1. 配置型事务
    > 通过 AOP 为符合表达式的方法统一加上事务

2. 注解式事务
    > 直接在Service方法上加上事务
    >
    > `@Transactional(rollbackFor = Throwable.class)`


```xml
<beans>
    <!-- 事务管理器配置 start -->

    <bean id="transactionManager" class="org.springframework.orm.hibernate5.HibernateTransactionManager">
        <property name="sessionFactory" ref="sessionFactory"/>
    </bean>

    <!-- 1.配置型事务 -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <tx:attributes>
            <tx:method name="*" propagation="REQUIRED" read-only="false"/>
        </tx:attributes>
    </tx:advice>

    <!-- 可通过如下方式为多个切面增加事务 -->
    <aop:config proxy-target-class="true">
        <aop:pointcut id="serviceMethod" expression="execution(* com.amos.module..service..*(..))"/>
        <aop:advisor pointcut-ref="serviceMethod" advice-ref="txAdvice"/>
    </aop:config>
    <aop:config proxy-target-class="true">
        <!-- 缺点：对继承的方法不生效；如果类继承自 SimpleHibernateDao，那么不会给 SimpleHibernateDao 里的方法加上事务 -->
        <!-- 解决办法：SimpleHibernateDao 的”增删改“方法上加上注解式事务@Transactional(rollbackFor = Throwable.class) -->
        <aop:pointcut id="daoMethod" expression="execution(* com.amos.module..dao..*(..))"/>
        <aop:advisor pointcut-ref="daoMethod" advice-ref="txAdvice"/>
    </aop:config>

    <!-- 2.注解式事务 -->
    <tx:annotation-driven transaction-manager="transactionManager" proxy-target-class="true"/>

    <!-- 事务管理器配置 end -->
</beans>
```