echo off&setlocal enabledelayedexpansion

cls
REM now in d:\Vim\Tools\Bat\
cd..
REM now in d:\Vim\Tools\
cd..
REM now in d:\Vim\
set current_path="%cd%"
REM ע��·����Ҫ��б��
set path_="%cd%\vim74"
echo ׼����ӣ�
echo %path_%
IF EXIST %cd%\vim74\gvim.exe (
        IF EXIST %systemroot%\system32\setx.exe (
            SET path_="%cd%\vim74"
            REM TODO ��ô�õ�ԭ����PATH??
            ECHO "����PATH��%path_%"
            %systemroot%\system32\setx.exe PATH "%path%;c:\Vim\tools\MINGW\bin\;c:\Vim\tools\GnuWin32\bin\;c:\Vim\vim74\;C:\Python27\;c:\Vim\tools\Git\cmd;c:\Vim\tools\exe;c:\vim\tools\ag"
            REM SETX PATH "%path_%"
            ECHO vim�����������óɹ�
            ) ELSE (
                ECHO ON
                ECHO δ���ҵ�%systemroot%\system32\setx.exe��������setx.exe����
                )
        ) ELSE (
            ECHO ON
            ECHO ��װĿ¼����ȷ,δ�ܰ���Ԥ�ڼƻ�ִ��
            )
        PAUSE
