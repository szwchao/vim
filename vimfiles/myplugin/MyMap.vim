if exists('my_map') || &cp || version < 700
    finish
endif
let my_map = 1

fun! QuickfixMap()
    nnoremap <buffer> v <Enter>zz:wincmd p<Enter>
    nnoremap <buffer> <ESC> :ccl<CR>
    nnoremap <buffer> <M-p> :colder<CR>
    nnoremap <buffer> <M-n> :cnewer<CR>
endfun

" toggles the quickfix window.
command -bang -nargs=? ToggleQuickfixWindow call QFixToggle(<bang>0)
function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
        cclose
    else
        " 确保quickfix窗口在底部
        execute "botright cw"
    endif
endfunction

" used to track the quickfix window
augroup QFixToggle
    autocmd!
    autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
    autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

" ===================================== vimwiki ================================
fun! WikiMap()
    set fileencoding=utf-8
    " F5将wiki转换为html并在浏览器里打开
    map <F5> <Plug>Vimwiki2HTMLBrowse
    " 运行wiki目录下的sync.bat自动提交
    map <C-F5> :exec 'silent !cmd.exe /k "cd "'.VimwikiGet('path_html').'" & sync"'<cr>
    map <F12> :call EditHtmlFiles()<CR>

    " 切换列表项的开关（选中/反选）
    nmap <S-Space> <Plug>VimwikiToggleListItem
    nmap <leader>t :VimwikiTable 2 2
    " normal下行首到行尾加`
    nmap <buffer> ` ^i`<ESC>$a`<ESC>
    " normal下有序列表
    nmap <buffer> # ^i#<Space><ESC>^
    " normal下无序列表
    nmap <buffer> * ^i*<Space><ESC>^
    " normal下Todolist
    nmap <buffer> [ ^i#<Space>[<Space>]<Space><ESC>^
    " normal下插入<br />，1.2版本直接<S-Enter>，2.0不行
    nmap <buffer> b $a<br /><ESC>

    " visual模式
    "zd把选中的内容删除放入z寄存器，<C-R>z读出
    " code
    vmap ` "zdi`<C-R>z`<ESC>
    " 粗体
    vmap * "zdi*<C-R>z*<ESC>
    " 斜体
    vmap _ "zdi_<C-R>z_<ESC>
    vmap { :<C-U>call VisualSelectAndWrapWithBrace()<CR>
endfun

fun! VisualSelectAndWrapWithBrace()
    let firstLine = line("'<")
    let lastLine = line("'>")
    "let firstCol = col("'<")
    "let lastCol = col("'>") - (&selection == 'exclusive' ? 1 : 0)
    call append(firstLine-1, "{{{")
    call append(lastLine+1, "}}}")
endfun

fun! EditHtmlFiles()
    let path_html = expand(VimwikiGet('path_html'))
    let wikifile = expand('%')
    let wikifile = fnamemodify(wikifile, ":p")
    let subdir = vimwiki#base#subdir(VimwikiGet('path'), wikifile)
    let path = expand(path_html).subdir
    let htmlfile = fnamemodify(wikifile, ":t:r").'.html'
    if !filereadable(path.htmlfile)
        return
    else
        exe "e ".path.htmlfile
    endif
endfun

function! VisualWrap(token_before, token_after)
    let l:wRow = line(".") 
    let l:wCol = col(".") 
    let firstCol = col("'<")
    let lastCol = col("'>") - (&selection == 'exclusive' ? 1 : 0)
    normal `>
    " TODO
    if &selection == 'exclusive'
        exe "normal! i".a:token_after
    else
        exe "normal! a".a:token_after
    endif
    normal `<
    exe "normal! i".a:token_before
    normal `>
    :call cursor(l:wRow, l:wCol) 
endfunction

