
" ��ֹ��������ű�{{{2
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

" �Լ�д�ĺ������õ�ȫ�ֱ���{{{2
"------------------------------------------------------------------------------"
" Python������
let g:python_dir='C:\\Python27\\python.exe'

" TotalCommander·��
let g:totalcommander_exe = 'd:\\Software\\TotalCMD\\TOTALCMD.EXE'

" vimgrep�������ļ�����
let g:ext_list = ['txt', 'c', 'h', 'cpp', 'py', 'vim', 'cnx', 'java', 'js', 'html', 'css', 'vimwiki', 'a', 'i', 'asm']
" gnugrep�������ļ�����
let g:mygrep_ext = ['c', 'h', 'py', 'txt', 'vim']

let g:fe_es_exe = g:vim_tools_dir . '\Everything\es.exe'
let g:fe_et_exe = g:vim_tools_dir . '\Everything\Everything.exe'

let g:git_bin = g:vim_tools_dir . '\git\cmd\git.exe'

" vimwiki�õ������
let g:vimwiki_browsers = [
            \  expand('~').'\Local Settings\Application Data\Google\Chrome\Application\chrome.exe',
            \  'd:\Software\ChromePortable\Chrome.exe',
            \  'C:\Program Files\Google\Chrome\Application\chrome.exe',
            \  'C:\Program Files\Opera\opera.exe',
            \  'C:\Program Files\Mozilla Firefox\firefox.exe',
            \  'C:\Program Files\Internet Explorer\iexplore.exe',
            \ ]
