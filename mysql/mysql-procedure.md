## 存储过程命名规范

- 1 业务相关以模块代码开头 gld_assist_check_p 
- 2 如果区分全量和增量，在最后加标识 gld_load_to_etl gld_load_to_etl_full 
- 3 全局使用，以global开头 global_procedure_check 

### 内部变量命名
- 变量（以 V 开头）e.g. V_SCORE
- 游标（以 C 开头）e.g. C_CURSOR
- 内存表（以 M 开头）e.g. M_TABLE
- 临时表（以 T 开头）e.g. T_TEMP_TABLE
