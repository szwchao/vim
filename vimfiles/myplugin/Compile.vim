" 防止重新载入脚本{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_mycompile')
    finish
endif
let g:loaded_mycompile = 1
"------------------------------------------------------------------------------"
"}}}

" 编译、运行、调试 {{{2
"------------------------------------------------------------------------------"
"定义CompileRun函数，用来调用进行编译和运行
func! CompileRun()
    if (&filetype != 'c') && (&filetype != 'cpp') && (&filetype != 'python') && (&filetype != 'dot')
        echo '只能编译c,cpp,python,dot文件!'
        return
    endif
    exec "w"
    if &filetype == 'c'
        if g:platform == 'win'
            set makeprg=gcc\ -o\ %<.exe\ %
            exec "silent make"
            set makeprg=make
            exec "!%<.exe"
        elseif g:platform == 'linux'
            set makeprg=gcc\ -o\ %<\ %
            exec "silent make"
            set makeprg=make
            exec "!./%<"
        endif
    elseif &filetype == 'cpp'
        if g:platform == 'win'
            set makeprg=g++\ -o\ %<.exe\ %
            exec "silent make"
            set makeprg=make
            exec "!%<.exe"
        elseif g:platform == 'linux'
            set makeprg=g++\ -o\ %<\ %
            set makeprg=make
            exec "silent make"
            exec "!./%<"
        endif
    elseif &filetype == 'python'
        if g:platform == 'win'
            if exists('g:python_exe')
                "exec "!".g:python_exe." %"
                let cmd = g:python_exe.' '.shellescape(expand("%:p"))
                let l:result=system(cmd)
                call s:Show_Compile_Result(l:result, 'open')
            elseif
                echo "please set g:python_exe first in your vimrc file"
            endif
        elseif g:platform == 'linux'
            exec "!python %<"
        endif
    elseif &filetype == 'dot'
        if g:platform == 'win'
            if exists('g:python_exe')
                exec "!".g:dot_bin." -Tpng -o %<.png % && start %<.png"
            elseif
                echo "pls set g:dot_bin first in your vimrc file"
            endif
        elseif g:platform == 'linux'
            exec "!dot -Tpng -o %<"
        elseif g:platform == 'mac'
            exec "!open –a Graphviz %"
        endif
    endif
    exe ":cw"
endfunc
"结束定义CompileRun

"定义Debug函数，用来调试程序
func! Debug()
    exec "w"
    "C程序
    if &filetype == 'c'
        exec "!gcc % -g -o %<.exe"
        exec "!gdb %<.exe"
        "C++程序
    elseif &filetype == 'cpp'
        exec "!g++ % -g -o %<.exe"
        exec "!gdb %<.exe"
        "Java程序
    elseif &filetype == 'java'
        exec "!javac %"
        exec "!jdb %<"
    endif
endfunc
"结束定义Debug
"------------------------------------------------------------------------------"
" s:Show_Compile_Result: 显示结果 {{{
"* --------------------------------------------------------------------------*/
" @函数说明：   显示结果
" @参    数：   result: 结果
" @参    数：   open_close_option: 打开还是关闭窗口
" @返 回 值：   
"* --------------------------------------------------------------------------*/
fun! s:Show_Compile_Result(result, open_close_option)
    let bname = '__Compile_Result__'
    " If the window is already open, jump to it
    let winnum = bufwinnr(bname)
    if winnum != -1
        if winnr() != winnum
            " If not already in the window, jump to it
            exe winnum . 'wincmd w'
        endif
        setlocal modifiable
        " Delete the contents of the buffer to the black-hole register
        silent! %delete _
    else
        let bufnum = bufnr(bname)
        if bufnum == -1
            let wcmd = bname
        else
            let wcmd = '+buffer' . bufnum
        endif
        exe 'silent! botright ' . '15' . 'split ' . wcmd
    endif
    " Mark the buffer as scratch
    setlocal buftype=nofile
    "setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal winfixheight
    setlocal modifiable

    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim
    " Create a mapping
    nnoremap <buffer> <silent> <ESC> :close<CR>
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    " Display the result
    silent! %delete _
    silent! 0put =a:result

    " Delete the last blank line
    silent! $delete _
    " Move the cursor to the beginning of the file
    normal! G
    call s:CompileSyntax()
    setlocal nomodifiable
    if a:open_close_option == 'close'
        silent! close
    endif
endfun
"}}}

" ToggleCompileResultWindow: 切换结果显示窗口 {{{
"* --------------------------------------------------------------------------*/
" @函数说明：   切换结果显示窗口
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! ToggleCompileResultWindow()
    let bname = '__Compile_Result__'
    let winnum = bufwinnr(bname)
    if winnum != -1
        if winnr() != winnum
            " If not already in the window, jump to it
            exe winnum . 'wincmd w'
            return
        else
            silent! close
            return
        endif
    endif

    let bufnum = bufnr(bname)
    if bufnum == -1
        echoh Error | echo "没有编译结果!" | echoh None
        let wcmd = bname
    else
        let wcmd = '+buffer' . bufnum
        exe 'silent! botright ' . '15' . 'split ' . wcmd
    endif
endfun
"}}}

" s:CompileSyntax( {{{2
fun! s:CompileSyntax()
    let l:make_error = "Error"
    let l:make_warning = "Warning"
    let l:python_traceback = "Traceback"
    sy case ignore
    let e = ":syn match Compile_Error ". '"'. l:make_error .'"'
    exe e
    let w = ":syn match Compile_Warning ". '"'. l:make_warning .'"'
    exe w
    let w = ":syn match Compile_Traceback ". '"'. l:python_traceback .'"'
    exe w
    hi def link Compile_Error Error
    hi def link Compile_Warning Type
    hi def link Compile_Traceback Error
endfun
"}}}
"}}}

command! -nargs=* C call ToggleCompileResultWindow()

" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
