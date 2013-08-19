" 自定义工程{{{1

"设置全局变量{{{2
"-----------------------------------------------------------------------------"

" Prevent reloading
if exists('g:loaded_myproject')
   finish
endif
let g:loaded_myproject = 1

let g:debugmsg = 1

fun! s:EchoError(msg)
    if !exists('g:debugmsg')
        return
    endif
    echohl errormsg
    redraw
    echo a:msg
    echohl normal
endfun

fun! s:Set(var, val)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . string(a:val)
    end
endfun

"供状态条使用
call s:Set('g:current_project', '')
call s:Set('g:AllwaysUseSameDirToCreateFilenametags', '1')
call s:Set('g:AllwaysUseDefaultTagsCscopeName', '1')
"call s:Set('g:MyProjectDir', $HOME.'\MyProject')
call s:Set('g:MyProjectDir', 'E:\Workspace\MyProject')
call s:Set('g:MyProjectFile', 'MyProjectFile')
call s:Set('g:MyProjectFilter', '*.h *.c *.py')
call s:Set('g:MyProjectFindProgram', "dir /B /S /A-D /ON")
call s:Set('g:MyProjectWinHeight', "15")
"}}}

"获取当前工程名{{{2
"-----------------------------------------------------------------------------"
fun! GetProjectName()
    if g:current_project == ''
        return g:current_project
    else
        return g:current_project . ' | '
    endif
endfun
"}}}

"设置工程目录{{{2
"-----------------------------------------------------------------------------"
fun! s:SetMyProjectDir()
    if !isdirectory(g:MyProjectDir)
        call mkdir(g:MyProjectDir, "p")
        let s:my_project_dir = g:MyProjectDir
        return 1
    elseif exists('g:MyProjectDir')
        let s:my_project_dir = g:MyProjectDir
        return 1
    else
        return 0
    endif
endfun

fun! s:GetMyProjectDir()
    return s:my_project_dir
endfun
"}}}

