" 自定义工程{{{1

"设置全局变量{{{2
"-----------------------------------------------------------------------------"

" Prevent reloading
if exists('g:loaded_myproject')
   finish
endif
let g:loaded_myproject = 1

fun! s:Set(var, val)
    if !exists(a:var)
        exec 'let ' . a:var . ' = ' . string(a:val)
    end
endfun

"供状态条以及编译使用
call s:Set('g:current_project_name', '')
" 用源码目录创建filenametags
call s:Set('g:AllwaysUseSameDirToCreateFilenametags', '1')
" 用默认名创建tag, cscope
call s:Set('g:AllwaysUseDefaultTagsCscopeName', '1')
" 是否可以添加多个源码目录
call s:Set('g:EnableMultiSourceCodeDir', '0')
" 工程目录名
"call s:Set('g:MyProjectConfigDir', $HOME.'\MyProject')
call s:Set('g:MyProjectConfigDir', 'E:\Workspace\MyProject')
" 配置文件名
call s:Set('g:MyProjectConfigFile', 'MyProjectFile')
if g:platform == 'win'
    " 过滤文件类型
    call s:Set('g:MyProjectFileFilter', '*.h *.c *.cpp *.py')
    " 生成文件列表的命令
    call s:Set('g:MyProjectFindProgram', "dir /B /S /A-D /ON")
else
    " 过滤文件类型
    call s:Set('g:MyProjectFileFilter', ' -name "*.h" -o -name "*.c" -o -name "*.cpp"')
    " 生成文件列表的命令
    call s:Set('g:MyProjectFindProgram', 'find ')
endif
" 窗口高度
call s:Set('g:MyProjectWinHeight', "15")
" seagate编译选项
call s:Set('g:EnableAddF3MakeVar', '0')
"}}}

"调试{{{2
"-----------------------------------------------------------------------------"
let s:debugmsg = 0

fun! s:EchoError(msg)
    if s:debugmsg != 1
        return
    endif
    echohl errormsg
    redraw
    echo a:msg
    echohl normal
endfun
"}}}

"获取当前工程名{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   获取project名称
" @返 回 值：   字符串
"* --------------------------------------------------------------------------*/
fun! GetProjectName()
    return g:current_project_name
endfun
"}}}

"设置工程配置目录{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   设置工程配置目录，不存在则创建目录
" @返 回 值：   1 - 成功， 0 - 失败
"* --------------------------------------------------------------------------*/
fun! s:SetMyProjectDir()
    if !isdirectory(g:MyProjectConfigDir)
        call mkdir(g:MyProjectConfigDir, "p")
        let s:my_project_config_dir = g:MyProjectConfigDir
        return 1
    elseif exists('g:MyProjectConfigDir')
        let s:my_project_config_dir = g:MyProjectConfigDir
        return 1
    else
        return 0
    endif
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   获取工程配置目录
" @返 回 值：   目录名称字符串
"* --------------------------------------------------------------------------*/
fun! s:GetMyProjectConfigDir()
    return s:my_project_config_dir
endfun
"}}}

"设置工程配置文件{{{2
"* --------------------------------------------------------------------------*/
" @函数说明：   设置工程配置文件
" @返 回 值：   1 - 成功， 0 - 失败
"* --------------------------------------------------------------------------*/
fun! s:SetMyProjectConfigFile()
    let l:filename = expand(s:GetMyProjectConfigDir() .g:slash. g:MyProjectConfigFile)
    if filereadable(l:filename)
        let s:my_project_config_file = l:filename
        return 1
    elseif !writefile([], l:filename)
        let s:my_project_config_file = l:filename
        return 1
    else
        return 0
    endif 
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   获取工程配置文件
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! s:GetMyProjectConfigFile()
    return s:my_project_config_file
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   编辑工程配置文件
" @返 回 值：   无
"* --------------------------------------------------------------------------*/
fun! s:EditMyProjectFile()
    let l:filename = s:GetMyProjectConfigFile()
    silent! close
    exec "e ". l:filename
endfun
"}}}

"解析工程配置文件{{{2
"-----------------------------------------------------------------------------"
fun! s:strip(text)
    let text = substitute(a:text, '^[[:space:][:cntrl:]]\+', '', '')
    let text = substitute(text, '[[:space:][:cntrl:]]\+$', '', '')
    return text
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   解析配置文件
" @参    数：   config_file，配置文件的路径
" @返 回 值：   解析好的字典
"* --------------------------------------------------------------------------*/
fun! s:ParseIni(config_file)
    let parsed = {}
    for line in a:config_file
        let line = s:strip(line)
        if strlen(line) > 0
            if match(line, '^\s*;') == 0
                " 空行
                continue
            elseif match(line, '[') == 0
                " []里的头部
                let header = split(line, ';')[0]
                let section = strpart(header, 1, strlen(line) - 2)
                let parsed[section] = {}
            else
                " xxx = yyy，xxx作为key，yyy作为value
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

"* --------------------------------------------------------------------------*/
" @函数说明：   由配置文件解析工程字典
" @返 回 值：   字典s:my_project_dict，格式:
"               {'name':{'SourceCodeDirx':xxx, 'FilenametagsDirx':'xxx', 
"                        'tags':'xxx', 'cscope':'xxx', 'filenametags':'xxx',
"                        'cache':'xxx'}}
"* --------------------------------------------------------------------------*/
fun! s:SetMyProjectDict()
    let s:my_project_dict = s:ParseIni(readfile(s:my_project_config_file))
    return 1
endfun

fun! GetMyProjectDict()
    return s:my_project_dict
endfun
"}}}

"设置当前工程{{{2
"-----------------------------------------------------------------------------"
fun! s:SetCurrentProject(cur_prj)
    let s:current_project = a:cur_prj
endfun
fun! GetCurrentProjectDict()
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
    if filereadable(s:my_project_config_file)
        let file = readfile(s:my_project_config_file)
        for line in file
            if match(line, '[') == 0
                let header = split(line, ';')[0]
                let section = strpart(header, 1, strlen(line) - 2)
                call add(s:my_project_list, section)
            endif
        endfor
    endif
endfun
fun! s:GetMyProjectNameList()
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
        call s:EchoError('Project Dir Error')
    endif
    if !s:SetMyProjectConfigFile()
        call s:EchoError('Config File Error')
    endif
    if !s:SetMyProjectDict()
        call s:EchoError('Project Dict Error')
    endif
    call s:SetMyProjectList()
endfun

fun! StartMyProject()
    call s:InitMyProject()
    call s:DisplayMyProject(s:GetMyProjectNameList())
endfun
"}}}

"添加新工程{{{2
"-----------------------------------------------------------------------------"
fun! s:IsProjectExist(project_name)
    if has_key(GetMyProjectDict(), a:project_name)
        return 1
    else
        return 0
    endif
endfun

fun! s:InputSourceCodeDir(source_type)
    let l:ans = 'y'
    let l:str = a:source_type
    "源程序目录
    let source_dir = []
    while ((l:ans == 'y') || (l:ans == 'Y'))
        let dir = input("增加" . l:str . "目录: ", "", "dir")
        if dir !~ '\S'
            break
        endif
        while !isdirectory(expand(dir))
            echohl errormsg
            let dir = input("必须是已存在的目录!\n" . l:str. " Directory: ", "", "dir")
            if dir !~ '\S'
                break
            endif
        endwhile
        if dir != ''
            call add(source_dir, expand(dir))
        endif
        echohl normal
        if g:EnableMultiSourceCodeDir == 1
            let l:ans = input("是否再增加另一个". l:str. "目录？(Y/N) ")
        else
            break
        endif
    endwhile
    call s:EchoError('源目录: ' . string(source_dir))
    return source_dir
endfun

