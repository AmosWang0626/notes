---
title: Maven架构选型，单模块还是多模块？
date: 2021-02-09
categories: Java
---

# Maven架构选型，单模块还是多模块？

## 1. 单模块

### 优势

快速上手，前期开发效率高。

### 劣势

要想实现传统的三层架构（`web/service/dao`），多采用分包，分包带来个问题就是，包之间边界约束不够。

正常来说，三层架构之间是有依赖关系的，`dao --> service --> web`，依赖是单向的。

举个例子：前端请求的 `xxxRequest` 应该放哪呢，放 `web` 还是 `service`，放 `web` 的话，`service` 应该是不能访问的，所以怎么约束呢？

再极端一点，`dao` 不能调用 `service` 吧，但项目中最不缺的就是临时方案，所以怎么约束呢？

## 2. 多模块（重点来了）

### 优势

约束能力，模块间引用关系是明确的，项目架构更清晰。

### 劣势

简单说，从头搭着可能慢点，用上模板都差不多。

- 首推阿里COLA [https://github.com/alibaba/COLA](https://github.com/alibaba/COLA)
- 本人结合 阿里COLA4.0 实现了一个，模块结构如下
    - think-cola
        - start（启动项目）
        - think-client（api、dto）
        - think-controller（controller，调用app）
        - think-app（校验、封装、执行，调用domain、infrastructure）
        - think-domain（DDD 领域模型，也可暴露接口，由infrastructure实现）
        - think-infrastructure（db、rpc、search、防腐）
    - 项目地址：[https://github.com/AmosWang0626/think-cola](https://github.com/AmosWang0626/think-cola)

## 3. 怎么选？

作为应用级架构，小项目，2~3个人开发的，单模块可能就足够，前提是每个人都对架构有认识，个人约束力很重要；

其他均建议多模块，长期来看，约束是第一生产力，架构直接影响重构的成本。

引用《代码精进之路：从码农到工匠》中的两段话结尾：

- 要记住，留给公司一个方便维护、整洁优雅的代码库，是我们技术人员最高技术使命，也是我们对公司做出的最大技术贡献；
- 【防止破窗】首先我们要有一套规范，并尽量遵守规范，不要做“打破第一扇窗”的人；其次，发现“破窗”要及时修复，不要让问题进一步恶化。