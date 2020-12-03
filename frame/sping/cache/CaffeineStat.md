---
title: Caffeine CacheManager 如何查看命中率、监控
date: 2020-12-03
categories: 框架相关
tags:
- caffeine
---

# Caffeine CacheManager 如何查看命中率、监控

> 官方提供了结合 Prometheus 的方案，如果想简单看下监控，可继续看下文。

## 直奔主题

```java

@Api(tags = "监控-Caffeine")
@RestController
@RequestMapping("monitor/caffeine")
public class MonitorCaffeineController {

    @Resource
    private CacheManager caffeine;


    @GetMapping("cacheNames")
    @ApiOperation("所有缓存name")
    public Collection<String> cacheNames() {

        return caffeine.getCacheNames();
    }

    @GetMapping("stats")
    @ApiOperation("根据缓存name查询缓存监控信息")
    public Map<String, Object> stats(@RequestParam String cacheName) {
        CaffeineCache caffeineCache = (CaffeineCache) caffeine.getCache(cacheName);
        CacheStats stats = CacheStats.empty();
        if (caffeineCache != null) {
            stats = caffeineCache.getNativeCache().stats();
        }

        Map<String, Object> map = new HashMap<>(16);
        map.put("请求次数", stats.requestCount());
        map.put("命中次数", stats.hitCount());
        map.put("未命中次数", stats.missCount());
        map.put("加载成功次数", stats.loadSuccessCount());
        map.put("加载失败次数", stats.loadFailureCount());
        map.put("加载失败占比", stats.loadFailureRate());
        map.put("加载总耗时", stats.totalLoadTime());
        map.put("回收总次数", stats.evictionCount());
        map.put("回收总权重", stats.evictionWeight());

        return map;
    }

}
```

## 下文可忽略，通过 CacheManager 找监控方法的心路

> 想通过 CacheManager --> CaffeineCacheManager 找到监控的方法，无果，准备重写 CaffeineCacheManager 时意外找到了，源码才是。。。

### 1、直接使用 Caffeine.newBuilder() 如何监控

```java
public class CaffeineController {

    private static final Cache<String, Object> CAFFEINE_CACHE = Caffeine.newBuilder()
            .initialCapacity(256)
            // 保存缓存数量
            .maximumSize(100)
            // 从写入开始保存的时间
            .expireAfterWrite(10, TimeUnit.SECONDS)
            // 删除缓存原因
            .removalListener((key, value, cause) -> LOGGER.info(">>> 删除缓存 [{}]({}), reason is [{}]", key, value, cause))
            // 开启状态监控
            .recordStats()
            .build();

    @GetMapping("stats")
    public String stats() {
        CacheStats stats = CAFFEINE_CACHE.stats();

        return stats.toString();
    }
}
```

## 2、通过 CacheManager 使用 Caffeine

```java

@EnableCaching
@Configuration
public class LocalCache {
    @Bean("caffeine")
    public CacheManager caffeineCacheManager() {
        CaffeineCacheManager cacheManager = new CaffeineCacheManager();
        cacheManager.setCaffeine(Caffeine.newBuilder()
                .initialCapacity(256)
                .expireAfterWrite(24, TimeUnit.HOURS)
                .maximumSize(100)
                // 删除缓存原因
                .removalListener((key, value, cause) -> LOGGER.info(">>> 删除缓存 [{}]({}), reason is [{}]", key, value, cause))
                // 开启状态监控
                .recordStats()
        );

        return cacheManager;
    }
}
```

## 3、惯性思维，翻翻 CaffeineCacheManager

不用 CacheManager 时，可以通过 `Caffeine.newBuilder().recordStats().build()` 查看监控信息，那 CaffeineCacheManager 里边 build 之后的东西返回值放哪了？

```java
public class CaffeineCacheManager implements CacheManager {

    private Caffeine<Object, Object> cacheBuilder = Caffeine.newBuilder();

    private final Map<String, Cache> cacheMap = new ConcurrentHashMap<>(16);

    public void setCaffeine(Caffeine<Object, Object> caffeine) {
        Assert.notNull(caffeine, "Caffeine must not be null");
        doSetCaffeine(caffeine);
    }

    // 3. *.caffeine.*.Cache 绑定名字并转化成 CaffeineCache
    protected Cache adaptCaffeineCache(String name, com.github.benmanes.caffeine.cache.Cache<Object, Object> cache) {
        return new CaffeineCache(name, cache, isAllowNullValues());
    }

    // 2. 核心步骤
    // 这层层线索证明 CacheManager#getCache(String name) 这个方法就是我们要的
    // Cache --> CaffeineCache --> *.caffeine.*.Cache --> 拿到 stats() 就好了
    protected Cache createCaffeineCache(String name) {
        return adaptCaffeineCache(name, createNativeCaffeineCache(name));
    }

    // 1. 这一步用了 cacheBuilder.build()
    // 这个 *.caffeine.*.Cache 就是要找的，也不知道这个 name 是干啥的，打个断点看看
    protected com.github.benmanes.caffeine.cache.Cache<Object, Object> createNativeCaffeineCache(String name) {
        return (this.cacheLoader != null ? this.cacheBuilder.build(this.cacheLoader) : this.cacheBuilder.build());
    }

}

```

## 4、重写吧（x_x）

cacheBuilder 是私有的，cacheBuilder.build()之后的东西也拿不到，但是 createNativeCaffeineCache 是 protected 的，可以用继承走一波。

新写个类 CustomCaffeineCacheManager 继承 CaffeineCacheManager，通过重写 createNativeCaffeineCache 拿到创建完的 *.caffeine.*
.Cache，后边使用它，啥也拿不到（可能是用的方式不对）。

意外收获，打断点后，知道 name 是干啥的了。就是 @Cacheable 的 value 属性对应的值

`@Cacheable(value = "short:url", cacheManager = "caffeine", key = "'short_url_' + #key")`

## 5、最后翻了下 CacheManager，原来如此

> 秒懂 getCacheNames，以及每个缓存 name 都对应了一个 *.caffeine.*.Cache，
> 也即`Caffeine.newBuilder().recordStats().build()` build 后的结果。

```java
public interface CacheManager {
    @Nullable
    Cache getCache(String name);

    Collection<String> getCacheNames();
}
```

- getCache(String name)
  > 根据缓存名字获取缓存对象（看到这句是不是就恍然大悟了）

- getCacheNames
  > 查看所有缓存名字

## 6、结束语

> 结合 CacheManager#getCache 以及 CaffeineCacheManager 源码写下了开篇的代码。