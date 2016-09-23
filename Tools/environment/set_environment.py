# -*- coding: utf-8 -*-
import os, sys, re
current_dir = os.getcwd()
vim_dir = os.path.dirname(os.path.dirname(current_dir))
vim_tool_dir = os.path.join(vim_dir, "tools")
new_env_vars = {
        "PATH":[
            "c:\\python35\\",
            "c:\\Python35\\Scripts",
            os.path.join(vim_dir, "vim80"),
            os.path.join(vim_tool_dir, "MINGW\\bin\\"),
            os.path.join(vim_tool_dir, "GnuWin32\\bin\\"),
            os.path.join(vim_tool_dir, "exe"),
            os.path.join(vim_tool_dir, "ag"),
            os.path.join(vim_tool_dir, "gtags\\bin"),
            ],
        "GRAPHVIZ_DOT":[
            os.path.join(vim_tool_dir, "Graphviz\\bin\\dot.exe"),
            ], 
        }

from subprocess import check_call
if sys.hexversion > 0x03000000:
    import winreg
else:
    import _winreg as winreg

class Win32Environment:
    """Utility class to get/set windows environment variable"""

    def __init__(self, scope):
        assert scope in ('user', 'system')
        self.scope = scope
        if scope == 'user':
            self.root = winreg.HKEY_CURRENT_USER
            self.subkey = 'Environment'
        else:
            self.root = winreg.HKEY_LOCAL_MACHINE
            self.subkey = r'SYSTEM\CurrentControlSet\Control\Session Manager\Environment'

    def getenv(self, name):
        key = winreg.OpenKey(self.root, self.subkey, 0, winreg.KEY_READ)
        try:
            value, _ = winreg.QueryValueEx(key, name)
        except WindowsError:
            value = ''
            self.setenv(name, value)
            print("set new null environment variable: %s!" % name)
        return value

    def setenv(self, name, value):
        setx = r"c:/windows/System32/setx.exe"
        if os.path.isfile(setx):
            print("now setting...\n%s=%s" %(name, value))
            cmd = setx + ' ' + name + ' "' + value + '"'
            #print cmd
            os.system(cmd)

    def build_new_env(self, name, new_env):
        """构造新的环境变量字符串"""
        old_env = self.getenv(name)
        if old_env != "":
            #最后不已;结尾要补上;
            if old_env[-1] != ";":
                old_env = old_env + ";"
            print("Old environment variable...\n%s" %(old_env))
            #全部转换成小写并按;分割
            old_env_list = old_env.lower().split(";")
        else:
            old_env_list = []
        append_str = ""
        for p in new_env:
            if p[-1] == ";":
                p = p[:-1]
            #查找新添加字符串是否已经在旧的环境变量里。先转换成小写字母并同时在尾部加\判断
            if (p.lower() not in old_env_list) and ((p+'\\').lower() not in old_env_list):
                append_str = append_str + p + ";"
                print("add new string: %s" %append_str)
        new_str = old_env + append_str
        return new_str

e = Win32Environment(scope="user")
for (key, value) in new_env_vars.items():
    new_str = e.build_new_env(key, value)
    e.setenv(key, new_str)
