# Java-Linux现场监控

1. 查看日志

   - tail -200f xxx.log

2. 查看内存

   - free -h

3. 查看磁盘

   - df -h
     - Filesystem
       - tmpfs
         - tmpfs 是 Linux/Unix 系统上的一种基于内存的文件系统。 tmpfs 可以使用您的内存或 swap 分区来存储文件。在 Redhat/CentOS 等 linux 发行版中默认大小为物理内存的一半。
         - tmpfs 既可以使用物理内存，也可以使用交换分区，因为 tmpfs 使用的是 “ 虚拟内存 ” 。 Linux 内核的虚拟内存同时来源于物理内存和交换分区，主要由内核中的 VM 子系统进行调度，进行内存页和 SWAP 的换入和换出操作， tmpfs 自己并不知道这些页面是在交换分区还是在物理内存中。
         -  如果你想使用 tmpfs ，那么最简单的办法就是直接将文件存放在 /dev/shm 下，虽然这并不是推荐的方案，因为 /dev/shm 是给共享内存分配的，共享内存是进程间通信的一种方式。
       - devtmpfs
         -  设备文件创建的管理工作，缩短开机时间
     - used：使用掉的硬盘空间
     - available：剩下的磁盘空间大小
     - use%：磁盘使用率
     - mounted on：磁盘挂载的目录所在（挂载点）
   - du -h
     - du -ah /opt/xxx 显示全部文件夹、子文件夹、文件大小，以human（人性化）展示
     - du -sh /opt/xxx 显示指定文件夹大小
     - du -Sh /opt/xxx 显示指定文件夹以及子文件夹大小

4. 查看进程

   - hcache
     
   - hcache --top 10
     
   - top

     - [参考Linux top命令参数及使用方法详解]( http://linuxeye.com/command/top.html )

   - htop

     - [htop使用详解](https://www.cnblogs.com/yqsun/p/5396363.html)

     - F1 show this help screen![htop-f1]( https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-f1.png )

     - htop info 可对比上图![linux-htop-info]( https://gitee.com/AmosWang/resource/raw/master/image/linux-htop-info.png )

     - 左边：CPU、内存、交换分区的使用情况

     - 右边：Tasks为进程总数，当前运行的进程数；Load average为系统1分钟，5分钟，10分钟的平均负载情况；Uptime为系统运行的时间。 

       ```
       PID：进行的标识号
       USER：运行此进程的用户
       PRI：进程的优先级
       NI：进程的优先级别值，默认的为0，可以进行调整(-20 )
       VIRT：进程占用的虚拟内存值
       RES：进程占用的物理内存值
       SHR：进程占用的共享内存值
       S：进程的运行状况，R表示正在运行、S表示休眠，等待唤醒、Z表示僵死状态
       %CPU：该进程占用的CPU使用率
       %MEM：该进程占用的物理内存和总内存的百分比
       TIME+：该进程启动后占用的总的CPU时间
       COMMAND：进程启动的启动命令名称
       ```

     - F3 search，F4 filter，F5 tree view

5. GC日志

   - [jstack(查看线程)、jmap(查看内存)和jstat(性能分析)](https://www.cnblogs.com/panxuejun/p/6052315.html)
   - jstack 136874 > /home/hello-group/mgr-23456-thread.txt
   - jmap -dump:live,format=b,file=/home/hello-group/mgr-map.bin 23456