"设置工程文件{{{2
"-----------------------------------------------------------------------------"
fun! s:SetMyProjectFile()
    let l:filename = expand(s:GetMyProjectDir() .'\'. g:MyProjectFile)
    if filereadable(l:filename)
        let s:my_project_file = l:filename
        return 1
    elseif !writefile([], l:filename)
        let s:my_project_file = l:filename
        return 1
    else
        return 0
    endif 
endfun

fun! s:GetMyProjectFile()
    return s:my_project_file
endfun
"}}}

"解析工程文件{{{2
"-----------------------------------------------------------------------------"
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

"s:my_project_dict格式:{'name':{'SourceCodeDir[x]':xxx, 'FilenametagsDir[x]':'xxx', 'tags':'xxx', 'cscope':'xxx', 'filenametags':'xxx'}}
fun! s:SetMyProjectDict()
    let s:my_project_dict = s:ParseIni(readfile(s:my_project_file))
    return 1
endfun

fun! s:GetMyProjectDict()
    return s:my_project_dict
endfun
"}}}

"设置当前工程{{{2
"-----------------------------------------------------------------------------"
fun! s:SetCurrentProject()
endfun
fun! s:GetCurrentProject()
    if exists('s:current_project')
        return s:current_project
    else
        return {}
    endif
endfun
"}}}

"当前工程列表{{{2
"-----------------------------------------------------------------------------"
fun! s:SetMyProjectList()
    let s:my_project_list = []
    "for key in keys(s:my_project_dict)
    "call add(s:my_project_list, key)
    "endfor
    if filereadable(s:my_project_file)
        let file = readfile(s:my_project_file)
        for line in file
            if match(line, '[') == 0
                let header = split(line, ';')[0]
                let section = strpart(header, 1, strlen(line) - 2)
                call add(s:my_project_list, section)
            endif
        endfor

    endif
endfun
fun! s:GetMyProjectList()
    if exists('s:my_project_list')
        return s:my_project_list
    endif
    return []
endfun
"}}}

" 入口 {{{2
"-----------------------------------------------------------------------------"
fun! s:InitMyProject()
    if !s:SetMyProjectDir()
        call s:EchoError('Dir Error')
    endif
    if !s:SetMyProjectFile()
        call s:EchoError('File Error')
    endif
    if !s:SetMyProjectDict()
        call s:EchoError('Dict Error')
    endif
    call s:SetMyProjectList()
endfun

fun! StartMyProject()
    call s:InitMyProject()
    call s:DisplayMyProject(s:GetMyProjectList())
endfun
"}}}

"添加新工程{{{2
"-----------------------------------------------------------------------------"
fun! s:IsProjectExist(project_name)
    if has_key(s:GetMyProjectDict(), a:project_name)
        return 1
    else
        return 0
    endif
endfun

fun! s:GetSourceDir(source_type)
    let l:ans = 'y'
    let l:str = a:source_type
    "源程序目录
    let source_dir = []
    while ((l:ans == 'y') || (l:ans == 'Y'))
        let dir = input("增加" . l:str . "目录: ", "", "dir")
        if dir !~ '\S'
            break
        endif
        while !isdirectory(dir)
            echohl errormsg
            let dir = input("必须是已存在的目录!\n" . l:str. " Directory: ", "", "dir")
            if dir !~ '\S'
                break
            endif
        endwhile
        if dir != ''
            call add(source_dir, dir)
        endif
        echohl normal
        let ans = input("是否再增加另一个". l:str. "目录？(Y/N) ")
    endwhile
    return source_dir
    call s:EchoError('源目录: ' . string(source_code_dir))
endfun

fun! s:AddNewMyProject()
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "项目名称
    let project_name = input("新项目名称: ", "", "file")
    if !len(project_name)
        return
    endif
    while s:IsProjectExist(project_name)
        echohl errormsg
        let project_name = input("该项目已存在!\n". "请重新输入项目名称: ", "", "file")
        if !len(project_name)
            return
        endif
        echohl normal
    endwhile

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let source_code_dir = s:GetSourceDir('Source Code')

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if g:AllwaysUseSameDirToCreateFilenametags == 1
        let filenametags_dir = source_code_dir
    else
        let choice = input("是否用源码目录创建filenametags? (Y/N)")
        if (choice == 'y') || (choice == 'Y')
            let filenametags_dir = source_code_dir
        elseif (choice == 'n') || (choice == 'N')
            let filenametags_dir = s:GetSourceDir('Filenametags')
        else
            let filenametags_dir = source_code_dir
        endif
    endif

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "是否用默认名称创建文件
    if g:AllwaysUseDefaultTagsCscopeName == 1
        let tags = "tags"
        let cscope = "cscope.out"
        let filenametags = "filenametags"
        let cache= "cache"
    else
        let tags = input("input tags file name(Default:tags)")
        let cscope = input("input cscope file name(Default:cscope.out)")
        let filenametags = input("input filenametags file name(Default:filenametags)")
        let cache = input("input cache file name(Default:cache)")
    endif
    let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
    let this_project_dir = escape(s:GetMyProjectDir().'\'.project_name, esc_filename_chars)
    let tags = this_project_dir.'\'.tags
    let cscope = this_project_dir.'\'.cscope
    let filenametags = this_project_dir.'\'.filenametags
    let cache = this_project_dir.'\'.cache

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let source_list = []
    for index in range(len(source_code_dir))
        let str = 'SourceCodeDir'. index .' = '.source_code_dir[index]
        call add(source_list, str)
    endfor

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let filenametags_list = []
    for index in range(len(filenametags_dir))
        let str = 'FilenametagsDir'. index .' = '.filenametags_dir[index]
        call add(filenametags_list, str)
    endfor

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    call mkdir(s:GetMyProjectDir().'\'.project_name, 'p')

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let tags_cscope_filenametags_list = []
    call add(tags_cscope_filenametags_list, 'tags = '.tags)
    call add(tags_cscope_filenametags_list, 'cscope = '.cscope)
    call add(tags_cscope_filenametags_list, 'filenametags = '.filenametags)

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let cache_list = []
    call add(cache_list, 'cache = '.cache)

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "输出到文件
    let item = ['', '[' . project_name . ']']
    let output = readfile(s:my_project_file) + item + source_list + filenametags_list + tags_cscope_filenametags_list + cache_list
    call writefile(output, s:my_project_file)
    echo "成功添加新工程：" . project_name 
    call StartMyProject()
    "定位到最后一行
    normal! G
    "更新tags, cscope, filenametags
    call s:UpdateProjectUnderCursor()
endfun
"}}}

" 移除光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:RemoveProjectUnderCursor()
    let prj_name = getline('.')
    if prj_name == ''
        return
    endif
    let l:ans = input("确定移除项目\"". prj_name. "\"？[Y/N] ")
    if l:ans == 'y' || l:ans == 'Y'
        let prj_name = '['.prj_name.']'
        let file_content_list = readfile(s:my_project_file)
        for i in range(len(file_content_list))
            if prj_name == file_content_list[i]
                let index = i
            endif
        endfor
        let start = index
        let list = file_content_list
        while (index < len(list) - 1) ? (match(s:strip(list[index + 1]), '[') != 0) : 0
            "call remove(file_content_list, index)
            let index = index + 1
        endwhile
        let end = index
        call remove(file_content_list, start, end)
        "echo file_content_list
        call writefile(file_content_list, s:my_project_file)
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        let l:cur_prj = s:GetProjectUnderCursor()
        if has_key(l:cur_prj, "name")
            let cur_prj_name = l:cur_prj['name']
        endif
        let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
        let my_cur_prj_dir = escape(s:GetMyProjectDir().'\'.cur_prj_name, esc_filename_chars)
        call s:DeleteDir(my_cur_prj_dir)
        echo "删除成功！"
    endif
    call StartMyProject()
endfun

fun! s:DeleteDir(name)
    if g:platform == 'win'
        let delName = tolower(a:name)
    else
        let recPath = g:VEConf.recyclePath
        let delName = a:name
    endif
    if isdirectory(a:name)
        if g:platform == 'win'
            return s:DoSystemCmd(" rmdir /S /Q \"" . escape(a:name,'%#'). "\"")
        else
            return s:DoSystemCmd("rm -r " . escape(a:name, ' %#') . "&")
        endif
    else
        if delete(a:name) == 0
            return 1
        else
            return 0
        endif
    endif
endfun

fun! s:DoSystemCmd(cmd)
    let convCmd = a:cmd
    call system(convCmd)
    return !(v:shell_error)
endfun
"-----------------------------------------------------------------------------"
"}}}

" 取得光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:GetProjectUnderCursor()
    let prj_name = getline('.')
    if prj_name == ''
        return
    endif
    let prj_dict = s:GetMyProjectDict()
    if has_key(prj_dict, prj_name)
        let l:cur_prj = prj_dict[prj_name]
        call extend(l:cur_prj, {'name':prj_name})
        let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
        let prj_dir = escape(s:GetMyProjectDir().'\'.prj_name, esc_filename_chars)
        call extend(l:cur_prj, {'MyPrjDir':prj_dir})
        return l:cur_prj
        "echo s:current_project
    elseif
        return {}
    endif
endfun
"-----------------------------------------------------------------------------"
"}}}

" 加载光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:LoadProjectUnderCursor()
    let l:cur_prj = s:GetProjectUnderCursor()
    if !empty(l:cur_prj)
        let s:current_project = l:cur_prj
        call s:SetTagsCscopeFilenametags()
    elseif
        echo "项目不存在!"
    endif
    silent! close
endfun
"-----------------------------------------------------------------------------"
"}}}

" 设置当前工程的tags，cscope，filenametags {{{2
"-----------------------------------------------------------------------------"
fun! s:SetTagsCscopeFilenametags()
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(s:current_project, "name")
        let g:current_project = s:current_project['name']
        " fuf提示符
        let g:fuf_mytaggedfile_prompt = '>'.s:current_project['name'].'>'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(s:current_project, "tags")
        if filereadable(s:current_project["tags"])
            exe ":set tags="
            exe ":set tags+=".s:current_project["tags"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(s:current_project, "cscope")
        if filereadable(s:current_project["cscope"])
            exe ":cscope reset"
            exe ":cscope add ".s:current_project["cscope"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(s:current_project, "filenametags")
        if filereadable(s:current_project["filenametags"])
            let g:filenametags = s:current_project["filenametags"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供fuf使用
    if has_key(s:current_project, "cache")
        if filereadable(s:current_project["cache"])
            let g:project_cache = s:current_project["cache"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供MyGrep使用
    if has_key(s:current_project, "SourceCodeDir0")
        let g:project_root_dir = s:current_project["SourceCodeDir0"]
    endif
    if has_key(s:current_project, "grep_ext")
        let g:project_grep_ext = s:current_project["grep_ext"]
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "MRU
    "let g:MRU_File = s:current_project['MyPrjDir'].'\'.s:current_project['name'].'_Mru_File'
    let g:MRU_File = g:MyProjectDir.'\'.s:current_project['name'].'\mru'
endfun
"-----------------------------------------------------------------------------"
"}}}

" 更新光标下的工程 {{{2
"-----------------------------------------------------------------------------"
fun! s:UpdateProjectUnderCursor()
    let l:cur_prj = s:GetProjectUnderCursor()
    let l:src_dir_list = []
    let l:fntags_dir_list = []
    let l:update_option = {'tags':1, 'cscope':1, 'filenametags':1, 'cache':1}
    for key in keys(l:cur_prj)
        let l:src_dir = matchstr(key, '^SourceCodeDir\d*')
        if l:src_dir != ""
            call add(l:src_dir_list, l:cur_prj[key])
        endif
    endfor
    for key in keys(l:cur_prj)
        let l:fntags_dir = matchstr(key, '^FilenametagsDir\d*')
        if l:fntags_dir != ""
            call add(l:fntags_dir_list, l:cur_prj[key])
        endif
    endfor
    let l:ans = input("更新所有的tags, cscope, filenametags, cache? [Y/N] ")
    if (l:ans == 'n') || (l:ans == 'N')
        let l:ans = input("更新tags? [Y/N] ")
        if (l:ans == 'n') || (l:ans == 'N')
            let l:update_option['tags'] = 0
        endif
        let l:ans = input("更新cscope? [Y/N] ")
        if (l:ans == 'n') || (l:ans == 'N')
            let l:update_option['cscope'] = 0
        endif
        let l:ans = input("更新filenametags? [Y/N] ")
        if (l:ans == 'n') || (l:ans == 'N')
            let l:update_option['filenametags'] = 0
        endif
        let l:ans = input("更新cache? [Y/N] ")
        if (l:ans == 'n') || (l:ans == 'N')
            let l:update_option['cache'] = 0
        endif
    endif
    if l:update_option['tags'] == 1
        call UpdateMyProjectTags(l:src_dir_list, l:cur_prj["tags"])
    endif
    if l:update_option['cscope'] == 1
        call UpdateMyProjectCscope(l:src_dir_list, l:cur_prj["cscope"])
    endif
    if l:update_option['filenametags'] == 1
        call UpdateMyProjectFilenametags(l:fntags_dir_list, l:cur_prj["filenametags"])
    endif
    if l:update_option['cache'] == 1
        call UpdateMyProjectCache(l:cur_prj["filenametags"], l:cur_prj["cache"])
    endif
    call s:LoadProjectUnderCursor()
endfun
"-----------------------------------------------------------------------------"
"}}}

" 刷新窗口 {{{2
"-----------------------------------------------------------------------------"
fun! s:RefreshDisplayWindow()
    call s:InitMyProject()
    call s:DisplayMyProject(s:GetMyProjectList())
endfun
"-----------------------------------------------------------------------------"
"}}}

"显示工程列表 {{{2
"-----------------------------------------------------------------------------"
fun! s:DisplayMyProject(project_list)
    let s:MyProjectDetailedHelp = 0
    let bname = '_MyProject_'
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
        exe 'silent! botright ' . g:MyProjectWinHeight . 'split ' . wcmd
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
    call s:MyProjectMapKeys()   
    " Restore the previous cpoptions settings
    let &cpoptions = old_cpoptions
    " Display the list
    call setline(1, s:MyProjectCreateHelp())
    silent! 0put = a:project_list
    " Move the cursor to the beginning of the file
    normal! G"_dd
    normal! gg
    setlocal nomodifiable
    call s:MyProjectSyntax()
    call cursor(s:firstBufferLine, 1)
endfun
"}}}

" 语法高亮 {{{2
"-----------------------------------------------------------------------------"
fun! s:MyProjectSyntax()
    syn match MyProjectList       /^[a-zA-Z0-9-_]\+$/
    hi def link MyProjectList Type
    syn match MyProjectHelp       "^\".*"
    hi def link MyProjectHelp Special
endfun
"}}}

" 显示帮助 {{{2
fun! s:MyProjectToggleHelp()
    let s:MyProjectDetailedHelp = !s:MyProjectDetailedHelp
    setlocal modifiable
    " Save position.
    normal! ma
    " Remove old header.
    if (s:firstBufferLine > 1)
        exec "keepjumps 1,".(s:firstBufferLine - 1) "d _"
    endif
    call append(0, s:MyProjectCreateHelp())
    silent! normal! g`a
    delmarks a
    setlocal nomodifiable
endfun

function! s:MyProjectCreateHelp()
    if s:MyProjectDetailedHelp == 0
        let s:firstBufferLine = 1
        return []
    endif
    let header = []

    if s:MyProjectDetailedHelp == 1
        call add(header, '" <F1> : 切换帮助')
        call add(header, '" <回车>: 加载工程')
        call add(header, '" a : 增加新工程')
        call add(header, '" u : 更新tags/cscope/filenametags/cache')
        call add(header, '" d : 删除工程')
        call add(header, '" <ESC> : 退出')
    else
        call add(header, '" Press <F1> for Help')
    endif
    let s:firstBufferLine = len(header) + 1
    return header
endfunction
"}}}

" 快捷键 {{{2
"-----------------------------------------------------------------------------"
fun! s:MyProjectMapKeys()   
    nnoremap <buffer> <silent> <F1>          :call <SID>MyProjectToggleHelp()<cr>
    nnoremap <buffer> <silent> <CR>          :call <SID>LoadProjectUnderCursor()<cr>
    nnoremap <buffer> <silent> u             :call <SID>UpdateProjectUnderCursor()<cr>
    nnoremap <buffer> <silent> a             :call <SID>AddNewMyProject()<cr>
    nnoremap <buffer> <silent> d             :call <SID>RemoveProjectUnderCursor()<cr>
    nnoremap <buffer> <silent> r             :call <SID>RefreshDisplayWindow()<cr>
    nnoremap <buffer> <silent> <ESC>         :close<CR>
endfun
"}}}

" 生成tags {{{2
"------------------------------------------------------------------------------"
fun! UpdateMyProjectTags(src_dir_list, tags)
    let l:src_dir_list = a:src_dir_list
    let l:tags = a:tags
    let l:output_dir = fnamemodify(a:tags, ":p:h")
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:cmd = g:MyProjectFindProgram
    let l:ext_filter = g:MyProjectFilter
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if filereadable(l:tags)
        call delete(l:tags)
    endif

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:output_cscope = l:output_dir.'\cscope.files'
    if filereadable(l:output_cscope)
        call delete(l:output_cscope)
    endif
    if !filereadable(l:output_cscope)
        let starttime = reltime()  " start the clock
        echo "生成tags文件列表中..."
        let l:cscope_string = ''
        for l:index in range(len(l:src_dir_list))
            "转到project目录
            execute "cd " .  l:src_dir_list[l:index]
            "得到命令输出
            let l:cscope_string = l:cscope_string . system(l:cmd . " " . l:ext_filter)
        endfor
        "分行
        let l:cscope_list = split(l:cscope_string, '\n')
        "写入文件
        call writefile(l:cscope_list, l:output_cscope)
        let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
        echo "tags文件列表已创建! ". '(time: '.elapsedtimestr.'s)'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    execute "cd " . output_dir 
    let starttime = reltime()  " start the clock
    echo "生成tags中..."
    "call system("ctags -L cscope.files")
    call system("ctags -L cscope.files --c++-kinds=+p --fields=+iaS --extra=+q .")
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "tags已创建! ". '(time: '.elapsedtimestr.'s)'
endfun
"------------------------------------------------------------------------------"
"}}}

" 生成cscope {{{2
"-----------------------------------------------------------------------------"
fun! UpdateMyProjectCscope(src_dir_list, cscope)
    let l:src_dir_list = a:src_dir_list
    let l:cscope_out = a:cscope
    let l:output_dir = fnamemodify(a:cscope, ":p:h")
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:cmd = g:MyProjectFindProgram
    let l:ext_filter = g:MyProjectFilter
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:output_cscope = l:output_dir.'\cscope.files'
    if !filereadable(l:output_cscope)
        let starttime = reltime()  " start the clock
        echo "生成cscope文件列表中..."
        let l:cscope_string = ''
        for l:index in range(len(l:src_dir_list))
            "转到project目录
            execute "cd " .  l:src_dir_list[l:index]
            "得到命令输出
            let l:cscope_string = l:cscope_string . system(l:cmd . " " . l:ext_filter)
        endfor
        "分行
        let l:cscope_list = split(l:cscope_string, '\n')
        "写入文件
        call writefile(l:cscope_list, l:output_cscope)
        let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
        echo "cscope文件列表已创建! ". '(time: '.elapsedtimestr.'s)'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    execute "cd " . output_dir 
    let starttime = reltime()  " start the clock
    echo "生成cscope中..."
    let l:temp = system("cscope.exe -bk -i ".l:output_cscope)
    "call delete(l:output_cscope)
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "cscope已创建! ". '(time: '.elapsedtimestr.'s)'
endfun
"-----------------------------------------------------------------------------"
"}}}

" 生成filenametags {{{2
"-----------------------------------------------------------------------------"
"生成filename_tag，用于fuzzyfinder的taggedfile模式快速打开文件
function! UpdateMyProjectFilenametags(fntags_dir_list, filenametags)
    let starttime = reltime()  " start the clock
    let l:fntags_dir_list = a:fntags_dir_list
    let l:output_filenametags = a:filenametags
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:cmd = g:MyProjectFindProgram
    let l:ext_filter = g:MyProjectFilter
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    echo "生成filenametags中..."
    if filereadable(l:output_filenametags)
        call delete(l:output_filenametags)
    endif
    let l:filenametags_string = ''
    for l:index in range(len(l:fntags_dir_list))
        "转到project目录
        execute "cd " .  l:fntags_dir_list[l:index]
        "得到命令输出
        let l:filenametags_string = l:filenametags_string . system(l:cmd . " " . l:ext_filter)
    endfor

    "分行
    let l:filenametags_list = split(l:filenametags_string, '\n')
    "排序
    let l:filenametags_list = sort(l:filenametags_list)

    "按tag格式整理好
    let l:item = ""
    let l:count = 0
    for l:item in l:filenametags_list
        let l:item = fnamemodify(l:item, ':t') . "\t" . l:item . "\t" . "1"
        let l:filenametags_list[l:count] = l:item
        let l:count = l:count + 1
    endfor

    "加上tags文件头
    let l:final_filenametags = ["!_TAG_FILE_SORTED   2   \/2=foldcase\/"]
    call extend(l:final_filenametags, l:filenametags_list)
    "写入文件
    call writefile(l:final_filenametags, l:output_filenametags)
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "filenametags已创建! ". '(time: '.elapsedtimestr.'s)'
endfunction
"-----------------------------------------------------------------------------"
"}}}

" 生成cache {{{2
"-----------------------------------------------------------------------------"
"生成cache，用于fuzzyfinder的taggedfile模式快速打开文件，需要先生成filenametags
function! UpdateMyProjectCache(filenametags, cache_file)
    if !filereadable(a:filenametags)
        call delete(a:filenametags)
        echo "需要先生成filenametags"
        return
    endif
    let starttime = reltime()  " start the clock
    echo "生成cache中..."
    let tags=[a:filenametags]
    let tags = sort(filter(map(tags, 'fnamemodify(v:val, '':p'')'), 'filereadable(v:val)'))
    let cacheName = a:cache_file
    "let items = []
    let items = l9#unique(l9#concat(map(copy(tags), 's:gettaggedfileList(v:val)')))
    call map(items, 'fuf#makePathItem(v:val, "", 0)')
    call fuf#mapToSetSerialIndex(items, 1)
    call fuf#mapToSetAbbrWithSnippedWordAsPath(items)
    call s:saveDataFile(cacheName, items)
    let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
    echo "cache已创建! " . '(time: '.elapsedtimestr.'s)'
endfunction

function s:gettaggedfileList(tagfile)
    execute 'cd ' . fnamemodify(a:tagfile, ':h')
    let result = map(l9#readFile(a:tagfile), 'matchstr(v:val, ''^[^!\t][^\t]*\t\zs[^\t]\+'')')
    call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":p")')
    cd -
    call map(l9#readFile(a:tagfile), 'fnamemodify(v:val, ":~:.")')
    return filter(result, 'v:val =~# ''[^/\\ ]$''')
endfunction

function! s:saveDataFile(dataName, items)
    let lines = map(copy(a:items), 'string(v:val)')
    return l9#writeFile(lines, a:dataName)
endfunction
"-----------------------------------------------------------------------------"
"}}}
" vim:fdm=marker:fmr={{{,}}} foldlevel=1:
"}}}
