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

if !has("python")
    echo "需要python支持"
    finish
endif

let g:f3make_error = "Error"
let g:f3make_warning = "Warning"
let s:f3make_cmd = ""

" s:LoadCurrentProjectDictFromMyProject {{{2
fun! s:LoadCurrentProjectDictFromMyProject()
    let l:cur_prj_dict = GetCurrentProjectDict()
    return l:cur_prj_dict
endfun
"}}}

" F3Make: 编译{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   编译
" @参    数：   increment_build: 是否增量编译
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! F3make(increment_build)
    let cur_prj_dict = s:LoadCurrentProjectDictFromMyProject()
    if has_key(cur_prj_dict, "name")
        let l:cur_prj_name = cur_prj_dict['name']
    else
        echo "请先指定工程"
        return
    endif
    if has_key(cur_prj_dict, "SourceCodeDir0")
        let l:cur_prj_path = cur_prj_dict['SourceCodeDir0']
    else
        echo "没有工程目录"
        return
    endif
    let l:build_target = ""
    if a:increment_build == 0
        if has_key(cur_prj_dict, "build_target")
            let l:build_target = cur_prj_dict['build_target']
        else
            let l:build_target = ""
        endif
    endif

    let s:f3make_cmd = Py_find_f3make(l:cur_prj_path)
    if s:f3make_cmd == ""
        echo "找不到f3make.bat"
    endif

    let cmd = s:f3make_cmd . " " . l:build_target
    let s = localtime()
    let l:result=system(cmd)
    let e = localtime() - s
    echo "耗时：" . e . "s"

    if matchstr(l:result, '-------------- Passed Build ---------------') != ""
        echo '编译成功, 现在开始解压...'
        call Py_find_package_and_extract(l:result, l:cur_prj_name, l:build_target)
        call s:Show_F3Make_Result(l:result, 'close')
    else
        echohl errormsg
        echo '编译失败'
        echohl normal
        call s:Show_F3Make_Result(l:result, 'open')
    endif
endfun
"}}}

" Py_find_f3make: 用python找到f3make.bat {{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   用python找到f3make.bat
" @参    数：   path: 工程目录
" @返 回 值：   f3make.bat文件路径
"* --------------------------------------------------------------------------*/
fun! Py_find_f3make(path)
    let l:f3make = ""
python << EOF
import vim, os
path = vim.eval("a:path")
for r,d,f in os.walk(path):
   for files in f:
      if files == "f3make.bat":
         f3make = os.path.join(r,files)
vim.command("let l:f3make = '" + f3make + "'")
EOF
    return l:f3make
endfun
"}}}

" Py_find_package_and_extract: 用Python找到编译生成的压缩包，并解压到指定目录{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   用Python找到编译生成的压缩包，并解压到指定目录
" @参    数：   result: 编译完得到的结果
" @参    数：   prj_name: 工程名字
" @参    数：   build_target: 编译命令
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! Py_find_package_and_extract(result, prj_name, build_target)
python << EOF
import vim, os, re, zipfile
result = vim.eval("a:result")
build_target = vim.eval("a:build_target")
prj_name = vim.eval("a:prj_name")
m = re.search('.*' + build_target + '.*zip', result)
zip_file = m.group().strip()

home = os.environ['HOME']
tmp_dir = os.path.join(home, 'temp/')
target_dir = os.path.join('c:/var/merlin/dlfiles/', prj_name)
if os.path.isdir(tmp_dir) != True:
   os.mkdir(tmp_dir)
files_in_zip = zipfile.ZipFile(zip_file, 'r')
for file in files_in_zip.namelist():
   #ST_DLFILES_SD.00000000.00.00.LSGEN200.STF0.00000000.00435736.zip
   # 压缩包内还有zip
   m = re.match('.*zip', file)
   if m is not None and file.startswith('ST_DLFILES'):
      #先解压出ST_DLFILES到临时文件夹
      files_in_zip.extract(file, tmp_dir)
      dl_zip_file = os.path.join(tmp_dir, file)
      files_in_dl_zip = zipfile.ZipFile(dl_zip_file, 'r')
      for sub_file in files_in_dl_zip.namelist():
         #再从压缩包内匹配出CFW和OVL
         m = re.match('.+CFW.LOD$|.+S_OVL.LOD$|.+TPM.LOD$', sub_file)
         if m is not None:
            files_in_dl_zip.extract(sub_file, target_dir)
            print os.path.join(target_dir, sub_file)
   m = re.match('.+CFW.LOD$|.+S_OVL.LOD$|.+TPM.LOD$', file)
   if m is not None:
      files_in_zip.extract(file, target_dir)
EOF
endfun
"}}}

" Py_f3make: 用Python调用系统命令编译 {{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   用Python调用系统命令编译
"               TODO: 实在没法处理引号双引号输出到vim的问题，弃用
" @参    数：   f3make_cmd: f3make.bat
" @参    数：   target: 编译命令
" @返 回 值：   编译输出的结果
"* --------------------------------------------------------------------------*/
fun! Py_f3make(f3make_cmd, target)
python << EOF
import os, subprocess
f3make = vim.eval("a:f3make_cmd")
target = vim.eval("a:target")
cmd = f3make + ' ' + target
#out = os.system(cmd)
p=subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
(stdoutput,erroutput) = p.communicate()
#print stdoutput
#p.wait()
EOF
endfun
"}}}

" ToggleF3MakeResultWindow: 切换结果显示窗口 {{{
"* --------------------------------------------------------------------------*/
" @函数说明：   切换结果显示窗口
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! ToggleF3MakeResultWindow()
    let bname = '__F3Make_Result__'
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
        echoh Error | echo "没有F3make编译结果!" | echoh None
        let wcmd = bname
    else
        let wcmd = '+buffer' . bufnum
        exe 'silent! botright ' . '15' . 'split ' . wcmd
    endif
endfun
"}}}

" s:Show_F3Make_Result: 显示结果 {{{
"* --------------------------------------------------------------------------*/
" @函数说明：   显示结果
" @参    数：   result: 结果
" @参    数：   open_close_option: 打开还是关闭窗口
" @返 回 值：   
"* --------------------------------------------------------------------------*/
fun! s:Show_F3Make_Result(result, open_close_option)
    let bname = '__F3Make_Result__'
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
    if a:open_close_option == 'close'
        silent! close
    endif
endfun
"}}}

" s:F3MakeSyntax {{{2
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

" s:Map_Keys {{{
fun! s:Map_Keys()
    nnoremap <buffer> <silent> <CR>
                \ :call <SID>Open_Error_File()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse>
                \ :call <SID>Open_Error_File()<CR>
    nnoremap <buffer> <silent> <ESC> :close<CR>
endfun
"}}}

" s:Open_Error_File {{{
fun! s:Open_Error_File()
    let line = getline('.')
    if line == ''
        return
    endif
    if s:f3make_cmd == ""
        echo "找不到s:f3make_cmd"
        return
    endif
    " 先通过f3make.bat定位到工程目录
    let source_dir = substitute(s:f3make_cmd, 'F1_Dev\\source\\f3make.bat', '', 'g')
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

command! -nargs=* F3 call F3make(1)
command! -nargs=* F3NEW call F3make(0)
command! -nargs=* FT call ToggleF3MakeResultWindow()

" vim:fdm=marker:fmr={{{,}}}
