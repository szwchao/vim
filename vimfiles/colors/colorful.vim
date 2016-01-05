" Vim color file
" A modified verion of habiLight color schemeversion of habiLight color scheme by Christian Habermann

" Intro {{{1
set background=light
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "colorful"

" Normal {{{1
hi Normal      gui=NONE        guifg=Black      guibg=GhostWhite

" Search {{{1
hi Search      gui=NONE        guifg=DarkBlue   guibg=#FFE270
hi IncSearch   gui=UNDERLINE   guifg=White      guibg=NavyBlue

" Messages {{{1
hi ErrorMsg    gui=BOLD        guifg=#EB1513    guibg=NONE
hi ModeMsg     gui=BOLD        guifg=#0070ff    guibg=NONE
hi MoreMsg                     guifg=seagreen   guibg=NONE

hi! link WarningMsg   ErrorMsg
hi! link Question     MoreMsg

" 'wildmenu' 补全的当前匹配，如command命令在状态栏的补全
hi WildMenu    gui=BOLD        guifg=White      guibg=#E9967A

hi! link VertSplit    StatusLineNC

" Diff {{{1
hi DiffAdd     gui=none        guifg=#003300    guibg=#B5EEB5
hi DiffChange  gui=none                         guibg=#E6E6FA
hi DiffText    gui=none        guifg=#C71585    guibg=#87B0FF
hi DiffDelete  gui=none        guifg=#DDCCCC    guibg=#FFDDDD

" Cursor   {{{1
" normal模式光标颜色
hi Cursor      gui=none        guifg=White      guibg=DarkBlue
" 插入模式光标颜色
hi CursorIM    gui=NONE        guifg=#F8F8F8    guibg=#8000ff

" Fold {{{1
hi Folded      gui=NONE        guifg=black      guibg=#FFF8DC 
" 在左侧有个状态条用'|'指示折叠，需set foldcolumn=x （x>0）时生效
hi FoldColumn  gui=NONE        guifg=black      guibg=#FFF8DC 
" 左侧的标志条
hi SignColumn   guibg=black

" Other {{{1
hi Directory    gui=NONE       guifg=NavyBlue   guibg=#FFE9E3
hi LineNr       gui=none       guifg=#6495ED    guibg=#FDF5E6
hi NonText      gui=BOLD       guifg=#333333    guibg=White
" :map 列出的 Meta 和特殊键，也包括文本里不可显示字符的显示和'listchars'。
hi SpecialKey   gui=NONE       guifg=#A35B00    guibg=NONE
" :set all、:autocmd 等输出的标题
hi Title        gui=BOLD       guifg=#1014AD    guibg=NONE
" 可视模式的选择区
hi Visual       gui=BOLD                        guibg=#D6E3F8

" Syntax group {{{1
" Comment	v 任何注释
hi Comment                     guifg=SteelBlue  guibg=#F0F6FF

" Constant	v 任何常数
hi Constant     gui=NONE        guifg=#8B0000       guibg=#FEE6FF
"String		v 字符串常数: "这是字符串"
hi! link String       Constant
"Character	v 字符常数: 'c'、'\n'
hi! link Character    Constant
"Number		v 数值常数: 234、0xff
hi Number      gui=NONE        guifg=#00C226    guibg=#DBF8E3
"Boolean	v 布尔型常数: TRUE、false
hi! link Boolean      Constant
"Float		v 浮点常数: 2.3e10
hi! link Float        Number

"*Identifier	v 任何变量名
hi Identifier                  guifg=Blue
"Function	v 函数名 (也包括: 类的方法名)
hi Function    gui=BOLD        guifg=#3A9CFF

"*Statement	v 任何语句
hi Statement   gui=NONE        guifg=#F06F00    guibg=#FCECE0
"Conditional	v if、then、else、endif、switch 等
hi Conditional gui=NONE        guifg=#F06F00    guibg=#FCECE0
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
hi PreProc                     guifg=#BA8C00    guibg=#FFF5CF
"Include	v 预处理命令 #include
hi! link Include      PreProc
"Define		v 预处理命令 #define
hi! link Define       PreProc
"Macro		v 同 Define
"hi! link Macro        PreProc
hi Macro                       guifg=#9A32CD
"PreCondit	v 预处理命令 #if、#else、#endif 等
hi! link PreCondit    PreProc

