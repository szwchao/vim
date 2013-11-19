echo off&setlocal enabledelayedexpansion

cls
set current_path="%cd%"
REM 注意路径不要加斜杠
set path_="%cd%\GnuWin32\bin"
echo 准备添加：
echo %path_%
echo;
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path |find %path_%
if "%ERRORLEVEL%"=="0" goto :c
:begin
if not defined path_ goto error
for,/f,"skip=4 tokens=1,2,*",%%a,in,('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path'),do,(
        echo 当前的环境变量为:
        echo %%c
        echo;
        set/p yesno=是否确认将"%path_%"添加到系统环境变量中去？[Y]/[N]
        if /i "!yesno!"=="y" (
                reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%%c;%path_%" /f
                echo 环境变量添加成功
                goto :eof
           )
        echo 环境变量未能添加
        pause
        goto :eof
)
pause
goto :Eof        
:error
echo 输入错误，请重新输入
pause
goto begin 
:c
echo 环境变量已存在，不可以重复添加
pause
