# 去除文件名中的左右括号
```
@Echo Off&SetLocal ENABLEDELAYEDEXPANSION
FOR %%a in (*) do (
　　set "name=%%a"
　　set "name=!name: (=!"
　　set "name=!name:)=!"
　　ren "%%a" "!name!"
)
exit
```

# 批处理命令详解
```
@Echo Off&SetLocal ENABLEDELAYEDEXPANSION
::关闭回显,设置变量延迟
FOR %%a in (*) do (
::获取文件名
    set "name=%%a"
    ::把获取到的文件名赋值给 变量 name
    set "name=!name: (=!"
    ::使用 SET 命令的变量替换功能 把name中的 ( 替换为空,即 !name: (=!"
    set "name=!name:)=!"
    ::同上一条命令类似
    ren "%%a" "!name!"
    ::把 刚才获取到的文件名修改为 set 命令替换后的文件名.
)
EXIT
::主要是使用 set 命令的变量替换功能. 修改一下就很好理解了:
set "name=!name: (=左括号!"
set "name=!name:)=右括号!"
```

## 注意事项

    其中，感叹号其实就是变量百分号（%）的强化版。
    之所以要用！而不用%，是因为在for循环中，当一个变量被多次赋值时，
    %dd%所获取的仅仅是dd第一次被赋予的值；
    要想刷新dd的值，
    就必须首先通过命令"setlocal enabledelayedexpansion"来开启延迟变量开关，
    然后用！dd！来获取dd的值。
    
    http://ttwang.iteye.com/blog/2017672
    @echo off
    关闭回显
    @echo on
    打开回显
    
    
    如果字符串中有&符号，可以使用 set c="abc&def" ，但是引号会带入变量，如果不想引号被带入变量就要使用 set "c=abc^&def"。
    
    set "c=abc&def" ---- 错误
    set c=abc&def   ---- 错误
    set c=abc^&def  ---- 错误
    
    set c="abc&def" ---- 输出结果："abc&def"
    set "c=abc^&def" --- 输出结果：abc&def

# 合并多个ts文件
```
@echo off
:: 开启延迟变量
setlocal EnableDelayedExpansion

:: 最终生成的文件名称（使用注意1）
set generate_file=amos.ts

:: =======================
:: == 生成的文件默认在当前文件夹下 ==
:: =======================
:: 最终生成的文件全路径
:: %~dp0 表示当前文件夹
set generate_file_full_path=%~dp0%generate_file%

:: 要合并文件数量（/a 表示数字）
set /a merge_count=0
:: 要合并的文件的前缀（使用注意2）
set old_file_prefix=a
:: 要合并的文件的后缀（使用注意3）
set old_file_suffix=.ts

:: 文件已存在就删除
if exist %generate_file% del /f /q %generate_file%

:: 遍历符合格式的文件
for /r %%i in (*.ts) do (
    set /a merge_count += 1
)

:: 初始化空文件
cd > %generate_file%
echo 开始合并文件······

:: for 循环遍历所有文件
for /l %%i in (1, 1, %merge_count%) do (
    set "temp_file_path=%~dp0%old_file_prefix%%%i%old_file_suffix%"
    :: 拼接文件 copy generate_file + 当前遍历的file generate_file
    copy /b %generate_file_full_path% + !temp_file_path! %generate_file_full_path%
    if "%%i" neq "%~f0" echo =========================
)

:: 结束语
echo 合并文件完成!
pause

```
