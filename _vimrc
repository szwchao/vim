"===============================================================================
"         Filename: vimrc
"         Author: Wang Chao
"         Email: szwchao@gmail.com
"         Modified: 2014/5/24 8:32:22
"===============================================================================
"设置 {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" 平台判断 {{{2
"-------------------------------------------------------------------------------
if (has("win32") || has("win95") || has("win64") || has("win16"))
    let g:platform = 'win'
    let g:slash = '\'
else
    let g:platform = 'linux'
    let g:slash = '/'
endif

if isdirectory("c:/local/55602")
    let g:computer_enviroment = "grundfos"
elseif matchstr(expand("~"), "435736")
    let g:computer_enviroment = "seagate"
else
    let g:computer_enviroment = "normal"
endif
let vim_data_path = expand("~/vim_data")
if !isdirectory(vim_data_path)
    call mkdir(vim_data_path)
endif
"-------------------------------------------------------------------------------
" 设定文件编码类型，解决中文编码问题 {{{2
"-------------------------------------------------------------------------------
set encoding=utf-8
set fileencodings=utf-8,chinese,utf-16le,latin-1
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
set helplang=cn

"-------------------------------------------------------------------------------
" 配色方案 {{{2
"-------------------------------------------------------------------------------
"colorscheme colorful
colorscheme bluechia

"-------------------------------------------------------------------------------
" 字体 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    set guifont=YaHei\ Consolas\ Hybrid:h12:cANSI
else
    set guifont=YaHei\ Consolas\ Hybrid\ 12
endif

"-------------------------------------------------------------------------------
" bundle设置 {{{2
"-------------------------------------------------------------------------------
call pathogen#infect()

filetype off                   " required!
if g:platform == 'win'
    set rtp+=$VIM/vimfiles/vundle/vundle
    call vundle#rc('$VIM/vimfiles/vundle/')
else
    set rtp+=~/.vim/vundle/vundle
    call vundle#rc('~/.vim/vundle/')
endif
Bundle 'gmarik/vundle'

Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Shougo/neocomplete.vim'
Bundle 'bling/vim-airline'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'a.vim'
Bundle 'CRefVim'
Bundle 'MatchTag'
Bundle 'FencView.vim'
Bundle 'colorizer'
Bundle 'DoxygenToolkit.vim'
Bundle 'matchit.zip'
Bundle 'python_match.vim'
Bundle 'QuickBuf'

"-------------------------------------------------------------------------------
" 一般设置 {{{2
"-------------------------------------------------------------------------------
let mapleader = ","                       " 设置mapleader为,键
if g:platform == 'win'
    source $VIMRUNTIME/mswin.vim          " 加载mswin.vim
    unmap <C-A>
    behave mswin
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
set fileformat=dos                        " 文件格式为dos，否则记事本打开有黑框

syntax on                                 " 打开语法高亮
filetype on                               " 自动检测文件类型
filetype plugin on                        " 特定文件类型加载插件
filetype indent on                        " 特定文件类型加载缩进

"set viminfo+=n~/vim_data/viminfo
let &backupdir=expand("~/vim_data/vimbackup")
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif
set backup                                " 打开自动备份功能

if has("persistent_undo")
    let &undodir=expand("~/vim_data/vimundo")
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
    nmap <M-t> :!start "H:\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "H"
elseif g:computer_enviroment == "seagate"
    autocmd FileType c,cpp,h set tabstop=3
    autocmd FileType c,cpp,h set shiftwidth=3
    autocmd FileType python set tabstop=3
    autocmd FileType python set shiftwidth=3
    nmap <M-t> :!start "D:\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "E"
else
    autocmd FileType c,cpp,h set tabstop=4
    autocmd FileType c,cpp,h set shiftwidth=4
    autocmd FileType python set tabstop=4
    autocmd FileType python set shiftwidth=4
    nmap <M-t> :!start "D:\Software\TotalCMD\TOTALCMD64.EXE" /o /t /l "%:p"<CR>
    let root_path = "D"
endif

"-------------------------------------------------------------------------------
" 编程相关的设置 {{{2
"-------------------------------------------------------------------------------
set completeopt=longest,menu,preview      " 关掉智能补全时的预览窗口
                                          " 自动补全(ctrl-p)时的一些选项：
                                          " 多于一项时显示菜单，最长选择，显示当前选择的额外信息
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
"au BufEnter,BufNew,BufRead,BufNewFile * call SetMyStatusLine()
" 标题栏显示函数名
"set updatetime=500
"autocmd CursorHold * if ((&filetype == 'c') || (&filetype == 'python')) | let &titlestring='%f%m (%F)%<%='.GetFunctionName() | endif

"-------------------------------------------------------------------------------
" 自动命令 {{{2
"-------------------------------------------------------------------------------
"当vimrc改变时自动重新载入vimrc
"autocmd! bufwritepost _vimrc source $VIM\\_vimrc
"当vimrc改变时自动更新修改时间
autocmd BufWritePre * call LastModified()
" 彻底关闭警告声
autocmd VimEnter * set vb t_vb=
" Windows下启动时最大化窗口
autocmd GUIEnter * simalt ~x
" 让打开文件时光标自动到上次退出该文件时的光标所在位置
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
" 缓冲区写入文件的时候自动检查文件类型
"autocmd BufWritePost * filet detect
" 取消换行时自动添加注释符
autocmd FileType * setl fo-=cro
" 指定全能补全所用的函数
autocmd FileType c,cpp,h set omnifunc=ccomplete#Complete
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
" 设定字典补全文件
autocmd FileType c set dictionary+=$VIM\vimfiles\dict\c_keywords.txt
autocmd FileType python set dictionary+=$VIM\vimfiles\dict\python_keywords.txt

"-------------------------------------------------------------------------------
" 查找/替换相关的设置 {{{2
"-------------------------------------------------------------------------------
set ic                                 " 搜索不分大小写
set hlsearch                           " 高亮显示搜索结果
set incsearch                          " 输入搜索命令时，显示目前输入的模式的匹配位置

"-------------------------------------------------------------------------------
" 比较文件 {{{2
"-------------------------------------------------------------------------------
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

"-------------------------------------------------------------------------------
" <Leader>相关 {{{2
"-------------------------------------------------------------------------------
if g:platform == 'win'
    " <leader>rr重新载入vimrc
    nmap <silent> <leader>rr :source $VIM\\_vimrc<cr>
    " <leader>e编辑vimrc
    nmap <silent> <leader>e :e $VIM\\_vimrc<cr>
else
    " <leader>rr重新载入vimrc
    nmap <silent> <leader>rr :source ~/.vimrc<cr>
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
" 切换补全函数
nmap <leader>of :call ToggleOmnifunc()<CR>

"-------------------------------------------------------------------------------
" Fx相关 {{{2
"-------------------------------------------------------------------------------
" F1加载项目
nmap <F1> :call StartMyProject()<CR>
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
" F9切换qbuf
let g:qb_hotkey = "<F9>"
" F10将wiki转换为html
map <F10> :Vimwiki2HTMLBrowse<cr>
" Ctrl+F10将所有wiki转换为html
map <C-F10> :VimwikiAll2HTML<cr>
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

nmap <C-_>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

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
map <kPlus> <C-W>+
map <kMinus> <C-W>-
map <kDivide> <C-W><
map <kMultiply> <C-W>>
nmap <C-PageUp> <C-W>+
nmap <C-PageDown> <C-W>-

" Shift+Left打开NERDTree
nmap <S-LEFT> <ESC>:NERDTreeToggle<CR>
" Shift+RIGHT打开Tlist
nmap <S-RIGHT> <ESC>:TagbarToggle<CR>
" Shift+DOWN打开SrcExplToggle
nmap <S-DOWN> <ESC>:SrcExplToggle<CR>
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

" 按CTRL快速移动文本，非常方便
"nmap <C-Down> :<C-u>move.+1<CR>
"nmap <C-Up> :<C-u>move.-2<CR>
"imap <C-Down> <C-o>:<C-u>move.+1<CR>
"imap <C-Up> <C-o>:<C-u>move.-2<CR>
"vmap <C-Down> :move '>+1<CR>gv
"vmap <C-Up> :move '<-2<CR>gv

" Alt+h向前切换buf，Alt+l向后切换buf
nmap <M-h> :bp<CR>
nmap <M-l> :bn<CR>
nmap <M-u> :tabp<CR>
nmap <M-o> :tabn<CR>

" 用相应符号包围visual选择的部分
vmap ( <Esc>:call VisualWrap('(', ')')<CR>
vmap [ <Esc>:call VisualWrap('[', ']')<CR>
vmap { <Esc>:call VisualWrap('{', '}')<CR>
vmap < <Esc>:call VisualWrap('<', '>')<CR>
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
    let g:MyProjectConfigDir = root_path . ':\Workspace\MyProject'
else
    let g:MyProjectConfigDir = expand('~/MyProject')
endif

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
let MRU_File = expand("~/vim_data/_vim_mru_files")
let MRU_Max_Entries = 200

"-------------------------------------------------------------------------------
" CRefVim.vim {{{2
"-------------------------------------------------------------------------------
map <silent> <unique> <Leader>ct <Plug>CRV_CRefVimInvoke

"-------------------------------------------------------------------------------
" neocomplete {{{2
" ------------------------------------------------------------------------------
let g:neocomplete#data_directory = '~/vim_data/.neocomplete'
" 使neocomplete自动启动
let g:neocomplete#enable_at_startup = 1
" 使neocomplete自动选择第一个
let g:neocomplete#enable_auto_select = 1
" <C-u>取消选择
imap <expr><M-y>  neocomplete#close_popup()
imap <expr><M-u>  neocomplete#cancel_popup()

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'c' : $VIM.'/dict/c.dict',
            \ 'vim' : $VIM.'/dict/vim.dict'
            \ }


"-------------------------------------------------------------------------------
" FuzzyFinder.vim {{{2
"-------------------------------------------------------------------------------
let g:fuf_dataDir = '~/vim_data/.vim-fuf-data'
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

"-------------------------------------------------------------------------------
" EasyMotion {{{2
"-------------------------------------------------------------------------------
let g:EasyMotion_leader_key = 'f'
let g:EasyMotion_do_shade = 1
hi link EasyMotionTarget Ignore
"-------------------------------------------------------------------------------
" snipMate.vim {{{2
"-------------------------------------------------------------------------------
" Alt+a显示所有代码段缩写
imap <M-a> <C-r><Tab>

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

let g:DoxygenToolkit_briefTag_pre="@函数说明：   "
let g:DoxygenToolkit_paramTag_pre="@参    数：   "
let g:DoxygenToolkit_returnTag="@返 回 值：   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="wchao"

"-------------------------------------------------------------------------------
" VimWiki (vimwiki.vim) {{{2
" ------------------------------------------------------------------------------
" 设置编码
let g:vimwiki_w32_dir_enc = 'utf-8'
" 不需要驼峰式词组作为wiki词条
let g:vimwiki_camel_case = 0
" 使用鼠标
let g:vimwiki_use_mouse = 1
let g:vimwiki_file_exts = 'c, cpp, wav, txt, h, hpp, zip, sh, awk, ps, pdf'
" 高亮标题颜色
let g:vimwiki_hl_headers = 1
" 是否开启按语法折叠  会让文件比较慢
"let g:vimwiki_folding = 1
" 启用折叠子列表项
let g:vimwiki_fold_lists = 1
" 是否在计算字串长度时用特别考虑中文字符
let g:vimwiki_CJK_length = 1
" 设置在wiki内使用的html标识
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,ul,li,p,a,small'
" 切换todo
autocmd FileType vimwiki map <M-Enter> <Plug>VimwikiToggleListItem

let seagate_wiki = {'path': root_path . ':/My/MyWiki/SeagateWiki/wiki_files/',
            \ 'path_html': root_path . ':/My/MyWiki/SeagateWiki/',
            \ 'template_path': root_path . ':/My/MyWiki/SeagateWiki/assets/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}
let grundfos_wiki = {'path': root_path . ':/My/MyWiki/GrundfosWiki/wiki_files/',
            \ 'path_html': root_path . ':/My/MyWiki/GrundfosWiki/',
            \ 'template_path': root_path. ':/My/MyWiki/GrundfosWiki/assets/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}

let wiki = {'path': $vim.'/vimfiles/vimwiki/wiki/',
            \ 'path_html': $vim.'/vimfiles/vimwiki/wiki/html/',
            \ 'template_path': $vim.'/vimfiles/vimwiki/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}
let g:vimwiki_list = [grundfos_wiki, seagate_wiki, wiki]

"-------------------------------------------------------------------------------
" rainbow {{{2
" ------------------------------------------------------------------------------
let g:rainbow_active = 1
let g:rainbow_operators = 1

"-------------------------------------------------------------------------------
" buftabs {{{2
" ------------------------------------------------------------------------------
let g:buftabs_only_basename=1
let g:buftabs_in_statusline=1

"-------------------------------------------------------------------------------
" SrcExpl {{{2
" ------------------------------------------------------------------------------
let g:SrcExpl_isUpdateTags = 0

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
" 更换主题
let g:airline_theme='mytheme'
let g:airline#extensions#bufferline#enabled = 1
" 关闭tagbar，防止每次都调用ctags
let g:airline#extensions#tagbar#enabled = 0
" 语法检查
let g:airline#extensions#syntastic#enabled = 1
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
"}}}1

" vim:fdm=marker:fmr={{{,}}}
