" 自定义状态栏{{{1

" 防止重新载入脚本{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_mystatusline')
    finish
endif
let g:loaded_mystatusline = 1

"------------------------------------------------------------------------------"
"}}}

" GetSpace {{{2
"------------------------------------------------------------------------------"
fun! GetStatusLineSpace()
    return " "
endfun
"------------------------------------------------------------------------------"
"}}}

" SetMyStatusLineHighlight {{{2
"------------------------------------------------------------------------------"
fun! SetMyStatusLineHighlight()
    " status line
    " bg是背景色，fg是字体颜色
    if &bg == "dark"
        let background = '#4E4E4E'
        exec 'hi SL_Normal            gui=none guifg=#FFFFFF guibg='. background  
        exec 'hi SL_ProjectName       gui=none guifg=#FF6A6A guibg='. background 
        exec 'hi SL_Flag              gui=none guifg=#bc5b4c guibg='. background 
        exec 'hi SL_FileName          gui=none guifg=#ffff77 guibg='. background 
        exec 'hi SL_AllBuf          gui=none guifg=#acff84 guibg='. background 
        exec 'hi SL_FileEnc              gui=none guifg=#63B8FF guibg='. background 
        exec 'hi SL_LineInfo              gui=none guifg=#FFD39B guibg='. background 
        " 其它备用颜色 #d59159
    else
        let background = '#4682B4'
        exec 'hi SL_Normal            gui=none guifg=#FFFFFF guibg='. background  
        exec 'hi SL_ProjectName       gui=none guifg=#68228B guibg='. background 
        exec 'hi SL_Flag           gui=none guifg=#8B1A1A guibg='. background 
        exec 'hi SL_FileName          gui=none guifg=#acff83 guibg='. background 
        exec 'hi SL_AllBuf          gui=none guifg=#E5E5E5 guibg='. background
        exec 'hi SL_FileEnc              gui=none guifg=#63B8FF guibg='. background 
        exec 'hi SL_LineInfo              gui=none guifg=#FFD39B guibg='. background 
    endif

endfun
"------------------------------------------------------------------------------"
"}}}

" statusline {{{2
"------------------------------------------------------------------------------"
fun! SetMyStatusLine()
    let currentBufName = bufname('%')
    let len_currentBufName = len(currentBufName)
    let currentProjectName = GetProjectName()
    let len_currentProjectName = len(currentProjectName)
    let g:statusbarKeepWidth=50+len_currentBufName+len_currentProjectName
    " 设置高亮
    call SetMyStatusLineHighlight()
	"每个项目的形式： %-0{minwid}.{maxwid}{item}
    "                   -	    左对齐项目
    "                   0	    数值项目前面用零填补。
    "                   minwid	    项目的最小宽度
    "                   maxwid	    项目的最大宽度
    "                   item	    单个字符的代码
    setlocal statusline=
    setlocal statusline+=%#SL_ProjectName#%{GetProjectName()}   " 工程名
    setlocal statusline+=%#SL_Flag#%r                           " %r             当前文件是否只读
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    "setlocal statusline+=%#SL_FileName#%{bufname('%')}       " %t             缓冲区的文件编号
    setlocal statusline+=%#SL_FileName#%t                       " %t             缓冲区的文件的文件名(尾部)
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=%#SL_Flag#%m                           " %m             当前文件修改状态
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=%#SL_AllBuf#%{buftabs#statusline()}    " 所有buffer
    setlocal statusline+=%<                                     " 行过长，在此截短 
    setlocal statusline+=%=                                     " 左对齐和右对齐项目之间的分割点
    setlocal statusline+=%#SL_FileEnc#%{&fileformat}            " %{&fileformat} 当前文件编码，dos/unix等
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=%{&fenc}                               " %{&fenc}       文件的字符编码，utf-8, cp936等
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=%#SL_LineInfo#[L:%l                    " %l             当前光标行号
    setlocal statusline+=/%L                                    " %L             当前文件总行数
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=\C:%c]                                 " %c             当前光标列号
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=\|
    setlocal statusline+=%{GetStatusLineSpace()}                " 空格
    setlocal statusline+=%P                                     " %p             当前行占总行数的百分比
    setlocal statusline+=%<
endfun

set updatetime=500
autocmd CursorHold * if ((&filetype == 'c') || (&filetype == 'python')) | let &titlestring='%f%m (%F)%<%='.GetFunctionName() | endif
"------------------------------------------------------------------------------"
"}}}

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
