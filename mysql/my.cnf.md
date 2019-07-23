```
[client]
port = 3306
default-character-set = utf8
#character_set_server=utf8 

[mysqld]
port = 3306
character_set_server = utf8

basedir = /opt/mysqlDB/mysql
datadir = /opt/mysqlDB/dbData

#表示是本机的序号为1,一般来讲就是master的意思
server-id = 1

#skip-networking
skip-name-resolve


back_log = 600
max_connections = 1000
open_files_limit = 65535
table_open_cache = 128
max_allowed_packet = 4M
binlog_cache_size = 1M
max_heap_table_size = 8M
tmp_table_size = 16M
read_buffer_size = 2M
read_rnd_buffer_size = 8M
sort_buffer_size = 8M
join_buffer_size = 8M
thread_cache_size = 16
query_cache_size = 8M
query_cache_limit = 2M
key_buffer_size = 4M

log_bin = /opt/mysqlDB/logs/binLog/mysql-bin
binlog_format = mixed
expire_logs_days = 7 #超过7天的binlog删除

log_error = /opt/mysqlDB/logs/errorLog/mysql-error.log #错误日志路径
slow_query_log = 1
long_query_time = 10 #慢查询时间 超过1秒则为慢查询
slow_query_log_file = /opt/mysqlDB/logs/slowLog/mysql-slow.log

performance_schema = 0
explicit_defaults_for_timestamp
lower_case_table_names = 1 #不区分大小写
skip-external-locking #MySQL选项以避免外部锁定。该选项默认开启
default-storage-engine = InnoDB #默认存储引擎

innodb_file_per_table = 1
innodb_open_files = 500
innodb_buffer_pool_size = 5G
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 0
innodb_purge_threads = 1
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 32M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120

bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
interactive_timeout = 28800
wait_timeout = 28800

sql_mode = NO_ENGINE_SUBSTITUTION, STRICT_TRANS_TABLES

[mysqldump]
quick
max_allowed_packet = 16M #服务器发送和接受的最大包长度

[myisamchk]
key_buffer_size = 8M
sort_buffer_size = 8M
read_buffer = 4M
write_buffer = 4M
```
