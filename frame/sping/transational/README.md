---
title: Spring 双层事务，我抛出的异常去哪了？
date: 2020-11-30
categories: 框架相关
tags:
- spring
- transactional
---

# Spring 双层事务，我抛出的异常去哪了？
> 系统A执行数据同步，同步到系统B时，系统B返回了错误信息，系统A需要将前边保存的回滚掉，同时把错误信息返回前端

## 大致代码如下

```java
@Service("noteService")
public class NoteServiceImpl implements NoteService {

    @Resource
    private NoteVersionService noteVersionService;


    @Transactional(rollbackFor = Throwable.class)
    @Override
    public CommonResponse<NoteEntity> save(NoteEntity note) {
        // 一系列 DB 操作

        try {
            noteVersionService.saveVersion(note);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return CommonResponse.success(entity);
    }

}
```

```java
@Service("noteVersionService")
public class NoteVersionServiceImpl implements NoteVersionService {

    @Transactional(rollbackFor = Throwable.class)
    @Override
    public void saveVersion(NoteEntity note) {
        // 一系列 DB 操作

        throw new RuntimeException("保存失败! [XXX]");
    }

}
```

```java
@SpringBootTest
public class NoteTests {

    @Resource
    private NoteService noteService;

    @Test
    public void saveNote() {
        NoteEntity entity = new NoteEntity();
        entity.setTitle("念奴娇赤壁怀古");
        entity.setContent("大江东去，浪淘尽，千古风流人物。故垒西边，人道是：三国周郎赤壁。。。");
        entity.setTags("苏轼,宋代");
        entity.setCategory("苏轼诗词");

        try {
            noteService.save(entity);
        } catch (Exception e) {
            e.printStackTrace();
            // FIXME 我想在这里拿到的是 保存失败! [XXX]
            // FIXME 但是这里拿到的是 Transaction silently rolled back because it has been marked as rollback-only
            System.out.println(">>>>>>>>>> " + e.getMessage());
        }
    }

}
```

## 事出有因
> 代码历史久远，为何这样写已无法追溯

纳闷了一会儿，看到双层事务，就想起了 Spring事务传播机制，前边理解得比较肤浅。

没有特殊的配置，自然是走默认的事务传播机制了，也就是 Propagation.REQUIRED。

国际惯例，列出事务传播机制：
```text
1、PROPAGATION_REQUIRED
当前没事务，则创建事务；存在事务，就加入该事务，这是最常用的设置。

2、PROPAGATION_SUPPORTS
当前存在事务，就加入事务，当前不存在事务，就以非事务方式执行。

3、PROPAGATION_MANDATORY
当前存在事务，就加入事务；当前不存在事务，就抛出异常。

4、PROPAGATION_REQUIRES_NEW
无条件创建新事务。

5、PROPAGATION_NOT_SUPPORTED
以非事务方式执行，如果当前存在事务，就将当前事务挂起。

6、PROPAGATION_NEVER
以非事务方式运行，如果存在事务，就抛出异常。

7、PROPAGATION_NESTED
开始执行事务前，先保存一个savepoint，当发生异常时，就回滚到savepoint；没有异常时，跟着外部事务一起提交或回滚。
```

## 具体原因

1、看了上边的事务传播机制，继续细化问题，内外层共用一个事务，内层抛出异常，会导致整个事务失败。

2、继续分析，外层逻辑进行了 try catch，就导致内层的异常无法继续向上抛出，外层事务会继续提交。

3、事务提交时，进行事务状态的判断，就发现这个事务是失败的，需要回滚，所以抛出了 `Transaction silently rolled back because it has been marked as rollback-only` 的异常。

## 怎么解决？
> 银弹自然是没有的，根据业务场景选择合适的方案。

1、当前这种场景，直接把外层逻辑中的 try catch 去掉即可。异常直接向上抛，事务就不会继续提交，调用方拿到的就是一手的异常；

2、如果内层不是核心逻辑，记录个日志啥的，可以把内层事务配置为 `@Transactional(rollbackFor = Throwable.class, propagation = Propagation.REQUIRES_NEW)`，
无论如何，都创建新的事务，外层事务不受内层事务影响。但是有个问题，外层事务失败了，内层事务还是把记录入库了，有可能产生脏数据；

3、如果外层事务失败了，内层事务也不能提交，那就可以使用 `@Transactional(rollbackFor = Throwable.class, propagation = Propagation.NESTED)`。
注意：hibernate/jpa 不支持嵌套事务 NESTED，可用 JdbcTemplate 代替。
