
" 防止重新载入脚本{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_myglobalvariables')
   finish
endif
let g:loaded_myglobalvariables = 1
"------------------------------------------------------------------------------"
"}}}

let g:vim_dir = $VIM
let g:vimfiles_dir = $VIM . '\vimfiles'
let g:vimruntime = $VIMRUNTIME
let g:vim_tools_dir = g:vim_dir . '\Tools'

" 自己写的函数所用的全局变量{{{2
"------------------------------------------------------------------------------"
" Python解释器
let g:python_dir='C:\\Python27\\python.exe'

" TotalCommander路径
let g:totalcommander_exe = 'd:\\Software\\TotalCMD\\TOTALCMD.EXE'

" vimgrep搜索的文件类型
let g:ext_list = ['txt', 'c', 'h', 'cpp', 'py', 'vim', 'cnx', 'java', 'js', 'html', 'css', 'vimwiki', 'a', 'i', 'asm']
" gnugrep搜索的文件类型
let g:mygrep_ext = ['c', 'h', 'py', 'txt', 'vim']

let g:fe_es_exe = g:vim_tools_dir . '\Everything\es.exe'
let g:fe_et_exe = g:vim_tools_dir . '\Everything\Everything.exe'

let g:git_bin = g:vim_tools_dir . '\git\cmd\git.exe'

" vimwiki用的浏览器
let g:vimwiki_browsers = [
            \  expand('~').'\Local Settings\Application Data\Google\Chrome\Application\chrome.exe',
            \  'd:\Software\ChromePortable\Chrome.exe',
            \  'C:\Program Files\Google\Chrome\Application\chrome.exe',
            \  'C:\Program Files\Opera\opera.exe',
            \  'C:\Program Files\Mozilla Firefox\firefox.exe',
            \  'C:\Program Files\Internet Explorer\iexplore.exe',
            \ ]
