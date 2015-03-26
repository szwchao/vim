" Name: bluechia.vim
" Authorship: Kojo Sugita
" Modifier: CRUX
" Last Change: 2009-12-03
" Revision: 1.0
"
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = 'bluechia'

" Default colors
"hi Normal	guifg=#FFF5EE	guibg=#242424
hi Normal	guifg=#FFF5EE	guibg=#002b36

"hi NonText	guifg=#92add3	guibg=#071925	gui=none
hi NonText      ctermfg=5  guifg=#333333 gui=underline
hi SpecialKey	guifg=#92add3	guibg=#14220a	gui=none
" 光标
hi Cursor	guifg=#3a553a	guibg=#d2ff00
" 光标水平线
hi CursorLine	guibg=#303035
" 光标垂直线
hi CursorColumn	guibg=#303035
hi lCursor	guifg=#3a553a	guibg=#d2ff00
hi CursorIM	guifg=#3a553a	guibg=#d2ff00


" 目录
hi Directory	guifg=#4682B4 gui=bold

" Diff
"hi DiffAdd	guifg=#d2ff00	guibg=#3a553a	gui=none
"hi DiffChange	guifg=#d2ff00	guibg=#3a553a	gui=none
"hi DiffDelete	guifg=#99bdff	guibg=#99bdff	gui=none
"hi DiffText	guifg=#d2ff00	guibg=#448844	gui=bold
hi DiffAdd	guifg=#D2EBBE	guibg=#437019	gui=none
hi DiffChange	guifg=#FFF5EE	guibg=#2B5B77   gui=none
hi DiffDelete	guifg=#40000A	guibg=#70000A	gui=none
hi DiffText	guifg=#000000	guibg=#8FBFDC	gui=bold

" 命令行上的错误信息
hi ErrorMsg	guifg=#eb7aa0	guibg=black
" 分离垂直分割窗口的列
hi VertSplit	guifg=#DCDCDC	guibg=black

" 折叠
"hi Folded	guifg=#b265a4	guibg=black
hi Folded       guibg=#1e2132 guifg=#686f9a
" 用于关闭的折叠的行
"hi Folded	guifg=#ff6902	guibg=black
hi FoldColumn	guifg=#557755	guibg=#102010

" Search
hi Search	guifg=#000000	guibg=#FFFF00	gui=none
hi IncSearch	guifg=#3a553a	guibg=#d2ff00	gui=none

" 行号
" hi LineNr	guifg=#a9ce49 guibg=black gui=none
hi LineNr 	guifg=#696969	guibg=black	gui=none
" 'showmode' 消息 (例如，"-- INSERT --")
hi ModeMsg	guifg=#8968CD
" 更多
hi MoreMsg	guifg=white	guibg=black
"hi Question	guifg=#071925	guibg=black
hi Question	guifg=red	guibg=black     gui=none

"\n, \0, %d, %s, etc...
hi Special	guifg=#fcd942			gui=none

" :set all、:autocmd、tags搜索等输出的标题
hi Title	guifg=#eb7aa0	gui=none
hi Visual	guifg=#d2ff00	guibg=#448844	gui=none
hi VisualNOS	guifg=#071925	guibg=black
hi WarningMsg	guifg=#d2ff00	guibg=black
hi WildMenu	guifg=#3a553a	guibg=#d2ff00

hi Ignore       guifg=#ef008c

hi Number	guifg=#66CD00
hi Character	guifg=#d2ff00
hi String	guifg=#76BEB0
hi Boolean	guifg=#d2ff00
hi Comment	guifg=#7b8487
"hi Constant	guifg=#eb7aa0			gui=none
hi Identifier	guifg=#CDB38B
"hi Identifier      guifg=#FD971F
hi Statement    guifg=#f19dae			gui=none

" Define, def
hi PreProc	guifg=#8ddaea			gui=none
hi Type		guifg=#8968CD			gui=none
"hi Underlined	guifg=gray			gui=underline
hi Underlined   guifg=#E6BC4B                   gui=underline
hi Error	guifg=#eb7aa0			guibg=black
hi Todo		guifg=#fcd942	guibg=black	gui=none

" status line
hi StatusLine	guifg=#cfddea	guibg=#4E4E4E	gui=bold
" hi StatusLineNC	guifg=#a9ce49	guibg=black	gui=none
hi StatusLineNC	guifg=#a9ce49	guibg=#4E4E4E	gui=bold

" 左侧的标志条
hi SignColumn   guibg=#05131c

" 括号匹配
hi MatchParen	guifg=#000000	guibg=#ef008c

" 弹出菜单
if version >= 700
  hi Pmenu      guibg=#b7ba6b guifg=black
  hi PmenuSel   guibg=#224b8f
  hi PmenuSbar  ctermbg=7   guibg=#CCCCCC
  hi PmenuThumb cterm=reverse  gui=reverse guifg=Orange   guibg=#AAAAAA
endif

" 顶部的标签页
hi TabLine	  guifg=#a9ce49	guibg=black	gui=None
hi TabLineFill  guibg=#071925	guibg=#071925	gui=None
hi TabLineSel	  guifg=#cfddea	guibg=black	gui=None

" 函数高亮
"hi Function     guifg=#ffd700
hi Function     guifg=#ff7f50

" 宏高亮
hi MyMacro	guifg=#4682B4			gui=none
"hi MyMacro	guifg=#8968CD			gui=none

" 操作符高亮
hi cMathOperator gui=NONE guifg=#FF0080
hi cPointerOperator gui=NONE guifg=#FF0080
hi cLogicalOperator gui=NONE guifg=#FF0080
hi cBinaryOperator gui=NONE guifg=#FF0080
hi cLogicalOperatorError gui=NONE guifg=#FF0080

finish

" vim:set ts=8 sts=2 sw=2 tw=0:
