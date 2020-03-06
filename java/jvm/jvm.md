# Java监控

1. 查看进程

   - hcache
     
   - hcache --top 10
     
   
2. GC日志

   - [jstack(查看线程)、jmap(查看内存)和jstat(性能分析)](https://www.cnblogs.com/panxuejun/p/6052315.html)
   - jstack 136874 > /home/hello-group/mgr-23456-thread.txt
   - jmap -dump:live,format=b,file=/home/hello-group/mgr-map.bin 23456



## GC 日志分析

```shell
OpenJDK 64-Bit Server VM (25.222-b10) for linux-amd64 JRE (1.8.0_222-b10), built on Sep 14 2019 13:24:21 by "mockbuild" with gcc 4.8.5 20150623 (Red Hat 4.8.5-39)

Memory: 4k page, physical 1882084k(737776k free), swap 0k(0k free)

CommandLine flags: -XX:GCLogFileSize=104857600 -XX:InitialHeapSize=536870912 -XX:MaxHeapSize=536870912 -XX:MaxNewSize=268435456 -XX:NewSize=268435456 -XX:NumberOfGCLogFiles=10 -XX:+PrintGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseCompressedClassPointers -XX:+UseCompressedOops -XX:+UseGCLogFileRotation

2020-03-04T11:15:57.502+0800: 3.099: [GC (Allocation Failure) 2020-03-04T11:15:57.502+0800: 3.099: [DefNew: 209792K->4355K(235968K), 0.0175870 secs] 209792K->4355K(498112K), 0.0177073 secs] [Times: user=0.01 sys=0.00, real=0.01 secs] 

2020-03-04T11:15:59.124+0800: 4.721: [GC (Allocation Failure) 2020-03-04T11:15:59.124+0800: 4.721: [DefNew: 214147K->5622K(235968K), 0.0187659 secs] 214147K->5622K(498112K), 0.0188789 secs] [Times: user=0.02 sys=0.00, real=0.02 secs] 

2020-03-04T11:15:59.398+0800: 4.996: [Full GC (Metadata GC Threshold) 2020-03-04T11:15:59.398+0800: 4.996: [Tenured: 0K->5754K(262144K), 0.0381043 secs] 38295K->5754K(498112K), [Metaspace: 20644K->20644K(1069056K)], 0.0382030 secs] [Times: user=0.03 sys=0.01, real=0.04 secs] 

2020-03-04T11:16:01.698+0800: 7.295: [GC (Allocation Failure) 2020-03-04T11:16:01.698+0800: 7.295: [DefNew: 209792K->4199K(235968K), 0.0343592 secs] 215546K->9953K(498112K), 0.0344617 secs] [Times: user=0.03 sys=0.00, real=0.04 secs] 

2020-03-04T11:16:02.561+0800: 8.158: [GC (Allocation Failure) 2020-03-04T11:16:02.561+0800: 8.158: [DefNew: 213991K->5329K(235968K), 0.0142467 secs] 219745K->11083K(498112K), 0.0143542 secs] [Times: user=0.02 sys=0.00, real=0.01 secs] 

2020-03-04T11:16:03.531+0800: 9.128: [GC (Allocation Failure) 2020-03-04T11:16:03.531+0800: 9.128: [DefNew: 215121K->7364K(235968K), 0.0393760 secs] 220875K->13118K(498112K), 0.0394767 secs] [Times: user=0.04 sys=0.00, real=0.03 secs] 

2020-03-04T11:16:05.699+0800: 11.296: [GC (Allocation Failure) 2020-03-04T11:16:05.699+0800: 11.296: [DefNew: 217156K->10563K(235968K), 0.0358828 secs] 222910K->16317K(498112K), 0.0359850 secs] [Times: user=0.03 sys=0.00, real=0.04 secs] 

2020-03-04T11:16:06.459+0800: 12.056: [Full GC (Metadata GC Threshold) 2020-03-04T11:16:06.459+0800: 12.056: [Tenured: 5754K->17122K(262144K), 0.1001467 secs] 84906K->17122K(498112K), [Metaspace: 34106K->34106K(1081344K)], 0.1002577 secs] [Times: user=0.09 sys=0.01, real=0.10 secs] 

2020-03-04T11:16:09.292+0800: 14.889: [GC (Allocation Failure) 2020-03-04T11:16:09.292+0800: 14.889: [DefNew: 209792K->8076K(235968K), 0.0368612 secs] 226914K->25198K(498112K), 0.0369717 secs] [Times: user=0.04 sys=0.00, real=0.03 secs] 

2020-03-04T11:16:13.030+0800: 18.627: [GC (GCLocker Initiated GC) 2020-03-04T11:16:13.030+0800: 18.628: [DefNew: 217868K->21128K(235968K), 0.0967121 secs] 234990K->38250K(498112K), 0.0968389 secs] [Times: user=0.09 sys=0.01, real=0.10 secs] 

2020-03-04T11:16:15.322+0800: 20.920: [Full GC (Metadata GC Threshold) 2020-03-04T11:16:15.322+0800: 20.920: [Tenured: 17122K->40388K(262144K), 0.2212495 secs] 246501K->40388K(498112K), [Metaspace: 56517K->56517K(1101824K)], 0.2215967 secs] [Times: user=0.20 sys=0.01, real=0.22 secs] 

2020-03-04T11:17:39.125+0800: 104.722: [GC (Allocation Failure) 2020-03-04T11:17:39.125+0800: 104.723: [DefNew: 209792K->8786K(235968K), 0.0246404 secs] 250180K->49175K(498112K), 0.0247969 secs] [Times: user=0.02 sys=0.00, real=0.02 secs] 
```