"* --------------------------------------------------------------------------*/
" @函数说明：   输入f3make的相关参数，包括：
"               1. target编译命令
" @参    数：   project_name - 工程名
" @参    数：   source_dir - 源码目录
" @返 回 值：   f3make的参数列表
"* --------------------------------------------------------------------------*/
fun! s:InputF3MakeVar(project_name, source_dir)
    let f3make_list = []

    let build_target = input("指定编译的Target: ")
    call add(f3make_list, 'build_target = '. build_target)
    return f3make_list
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
    let source_code_dir = s:InputSourceCodeDir('Source Code')

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if g:AllwaysUseSameDirToCreateFilenametags == 1
        let filenametags_dir = source_code_dir
    else
        let choice = input("是否用源码目录创建filenametags? (Y/N)")
        if (choice == 'y') || (choice == 'Y')
            let filenametags_dir = source_code_dir
        elseif (choice == 'n') || (choice == 'N')
            let filenametags_dir = s:InputSourceCodeDir('Filenametags')
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
    let this_project_dir = escape(s:GetMyProjectConfigDir().g:slash.project_name, esc_filename_chars)
    let tags = this_project_dir.g:slash.tags
    let cscope = this_project_dir.g:slash.cscope
    let filenametags = this_project_dir.g:slash.filenametags
    let cache = this_project_dir.g:slash.cache

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
    call mkdir(s:GetMyProjectConfigDir().g:slash.project_name, 'p')

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let tags_cscope_filenametags_list = []
    call add(tags_cscope_filenametags_list, 'tags = '.tags)
    call add(tags_cscope_filenametags_list, 'cscope = '.cscope)
    call add(tags_cscope_filenametags_list, 'filenametags = '.filenametags)

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let cache_list = []
    call add(cache_list, 'cache = '.cache)

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let f3make_list = []
    if g:EnableAddF3MakeVar == 1
        let l:ans = input("添加f3make相关参数？[Y/N] ")
        if l:ans == 'y' || l:ans == 'Y'
            let f3make_list = s:InputF3MakeVar(project_name, source_code_dir[0])
        endif
    endif

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "输出到文件
    let item = ['', '[' . project_name . ']']
    let output = readfile(s:my_project_config_file) + item + source_list + filenametags_list + tags_cscope_filenametags_list + cache_list + f3make_list
    call writefile(output, s:my_project_config_file)
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
        let file_content_list = readfile(s:my_project_config_file)
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
        call writefile(file_content_list, s:my_project_config_file)
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        let l:cur_prj = s:GetProjectUnderCursor()
        if has_key(l:cur_prj, "name")
            let cur_prj_name = l:cur_prj['name']
        endif
        let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
        let my_cur_prj_dir = escape(s:GetMyProjectConfigDir().g:slash.cur_prj_name, esc_filename_chars)
        call s:DeleteDir(my_cur_prj_dir)
        echo "删除成功！"
    endif
    call StartMyProject()
endfun

fun! s:DeleteDir(name)
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
        return {}
    endif
    let prj_dict = GetMyProjectDict()
    if has_key(prj_dict, prj_name)
        let l:cur_prj = prj_dict[prj_name]
        call extend(l:cur_prj, {'name':prj_name})
        let esc_filename_chars = ' *?[{`$%#"|!<>();&' . "'\t\n"
        let prj_dir = escape(s:GetMyProjectConfigDir().g:slash.prj_name, esc_filename_chars)
        call extend(l:cur_prj, {'MyPrjDir':prj_dir})
        return l:cur_prj
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
    if l:cur_prj == {}
        echo "没有工程!"
        silent! close
        return
    endif
    if !empty(l:cur_prj)
        call s:SetCurrentProject(l:cur_prj)
        call s:SetTagsCscopeFilenametags()
        if exists('g:loaded_airline')
            let symbol = get(g:, 'airline#extensions#branch#symbol', g:airline_symbols.branch)
            "let g:airline_section_b = symbol . GetProjectName()
            call airline#parts#define_function('prj', 'GetProjectName')
            let g:airline_section_a = airline#section#create(['mode', ' ★ ', 'prj'])
            exe ":AirlineRefresh"
        endif
    elseif
        call s:SetCurrentProject({})
        echo "项目不存在!"
    endif
    silent! close
endfun
"-----------------------------------------------------------------------------"
"}}}

