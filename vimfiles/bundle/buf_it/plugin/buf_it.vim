"Author:  Fvw (vimtexhappy@gmail.com)
"         Buffer list in statusline
"         2010-01-02 23:57:48 v2.0
"License: Copyright (c) 2001-2009, Fvw
"         GNU General Public License version 2 for more details.

let g:disable_buf_it = 0
if g:disable_buf_it
   finish
endif

noremap  \p       :call BufPrevPart()<cr>
noremap  \n       :call BufNextPart()<cr>
"noremap  ,bo :call BufOnly()<cr>

let g:statusbarKeepWidth = 30
let g:currentBufNum = '(0)'

let s:bufNowPartIdx = 0
let s:bufList = []
let s:bufPartStrList = []
let s:last_maxidx = -1

autocmd VimEnter,BufNew,BufEnter,BufWritePost * call UpdateStatus()
"if version >= 700
"autocmd InsertLeave,VimResized * call UpdateStatus()
"end

function! BufMap() "{{{
    let now_maxidx = len(s:bufList) - 1
    if now_maxidx > s:last_maxidx
        for i in range(s:last_maxidx+1, now_maxidx, 1)
            let x = i + 1
            if i < 10
                exec "silent! noremap <M-".x."> :call BufChange(".i.")<CR>"
            else
                exec "silent! noremap <M-".x/10.x%10."> :call BufChange(".i.")<CR>"
            endif
            exec "silent! noremap <leader>".x." :call BufSplit(".i.")<CR>"
        endfor
    elseif now_maxidx < s:last_maxidx
        for i in range(now_maxidx+1, s:last_maxidx, 1)
            let x = i + 1
            if i < 10
                exec "silent! unmap <M-".x.">"
            else
                exec "silent! unmap <M-".x/10.x%10.">"
            endif
            exec "silent! unmap <leader>".x
        endfor
    endif
    let s:last_maxidx = now_maxidx
endfunction
"}}}

function! BufOnly() "{{{
    let i = 1
    while(i <= bufnr('$'))
        if buflisted(i) && getbufvar(i, "&modifiable")
                    \   && (bufwinnr(i) != winnr())
            exec 'bd'.i
        endif
        let i = i + 1
    endwhile
    call UpdateStatus()
endfun
"}}}

function! BufChange(idx) "{{{
    if !empty(get(s:bufList, a:idx, []))
        exec 'b! '.s:bufList[a:idx][0]
    endif
endfunction
"}}}

function! BufSplit(idx) "{{{
    if !empty(get(s:bufList, a:idx, []))
        exec 'sb! '.s:bufList[a:idx][0]
    endif
endfunction
"}}}

function! BufNextPart() "{{{
    let s:bufNowPartIdx += 1
    if s:bufNowPartIdx >= len(s:bufPartStrList)
        let s:bufNowPartIdx = 0
    endif
    call UpdateBufPartStr()
endfunction
"}}}

function! BufPrevPart() "{{{
    let s:bufNowPartIdx -= 1
    if s:bufNowPartIdx < 0
        let s:bufNowPartIdx = len(s:bufPartStrList)-1
    endif
    call UpdateBufPartStr()
endfunction
"}}}

function! UpdateBufPartStr() "{{{
    let g:bufPartStr = s:bufPartStrList[s:bufNowPartIdx]
    if s:bufNowPartIdx > 0
        let g:bufPartStr = '<<'.g:bufPartStr
    endif
    if s:bufNowPartIdx < len(s:bufPartStrList)-1
        let g:bufPartStr = g:bufPartStr.'>>'
    endif
endfunction
"}}}

function! UpdateStatus() "{{{
    let s:bufList = []
    let [i,idx] = [1, 1]
    while(i <= bufnr('$'))
        if buflisted(i) && getbufvar(i, "&modifiable")
            "let buf  =  idx."-"
            let buf  =  "| (".idx.")"
            "let buf .= fnamemodify(bufname(i), ":t")."(".i.")"
            let buf .= fnamemodify(bufname(i), ":t")
            let buf .= getbufvar(i, "&modified")? "[+]":''
            let buf .= " "
            if bufname(i) == bufname("%")
               let g:currentBufNum = '('.idx.')'
            endif
            call add(s:bufList, [i, buf])
            let idx += 1
        endif
        let i += 1
    endwhile

    if empty(s:bufList)
        return
    endif

    let s:bufPartStrList = []
    let str = ''
    let widthForBufStr = winwidth(0) - g:statusbarKeepWidth
    for [i, bufStr] in s:bufList
        if len(str.bufStr) > widthForBufStr
            call add(s:bufPartStrList, str)
            let str = ''
        endif
        let str .= bufStr
    endfor
    if str != ''
        call add(s:bufPartStrList, str)
    endif

    "let g:currentBufNum = bufname("%")

    let s:bufNowPartIdx = 0
    call UpdateBufPartStr()
    call BufMap()
endfunction
"}}}

" vim:fdm=marker:fmr={{{,}}}
