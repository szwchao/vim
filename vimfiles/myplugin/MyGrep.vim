" 防止重新载入脚本{{{2
"------------------------------------------------------------------------------"
if exists('g:loaded_mygrep')
    finish
endif
let g:loaded_mygrep = 1
"------------------------------------------------------------------------------"
"}}}

" Meta folder of several typical version control systems
if exists('g:vcs_root_marker')
    let s:vcs_root_marker = g:vcs_root_marker
else
    let s:vcs_root_marker = ['.git', '.hg', '.svn', '.bzr', '_darcs', 'view.dat', 'f3make.bat']
endif

if executable('ag')
    let s:grepprg = "set grepprg=ag\\ --nogroup\\ --column\\ --skip-vcs-ignores\\ -"
    if exists('g:vim_tools_dir')
        " 为ag加一个全局的ignore文件
        let s:agignore_file = g:vim_tools_dir . '/ag/.agignore'
        if filereadable(s:agignore_file)
            let s:grepprg = s:grepprg . "-path-to-agignore=". s:agignore_file . "\\ -"
        endif
    endif
else
    let s:grepprg = "set grepprg=grep\\ -"
endif


" FindVcsRoot{{{2
"------------------------------------------------------------------------------"
func! s:FindVcsRoot() abort
    let vsc_dir = ''
    let vsc_file = ''
    let root = getcwd()
    for vcs in s:vcs_root_marker
        " 向上递归查找目录
        let vsc_dir = finddir(vcs, expand('%:p:h').';')
        if isdirectory(vsc_dir)
            let root = fnamemodify(vsc_dir, ':h')
            break
        endif
        " 向上递归查找文件
        let vsc_file = findfile(vcs, expand('%:p:h').';')
        if filereadable(vsc_file)
            let root = fnamemodify(vsc_file, ':p:h')
            break
        endif
    endfor

    "echom root
    return root
endf

"------------------------------------------------------------------------------"
"}}}

" vimgrep{{{2
"------------------------------------------------------------------------------"
func! MyVimGrep()
    let l:word=input("请输入要查找的内容: ", expand("<cword>"))
    if l:word == ''
        echo 'No input'
        return
    endif
    let l:word="/".l:word."/j"
    let l:flag = 'j'
    let ext = []
    if exists('g:ext_list')
        if g:ext_list != []
            let ext = g:ext_list
        endif
    endif
    if ext == []
        let l:word = l:word." **/*"
    endif
    for each_ext in ext
        let l:word = l:word." **/*.".each_ext
    endfor
    "echo l:word
    let cmd = "silent! vimgrep ".l:word
    call s:DoGrepCmd(cmd)
endfunc
command! -nargs=0 MyVimGrep :call MyVimGrep()

"------------------------------------------------------------------------------"
"}}}

" GNUGrep{{{2
"------------------------------------------------------------------------------"
fun! MyGrep()
    call s:InitGrepOptions()
    call s:DoGrepCmd(s:BuildGrepCmd())
endfun
command! -nargs=0 MyGrep :call MyGrep()
"------------------------------------------------------------------------------"
"}}}

"s:InitGrepOptions:  {{{2
fun! s:InitGrepOptions()
    if !exists('s:GrepOptionsDict')
        let s:GrepOptionsDict = {}
        " format:{key: [description, value]}
        let s:GrepOptionsDict["Recursive"] = ["\"r: 递归查找目录", "on"]
        let s:GrepOptionsDict["IgnoreCase"] = ["\"i: 忽略大小写", "on"]
        let s:GrepOptionsDict["WholeWord"] = ["\"w: 整词搜索", "on"]
        let s:GrepOptionsDict["LineNumber"] = ["\"l: 显示行号", "on"]
        let s:GrepOptionsDict["IncludeExt"] = [">c: 搜索扩展名", "*"]
        let s:GrepOptionsDict["Directory"] = [">d: 查找目录", exists("g:project_root_dir")?(g:project_root_dir):s:FindVcsRoot()]
        let s:GrepOptionsDict["SearchMode"] = [">e: 搜索模式", "All"]
    endif
endfun
"}}}

"s:DisplayGrepOptionsDict: {{{2
fun! s:DisplayGrepOptionsDict()
    for item in items(s:GrepOptionsDict)
        echo item
    endfor
endfun
"}}}

"s:GetGrepOptionsValue: {{{2
fun! s:GetGrepOptionsValue(key, choice)
    if a:choice == "description"
        return s:GrepOptionsDict[a:key][0]
    elseif a:choice == "value"
        return s:GrepOptionsDict[a:key][1]
    elseif a:choice == 0
        return s:GrepOptionsDict[a:key][0]
    elseif a:choice == 1
        return s:GrepOptionsDict[a:key][1]
    endif
endfun
"}}}

