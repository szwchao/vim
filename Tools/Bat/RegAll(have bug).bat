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
            SETX PATH "d:\Vim\Tools\MINGW\bin\;d:\Vim\Tools\GnuWin32\bin\;D:\Vim\vim74\;C:\Python25\;d:\Vim\Tools\Git\cmd"
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
