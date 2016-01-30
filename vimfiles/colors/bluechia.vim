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
hi Normal    guifg=#c4c4c4    guibg=#002b36

"hi NonText    guifg=#92add3    guibg=#071925    gui=none
hi NonText      ctermfg=5  guifg=#333333 gui=underline
hi SpecialKey    guifg=#92add3    guibg=#14220a    gui=none
" 光标
hi Cursor    guifg=#3a553a    guibg=#CDC9A5
" 光标水平线
hi CursorLine    guibg=#303035
" 光标垂直线
hi CursorColumn    guibg=#303035
hi lCursor    guifg=#3a553a    guibg=#d2ff00
hi CursorIM    guifg=#3a553a    guibg=#d2ff00


" 目录
hi Directory    guifg=#4682B4 gui=bold

" Diff
hi DiffAdd    guifg=#D2EBBE    guibg=#437019    gui=none
hi DiffChange    guifg=#FFF5EE    guibg=#2B5B77   gui=none
hi DiffDelete    guifg=#40000A    guibg=#70000A    gui=none
hi DiffText    guifg=#000000    guibg=#8FBFDC    gui=bold

" 命令行上的错误信息
hi ErrorMsg    guifg=#eb7aa0    guibg=black
" 分离垂直分割窗口的列
hi VertSplit    guifg=#DCDCDC    guibg=black

" 折叠
"hi Folded    guifg=#b265a4    guibg=black
hi Folded       guibg=#1e2132 guifg=#686f9a
" 用于关闭的折叠的行
"hi Folded    guifg=#ff6902    guibg=black
hi FoldColumn    guifg=#557755    guibg=#102010

" Search
hi Search    guifg=#000000    guibg=#FFFF00    gui=none
hi IncSearch    guifg=#3a553a    guibg=#d2ff00    gui=none

" 行号
" hi LineNr    guifg=#a9ce49 guibg=black gui=none
hi LineNr     guifg=#696969    guibg=#073642    gui=none
" 'showmode' 消息 (例如，"-- INSERT --")
hi ModeMsg    guifg=#8968CD
" 更多
hi MoreMsg    guifg=#cb4b16    guibg=NONE
"hi Question    guifg=#071925    guibg=black
hi Question    guifg=red    guibg=black     gui=none

"\n, \0, %d, %s, etc...
hi Special    guifg=#fcd942            gui=none

" :set all、:autocmd、tags搜索等输出的标题
hi Title    guifg=#eb7aa0    gui=none
hi Visual    guifg=#d2ff00    guibg=#448844    gui=none
hi VisualNOS    guifg=#071925    guibg=black
hi WarningMsg    guifg=#d2ff00    guibg=black
hi WildMenu    guifg=#3a553a    guibg=#d2ff00

" Comment	v 任何注释
hi Comment                     guifg=#586e75

" Constant	v 任何常数
hi Constant    guifg=#859900
"String		v 字符串常数: "这是字符串"
"hi String    guifg=#76BEB0
hi! link String       Constant
"Character	v 字符常数: 'c'、'\n'
"hi Character    guifg=#d2ff00
hi! link Character    Constant
"Number		v 数值常数: 234、0xff
"hi Number      gui=NONE        guifg=#66CD00
hi! link Number    Constant
"Boolean	v 布尔型常数: TRUE、false
"hi Boolean    guifg=#d2ff00
hi! link Boolean      Constant
"Float		v 浮点常数: 2.3e10
hi! link Float        Number

"*Identifier	v 任何变量名
hi Identifier    guifg=#CDB38B
"Function	v 函数名 (也包括: 类的方法名)
"hi Function     guifg=#4682B4
hi Function    gui=none        guifg=#4682B4

"*Statement	v 任何语句
hi Statement    guifg=#f19dae            gui=none
"Conditional	v if、then、else、endif、switch 等
"Repeat		v for、do、while 等
hi! link Repeat       Statement
"Label		v case、default 等
hi! link Label        Statement
"Operator	v "sizeof"、"+"、"*" 等，再加上自定义的操作符，如"==", "->"等
hi Operator    gui=NONE        guifg=#FF0080
"Keyword	v 其它关键字
hi! link Keyword      Statement
"Exception	v try、catch、throw
hi! link Exception    Statement

