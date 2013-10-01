"===============================================================================
"         Filename: vimrc
"         Author: Wang Chao
"         Email: szwchao@gmail.com
"         Modified: 2013/10/1 20:23:14
"===============================================================================
"���� {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" ƽ̨�ж� {{{2
"-------------------------------------------------------------------------------
if (has("win32") || has("win95") || has("win64") || has("win16"))
   let g:platform = 'win'
else
   let g:platform = 'linux'
endif

"-------------------------------------------------------------------------------
" �趨�ļ��������ͣ�������ı������� {{{2
"-------------------------------------------------------------------------------
"set encoding=utf-8
let &termencoding=&encoding
set fileencodings=ucs-bom,utf-8,gbk,cp936
set helplang=cn

"-------------------------------------------------------------------------------
" ��ɫ���� {{{2
"-------------------------------------------------------------------------------
colorscheme colorful
"colorscheme bluechia

"-------------------------------------------------------------------------------
" ���� {{{2
"-------------------------------------------------------------------------------
set guifont=YaHei\ Consolas\ Hybrid:h14:cANSI
"set guifont=Yahei_Mono:h12:cANSI 

"-------------------------------------------------------------------------------
" bundle���� {{{2
"-------------------------------------------------------------------------------
call pathogen#infect()

filetype off                   " required!
set rtp+=$VIM/vimfiles/vundle/vundle
call vundle#rc('$VIM/vimfiles/vundle/')
Bundle 'gmarik/vundle'

Bundle 'majutsushi/tagbar'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'Shougo/neocomplete.vim'
Bundle 'CRefVim'
Bundle 'MatchTag'
Bundle 'FencView.vim'
Bundle 'colorizer'
Bundle 'DoxygenToolkit.vim'
Bundle 'matchit.zip'
Bundle 'python_match.vim'
Bundle 'QuickBuf'

"-------------------------------------------------------------------------------
" һ������ {{{2
"-------------------------------------------------------------------------------
let mapleader = ","                       " ����mapleaderΪ,��
source $VIMRUNTIME/mswin.vim              " ����mswin.vim
unmap <C-A>
behave mswin
set nocompatible                          " ȥ����viһ����ģʽ��������ǰ�汾��һЩbug�;���
set shortmess=atI                         " ������ʱ����ʾԮ���������ͯ����ʾ
set showcmd                               " ����������ʾ
set wildmenu                              " ����������ʱ�г�ƥ����Ŀ
set noerrorbells                          " ������
set novisualbell                          " ʹ�ÿ��������������
set history=500                           " history�ļ�����Ҫ��¼������
set clipboard+=unnamed                    " ��Windows���������
set smarttab                              " ����tab���˸�ʱɾ��tab����
set expandtab                             " ����<Tab>ʱʹ�ÿո�
set tabstop=4                             " ����tab���Ŀ��
set shiftwidth=4                          " ����ʱ�м佻��ʹ��4���ո��趨<<��>>�����ƶ�ʱ�Ŀ��Ϊ4
set backspace=2                           " �����˸������
set guioptions-=m                         " ����ʾ�˵�
set guioptions-=T                         " ����ʾ������
set winaltkeys=no                         " ȥ���˵���ݼ�
set nu!                                   " ��ʾ�к�
set listchars=eol:$,tab:>-,nbsp:~         " ��ʾ��β��TAB��ʹ�õķ���
set wrap                                  " �Զ�����
set linebreak                             " ���ʻ���
set whichwrap=b,s,<,>,[,]                 " �������׺���ĩʱ����������һ��ȥ���ֱ��Ӧ�˸�����ո������ͨģʽ�µ����Ҽ��Ͳ���ģʽ�µ����Ҽ�
set autochdir                             " �Զ�����Ŀ¼Ϊ���ڱ༭���ļ����ڵ�Ŀ¼
set hidden                                " û�б���Ļ����������Զ�������
set scrolloff=3                           " ����봰�����±߽��3��ʱ�����𴰿ڹ���
set noswapfile                            " ����swf�����ļ�
"set iskeyword+=-                         " ����a-b����Ϊ����
set fileformat=dos                        " �ļ���ʽΪdos��������±����кڿ�

syntax on                                 " ���﷨����
filetype on                               " �Զ�����ļ�����
filetype plugin on                        " �ض��ļ����ͼ��ز��
filetype indent on                        " �ض��ļ����ͼ�������

let &backupdir=expand("~/vimbackup")
if !isdirectory(&backupdir)
    call mkdir(&backupdir)
endif
set backup                               " ���Զ����ݹ���

if has("persistent_undo")
  "let &undodir=expand("$Vim/vimfiles/undodir")
  let &undodir=expand("~/vimundo")
  if !isdirectory(&undodir)
    call mkdir(&undodir)
  endif
  set undofile
endif

"-------------------------------------------------------------------------------
" �����ص����� {{{2
"-------------------------------------------------------------------------------
set completeopt=longest,menu,preview      " �ص����ܲ�ȫʱ��Ԥ������
                                          " �Զ���ȫ(ctrl-p)ʱ��һЩѡ�
                                          " ����һ��ʱ��ʾ�˵����ѡ����ʾ��ǰѡ��Ķ�����Ϣ
set showmatch                             " ����ƥ��ģʽ�����Ƶ�����һ��������ʱ��ƥ����Ӧ���Ǹ�������
set matchtime=0                           " ������ŵ���ʾʱ��
set smartindent                           " ���ܶ��뷽ʽ
set autoindent                            " �Զ�����
set cindent                               " C��ʽ�Զ�����
set ai!                                   " �����Զ�����

"-------------------------------------------------------------------------------
" cscope���� {{{2
"-------------------------------------------------------------------------------
set cscopequickfix=s-,d-,c-,t-,e-,i-      " ʹ��quickfix��������ʾcscope���
set cst                                   " CTRL-]ͬʱ����cscope���ݿ��tag
set csto=1                                " |:cstag| ������ҵĴ���0:cscope����; 1:tag����

"-------------------------------------------------------------------------------
" ���֧�� {{{2
"-------------------------------------------------------------------------------
if has('mouse')
  set mouse=a
endif
set cursorline                            " �������ˮƽ��
set cursorcolumn                          " ������괹ֱ��

"-------------------------------------------------------------------------------
" ״̬�� {{{2
"-------------------------------------------------------------------------------
set ruler                                 " �ڱ༭�����У������½���ʾ���λ�õ�״̬��
set cmdheight=1                           " �趨�����е�����Ϊ 1
set laststatus=2                          " ��ʾ״̬�� (Ĭ��ֵΪ 1, �޷���ʾ״̬��)
au BufEnter,BufNew,BufRead,BufNewFile * call SetMyStatusLine()
" ��������ʾ������
"set updatetime=500
"autocmd CursorHold * if ((&filetype == 'c') || (&filetype == 'python')) | let &titlestring='%f%m (%F)%<%='.GetFunctionName() | endif

"-------------------------------------------------------------------------------
" �Զ����� {{{2
"-------------------------------------------------------------------------------
"��vimrc�ı�ʱ�Զ���������vimrc
"autocmd! bufwritepost _vimrc source $VIM\\_vimrc
"��vimrc�ı�ʱ�Զ������޸�ʱ��
autocmd BufWritePre * call LastModified()
" ���׹رվ�����
autocmd VimEnter * set vb t_vb=
" Windows������ʱ��󻯴���
autocmd GUIEnter * simalt ~x
" �ô��ļ�ʱ����Զ����ϴ��˳����ļ�ʱ�Ĺ������λ��
autocmd BufReadPost * if line("'\"") && line("'\"") <= line("$") | exe "normal `\"" | endif
" ������д���ļ���ʱ���Զ�����ļ�����
"autocmd BufWritePost * filet detect
" ȡ������ʱ�Զ����ע�ͷ�
autocmd FileType * setl fo-=cro
" ָ��ȫ�ܲ�ȫ���õĺ���
autocmd FileType c,cpp,h set omnifunc=ccomplete#Complete
" ��quickfix�����а�vԤ��
autocmd FileType qf :call QuickfixMap()
" ��wiki�ļ��е�map
autocmd FileType vimwiki :call WikiMap()
" txt, cue, lrc
autocmd BufNewFile,BufRead *.txt    setf txt
autocmd BufNewFile,BufRead *.cue    setf cue
autocmd BufNewFile,BufRead *.lrc    setf lrc
" c��tab����
autocmd FileType c,cpp,h set tabstop=3
autocmd FileType c,cpp,h set shiftwidth=3
" python��tab����
autocmd FileType python set tabstop=3
autocmd FileType python set shiftwidth=3
autocmd FileType python set foldmethod=indent
" html��css�ļ����۵���ʽ
autocmd FileType html,htmldjango,xml,css set foldmethod=indent
" markdown �ļ�
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
" ���ʱ����80����ʾ
"autocmd FileType c,cpp :match ErrorMsg /\%>80v.\+/
" �趨�ֵ䲹ȫ�ļ�
autocmd FileType c set dictionary+=$VIM\vimfiles\dictionary\c_keywords.txt
autocmd FileType python set dictionary+=$VIM\vimfiles\dictionary\python_keywords.txt

"-------------------------------------------------------------------------------
" ����/�滻��ص����� {{{2
"-------------------------------------------------------------------------------
set ic                                 " �������ִ�Сд
set hlsearch                           " ������ʾ�������
set incsearch                          " ������������ʱ����ʾĿǰ�����ģʽ��ƥ��λ��

"-------------------------------------------------------------------------------
" �Ƚ��ļ� {{{2
"-------------------------------------------------------------------------------
" ʹ�� ":DiffOrig" �鿴���ĺ���ļ���Դ�ļ���֮ͬ����
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

"-------------------------------------------------------------------------------
" ��ȫ {{{2
"-------------------------------------------------------------------------------
" ��������˵��������س�ӳ��Ϊ���ܵ�ǰ��ѡ��Ŀ��������ӳ��Ϊ�س���
" ��������˵�������CTRL-Jӳ��Ϊ�������˵������·�ҳ������ӳ��ΪCTRL-X CTRL-O��
" ��������˵�������CTRL-Kӳ��Ϊ�������˵������Ϸ�ҳ��������ӳ��ΪCTRL-K��
" ��������˵�������CTRL-Uӳ��ΪCTRL-E����ֹͣ��ȫ��������ӳ��ΪCTRL-U��
inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"

"-------------------------------------------------------------------------------
" �����۵� {{{2
"-------------------------------------------------------------------------------
set foldmethod=syntax
set foldenable
set foldlevel=100

"===============================================================================
" �Զ����ݼ� {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" ��������vim�Դ���ݼ� {{{2
"-------------------------------------------------------------------------------
" ����ģʽ��jjת����ͨģʽ
imap jj <Esc>
" ��b�������۵�
nnoremap b za
" e��һ������
nnoremap e b
" t������
nnoremap t <ESC>^
vmap t 0
" zz����ĩ
nnoremap zz <ESC>$
vmap zz $
" �л�buf
nmap <C-D> :b #<CR>
" Ctrl+m������λ�ã���ʵ<C-I>��ͬ��<Tab>
"nmap <C-m> <ESC><C-I>
"gw ������ڵ��ʺ���һ�����ʽ���
nmap <silent> gw "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<cr><c-o>
"gW ������ڵ��ʺ���һ�����ʽ���
nmap <silent> gW "_yiw:s/\(\w\+\)\(\_W\+\)\(\%#\w\+\)/\3\2\1/<cr><c-o>
" Y���Ƶ���ĩ
nmap Y y$
" ��Ϊ����
nmap F i<CR><ESC>

"-------------------------------------------------------------------------------
" <Leader>��� {{{2
"-------------------------------------------------------------------------------
" <leader>rr��������vimrc
nmap <silent> <leader>rr :source $VIM\\_vimrc<cr>
" <leader>e�༭vimrc
nmap <silent> <leader>e :e $VIM\\_vimrc<cr>
" ���Ƶ�ϵͳ������
nmap <leader>y "*y
nmap <leader>p "*p
nmap <leader>P "*P
" �����ļ�
nmap <leader>s :w<cr>
" ��ֱ�ָ��
nmap <leader>v <C-W>v
" �л�����
nmap <leader>w <C-W>W
" ��������򿪵�ǰ�ļ�
nmap <leader>f :silent !explorer %:p:h<CR>
" �л��к�/����к�
nmap <leader>t :ToggleNuMode<CR>
" �л���ȫ����
nmap <leader>of :call ToggleOmnifunc()<CR>

"-------------------------------------------------------------------------------
" Fx��� {{{2
"-------------------------------------------------------------------------------
" F1������Ŀ
nmap <F1> :call StartMyProject()<CR>
" F2��ת��ǩ
nmap <F2> <Plug>Vm_goto_next_sign
" F3����
nmap <F3> /\<<C-R><C-W>\><CR>
" Alt+F3���ļ���vimgrep����
nmap <M-F3> <ESC>:call MyVimGrep()<CR>
" Ctrl+F3���ļ���GNUGrep����
nmap <C-F3> <ESC>:MyGrep<CR>
" F4������ļ�(MRU.vim)
nmap <F4> :MRU<cr>
" F5��������C��C++��Python����
nmap <F5> :call CompileRun()<CR>
" Ctrl+F5����C��C++��Python����
nmap <C-F5> :call Debug()<CR>
" F6 FindEverything
nmap <F6> :FE<CR>
" F7������ɫ����
nmap <F7> <ESC>:ToggleColorScheme<CR>
" F8Ϊ�������ע��(DoxygenToolkit.vim)
nmap <F8> :Dox<CR>
" F9�л�qbuf
let g:qb_hotkey = "<F9>"
" F10��wikiת��Ϊhtml
map <F10> :Vimwiki2HTML<cr>
" Ctrl+F10������wikiת��Ϊhtml
map <C-F10> :VimwikiAll2HTML<cr>
" F11ȫ��
nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
" F12�л�c/h�ļ�(a.vim)
"nmap <silent> <F12> :A<CR>
" Ctrl+F12����tags
nmap <silent> <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

"-------------------------------------------------------------------------------
" cscope��ݼ� {{{2
"-------------------------------------------------------------------------------
"s: ����C���Է��ţ������Һ��������ꡢö��ֵ�ȳ��ֵĵط�
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
" 0��g: ���Һ������ꡢö�ٵȶ����λ�ã�����ctags���ṩ�Ĺ���
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
" 1��d: ���ұ��������õĺ���
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
" 2��c: ���ҵ��ñ������ĺ���
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
" 3��t: ����ָ�����ַ���
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
" 4��e: ����egrepģʽ���൱��egrep���ܣ��������ٶȿ����
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
" 5��f: ���Ҳ����ļ�������vim��find����
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
" 6��i: ���Ұ������ļ����ļ�
nmap <C-\>i :cs find i <C-R>=expand("%")<CR><CR>

nmap <C-_>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

"-------------------------------------------------------------------------------
" ���� {{{2
"-------------------------------------------------------------------------------
" ��Alt+m�����л���ʾ���߹ر���ʾ�˵����͹�����.
map <silent> <M-m> :if &guioptions =~# 'T' <Bar>
         \set guioptions-=T <Bar>
         \set guioptions-=m <bar>
         \else <Bar>
         \set guioptions+=T <Bar>
         \set guioptions+=m <Bar>
         \endif<CR>

" Alt+t��TotalCommander�򿪵�ǰ�ļ�
"nmap <M-t> :!start <C-R>=$g:totalcommander_exe /o /t /l '%:p'
nmap <M-t> :!start "d:\Software\TotalCMD\TOTALCMD.EXE" /o /t /l "%:p"<CR>

" ���Ŵ���
map <kPlus> <C-W>+
map <kMinus> <C-W>-
map <kDivide> <C-W><
map <kMultiply> <C-W>>
nmap <C-PageUp> <C-W>+
nmap <C-PageDown> <C-W>-

" Shift+Left��NERDTree
nmap <S-LEFT> <ESC>:NERDTreeToggle<CR>
" Shift+RIGHT��Tlist
nmap <S-RIGHT> <ESC>:TagbarToggle<CR>
" Shift+DOWN��SrcExplToggle
nmap <S-DOWN> <ESC>:SrcExplToggle<CR>
" Shift+UP��Calendar
"nmap <S-UP> <ESC>:Calendar<CR>

" Insert��Alt+h,j,k,l�ƶ����
imap <M-h> <LEFT>
imap <M-j> <DOWN>
imap <M-k> <UP>
imap <M-l> <RIGHT>

" Ctrl+h,j,k,l�л�����
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" ��CTRL�����ƶ��ı����ǳ�����
nmap <C-Down> :<C-u>move.+1<CR>
nmap <C-Up> :<C-u>move.-2<CR>
imap <C-Down> <C-o>:<C-u>move.+1<CR>
imap <C-Up> <C-o>:<C-u>move.-2<CR>
vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv

" Alt+h��ǰ�л�buf��Alt+l����л�buf
nmap <M-h> :bp<CR>
nmap <M-l> :bn<CR>
nmap <M-u> :tabp<CR>
nmap <M-o> :tabn<CR>

" ����Ӧ���Ű�Χvisualѡ��Ĳ���
vmap ( <Esc>:call VisualWrap('(', ')')<CR>
vmap [ <Esc>:call VisualWrap('[', ']')<CR>
vmap { <Esc>:call VisualWrap('{', '}')<CR>
vmap < <Esc>:call VisualWrap('<', '>')<CR>
vmap " <Esc>:call VisualWrap('"', '"')<CR>
vmap ' <Esc>:call VisualWrap("'", "'")<CR>

"===============================================================================
"������� {{{1
"===============================================================================

"-------------------------------------------------------------------------------
" MyProject {{{2
"-------------------------------------------------------------------------------
" ����Ŀ¼
let g:MyProjectConfigDir = 'D:\Workspace\MyProject'

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
" ���Զ�������
let g:fencview_autodetect = 0

"-------------------------------------------------------------------------------
" MRU.vim {{{2
"-------------------------------------------------------------------------------
" ����б���Ŀ200
let MRU_Max_Entries = 200

"-------------------------------------------------------------------------------
" CRefVim.vim {{{2
"-------------------------------------------------------------------------------
map <silent> <unique> <Leader>ct <Plug>CRV_CRefVimInvoke

"-------------------------------------------------------------------------------
" neocomplete {{{2
" ------------------------------------------------------------------------------
" ʹneocomplete�Զ�����
let g:neocomplete#enable_at_startup = 1
" ʹneocomplete�Զ�ѡ���һ��
let g:neocomplete#enable_auto_select = 1
" <C-u>ȡ��ѡ��
inoremap <expr><C-u>  neocomplete#cancel_popup()

"-------------------------------------------------------------------------------
" FuzzyFinder.vim {{{2
"-------------------------------------------------------------------------------
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
" snipMate.vim {{{2
"-------------------------------------------------------------------------------
" Alt+a��ʾ���д������д
imap <M-a> <C-r><Tab>

"-------------------------------------------------------------------------------
" NERD_commenter {{{2
" ------------------------------------------------------------------------------
" ��C���Ե�ע�ͷ��Ÿ�Ϊ//, Ĭ����/**/
"let NERD_c_alt_style = 1
" ����Alt+/Ϊע�Ϳ�ݼ�
nmap <M-/> ,cc
" ����Alt+.Ϊȡ��ע�Ϳ�ݼ�
nmap <M-.> ,cu

"-------------------------------------------------------------------------------
" DoxygenToolkit.vim {{{2
" ------------------------------------------------------------------------------
let g:DoxygenToolkit_compactDoc = "yes"
"let g:DoxygenToolkit_commentType = "C++"
let g:doxygenToolkit_briefTag_funcName="yes"

let g:DoxygenToolkit_briefTag_pre="@����˵����   "
let g:DoxygenToolkit_paramTag_pre="@��    ����   "
let g:DoxygenToolkit_returnTag="@�� �� ֵ��   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="wchao"

"-------------------------------------------------------------------------------
" VimWiki (vimwiki.vim) {{{2
" ------------------------------------------------------------------------------
" ���ñ���
let g:vimwiki_w32_dir_enc = 'utf-8'
" ����Ҫ�շ�ʽ������Ϊwiki����
let g:vimwiki_camel_case = 0
" ʹ�����
let g:vimwiki_use_mouse = 1
let g:vimwiki_file_exts = 'c, cpp, wav, txt, h, hpp, zip, sh, awk, ps, pdf'
" ����������ɫ
let g:vimwiki_hl_headers = 1
" �Ƿ������﷨�۵�  �����ļ��Ƚ���
"let g:vimwiki_folding = 1
" �����۵����б���
let g:vimwiki_fold_lists = 1
" �Ƿ��ڼ����ִ�����ʱ���ر��������ַ�
let g:vimwiki_CJK_length = 1
" ������wiki��ʹ�õ�html��ʶ
let g:vimwiki_valid_html_tags='b,i,s,u,sub,sup,kbd,del,br,hr,div,code,ul,li,p,a,small'
" �л�todo
autocmd FileType vimwiki map <M-Enter> <Plug>VimwikiToggleListItem
let wiki = {'path': $vim.'/vimfiles/vimwiki/wiki/',
            \ 'path_html': $vim.'/vimfiles/vimwiki/wiki/html/',
            \ 'template_path': $vim.'/vimfiles/vimwiki/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}
let my_wiki = {'path': 'd:/My/MyWiki/wiki_files/',
            \ 'path_html': 'd:/My/MyWiki/',
            \ 'template_path': 'd:/My/MyWiki/assets/template/',
            \ 'template_default': 'template',
            \ 'template_ext': '.html',
            \ 'diary_link_count': 6}
let g:vimwiki_list = [my_wiki, wiki]

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

"}}}1

" vim:fdm=marker:fmr={{{,}}}