" 设置当前工程的tags，cscope，filenametags {{{2
"-----------------------------------------------------------------------------"
fun! s:SetTagsCscopeFilenametags()
    let cur_prj = GetCurrentProjectDict()
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "name")
        let g:current_project_name = cur_prj['name']
        " fuf提示符
        let g:fuf_mytaggedfile_prompt = '>'.cur_prj['name'].'>'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "tags")
        if filereadable(cur_prj["tags"])
            exe ":set tags="
            exe ":set tags+=".cur_prj["tags"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "cscope")
        if filereadable(cur_prj["cscope"])
            exe ":cscope reset"
            exe ":cscope add ".cur_prj["cscope"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if has_key(cur_prj, "filenametags")
        if filereadable(cur_prj["filenametags"])
            let g:filenametags = cur_prj["filenametags"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供fuf使用
    if has_key(cur_prj, "cache")
        if filereadable(cur_prj["cache"])
            let g:project_cache = cur_prj["cache"]
        endif
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "供MyGrep使用
    if has_key(cur_prj, "SourceCodeDir0")
        let g:project_root_dir = cur_prj["SourceCodeDir0"]
    endif
    if has_key(cur_prj, "grep_ext")
        let g:project_grep_ext = cur_prj["grep_ext"]
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "MRU
    let g:MRU_File = s:GetMyProjectConfigDir() . g:slash . cur_prj['name'] . g:slash. 'mru'
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    "Ctrlp
    exe "nmap <C-p> :<C-u>CtrlP " . cur_prj["SourceCodeDir0"] . "<CR>"
    
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
    echo "\n"
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
    call s:DisplayMyProject(s:GetMyProjectNameList())
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
        call add(header, '" e : 编辑config文件')
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
    nnoremap <buffer> <silent> e             :call <SID>EditMyProjectFile()<cr>
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
    let l:ext_filter = g:MyProjectFileFilter
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    if filereadable(l:tags)
        call delete(l:tags)
    endif

    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:output_cscope = l:output_dir.g:slash.'cscope.files'
    if filereadable(l:output_cscope)
        call delete(l:output_cscope)
    endif
    if !filereadable(l:output_cscope)
        let starttime = reltime()  " start the clock
        echo "生成tags文件列表中..."
        let l:cscope_string = ''
        for l:index in range(len(l:src_dir_list))
            if g:platform == 'win'
                "转到project目录
                execute "cd " .  l:src_dir_list[l:index]
                "得到命令输出
                let l:cscope_string = l:cscope_string . system(l:cmd . " " . l:ext_filter)
            else
                "得到命令输出
                let l:cscope_string = l:cscope_string . system(l:cmd . l:src_dir_list[l:index] . " " . l:ext_filter)
            endif
        endfor
        "分行
        let l:cscope_list = split(l:cscope_string, '\n')
        "写入文件
        call writefile(l:cscope_list, l:output_cscope)
        let elapsedtimestr = matchstr(reltimestr(reltime(starttime)),'\d\+\(\.\d\d\)\=')
        echo "tags文件列表已创建! ". '(time: '.elapsedtimestr.'s)'
    endif
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    execute "cd " . l:output_dir 
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
    let l:ext_filter = g:MyProjectFileFilter
    ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    let l:output_cscope = l:output_dir.g:slash.'cscope.files'
    if !filereadable(l:output_cscope)
        let starttime = reltime()  " start the clock
        echo "生成cscope文件列表中..."
        let l:cscope_string = ''
        for l:index in range(len(l:src_dir_list))
            "转到project目录
            execute "cd " .  l:src_dir_list[l:index]
            "得到命令输出
            if g:platform == 'win'
                let l:cscope_string = l:cscope_string . system(l:cmd . " " . l:ext_filter)
            else
                let l:cscope_string = l:cscope_string . system(l:cmd . l:src_dir_list[l:index] . " " . l:ext_filter)
            endif
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
    "let l:temp = system("cscope.exe -bkq -i ".l:output_cscope)
    let l:temp = system("cscope -bkq -i ".l:output_cscope)
    call s:EchoError(l:temp)
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
    let l:ext_filter = g:MyProjectFileFilter
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
        if g:platform == 'win'
            let l:filenametags_string = l:filenametags_string . system(l:cmd . " " . l:ext_filter)
        else
            let l:filenametags_string = l:filenametags_string . system(l:cmd . l:fntags_dir_list[l:index] . " " . l:ext_filter)
        endif
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