"s:SetGrepOptionsValue: {{{2
fun! s:SetGrepOptionsValue(key, value)
    let s:GrepOptionsDict[a:key][1] = a:value
endfun
"}}}

" s:BuildGrepOptionsDisplayList {{{
function! s:BuildGrepOptionsDisplayList()
    let optList = []
    "这样顺序不对
    "for key in keys(s:GrepOptionsDict)
    "call add(optList, s:GetGrepOptionsValue(key, 0)." [".s:GetGrepOptionsValue(key, 1)."]")
    "endfor
    call add(optList, s:GetGrepOptionsValue("Recursive", "description")." [".s:GetGrepOptionsValue("Recursive", "value")."]")
    call add(optList, s:GetGrepOptionsValue("IgnoreCase", "description")." [".s:GetGrepOptionsValue("IgnoreCase", "value")."]")
    call add(optList, s:GetGrepOptionsValue("WholeWord", "description")." [".s:GetGrepOptionsValue("WholeWord", "value")."]")
    call add(optList, s:GetGrepOptionsValue("LineNumber", "description")." [".s:GetGrepOptionsValue("LineNumber", "value")."]")
    call add(optList, "")
    call add(optList, s:GetGrepOptionsValue("IncludeExt", "description")." [".s:GetGrepOptionsValue("IncludeExt", "value")."]")
    call add(optList, s:GetGrepOptionsValue("Directory", "description")." [".s:GetGrepOptionsValue("Directory", "value")."]")
    call add(optList, s:GetGrepOptionsValue("SearchMode", "description")." [".s:GetGrepOptionsValue("SearchMode", "value")."]")
    return optList
endfunction
" }}}

" s:GrepOptionsSyntaxAndMapKeys {{{2
"-----------------------------------------------------------------------------"
fun! s:GrepOptionsSyntaxAndMapKeys()
    syn match Help    /^".*/
    highlight def link Help Special

    syn match Activated    /^>\w.*/
    highlight def link Activated Type

    syn match Selection    /^\ \w.*/
    highlight def link Selection String

    nnoremap <buffer> <silent> r     :call <SID>ToggleGrepOptionOnOff("Recursive")<cr>
    nnoremap <buffer> <silent> i     :call <SID>ToggleGrepOptionOnOff("IgnoreCase")<cr>
    nnoremap <buffer> <silent> w     :call <SID>ToggleGrepOptionOnOff("WholeWord")<cr>
    nnoremap <buffer> <silent> l     :call <SID>ToggleGrepOptionOnOff("LineNumber")<cr>
    nnoremap <buffer> <silent> d     :call <SID>ChangeSearchDirectory()<cr>
    nnoremap <buffer> <silent> g     :call <SID>BuildGrepCmd()<cr>
    nnoremap <buffer> <silent> c     :call <SID>ChangeIncludeExt()<cr>
    nnoremap <buffer> <silent> e     :call <SID>SetMode()<cr>
    nnoremap <buffer> <silent> ?     :call <SID>DisplayGrepOptionsDict()<cr>
    nnoremap <buffer> <silent> <ESC> :close<CR>
endfun
"}}}

"DisplayGrepOptions {{{2
"-----------------------------------------------------------------------------"
fun! DisplayGrepOptions()
    call s:InitGrepOptions()
    let bname = '_Grep_Options_'
    let l:height = '10'
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
        exe 'silent! botright ' . l:height . 'split ' . wcmd
    endif
    " Mark the buffer as scratch
    setlocal modifiable
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal noswapfile
    setlocal nowrap
    setlocal nobuflisted
    setlocal winfixheight
    " Setup the cpoptions properly for the maps to work
    let old_cpoptions = &cpoptions
    set cpoptions&vim
    call s:GrepOptionsSyntaxAndMapKeys()
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    " Display the list
    let optList = s:BuildGrepOptionsDisplayList()
    let lastLine = len(optList)
    let line = 0
    while line < lastLine
        call setline(line+1, optList[line])
        let line += 1
    endwhile
    setlocal nomodifiable
    call cursor(1, 1)
endfun
"}}}

"s:SetMode: {{{2
fun! s:SetMode()
    let modes = ["All", "Project", "Buffers", "User"]
    let current_mode = s:GrepOptionsDict["SearchMode"][1]
    let index = index(modes, current_mode)
    let index = (index+1) % len(modes)
    let s:GrepOptionsDict["SearchMode"][1] = modes[index]
    if modes[index] == "All"
        let dir = "*"
    elseif modes[index] == "Project"
        if exists("g:project_root_dir")
            let dir = g:project_root_dir
            if exists('g:project_grep_ext')
                let include_ext = g:project_grep_ext
            else
                let include_ext = 'c h cpp a asm py vim html'
            endif
            call s:SetGrepOptionsValue("IncludeExt", include_ext)
        else
            echo "No Project"
            let dir = "*"
        endif
    elseif modes[index] == "Buffers"
        let dir = join(s:GetBufferNamesList())
    elseif modes[index] == "User"
        let dir = "*"
    endif
    call s:SetGrepOptionsValue("Directory", dir)
    call DisplayGrepOptions()
