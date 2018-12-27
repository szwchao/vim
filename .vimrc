"===============================================================================
"         Filename: vimrc
"         Author: Wang Chao
"         Email: szwchao@gmail.com
"         Modified: 07-03-2016 4:39:10 PM
"===============================================================================
" 设置 {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" 平台判断 {{{2
"-------------------------------------------------------------------------------
if (has("win32") || has("win95") || has("win64") || has("win16"))
    let g:platform = 'win'
elseif (has("mac"))
    let g:platform = 'mac'
else
    let g:platform = 'linux'
endif

let vim_data_path = expand("~" . "/vim_data")
if !isdirectory(vim_data_path)
    call mkdir(vim_data_path)
endif
"-------------------------------------------------------------------------------
" 设定文件编码类型，解决中文编码问题 {{{2
"-------------------------------------------------------------------------------
set encoding=utf-8
set fileencodings=utf-8,chinese,latin1,utf-16le
if has("win32")
    set fileencoding=chinese
else
    set fileencoding=utf-8
endif
"解决console输出乱码
language messages zh_CN.utf-8
let &termencoding=&encoding
set langmenu=zh_CN.UTF-8
set helplang=cn

"-------------------------------------------------------------------------------
" 插件及设置 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    if has('nvim')
        source ~/AppData/Local/nvim/_vimrc.plugins
    else
        set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME
        source ~/.vim/.vimrc.plugins
    endif
else
    if filereadable(expand("~/.vim/.vimrc.plugins"))
        source ~/.vim/.vimrc.plugins
    endif
endif

"-------------------------------------------------------------------------------
" 字体 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    set guifont=SauceCodePro_NF:h14
    set guifontwide=YaHei\ Consolas\ Hybrid:h14:cANSI
elseif g:platform == 'mac'
    set guifont=SauceCodePro\ NF:h18
else
    set guifont=SauceCodePro\ Nerd\ Font\ Mono\ 13
endif

"-------------------------------------------------------------------------------
" 配色方案 {{{2
"-------------------------------------------------------------------------------
set termguicolors
set background=dark
try
    colorscheme mycolor
endtry

"-------------------------------------------------------------------------------
" 一般设置 {{{2
"-------------------------------------------------------------------------------
let mapleader = ","                       " 设置mapleader为,键
if g:platform == 'win'
    source $VIMRUNTIME/mswin.vim          " 加载mswin.vim
    unmap <C-A>
    behave mswin
    set fileformat=dos                    " 文件格式为dos，否则记事本打开有黑框
else
    exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
    exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']
    noremap <C-Q>		<C-V>
    noremap <C-S>		:update<CR>
    vnoremap <C-S>		<C-C>:update<CR>
    inoremap <C-S>		<C-O>:update<CR>
    set fileformat=unix
endif
set nocompatible                          " 去掉关vi一致性模式，避免以前版本的一些bug和局限
set shortmess=atI                         " 启动的时候不显示援助索马里儿童的提示
set showcmd                               " 开启命令显示
set wildmenu                              " 在输入命令时列出匹配项目
set noerrorbells                          " 无响铃
set novisualbell                          " 使用可视响铃代替鸣叫
set history=500                           " history文件中需要记录的行数
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus     " Linux共享系统剪贴板
else
    set clipboard+=unnamed                " Windows和Mac共享系统剪贴板
endif
set smarttab                              " 智能tab，退格时删除tab长度
set expandtab                             " 插入<Tab>时使用空格
set tabstop=4                             " 设置tab键的宽度
set shiftwidth=4                          " 换行时行间交错使用4个空格，设定<<和>>命令移动时的宽度为4
set backspace=2                           " 设置退格键可用
set guioptions-=m                         " 不显示菜单
set guioptions-=T                         " 不显示工具栏
set winaltkeys=no                         " 去除菜单快捷键
set nu!                                   " 显示行号
set listchars=eol:$,tab:>-,nbsp:~         " 显示行尾、TAB所使用的符号
set wrap                                  " 自动换行
set linebreak                             " 整词换行
set whichwrap=b,s,<,>,[,]                 " 光标从行首和行末时可以跳到另一行去，分别对应退格键、空格键、普通模式下的左右键和插入模式下的左右键
set autochdir                             " 自动设置目录为正在编辑的文件所在的目录
set hidden                                " 没有保存的缓冲区可以自动被隐藏
set scrolloff=3                           " 光标离窗口上下边界的3行时会引起窗口滚动
set noswapfile                            " 禁用swf交换文件
"set iskeyword+=-                         " 形如a-b的作为整词

syntax on                                 " 打开语法高亮
filetype on                               " 自动检测文件类型
filetype plugin on                        " 特定文件类型加载插件
filetype indent on                        " 特定文件类型加载缩进

if (!has('nvim'))
    set viminfo+=n~/vim_data/viminfo
endif

let &backupdir=expand(vim_data_path . "/vimbackup")
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif
set backup                                " 打开自动备份功能

if has("persistent_undo")
    let &undodir=expand(vim_data_path . "/vimundo")
    if !isdirectory(&undodir)
        call mkdir(&undodir)
    endif
    set undofile
endif

let &viewdir=expand(vim_data_path . "/view")
if !isdirectory(&viewdir)
    call mkdir(&viewdir)
endif

"-------------------------------------------------------------------------------
" 编程相关的设置 {{{2
"-------------------------------------------------------------------------------
set completeopt=longest,menu,noinsert     " 关掉智能补全时的预览窗口
set showmatch                             " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set matchtime=0                           " 配对括号的显示时间
set smartindent                           " 智能对齐方式
set autoindent                            " 自动对齐
set cindent                               " C格式自动缩进
set ai!                                   " 设置自动缩进

"-------------------------------------------------------------------------------
" 代码折叠 {{{2
"-------------------------------------------------------------------------------
"set foldmethod=syntax
set foldmethod=indent
set foldenable
set foldlevel=100

"-------------------------------------------------------------------------------
" cscope设置 {{{2
"-------------------------------------------------------------------------------
set cscopequickfix=s-,d-,c-,t-,e-,i-      " 使用quickfix窗口来显示cscope结果
set cst                                   " CTRL-]同时搜索cscope数据库和tag
set csto=1                                " |:cstag| 命令查找的次序。0:cscope优先; 1:tag优先

"-------------------------------------------------------------------------------
" 鼠标支持 {{{2
"-------------------------------------------------------------------------------
if has('mouse')
  set mouse=a
endif
set cursorline                            " 增加鼠标水平线
set cursorcolumn                          " 增加鼠标垂直线

"-------------------------------------------------------------------------------
" 状态栏 {{{2
"-------------------------------------------------------------------------------
set ruler                                 " 在编辑过程中，在右下角显示光标位置的状态行
set cmdheight=1                           " 设定命令行的行数为 1
set laststatus=2                          " 显示状态栏 (默认值为 1, 无法显示状态栏)

"-------------------------------------------------------------------------------
" 自动命令 {{{2
"-------------------------------------------------------------------------------
"当vimrc改变时自动重新载入vimrc
"autocmd! bufwritepost _vimrc source $VIM\\_vimrc
" 彻底关闭警告声
autocmd VimEnter * set vb t_vb=
if g:platform == 'win'
    " Windows下启动时最大化窗口
    autocmd GUIEnter * simalt ~x
endif
" 让打开文件时光标自动到上次退出该文件时的光标所在位置
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
" 缓冲区写入文件的时候自动检查文件类型
autocmd BufWritePost * filet detect
" 取消换行时自动添加注释符
autocmd FileType * setl fo-=cro
" tab长度
autocmd FileType c,cpp,h set tabstop=2
" 缩进长度
autocmd FileType c,cpp,h set shiftwidth=2
" help文件不隐藏||,**
autocmd FileType help setl cole=0
" help文件ESC退出
autocmd FileType help nnoremap <buffer> <ESC> :q<CR>
" 在quickfix窗口中的快捷键
autocmd FileType qf :call QuickfixMap()
" 在markdown文件中的map
autocmd FileType markdown :call MarkdownMap()
" txt, cue, lrc
autocmd BufNewFile,BufRead *.txt    setf txt
" python的折叠方式
autocmd FileType python set foldmethod=indent
" html和css文件的折叠方式
autocmd FileType html,htmldjango,xml,css set foldmethod=indent
" markdown 文件
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
" 编程时超过80行提示
"autocmd FileType c,cpp :match ErrorMsg /\%>80v.\+/
" 关闭python的补全预览窗口
autocmd FileType python setlocal completeopt-=preview
" gitcommit设置拼写检查
autocmd Filetype gitcommit setlocal spell
" gitcommit将光标移至第一行
autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

"-------------------------------------------------------------------------------
" 查找/替换相关的设置 {{{2
"-------------------------------------------------------------------------------
set ic                                 " 搜索不分大小写
set hlsearch                           " 高亮显示搜索结果
set incsearch                          " 输入搜索命令时，显示目前输入的模式的匹配位置

"-------------------------------------------------------------------------------
" 比较文件 {{{2
"-------------------------------------------------------------------------------
" 显示填充行，以垂直方式打开
set diffopt=filler,vertical
" 使用 ":DiffOrig" 查看更改后的文件与源文件不同之处。
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

"-------------------------------------------------------------------------------
" 补全 {{{2
"-------------------------------------------------------------------------------
" 如果下拉菜单弹出，回车映射为接受当前所选项目，否则，仍映射为回车；
" 如果下拉菜单弹出，CTRL-J映射为在下拉菜单中向下翻页。否则映射为CTRL-X CTRL-O；
" 如果下拉菜单弹出，CTRL-K映射为在下拉菜单中向上翻页，否则仍映射为CTRL-K；
" 如果下拉菜单弹出，CTRL-U映射为CTRL-E，即停止补全，否则，仍映射为CTRL-U；
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
"inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"

"===============================================================================
" 自定义快捷键 {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" 重新设置vim自带快捷键 {{{2
"-------------------------------------------------------------------------------
" 插入模式下jj转到普通模式
imap jj <Esc>
" 用b来开关折叠
nnoremap b za
" e上一个词首
nnoremap e b
" t到行首
nnoremap t <ESC>^
vmap t 0
" zz到行末
nnoremap zz <ESC>$
vmap zz $
" 切换buf
nmap <C-Tab> :b #<CR>
" Ctrl+m到较新位置，其实<C-I>等同于<Tab>
"nmap <C-m> <ESC><C-I>
"gw 光标所在单词和下一个单词交换
nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o>
"gW 光标所在单词和上一个单词交换
nmap <silent> gW "_yiw:s/\(\w\+\)\(\_W\+\)\(\%#\w\+\)/\3\2\1/<cr><c-o>
"dp 删除光标所在单词并粘贴系统剪切板内容
nmap <silent> dp "_ciw<C-r>*<ESC>
" Y复制到行末
nmap Y y$
" 分为两行
nmap F i<CR><ESC>
" 转换进制
nmap H <ESC>:call ConvertDigital()<CR>
" 打开/关闭quickfix窗口
nmap S :ToggleQuickfixWindow<CR>

"-------------------------------------------------------------------------------
" <Leader>相关 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    if has('nvim')
        nmap <silent> <leader>e :e ~/AppData/Local/nvim/init.vim<cr>
        nmap <silent> <leader>ep :e ~/AppData/Local/nvim/_vimrc.plugins<cr>
    else
        nmap <silent> <leader>e :e $VIM\\_vimrc<cr>
        nmap <silent> <leader>ep :e $VIM\\_vimrc.plugins<cr>
    endif
else
    nmap <silent> <leader>e :e ~/.vimrc<cr>
    nmap <silent> <leader>ep :e ~/_vimrc.plugins<cr>
endif

" 复制到系统剪贴板
nmap <leader>y "*y
nmap <leader>p "*p
nmap <leader>P "*P
" 保存文件
nmap <leader>s :w<cr>
" 垂直分割窗口
nmap <leader>v <C-W>v
" 切换窗口
nmap <leader>w <C-W>W
" 用浏览器打开当前文件
nmap <leader>o :silent !explorer %:p:h<CR>
" 切换行号/相对行号
nmap <leader>l :ToggleNuMode<CR>

exe "nmap <leader>ww :<C-u>CtrlP " . "c:\\personal\\My\\blog\\source\\_posts\\" . "<CR>"
" 列出当前单词所在行并提供跳转
nmap <Leader>f [I:let nr = input("跳转到：")<Bar>exe "normal " . nr ."[\t"<CR>

"-------------------------------------------------------------------------------
" Fx相关 {{{2
"-------------------------------------------------------------------------------
" F1加载项目
nmap <F1> :call StartMyProject()<CR>
" F3查找
nmap <F3> /\<<C-R><C-W>\><CR>
" Alt+F3多文件内vimgrep查找
nmap <M-F3> <ESC>:call MyVimGrep()<CR>
" Ctrl+F3多文件内GNUGrep查找
nmap <C-F3> <ESC>:MyGrep<CR>
" F5编译运行C、C++、Python程序
nmap <F5> :call CompileRun()<CR>
" Ctrl+F5调试C、C++、Python程序
nmap <C-F5> :call Debug()<CR>
" F6 FindEverything
nmap <F6> :FE<CR>
" F7切换背景
nmap <F7> <ESC>:ToggleBackground<CR>
" Ctrl+F7更换配色方案
nmap <C-F7> <ESC>:ToggleColorScheme<CR>
" F8为函数添加注释(DoxygenToolkit.vim)
nmap <F8> :Dox<CR>
autocmd FileType python nmap <F8> :PD<CR>
" F11全屏
if g:platform == 'win'
    nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
else
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
endif    
" F12切换c/h文件(fswitch.vim)
nmap <silent> <F12> :FSHere<CR>
" Ctrl+F12生成tags
nmap <silent> <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"-------------------------------------------------------------------------------
" cscope快捷键 {{{2
"-------------------------------------------------------------------------------
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
" 0或g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
" 1或d: 查找本函数调用的函数
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" 2或c: 查找调用本函数的函数
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
" 3或t: 查找指定的字符串
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
" 4或e: 查找egrep模式，相当于egrep功能，但查找速度快多了
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
" 5或f: 查找并打开文件，类似vim的find功能
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
" 6或i: 查找包含本文件的文件
nmap <C-\>i :cs find i <C-R>=expand("%")<CR><CR>

"-------------------------------------------------------------------------------
" 其它 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    let g:python_host_prog  = 'c:/Python27/python.exe'
    let g:python3_host_prog = 'c:/Python36/python.exe'
else
    let g:python_host_prog  = '/usr/bin/python'
    let g:python3_host_prog = '/usr/bin/python3'
endif

" 按Alt+m即可切换显示或者关闭显示菜单栏和工具栏.
map <silent> <S-M-m> :if &guioptions =~# 'T' <Bar>
         \set guioptions-=T <Bar>
         \set guioptions-=m <bar>
         \else <Bar>
         \set guioptions+=T <Bar>
         \set guioptions+=m <Bar>
         \endif<CR>

" 缩放窗口
nmap <C-PageUp> <C-W>+
nmap <C-PageDown> <C-W>-

" Shift+Left打开NERDTree
nmap <S-LEFT> <ESC>:NERDTreeToggle<CR>
" Shift+RIGHT打开Tlist
nmap <S-RIGHT> <ESC>:TagbarToggle<CR>
" Shift+DOWN打开Quickfix
nmap <S-DOWN> <ESC>:cw<CR>

" Insert下Alt+h,j,k,l移动光标
imap <M-h> <LEFT>
imap <C-j> <DOWN>
imap <C-k> <UP>
imap <M-l> <RIGHT>

" Ctrl+h,j,k,l切换窗口
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Alt+h向前切换buf，Alt+l向后切换buf
nmap <M-h> :bp<CR>
nmap <M-l> :bn<CR>

" 用相应符号包围visual选择的部分
vmap ( <Esc>:call VisualWrap('(', ')')<CR>
vmap [ <Esc>:call VisualWrap('[', ']')<CR>
vmap { <Esc>:call VisualWrap('{', '}')<CR>
"vmap < <Esc>:call VisualWrap('<', '>')<CR>
vmap " <Esc>:call VisualWrap('"', '"')<CR>
vmap ' <Esc>:call VisualWrap("'", "'")<CR>

if g:platform == 'win'
    " Alt+t用TotalCommander打开当前文件
    nmap <M-t> :!start TOTALCMD64.EXE /o /t /l "%:p"<CR>
    " Alt+c用cmder打开当前文件所在目录
    nmap <M-c> :!start Cmder "%:p:h"<CR>
endif

"}}}2

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
