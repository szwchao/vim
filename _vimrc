"===============================================================================
"         Filename: vimrc
"         Author: Wang Chao
"         Email: szwchao@gmail.com
"         Modified: 06-05-2015 4:50:18 PM
"===============================================================================
"设置 {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" 平台判断 {{{2
"-------------------------------------------------------------------------------
if (has("win32") || has("win95") || has("win64") || has("win16"))
    let g:platform = 'win'
    let g:slash = '\'
elseif (has("mac"))
    let g:platform = 'mac'
    let g:slash = '/'
else
    let g:platform = 'linux'
    let g:slash = '/'
endif

if isdirectory("c:/Users/55602")
    let g:computer_enviroment = "grundfos"
    let temp_dir = "c:/local/temp/"
elseif matchstr(expand("~"), "435736")
    let g:computer_enviroment = "seagate"
    let temp_dir = expand("~") . "//"
else
    let g:computer_enviroment = "normal"
    let temp_dir = expand("~") . "//"
endif
let vim_data_path = expand(temp_dir . "vim_data")
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
"解决consle输出乱码
language messages zh_CN.utf-8
"set encoding=utf-8
"let &termencoding=&encoding
"set fileencodings=ucs-bom,utf-8,gbk,cp936
set langmenu=zh_CN.UTF-8
set helplang=cn

"-------------------------------------------------------------------------------
" 配色方案 {{{2
"-------------------------------------------------------------------------------
colorscheme colorful
"colorscheme bluechia

"-------------------------------------------------------------------------------
" 字体 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    set guifont=YaHei\ Consolas\ Hybrid:h12:cANSI
elseif g:platform == 'mac'
    set guifont=YaHei\ Consolas\ Hybrid:h18
else
    set guifont=YaHei\ Consolas\ Hybrid\ 12
endif

"-------------------------------------------------------------------------------
" bundle设置 {{{2
"-------------------------------------------------------------------------------
call pathogen#infect()

filetype off                   " required!
if g:platform == 'win'
    set rtp+=$VIM/vimfiles/vundle/vundle.vim
    call vundle#begin('$VIM/vimfiles/vundle/')
else
    set rtp+=~/.vim/vundle/vundle.vim
    call vundle#begin('~/.vim/vundle/')
endif
Plugin 'gmarik/Vundle.vim'
Plugin 'szwchao/vimwiki'
Plugin 'bling/vim-airline'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'Shougo/neocomplete.vim'
Plugin 'Shougo/neosnippet.vim'
Plugin 'Shougo/neosnippet-snippets'
Plugin 'kien/ctrlp.vim'
Plugin 'tacahiroy/ctrlp-funky'
Plugin 'JazzCore/ctrlp-cmatcher'
Plugin 'naquad/ctrlp-digraphs.vim'
Plugin 'mattn/calendar-vim'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'hynek/vim-python-pep8-indent'
Plugin 'gregsexton/MatchTag'
Plugin 'wannesm/wmgraphviz.vim'
Plugin 'aklt/plantuml-syntax'
Plugin 'mbbill/fencview'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-surround'
Plugin 'lilydjwg/colorizer'
Bundle 'luochen1990/rainbow'
Plugin 'godlygeek/tabular'
Plugin 'a.vim'
Plugin 'CRefVim'
Plugin 'mru.vim'
Plugin 'DoxygenToolkit.vim'
Plugin 'matchit.zip'
Plugin 'python_match.vim'
Plugin 'OmniCppComplete'
Plugin 'VisIncr'
Plugin 'nvie/vim-rst-tables'
Plugin 'tpope/vim-fugitive'

call vundle#end()            " required
"-------------------------------------------------------------------------------
" 一般设置 {{{2
"-------------------------------------------------------------------------------
let mapleader = ","                       " 设置mapleader为,键
if g:platform == 'win'
    source $VIMRUNTIME/mswin.vim          " 加载mswin.vim
    unmap <C-A>
    behave mswin
    set fileformat=dos                    " 文件格式为dos，否则记事本打开有黑框
elseif g:platform = 'mac'
    set macmeta
    set fileformat=unix
else
    set fileformat=unix
endif
set nocompatible                          " 去掉关vi一致性模式，避免以前版本的一些bug和局限
set shortmess=atI                         " 启动的时候不显示援助索马里儿童的提示
set showcmd                               " 开启命令显示
set wildmenu                              " 在输入命令时列出匹配项目
set noerrorbells                          " 无响铃
set novisualbell                          " 使用可视响铃代替鸣叫
set history=500                           " history文件中需要记录的行数
set clipboard+=unnamed                    " 与Windows共享剪贴板
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

"set viminfo+=n~/vim_data/viminfo
let &backupdir=expand(temp_dir . "vim_data/vimbackup")
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif
set backup                                " 打开自动备份功能

if has("persistent_undo")
    let &undodir=expand(temp_dir . "vim_data/vimundo")
    if !isdirectory(&undodir)
        call mkdir(&undodir)
    endif
    set undofile
endif

if g:computer_enviroment == "grundfos"
    " tab长度
    autocmd FileType c,cpp,h set tabstop=2
    autocmd FileType c,cpp,h set shiftwidth=2
    autocmd FileType python set tabstop=4
    autocmd FileType python set shiftwidth=4
    " Alt+t用TotalCommander打开当前文件
    "nmap <M-t> :!start <C-R>=$g:totalcommander_exe /o /t /l '%:p'
    nmap <M-t> :!start "c:\local\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "c:/local"
elseif g:computer_enviroment == "seagate"
    autocmd FileType c,cpp,h set tabstop=3
    autocmd FileType c,cpp,h set shiftwidth=3
    autocmd FileType python set tabstop=3
    autocmd FileType python set shiftwidth=3
    nmap <M-t> :!start "D:\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "E:"
else
    autocmd FileType c,cpp,h set tabstop=4
    autocmd FileType c,cpp,h set shiftwidth=4
    autocmd FileType python set tabstop=4
    autocmd FileType python set shiftwidth=4
    nmap <M-t> :!start "D:\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "D:"
endif

"-------------------------------------------------------------------------------
" 编程相关的设置 {{{2
"-------------------------------------------------------------------------------
set completeopt=longest,menu              " 关掉智能补全时的预览窗口
set showmatch                             " 设置匹配模式，类似当输入一个左括号时会匹配相应的那个右括号
set matchtime=0                           " 配对括号的显示时间
set smartindent                           " 智能对齐方式
set autoindent                            " 自动对齐
set cindent                               " C格式自动缩进
set ai!                                   " 设置自动缩进

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
"当vimrc改变时自动更新修改时间
autocmd BufWritePre * call LastModified()
" 彻底关闭警告声
autocmd VimEnter * set vb t_vb=
if g:platform == 'win'
    " Windows下启动时最大化窗口
    autocmd GUIEnter * simalt ~x
endif
" 让打开文件时光标自动到上次退出该文件时的光标所在位置
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
" 缓冲区写入文件的时候自动检查文件类型
"autocmd BufWritePost * filet detect
" 取消换行时自动添加注释符
autocmd FileType * setl fo-=cro
" 在quickfix窗口中的快捷键
autocmd FileType qf :call QuickfixMap()
" 在wiki文件中的map
autocmd FileType vimwiki :call WikiMap()
" txt, cue, lrc
autocmd BufNewFile,BufRead *.txt    setf txt
autocmd BufNewFile,BufRead *.cue    setf cue
autocmd BufNewFile,BufRead *.lrc    setf lrc
" python的折叠方式
autocmd FileType python set foldmethod=indent
" html和css文件的折叠方式
autocmd FileType html,htmldjango,xml,css set foldmethod=indent
" markdown 文件
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
" 编程时超过80行提示
"autocmd FileType c,cpp :match ErrorMsg /\%>80v.\+/
" 关闭python的补全预览窗口
autocmd FileType python setlocal completeopt-=preview

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

"-------------------------------------------------------------------------------
" 代码折叠 {{{2
"-------------------------------------------------------------------------------
set foldmethod=syntax
set foldenable
set foldlevel=100

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
nmap <C-D> :b #<CR>
" Ctrl+m到较新位置，其实<C-I>等同于<Tab>
"nmap <C-m> <ESC><C-I>
"gw 光标所在单词和下一个单词交换
nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o>
"gW 光标所在单词和上一个单词交换
nmap <silent> gW "_yiw:s/\(\w\+\)\(\_W\+\)\(\%#\w\+\)/\3\2\1/<cr><c-o>
"gp 删除光标所在单词并粘贴剪切板内容
nmap <silent> gp "_diwP
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
    " <leader>rr重新载入vimrc
    "nmap <silent> <leader>rr :source $VIM\\_vimrc<cr>
    " <leader>e编辑vimrc
    nmap <silent> <leader>e :e $VIM\\_vimrc<cr>
else
    " <leader>rr重新载入vimrc
    "nmap <silent> <leader>rr :source ~/.vimrc<cr>
    " <leader>e编辑vimrc
    nmap <silent> <leader>e :e ~/.vimrc<cr>
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
nmap <leader>f :silent !explorer %:p:h<CR>
" 切换行号/相对行号
nmap <leader>l :ToggleNuMode<CR>

"-------------------------------------------------------------------------------
" Fx相关 {{{2
"-------------------------------------------------------------------------------
" F1加载项目
nmap <F1> :call StartMyProject()<CR>
nmap <C-F1> :call StartVCProject()<CR>
" F2跳转书签
nmap <F2> <Plug>Vm_goto_next_sign
" F3查找
nmap <F3> /\<<C-R><C-W>\><CR>
" Alt+F3多文件内vimgrep查找
nmap <M-F3> <ESC>:call MyVimGrep()<CR>
" Ctrl+F3多文件内GNUGrep查找
nmap <C-F3> <ESC>:MyGrep<CR>
" F4打开最近文件(MRU.vim)
nmap <F4> :MRU<cr>
" F5编译运行C、C++、Python程序
nmap <F5> :call CompileRun()<CR>
" Ctrl+F5调试C、C++、Python程序
nmap <C-F5> :call Debug()<CR>
" F6 FindEverything
nmap <F6> :FE<CR>
" F7更换配色方案
nmap <F7> <ESC>:ToggleColorScheme<CR>
" F8为函数添加注释(DoxygenToolkit.vim)
nmap <F8> :Dox<CR>
autocmd FileType python nmap <F8> :PD<CR>
" F10将wiki转换为html
map <F10> :Wiki2Html<cr>
" Ctrl+F10将所有wiki转换为html
map <C-F10> :WikiAll2Html<cr>
" F11全屏
nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
" F12切换c/h文件(a.vim)
nmap <silent> <F12> :A<CR>
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
" 按Alt+m即可切换显示或者关闭显示菜单栏和工具栏.
map <silent> <M-m> :if &guioptions =~# 'T' <Bar>
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
" Shift+UP打开Calendar
nmap <S-UP> <ESC>:Calendar<CR>

" Insert下Alt+h,j,k,l移动光标
imap <M-h> <LEFT>
imap <M-j> <DOWN>
imap <M-k> <UP>
imap <M-l> <RIGHT>

" Ctrl+h,j,k,l切换窗口
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Alt+h向前切换buf，Alt+l向后切换buf
nmap <M-h> :bp<CR>
nmap <M-l> :bn<CR>
nmap <M-u> :tabp<CR>
nmap <M-o> :tabn<CR>

" 用相应符号包围visual选择的部分
vmap ( <Esc>:call VisualWrap('(', ')')<CR>
vmap [ <Esc>:call VisualWrap('[', ']')<CR>
vmap { <Esc>:call VisualWrap('{', '}')<CR>
"vmap < <Esc>:call VisualWrap('<', '>')<CR>
vmap " <Esc>:call VisualWrap('"', '"')<CR>
vmap ' <Esc>:call VisualWrap("'", "'")<CR>

"===============================================================================
"插件配置 {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" MyProject {{{2
"-------------------------------------------------------------------------------
" 工程目录
if g:platform == 'win'
    let g:MyProjectConfigDir = root_path . '/Workspace/MyProject'
else
    let g:MyProjectConfigDir = expand('~/MyProject')
endif

"-------------------------------------------------------------------------------
" Calendar {{{2
" ------------------------------------------------------------------------------
let g:calendar_mruler = '一月,二月,三月,四月,五月,六月,七月,八月,九月,十月,十一月,十二月'
let g:calendar_wruler = '日 一 二 三 四 五 六'
let g:calendar_navi_label = '上月,今天,下月'
let g:calendar_monday = 1
let g:calendar_weeknm = 1 " WK01
let g:calendar_datetime = 'title'

"-------------------------------------------------------------------------------
" startify {{{2
"-------------------------------------------------------------------------------
let g:startify_show_sessions = 1
let g:startify_custom_header = [
\' ___    __    ___  ______  __    __       ___       ______    __     _______.   ___    ___  __  .___  ___. ',
\' \  \  /  \  /  / /      ||  |  |  |     /   \     /  __  \  (_ )   /       |   \  \  /  / |  | |   \/   | ',
\'  \  \/    \/  / |  .----`|  |__|  |    /  ^  \   |  |  |  |  |/   |   (----`    \  \/  /  |  | |  \  /  | ',
\'   \          /  |  |     |   __   |   /  /_\  \  |  |  |  |        \   \         \    /   |  | |  |\/|  | ',
\'    \   /\   /   |  `----.|  |  |  |  /  _____  \ |  `--`  |    .----)   |         \  /    |  | |  |  |  | ',
\'     \_/  \_/     \______||__|  |__| /__/     \__\ \______/     |_______/           \/     |__| |__|  |__| ',
\'',
\]

"-------------------------------------------------------------------------------
" fencview.vim {{{2
"-------------------------------------------------------------------------------
" 不自动检测编码
let g:fencview_autodetect = 0

"-------------------------------------------------------------------------------
" MRU.vim {{{2
"-------------------------------------------------------------------------------
" 最大列表数目200
let MRU_File = expand(temp_dir . "vim_data/_vim_mru_files")
let MRU_Max_Entries = 200

"-------------------------------------------------------------------------------
" CRefVim.vim {{{2
"-------------------------------------------------------------------------------
map <silent> <unique> <Leader>ct <Plug>CRV_CRefVimInvoke

"-------------------------------------------------------------------------------
" neocomplete {{{2
" ------------------------------------------------------------------------------
let g:neocomplete#data_directory = expand(temp_dir . 'vim_data/.neocomplete')
" 使neocomplete自动启动
let g:neocomplete#enable_at_startup = 1
" 使neocomplete自动选择第一个
let g:neocomplete#enable_auto_select = 1
" <C-u>取消选择
imap <expr><M-y>  neocomplete#close_popup()
imap <expr><M-u>  neocomplete#cancel_popup()

let g:neocomplete#sources#omni#functions = {'python': 'jedi#completions', 'dot': 'GraphvizComplete'}

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'c' : $VIM.'/vimfiles/dict/c.dict',
            \ 'cpp' : $VIM.'/viiles/dict/cpp.dict',
            \ 'vim' : $VIM.'/viiles/dict/vim.dict'
            \ }

" jedi-vim配置
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

let g:jedi#completions_command = "<C-N>"

" 处于文本模式的文件类型
let g:neocomplete#text_mode_filetypes = {'markdown' : 1, 'gitcommit' : 1, 'text' : 1, 'vimwiki' : 1,}

call neocomplete#custom#source('buffer', 'mark', '[缓冲区]')
call neocomplete#custom#source('dictionary', 'mark', '[字典]')
call neocomplete#custom#source('file', 'mark', '[文件]')
call neocomplete#custom#source('member', 'mark', '[成员]')
call neocomplete#custom#source('omni', 'mark', '[OMNI]')
call neocomplete#custom#source('syntax', 'mark', '[语法]')


"-------------------------------------------------------------------------------
" neosnippet {{{2
" ------------------------------------------------------------------------------
let g:neocomplete#data_directory = expand(temp_dir . 'vim_data/.neosnippet')
" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"-------------------------------------------------------------------------------
" FuzzyFinder.vim {{{2
"-------------------------------------------------------------------------------
let g:fuf_dataDir = expand(temp_dir . 'vim_data/.vim-fuf-data')
let g:fuf_keyPreview = '<M-x>'
let g:fuf_previewHeight = 0
let g:fuf_autoPreview = 0
let g:fuf_maxMenuWidth = 200
nmap <M-a> :FufBookmarkFile<CR>
nmap <M-r> :FufTaggedFile<CR>
nmap <M-d> :FufBuffer<CR>
nmap <M-f> :FufFile<CR>
nmap <M-q> :FufQuickfix<CR>
nmap <M-w> :call fuf#mycmd#launch('', 0, '')<CR>
nmap <M-e> :FufLine<CR>
nmap <M-s> :FufMyProject<CR>
nmap <M-j> :FufJumpList<CR>
nmap <M-k> :FufChangeList<CR>

"-------------------------------------------------------------------------------
" TagBar {{{2
"-------------------------------------------------------------------------------
let g:tagbar_sort = 0
let g:tagbar_show_visibility = 1
let g:tagbar_show_linenumbers = 1

"-------------------------------------------------------------------------------
" OmniCppComplete {{{2
" ------------------------------------------------------------------------------
" 命名空间查找控制。0 : 禁止查找命名空间, 1 : 查找当前文件缓冲区内的命名空间(缺省), 2 : 查找当前文件缓冲区和包含文件中的命名空间
let OmniCpp_NamespaceSearch = 1
" 全局查找控制。0:禁止；1:允许(缺省)
let OmniCpp_GlobalScopeSearch = 1
" 是否显示访问控制信息('+', '-', '#')。0/1, 缺省为1(显示)
let OmniCpp_ShowAccess = 1
" 是否是补全提示缩略信息中显示函数原型。0：不显示，1：显示（缺省）
let OmniCpp_ShowPrototypeInAbbr = 1
" 在'.'号后是否自动给出提示信息。0/1, 缺省为1
let OmniCpp_MayCompleteDot = 1
" 在'->'号后是否自动给出提示信息。0/1, 缺省为1
let OmniCpp_MayCompleteArrow = 1
" 在'::'号后是否自动给出提示信息。0/1, 缺省为1
let OmniCpp_MayCompleteScope = 1
" 是否自动选择第一个匹配项。0 : 不选择第一项(缺省) 1 : 选择第一项并插入到光标位置 2 : 选择第一项但不插入光标位置
let OmniCpp_SelectFirstItem = 2
" 默认命名空间列表，项目间使用','隔开。
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

"-------------------------------------------------------------------------------
" NERD_commenter {{{2
" ------------------------------------------------------------------------------
" 将C语言的注释符号改为//, 默认是/**/
"let NERD_c_alt_style = 1
" 定义Alt+/为注释快捷键
nmap <M-/> ,cc
" 定义Alt+.为取消注释快捷键
nmap <M-.> ,cu

"-------------------------------------------------------------------------------
" DoxygenToolkit.vim {{{2
" ------------------------------------------------------------------------------
let g:DoxygenToolkit_compactDoc = "yes"
"let g:DoxygenToolkit_commentType = "C++"
let g:doxygenToolkit_briefTag_funcName="yes"

"let g:DoxygenToolkit_briefTag_pre="@函数说明：   "
"let g:DoxygenToolkit_paramTag_pre="@参    数：   "
"let g:DoxygenToolkit_returnTag="@返 回 值：   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="wchao"
let g:doxygen_enhanced_color = 1

"-------------------------------------------------------------------------------
" VimWiki {{{2
" ------------------------------------------------------------------------------
" 设置编码
let g:vimwiki_w32_dir_enc = 'utf-8'
" 使用鼠标
let g:vimwiki_use_mouse = 1
" 高亮标题颜色
let g:vimwiki_hl_headers = 1
" 是否开启按语法折叠  会让文件比较慢
"let g:vimwiki_folding = 1
" 是否在计算字串长度时用特别考虑中文字符
let g:vimwiki_CJK_length = 1
" 设置在wiki内使用的html标识
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,ul,li,p,a,small'
" 切换todo
autocmd FileType vimwiki map <M-Enter> <Plug>VimwikiToggleListItem

let g:vimwiki_ext2syntax = {'.md': 'markdown', '.mkd': 'markdown', '.wiki': 'vimwiki'}

let seagate_wiki = {'path': root_path . '/My/MyWiki/SeagateWiki/wiki_files/',
            \ 'path_html': root_path . '/My/MyWiki/SeagateWiki/',
            \ 'template_path': root_path . '/My/MyWiki/SeagateWiki/assets/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}
let wiki = {'path': root_path . '/My/Wiki/wiki_files/',
            \ 'path_html': root_path . '/My/Wiki/',
            \ 'syntax': 'markdown', 'ext': '.md',
            \ 'template_path': root_path. '/My/Wiki/assets/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',}

let g:vimwiki_list = [wiki]

"-------------------------------------------------------------------------------
" rainbow {{{2
" ------------------------------------------------------------------------------
let g:rainbow_active = 1
let g:rainbow_operators = 1

"-------------------------------------------------------------------------------
" Vim-Airline {{{2
" ------------------------------------------------------------------------------
" 不自动检测行尾空格
let g:airline#extensions#whitespace#enabled = 0
" 打开上面的smarttab
let g:airline#extensions#tabline#enabled = 1
" smartbar只留文件名和扩展名
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
" 不包含在tabline里的文件
let g:airline#extensions#tabline#excludes = ['__doc__']
" 打开buffer的index
let g:airline#extensions#tabline#buffer_idx_mode = 1
" 切换buffer快捷键
nmap <M-1> <Plug>AirlineSelectTab1
nmap <M-2> <Plug>AirlineSelectTab2
nmap <M-3> <Plug>AirlineSelectTab3
nmap <M-4> <Plug>AirlineSelectTab4
nmap <M-5> <Plug>AirlineSelectTab5
nmap <M-6> <Plug>AirlineSelectTab6
nmap <M-7> <Plug>AirlineSelectTab7
nmap <M-8> <Plug>AirlineSelectTab8
nmap <M-9> <Plug>AirlineSelectTab9

" 更换主题
let g:airline_theme='mytheme'
" 关闭tagbar，防止每次都调用ctags
let g:airline#extensions#tagbar#enabled = 0
" 语法检查
let g:airline#extensions#syntastic#enabled = 1
" 增强字体
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ' '
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' '

"-------------------------------------------------------------------------------
" Tabular {{{2
" ------------------------------------------------------------------------------
vmap <Enter> :Tab /

"-------------------------------------------------------------------------------
" plantuml {{{2
" ------------------------------------------------------------------------------
let g:plantuml_executable_script = $VIM. '/tools/plantuml/plantuml.jar -charset utf-8 '

"-------------------------------------------------------------------------------
" WMGraphviz_dot {{{2
" ------------------------------------------------------------------------------
let g:WMGraphviz_dot = $VIM . "/tools/Graphviz/bin/dot.exe"

" ctrlp {{{2
" ------------------------------------------------------------------------------
" 修改该选项为1，设置默认为按文件名搜索（否则为全路径）。在提示符面板内可以使用 <c-d> 来切换。
let g:ctrlp_by_filename = 1
" 改变匹配窗口的位置，结果的排列顺序，最小和最大高度:
let g:ctrlp_match_window = 'bottom,order:ttb,results:50'
" 使用该选项来设置自定义的根目录标记作为对默认标记(.hg, .svn, .bzr, and _darcs)的补充。自定义的标记具有优先权:
let g:ctrlp_root_markers = ['.git', 'view.dat']
" 扩展
"let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_extensions = ['funky']
" 扫描文件的最大数量，设置为0时不进行限制
let g:ctrlp_max_files = 0
" 在CtrlP中隐藏的文件和目录
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$|debug$|release$|objs$',
    \ 'file': '\v\.(exe|so|dat|dll|bin|hex|doc|docx|ppt|pptx|xls|xlsx|mdb|lib|o|ncb|pyc|obj|msi|resources|jpg|bmp|png|temp|tmp)$',
    \ }

" 为CtrlP设置一个额外的模糊匹配函数
let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }

let g:ctrlp_funky_syntax_highlight = 1

"}}}1

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
