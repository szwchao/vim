echo off&setlocal enabledelayedexpansion

cls
REM now in d:\Vim\Tools\Bat\
cd..
REM now in d:\Vim\Tools\
cd..
REM now in d:\Vim\
set current_path="%cd%"
REM 注意路径不要加斜杠
set path_="%cd%\vim74"
echo 准备添加：
echo %path_%
IF EXIST %cd%\vim74\gvim.exe (
        IF EXIST %systemroot%\system32\setx.exe (
            SET path_="%cd%\vim74"
            REM TODO 怎么得到原来的PATH??
            ECHO "设置PATH：%path_%"
            %systemroot%\system32\setx.exe PATH "%path%;d:\Vim\tools\MINGW\bin\;d:\Vim\tools\GnuWin32\bin\;d:\Vim\vim74\;C:\Python25\;d:\Vim\tools\Git\cmd;d:\Vim\tools\exe;d:\vim\tools\ag"
            REM SETX PATH "%path_%"
            ECHO vim环境变量设置成功
            ) ELSE (
                ECHO ON
                ECHO 未能找到%systemroot%\system32\setx.exe，请下载setx.exe程序
                )
        ) ELSE (
            ECHO ON
            ECHO 安装目录不正确,未能按照预期计划执行
            )
        PAUSE
