# Oracle

## 根据日期找出年月日
- 方式1
    - SELECT EXTRACT (YEAR FROM DATE '2019-08-15') FROM dual;
    - SELECT EXTRACT (MONTH FROM DATE '2019-08-15') FROM dual;
    - SELECT EXTRACT (DAY FROM DATE '2019-08-15') FROM dual;
- 方式2
    - SELECT "SUBSTR"('2019-08-15', 0, 4) FROM dual;
    - SELECT "SUBSTR"('2019-08-15', 6, 2) FROM dual;
    - SELECT "SUBSTR"('2019-08-15', 9, 2) FROM dual;

## IN
```oracle
SELECT COL01, COL02, COL03
FROM TEXT_TABLE
WHERE "ID" IN ('10001', '10002', '10003');
```

## 建表
### 查看表字段及数据类型
```
SELECT table_name, column_name, data_type
FROM all_tab_cols WHERE table_name = 'MOS_USER'
```

### 字段类型须知
- [Err] ORA-00907: missing right parenthesis
> - 表面意思是少右括号，但和MySQL不同，某些关键字也是需要处理的。
> - 例如：`INTEGER (8)`是错的，正确写法是去掉长度 `(8)`，示例如下

```oracle
CREATE TABLE "CODE_SEARCH" (
	"ID" VARCHAR2 (32) NOT NULL,
	"TYPE" INTEGER,
	"CONTENT" VARCHAR2 (4000),
	"USER_ID" VARCHAR2 (32),
	"VISIT_TIME" TIMESTAMP (6),
	"DESCRIPTION" VARCHAR2 (4000),
	PRIMARY KEY ("ID")
);
```

### 较MySQL
- `` to ""
- `INTEGER (8)` to `INTEGER`
- `VARCHAR (100)` to `VARCHAR2 (100)`
- `DATETIME` to `TIMESTAMP (6)`
