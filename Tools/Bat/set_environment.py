# -*- coding: utf-8 -*-
import os
#user
#c:\python27\;c:\Python27\Scripts\;d:\Vim\tools\MINGW\bin\;d:\Vim\tools\GnuWin32\bin\;d:\Vim\vim74\;C:\Python25\;d:\Vim\tools\Git\cmd;d:\Vim\tools\exe;d:\vim\tools\ag
#system
#C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;C:\Program Files\TortoiseGit\bin;C:\Program Files (x86)\ATI Technologies\ATI.ACE\Core-Static
new_path = [
        r"c:\python27\;",
        r"c:\Python27\Scripts\;",
        r"d:\Vim\vim74\;",
        r"d:\Vim\tools\Git\cmd;",
        r"d:\Vim\tools\MINGW\bin\;",
        r"d:\Vim\tools\GnuWin32\bin\;",
        r"d:\Vim\tools\exe;",
        r"d:\vim\tools\ag",
        ]
old_path = os.environ['PATH']
#print "Old PATH: %s" %(old_path)
setx = r"c:/windows/System32/setx.exe"
if os.path.isfile(setx):
    print "can run"
cmd = setx + ' PATH "' + old_path + '"'
#print cmd
#os.system(cmd)

#x = os.popen('wmic ENVIRONMENT where "name=\'path\' and username=\'<system>\'" get VariableValue').read()
x = os.popen('wmic ENVIRONMENT where "name=\'temp\'" get UserName,VariableValue').read()
print x
x = x.split('VariableValue')[1]
x = x.strip()
#print old_path.find(x)