endfun
"}}}

"s:GetMode: {{{2
fun! s:GetMode()
    return s:GetGrepOptionsValue("SearchMode", "value")
endfun
"}}}

"s:GetBufferNamesList: {{{2
fun! s:GetBufferNamesList()
    redir => bufoutput
    silent! buffers
    " This echo clears a bug in printing that shows up when it is not present
    silent! echo ""
    redir END

    let bufNames = []
    for i in split(bufoutput, '\n')
        let s1 = stridx(i, '"') + 1
        let s2 = stridx(i, '"', s1) - 1
        let str = i[s1 : s2]

        if str[0] == '[' && str[len(str)-1] == ']'
            continue
        endif

        call add(bufNames, str)
    endfor

    return bufNames
endfun
" }}}

"s:ToggleGrepOptionOnOff: {{{2
fun! s:ToggleGrepOptionOnOff(key, ...)
    if a:0 == 0
        let s:GrepOptionsDict[a:key][1] = s:GrepOptionsDict[a:key][1] == "On"? "Off":"On"
    elseif a:0 == 1
        let s:GrepOptionsDict[a:key][1] = a:1
    endif
    echo s:GrepOptionsDict[a:key][1]
    call DisplayGrepOptions()
endfun
"}}}

"s:ChangeSearchDirectory: {{{2
fun! s:ChangeSearchDirectory()
    let dir = input("Grep in dir: ", "", "dir")
    if !len(dir)
        let dir = s:GetGrepOptionsValue("Directory", "value")
    endif
    if !isdirectory(dir)
        echo "Must be a exist directory!\n"
        let dir = s:GetGrepOptionsValue("Directory", "value")
    endif
    call s:SetGrepOptionsValue("Directory", dir)
    call DisplayGrepOptions()
endfun
"}}}

"s:ChangeIncludeExt: description {{{2
fun! s:ChangeIncludeExt()
    let include_ext = input("请输入要查找的文件扩展名（空格区分）: ")
    if len(include_ext) == 0
        return
    endif
    call s:SetGrepOptionsValue("IncludeExt", include_ext)
    call DisplayGrepOptions()
endfun
"}}}

"s:BuildFilterList: {{{2
fun! s:BuildIncludeExtList()
    "let g:mygrep_ext = ['c', 'h', 'py', 'txt', 'vim']
    let include_ext = s:GetGrepOptionsValue("IncludeExt", "value")
    if include_ext == "*"
        let ext_list = []
        let include = ' '
    else
        let ext_list = split(include_ext)
        let include = ' '
        for ext in ext_list
            let include .= '--include=*.'.ext.' '
        endfor
    endif
    return include
endfun
"}}}

"s:BuildGrepCmd: {{{2
fun! s:BuildGrepCmd()
    " 设置grepprg
    let grepprg = s:grepprg
    if s:GetGrepOptionsValue("LineNumber", "value") == "On"
        let grepprg .= "n"
    endif
    if s:GetGrepOptionsValue("Recursive", "value") == "On"
        let grepprg .= "r"
    endif
    if s:GetGrepOptionsValue("IgnoreCase", "value") == "On"
        let grepprg .= "i"
    endif
    if s:GetGrepOptionsValue("WholeWord", "value") == "On"
        let grepprg .= "w"
    endif
    exec grepprg

   let cmd = "silent! grep! "

    " 指定目录
    let dir = s:GetGrepOptionsValue("Directory", "value")
    let dir = substitute(dir, "\\\\$", "", "")

    " 输入查找内容
    let word=input("请输入要查找的内容: ", expand("<cword>"))
    if word == ''
        echo 'No input'
        return
    endif

    " highlight
    let @/ = matchstr(word, "\\v(-)\@<!(\<)\@<=\\w+|['\"]\\zs.{-}\\ze['\"]")
    call feedkeys(":let &hlsearch=1 \| echo \<CR>", 'n')

    let word = '"'.word.'"'

    let include = s:BuildIncludeExtList()

    let cmd = cmd. word . include . dir
    return cmd
endfun
"}}}

"s:DoGrepCmd: {{{2
fun! s:DoGrepCmd(cmd)
    echo ' '
    echo a:cmd
    let starttime = reltime()  " start the clock
    execute a:cmd
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    let l:match_count = len(getqflist())
    echo "找到" . l:match_count . "条记录，用时：" .elapsedtimestr.'s'
    if l:match_count
        exec "cw"
    endif
endfun
"}}}

command! -nargs=0 MyGrepOptions :call DisplayGrepOptions()
nmap <leader>go :MyGrepOptions<CR>
"}}}

" vim:fdm=marker:fmr={{{,}}}
