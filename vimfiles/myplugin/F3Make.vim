" Prevent reloading{{{
if exists('g:f3make')
    finish
endif
let g:f3make = 1
"}}}

" Only working in windows {{{
if (!has("win32") && !has("win95") && !has("win64") && !has("win16"))
    finish
endif
"}}}

let g:f3make_error = "Error"
let g:f3make_warning = "Warning"
let g:f3_zip_tool = 'C:\Program Files\7-Zip\7z.exe'

fun! s:strip(text)
    let text = substitute(a:text, '^[[:space:][:cntrl:]]\+', '', '')
    let text = substitute(text, '[[:space:][:cntrl:]]\+$', '', '')
    return text
endfun

fun! s:ParseIni(ini)
    let parsed = {}
    for line in a:ini
        let line = s:strip(line)
        if strlen(line) > 0
            if match(line, '^\s*;') == 0
                continue
            elseif match(line, '[') == 0
                let header = split(line, ';')[0]
                let section = strpart(header, 1, strlen(line) - 2)
                let parsed[section] = {}

            else
                let optline = map(split(line, '='), 's:strip(v:val)')

                if len(optline) > 1
                    let optval = split(optline[1], ';')[0]
                else
                    let optval = 1
                end

                let parsed[section][optline[0]] = optval
            end
        end
    endfor
    return parsed
endfun

fun! s:SetMyProjectDict()
    let s:my_project_dict = s:ParseIni(readfile(s:my_project_file))
    return 1
endfun

" s:Handle_String {{{
fun! s:Handle_String(string)
   let l:str = a:string
   "trim
   let l:str = substitute(l:str, '^[[:blank:]]*\|[[:blank:]]*$', '', 'g')
   "if there is any space in file name, enclosed by double quotation
   if len(matchstr(l:str, " "))
      "don't add backslash before any white-space
      let l:str = substitute(l:str, '\\[[:blank:]]\+', " ", "g")
      let l:str = '"'.l:str.'"'
   endif
   return l:str
endfun
"}}}

" F3Make.vim {{{2
fun! F3make()
    if !exists('g:project_root_dir')
        echo "请先指定工程"
        return
    endif
    let cmd = g:project_root_dir . 'F1_Dev\source\f3make.bat'
    if !filereadable(cmd)
        echo "F3make.bat路径错误，请手动指定"
        return
    endif

    let s = localtime()
    let l:result=system(cmd)
    let e = localtime() - s
    "echo e
    if matchstr(l:result, '-------------- Failed Build ---------------') != ""
        echo 'Failed'
    else
        echo 'Pass, 现在开始解压'
        "let l:result = F3_Extract()
    endif

    " Show results
    call s:Show_F3Make_Result(l:result)
endfun
"}}}

" ToggleF3MakeResultWindow {{{
fun! ToggleF3MakeResultWindow()
    let bname = '_F3Make_Result_'
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
        echoh Error | echo "No F3make results yet!" | echoh None
        let wcmd = bname
    else
        let wcmd = '+buffer' . bufnum
        exe 'silent! botright ' . '15' . 'split ' . wcmd
    endif
endfun
"}}}

"s:Show_F3Make_Result {{{
fun! s:Show_F3Make_Result(result)
    let bname = '_F3Make_Result_'
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
    call s:Map_Keys()
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    " Display the result
    silent! %delete _
    silent! 0put =a:result

    " Delete the last blank line
    silent! $delete _
    " Move the cursor to the beginning of the file
    normal! G
    call s:F3MakeSyntax()
    setlocal nomodifiable
endfun
"}}}

"F3MakeSyntax {{{2
fun! s:F3MakeSyntax()
    sy case ignore
    let e = ":syn match F3Make_Word ". '"'. g:f3make_error .'"'
    exe e
    let w = ":syn match F3Make_Word ". '"'. g:f3make_warning .'"'
    exe w
    hi def link F3Make_Word Type
endfun
"}}}

"Map_Keys {{{
fun! s:Map_Keys()
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>Open_Error_File()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>
                \ :call <SID>Open_Error_File()<CR>
    nnoremap <buffer> <silent> <ESC> :close<CR>
endfun
"}}}

" Open_Error_File {{{
fun! s:Open_Error_File()
    let line = getline('.')
    if line == ''
        return
    endif
    " 将工程目录的\转成/
    let project_dir = substitute(g:project_root_dir, '\\', '/', 'g')
    " 用工程目录名代替..\..\
    let error_file = substitute(line, '"\.\.\\\.\.\\', project_dir, 'g')
    " 转换/为\
    let error_file = substitute(error_file, '/', "\\", 'g')
    " 去掉后面的部分
    let error_file = substitute(error_file, '".*$', "", 'g')

    "let esc_fname_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
    "let esc_fname = escape(error_file, esc_fname_chars)
    if !filereadable(error_file)
        echo "文件不存在"
        return
    endif
    
    " 先把行号前面的内容去掉
    let line_num = substitute(line, '^".*", line ', '', 'g')
    " 再把后面的去掉
    let line_num = substitute(line_num, '\(\d\+\):.*$', '\1', 'g')

    let winnum = bufwinnr('^' . error_file . '$')
    if winnum != -1
        " Automatically close the window
        silent! close
        " If the selected file is already open in one of the windows, jump to it
        let winnum = bufwinnr('^' . error_file . '$')
        if winnum != winnr()
            exe winnum . 'wincmd w'
        endif
        silent! execute "call cursor(line_num, 1)"
    else
        " Automatically close the window
        silent! close
        " Edit the file
        exe 'edit ' . error_file
        silent! execute "call cursor(line_num, 1)"
    endif
endfun
"}}}

"F3_Extract: {{{2
fun! F3_Extract()
    let zip_tool = s:Handle_String(g:f3_zip_tool)
    let project_zip_file = 'E:\Workspace\LightningBug\BuildOutput\Objects\final\ST_DLFILES_SD.00000000.00.00.LSGEN200.STF0.00000000.00435736.zip'
    let Project_DownDir = 'C:\var\merlin\dlfiles\LightningBug\'
    let Project_CFW_File= 'LSGEN200.STF0.00000000.00435736.CFW.LOD'
    let Project_OVL_File= 'LSGEN200.STF0.00000000.00435736.S_OVL.LOD'
    let Project_TPM_File= 'LSGEN200.STF0.00000000.00435736.TPM.LOD'
    let cmd = zip_tool .' e ' . project_zip_file . ' -o' . Project_DownDir . ' -aoa ' . Project_CFW_File . ' ' . Project_OVL_File . ' ' . Project_TPM_File
    echo cmd
    let result=system(cmd)
    return result
endfun
"}}}

command! -nargs=* F3 call F3make()
command! -nargs=* FT call ToggleF3MakeResultWindow()

" vim:fdm=marker:fmr={{{,}}}
