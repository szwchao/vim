echo off&setlocal enabledelayedexpansion

cls
set current_path="%cd%"
REM ע��·����Ҫ��б��
set path_="%cd%\GnuWin32\bin"
echo ׼����ӣ�
echo %path_%
echo;
reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path |find %path_%
if "%ERRORLEVEL%"=="0" goto :c
:begin
if not defined path_ goto error
for,/f,"skip=4 tokens=1,2,*",%%a,in,('reg query "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path'),do,(
        echo ��ǰ�Ļ�������Ϊ:
        echo %%c
        echo;
        set/p yesno=�Ƿ�ȷ�Ͻ�"%path_%"��ӵ�ϵͳ����������ȥ��[Y]/[N]
        if /i "!yesno!"=="y" (
                reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment" /v Path /t REG_EXPAND_SZ /d "%%c;%path_%" /f
                echo ����������ӳɹ�
                goto :eof
           )
        echo ��������δ�����
        pause
        goto :eof
)
pause
goto :Eof        
:error
echo �����������������
pause
goto begin 
:c
echo ���������Ѵ��ڣ��������ظ����
pause