"*Type		v int、long、char 等
hi Type        gui=NONE        guifg=#B91F49    guibg=#FFE3E5
"StorageClass	v static、register、volatile 等
hi! link StorageClass Type
"Structure	v struct、union、enum 等
hi! link Structure    Type
"Typedef	v typedef 定义
hi! link Typedef      Type

"*Special	v 任何特殊符号
hi Special                     guifg=#EE0000
"SpecialChar	v 常数中的特殊字符
hi! link SpecialChar  Special
"Tag		v 可以使用 CTRL-] 的项目
hi Tag                         guifg=DarkGreen
"Delimiter	v 需要注意的字符
hi! link Delimiter    Special
"SpecialComment	v 注释里的特殊部分
hi! link SpecialComment Special
"Debug		v 调试语句
hi! link Debug        Special

"*Underlined	v 需要突出的文本，HTML 链接
hi Underlined   guibg=#FF6EB4  guifg=black      gui=underline

"*Ignore		v 留空，被隐藏  |hl-Ignore|
" help ** & ||
hi Ignore       guifg=#ef008c

"*Error		v 有错的构造
hi Error                       guifg=White      guibg=Red

"*Todo		v 需要特殊注意的部分；主要是关键字 TODO FIXME 和 XXX
hi Todo        gui=BOLD        guifg=DarkBlue   guibg=Red


" HTML {{{1
hi htmlLink                 gui=UNDERLINE guifg=#0000ff guibg=NONE
hi htmlBold                 gui=BOLD
hi htmlBoldItalic           gui=BOLD,ITALIC
hi htmlBoldUnderline        gui=BOLD,UNDERLINE
hi htmlBoldUnderlineItalic  gui=BOLD,UNDERLINE,ITALIC
hi htmlItalic               gui=ITALIC
hi htmlUnderline            gui=UNDERLINE
hi htmlUnderlineItalic      gui=UNDERLINE,ITALIC
hi htmlH1                   gui=BOLD    guifg=#103040
hi htmlH2                   gui=BOLD    guifg=#507030
hi htmlH3                   gui=BOLD    guifg=#aa5858
hi htmlH4                   gui=BOLD    guifg=#6090e0
hi htmlH5                   gui=BOLD    guifg=#103040
hi htmlH6                   gui=BOLD    guifg=#103040

" Tabs {{{1
hi TabLine     gui=underline guibg=LightGrey
hi TabLineFill gui=reverse
hi TabLineSel  gui=bold

" Spell Checker {{{1
hi SpellBad    gui=undercurl guisp=Red
hi SpellCap    gui=undercurl guisp=Blue
hi SpellRare   gui=undercurl guisp=Magenta
hi SpellLocale gui=undercurl guisp=DarkCyan

" Completion {{{1
hi Pmenu      guifg=Black   guibg=#BDDFFF
hi PmenuSel   guifg=Black   guibg=Orange
hi PmenuSbar  guifg=#CCCCCC guibg=#CCCCCC
hi PmenuThumb gui=reverse guifg=Black   guibg=#AAAAAA

" Misc {{{1
" 配对的括号
hi MatchParen guibg=#ef008c guifg=black


" TagHighlight
" Class 类名
hi Class guifg=Blue
" Define
hi DefinedName guifg=#9A32CD
" Enumerator
hi Enumerator guifg=Green
" Enumeration name
hi EnumerationName guifg=Green
" Member (of structure or class)
hi Member guifg=#5f8700
" Global Constant
hi GlobalConstant guifg=Red
" Global Variable
hi GlobalVariable guifg=#d75f00
" Local Variable
hi LocalVariable guifg=Yellow

" vim600:foldmethod=marker