"*PreProc	v 通用预处理命令
"hi PreProc    guifg=#8ddaea            gui=none
"hi PreProc    guifg=#A83D8B            gui=none
hi PreProc    guifg=#b294bb             gui=none
"Include	v 预处理命令 #include
hi! link Include      PreProc
"Define		v 预处理命令 #define
hi! link Define       PreProc
"Macro		v 同 Define
hi! link Macro        PreProc
"PreCondit	v 预处理命令 #if、#else、#endif 等
hi! link PreCondit    PreProc

"*Type		v int、long、char 等
hi Type        guifg=#cb4b16            gui=none
"StorageClass	v static、register、volatile 等
hi! link StorageClass Type
"Structure	v struct、union、enum 等
hi! link Structure    Type
"Typedef	v typedef 定义
hi! link Typedef      Type

"*Special	v 任何特殊符号
hi Special                     guifg=#dc322f
"SpecialChar	v 常数中的特殊字符
hi! link SpecialChar  Special
"Tag		v 可以使用 CTRL-] 的项目
hi! link Tag  Special
"Delimiter	v 需要注意的字符
hi! link Delimiter    Special
"SpecialComment	v 注释里的特殊部分
hi! link SpecialComment Special
"Debug		v 调试语句
hi! link Debug        Special

"*Underlined	v 需要突出的文本，HTML 链接
hi Underlined   guifg=#E6BC4B                   gui=underline

"*Ignore		v 留空，被隐藏  |hl-Ignore|
" help ** & ||
hi Ignore       guifg=#ef008c

"*Error		v 有错的构造
hi Error        guifg=#dc322f    guibg=NONE gui=Bold

"*Todo		v 需要特殊注意的部分；主要是关键字 TODO FIXME 和 XXX
hi Todo        guifg=#d33682    guibg=NONE gui=Bold


"hi Constant    guifg=#eb7aa0            gui=none

" HTML {{{1
hi htmlLink                 gui=UNDERLINE guifg=#87CEEB guibg=NONE
hi htmlBold                 gui=BOLD
hi htmlBoldItalic           gui=BOLD,ITALIC
hi htmlBoldUnderline        gui=BOLD,UNDERLINE
hi htmlBoldUnderlineItalic  gui=BOLD,UNDERLINE,ITALIC
hi htmlItalic               gui=ITALIC
hi htmlUnderline            gui=UNDERLINE
hi htmlUnderlineItalic      gui=UNDERLINE,ITALIC
hi htmlH1                   gui=BOLD    guifg=#4682B4
hi htmlH2                   gui=BOLD    guifg=#507030
hi htmlH3                   gui=BOLD    guifg=#aa5858
hi htmlH4                   gui=BOLD    guifg=#8B3A62
hi htmlH5                   gui=BOLD    guifg=#9C9C9C
hi htmlH6                   gui=BOLD    guifg=#5C5C5C

" status line
hi StatusLine    guifg=#cfddea    guibg=#4E4E4E    gui=bold
" hi StatusLineNC    guifg=#a9ce49    guibg=black    gui=none
hi StatusLineNC    guifg=#a9ce49    guibg=#4E4E4E    gui=bold

" 左侧的标志条
hi SignColumn   guibg=#05131c

" 括号匹配
hi MatchParen    guifg=#000000    guibg=#ef008c

" 弹出菜单
hi Pmenu      guibg=#b7ba6b guifg=black
hi PmenuSel   guibg=#224b8f
hi PmenuSbar  ctermbg=7   guibg=#CCCCCC
hi PmenuThumb cterm=reverse  gui=reverse guifg=Orange   guibg=#AAAAAA

" 顶部的标签页
hi TabLine      guifg=#a9ce49    guibg=black    gui=None
hi TabLineFill  guibg=#071925    guibg=#071925    gui=None
hi TabLineSel      guifg=#cfddea    guibg=black    gui=None

" 操作符高亮
hi Operator gui=NONE guifg=#FF0080

" TagHighlight
" Class 类名
hi Class guifg=#8ddaea
" Define
"hi DefinedName guifg=#b58900
hi! link DefinedName PreProc
" Enumerator
hi Enumerator guifg=Green
" Enumeration name
hi EnumerationName guifg=Green
" Member (of structure or class)
hi! link Member Identifier
" Global Constant
hi GlobalConstant guifg=Red
" Global Variable
hi! link GlobalVariable Identifier
" Local Variable
hi LocalVariable guifg=Yellow
" Member (of structure or class)
finish

" vim:set ts=8 sts=2 sw=2 tw=0:
