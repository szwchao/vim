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

"s:LoadCurrentProjectDictFromMyProject: description {{{2
fun! s:LoadCurrentProjectDictFromMyProject()
    let l:cur_prj_dict = GetCurrentProjectDict()
    return l:cur_prj_dict
endfun
"}}}

" F3Make.vim {{{2
fun! F3make(increment_build)
    let cur_prj_dict = s:LoadCurrentProjectDictFromMyProject()
    if has_key(cur_prj_dict, "name")
        let cur_prj_name = cur_prj_dict['name']
    else
        echo "请先指定工程"
        return
    endif

    let target = ""
    if a:increment_build == 0
        if has_key(cur_prj_dict, "build_target")
            let target = cur_prj_dict['build_target']
        else
            let target = ""
        endif
    endif
    let f3make = ""
    if has_key(cur_prj_dict, "f3make_cmd")
        let f3make = cur_prj_dict['f3make_cmd']
        if !filereadable(f3make)
            let f3make = input("F3make.bat路径错误，请重新指定: ", "", "file")
        endif
    else
        echo "没有f3make.bat"
        return
    endif

    let cmd = f3make . " " . target
    echo cmd

    let s = localtime()
    let l:result=system(cmd)
    let e = localtime() - s
    "echo e

    if matchstr(l:result, '-------------- Failed Build ---------------') != ""
        echohl errormsg
        echo 'Failed'
        echohl normal
    else
        echo 'Pass, 现在开始解压...'
        echo F3_Extract()
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
    let e = ":syn match F3Make_Error ". '"'. g:f3make_error .'"'
    exe e
    let w = ":syn match F3Make_Warning ". '"'. g:f3make_warning .'"'
    exe w
    hi def link F3Make_Error Error
    hi def link F3Make_Warning Type
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
    let cur_prj_dict = s:LoadCurrentProjectDictFromMyProject()
    if has_key(cur_prj_dict, "f3make_cmd")
        let f3make_file = cur_prj_dict['f3make_cmd']
    else
        echo "找不到f3make"
    endif
    let source_dir = substitute(f3make_file, 'F1_Dev\\source\\f3make.bat', '', 'g')
    " 将工程目录的\转成/
    let project_dir = substitute(source_dir, '\\', '/', 'g')
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
    if !filereadable(g:f3_zip_tool)
        echo "没有7z解压工具"
        return
    endif

    let zip_tool = s:Handle_String(g:f3_zip_tool)
    let cur_prj_dict = s:LoadCurrentProjectDictFromMyProject()
    if has_key(cur_prj_dict, "project_zip_file")
        let project_zip_file = cur_prj_dict['project_zip_file']
    endif
    if has_key(cur_prj_dict, "project_zip_file")
        let project_download_dir = cur_prj_dict['project_download_dir']
    endif
    if has_key(cur_prj_dict, "project_cfw_file")
        let project_cfw_file = cur_prj_dict['project_cfw_file']
    endif
    if has_key(cur_prj_dict, "project_ovl_file")
        let project_ovl_file = cur_prj_dict['project_ovl_file']
    endif
    if has_key(cur_prj_dict, "project_tpm_file")
        let project_tpm_file = cur_prj_dict['project_tpm_file']
    endif
    let cmd = zip_tool .' e ' . project_zip_file . ' -o' . project_download_dir . ' -aoa ' . project_cfw_file . ' ' . project_ovl_file . ' ' . project_tpm_file
    let result=system(cmd)
    if matchstr(result, 'Everything is Ok') != ""
        return "解压成功"
    else
        return result
    endif
endfun
"}}}

command! -nargs=* F3 call F3make(1)
command! -nargs=* F3NEW call F3make(0)
command! -nargs=* FT call ToggleF3MakeResultWindow()

" vim:fdm=marker:fmr={{{,}}}
